//获取校园卡余额
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/cumt/cumt.dart';
import 'package:flying_kxz/cumt/cumt_format.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:flying_kxz/util/logger/log.dart';

import 'package:flying_kxz/ui/ui.dart';

import '../../../../Model/prefs.dart';
import '../../../navigator_page.dart';

enum BalanceRequestType { Balance, BalanceHis }

class BalanceProvider extends ChangeNotifier {
  Cumt cumt = Cumt.getInstance();
  String? _cardNum; // 卡号
  String? _balance; // 余额
  List? _detailEntity; // 校园卡流水
  String? _getBalanceDate; // 上次成功获取校园卡余额的时间
  String? _getBalanceHisDate; //上次成功获取校园卡流水的时间
  String? _auth;

  Map<BalanceRequestType, dynamic> urls = {
    BalanceRequestType.Balance:'https://yktm.cumt.edu.cn/berserker-app/ykt/tsm/getCampusCards?synAccessSource=pc',
    BalanceRequestType.BalanceHis:'https://yktm.cumt.edu.cn/berserker-search/search/personal/turnover?size=20&current=1&synAccessSource=pc'
    // BalanceRequestType.Balance: 'http://portal.cumt.edu.cn/ykt/balance',
    // BalanceRequestType.BalanceHis:
    //     'http://portal.cumt.edu.cn/ykt/flow?flow_num=20'
  };

  //校园卡余额
  Future<bool> getBalance({int count = 2}) async {
    // 递归终止
    if (count == 0) {
      return false;
    }
    Response res;
    try {
      //模拟登录融合门户
      this._auth = await cumt.loginYkt();
      //获取校园卡原始数据
      cumt.dio.options.headers['Synjones-Auth'] = this._auth;
      res = await cumt.dio.get(urls[BalanceRequestType.Balance]);
      cumt.dio.options.headers.remove("Synjones-Auth");
      var map = jsonDecode(res.toString());
      // 提取校园卡基本信息
      try{
        cardNum = map['data']['card'][0]['account'];
      }catch(e){
        cardNum = "000000_Error";
      }
      try{
        balance = (map['data']['card'][0]['elec_accamt'] / 100.0).toStringAsFixed(2);
      }catch(e){
        balance = "0";
      }
      //记录当前时间
      getBalanceDate = DateTime.now().toString().substring(0, 16);
      //发送埋点数据
      Logger.log('Balance', '余额,成功', {'cardNum': cardNum, 'balance': balance});
      //通知页面刷新
      notifyListeners();
      return true;
    } on DioError catch (e) {
      Logger.log('Balance', '余额,失败', {'cardNum': cardNum, 'balance': balance});
      cumt.isLogin = false; // 将模拟登录的锁关闭
      return getBalance(count: count - 1); // 递归进行网络请求
    }
  }

