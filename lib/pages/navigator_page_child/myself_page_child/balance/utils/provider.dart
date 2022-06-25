//获取校园卡余额


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../CumtSpider/cumt.dart';
import '../../../../../CumtSpider/cumt_format.dart';
import '../../../../../Model/balance_detail_info.dart';
import '../../../../../Model/prefs.dart';
import '../../../../navigator_page.dart';

class BalanceProvider extends ChangeNotifier{
  String username;
  String password;
  String cardNum;
  String balance;
  BalanceDetailInfo detailInfo;
  BalanceProvider(){
    username = Prefs.username??"";
    password = Prefs.password??"";
  }
  Map<String,dynamic> _urls = {
    'balance':'http://portal.cumt.edu.cn/ykt/balance',
    'balanceHis':'http://portal.cumt.edu.cn/ykt/flow?flow_num=20'
  };
  //校园卡流水
  Future<bool> getBalanceHistory()async{
    try{
      await cumt.login(Prefs.username??'', Prefs.password??'');
      var res = await cumt.dio.get(_urls['balanceHis']);
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      map = CumtFormat.parseBalanceHis(map);
      detailInfo = BalanceDetailInfo.fromJson(map);
      notifyListeners();
      return true;
    }on DioError catch(e){
      debugPrint('获取校园卡流水失败');
      return false;
    }
  }
  //校园卡余额
  Future<bool> getBalance()async{
    if(Prefs.visitor){
      Prefs.cardNum = '123456';
      Prefs.balance = '52.1';
      return true;
    }
    try{
      await cumt.login(Prefs.username??'', Prefs.password??'');
      var res = await cumt.dio.get(_urls['balance']);
      var map = jsonDecode(res.toString());
      Prefs.cardNum = map['data']['ZH'];
      Prefs.balance = (double.parse(map['data']['YE'])/100).toStringAsFixed(2);
      cardNum = Prefs.cardNum;
      balance = Prefs.balance;
      sendInfo('校园卡', '获取校园卡余额:${Prefs.balance}');
      notifyListeners();
      return true;
    }on DioError catch(e){
      debugPrint('获取校园卡余额失败');
      return false;
    }
  }


}