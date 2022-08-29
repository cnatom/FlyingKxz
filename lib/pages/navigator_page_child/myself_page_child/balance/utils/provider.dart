//获取校园卡余额


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';

import '../../../../../cumt_spider/cumt.dart';
import '../../../../../cumt_spider/cumt_format.dart';
import '../../../../../Model/balance_detail_info.dart';
import '../../../../../Model/prefs.dart';
import '../../../../navigator_page.dart';

class BalanceProvider extends ChangeNotifier{
  Cumt cumt = Cumt.getInstance();
  String cardNum = Prefs.cardNum;
  String balance = Prefs.balance;
  BalanceDetailInfo detailInfo;
  Map<String,dynamic> _urls = {
    'balance':'http://portal.cumt.edu.cn/ykt/balance',
    'balanceHis':'http://portal.cumt.edu.cn/ykt/flow?flow_num=20'
  };
  //校园卡流水
  Future<bool> getBalanceHistory({bool showToasts=false})async{
    try{
      var res = await cumt.dio.get(_urls['balanceHis']);
      var map = jsonDecode(res.toString());
      map = CumtFormat.parseBalanceHis(map);
      detailInfo = BalanceDetailInfo.fromJson(map);
      notifyListeners();
      return true;
    }on DioError catch(e){
      if(showToasts) showToast("获取校园卡流水失败\n ${e.message.toString()}");
      return false;
    }
  }
  //校园卡余额
  Future<bool> getBalance()async{
    Response res;
    try{
      res = await cumt.dio.get(_urls['balance']);
      var map = jsonDecode(res.toString());
      Prefs.cardNum = map['data']['ZH'];
      Prefs.balance = (double.parse(map['data']['YE'])/100).toStringAsFixed(2);
      cardNum = Prefs.cardNum;
      balance = Prefs.balance;
      sendInfo('校园卡', '获取校园卡余额:${Prefs.balance}');
      notifyListeners();
      return true;
    }on DioError catch(e){
      return false;
    }
  }


}