  //校园卡流水
  Future<bool> getBalanceHistory(BuildContext context,
      {bool showToasts = false}) async {
    cumt.dio.options.headers['Synjones-Auth'] = this._auth;
    var res = await cumt.dio.get(urls[BalanceRequestType.BalanceHis]);
    cumt.dio.options.headers.remove("Synjones-Auth");
    var map = jsonDecode(res.toString());
    try {
      var l1 = [];
      try{
        for (var a in map['data']['records']) {
          if(a['icon']=='consume'){
            a['tranamt'] = -a['tranamt'];
          }
          l1.add({
            "title": a['resume'],
            "change": (a['tranamt']/100.0).toStringAsFixed(2),
            "balance": (a['cardBalance']/100.0).toStringAsFixed(2),
            "time": a['jndatetimeStr']
          });
        }
      }catch (e){
        print(e.toString());
        l1 = [];
        if(showToasts) showToast("解析Response失败，请尝试下滑刷新\n${e.toString()}");
      }
      detailEntity = l1;
      getBalanceHisDate = DateTime.now().toString().substring(0, 16);
      notifyListeners();
      await Logger.log("Balance", "历史,成功", {
        "timeKey": DateTime.now().toString(),
        "info": jsonEncode(detailEntity.toList())
      });
      return true;
    } on DioError catch (e) {
      if (showToasts) showToast("获取校园卡流水失败\n ${e.message.toString()}");
      return false;
    }
    // try {
    //   if (await Cumt.checkConnect(showToasts: showToasts)) {
    //     await cumt
    //         .loginFWDT(Prefs.username, Prefs.password)
    //         .then((value) async {
    //       Response res = await cumt.dio.post(urls[BalanceRequestType.BalanceHis],
    //           data: FormData.fromMap(
    //               {'account': cardNum, 'page': "1", 'rows': '100'}),
    //           options: Options(followRedirects: false));
    //       var map = jsonDecode(res.toString());
    //       List<Map<String, dynamic>> temp = [];
    //       for (Map<String, dynamic> m in map['rows']) {
    //         temp.add({
    //           "title": m['MERCNAME'] == ""
    //               ? m["TRANNAME"]
    //               : m['MERCNAME'].toString().trim(),
    //           "time": m['OCCTIME'].toString().trim(),
    //           "change": m['TRANAMT'].toString(),
    //           "balance": m['ZMONEY'].toString()
    //         });
    //       }
    //       detailEntity = temp;
    //       getBalanceHisDate = DateTime.now().toString().substring(0, 16);
    //       notifyListeners();
    //       // 分批埋点
    //       // String timeKey = DateTime.now().toString();
    //       // int batch = 50;
    //       // for (int i = 0; i < detailEntity.length; i += batch) {
    //       //   int start = i;
    //       //   int end = i + batch;
    //       //   if (end > detailEntity.length) {
    //       //     end = detailEntity.length;
    //       //   }
    //       //   await Logger.log("Balance", "历史,成功", {
    //       //     "timeKey": timeKey,
    //       //     "info": jsonEncode(detailEntity.getRange(start, end).toList())
    //       //   });
    //       //   await Future.delayed(Duration(seconds: 1));
    //       // }
    //     });
    //     return true;
    //   } else {
    //     toTipPage();
    //     return false;
    //   }
    // } on DioError catch (e) {
    //   if (showToasts) {
    //     showToast("获取校园卡流水失败\n可能未连接校园网\n ${e.message.toString()}", duration: 4);
    //     toTipPage();
    //   }
    //   ;
    //   Logger.log("Balance", "历史,失败", {});
    //   return false;
    // }
  }

  /// Setter

  set cardNum(String value) {
    Prefs.cardNum = value;
    _cardNum = value;
  }

  set getBalanceHisDate(String value) {
    Prefs.balanceRequestHisDate = value;
    _getBalanceHisDate = value;
  }

  set getBalanceDate(String value) {
    Prefs.balanceRequestDate = value;
    _getBalanceDate = value;
  }

  set balance(String value) {
    Prefs.balance = value;
    _balance = value;
  }

  set detailEntity(List value) {
    Prefs.balanceHis = jsonEncode(value);
    _detailEntity = value;
  }

  /// Getter

  String get cardNum {
    if (_cardNum == null) {
      if (Prefs.cardNum != null) {
        _cardNum = Prefs.cardNum;
      } else {
        _cardNum = "000000";
      }
    }
    return _cardNum!;
  }

  String get balance {
    if (_balance == null) {
      if (Prefs.balance != null) {
        _balance = Prefs.balance;
      } else {
        _balance = "0.0";
      }
    }
    return _balance!;
  }

  List get detailEntity {
    if (_detailEntity == null && Prefs.balanceHis != null) {
      _detailEntity = jsonDecode(Prefs.balanceHis!);
    }
    return _detailEntity!;
  }

  String get getBalanceDate {
    if (_getBalanceDate == null) {
      if (Prefs.balanceRequestDate != null) {
        _getBalanceDate = Prefs.balanceRequestDate;
      } else {
        _getBalanceDate = "……";
      }
    }
    return _getBalanceDate!;
  }

  String get getBalanceHisDate {
    if (_getBalanceHisDate == null) {
      if (Prefs.balanceRequestHisDate != null) {
        _getBalanceHisDate = Prefs.balanceRequestHisDate;
      } else {
        _getBalanceHisDate = "……";
      }
    }
    return _getBalanceHisDate!;
  }
}
