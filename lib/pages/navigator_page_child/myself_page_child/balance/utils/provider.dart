//获取校园卡余额
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/cumt/cumt.dart';
import 'package:flying_kxz/cumt/cumt_format.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/model/detail_model.dart';
import '../../../../../Model/prefs.dart';
import '../../../../navigator_page.dart';
enum BalanceRequestType{
  Balance,BalanceHis
}

class BalanceProvider extends ChangeNotifier{
  Cumt cumt = Cumt.getInstance();
  String _cardNum; // 卡号
  String _balance; // 余额
  BalanceDetailModel _detailInfo; // 校园卡流水
  String _getBalanceDate; // 上次成功获取校园卡余额的时间
  String _getBalanceHisDate; //上次成功获取校园卡流水的时间

  Map<BalanceRequestType,dynamic> urls = {
    BalanceRequestType.Balance:'http://portal.cumt.edu.cn/ykt/balance',
    BalanceRequestType.BalanceHis:'http://portal.cumt.edu.cn/ykt/flow?flow_num=20'
  };

  //校园卡余额
  Future<bool> getBalance()async{
    Response res;
    try{
      res = await cumt.dio.get(urls[BalanceRequestType.Balance]);
      var map = jsonDecode(res.toString());
      cardNum = map['data']['ZH'];
      balance = (double.parse(map['data']['YE'])/100).toStringAsFixed(2);
      getBalanceDate = DateTime.now().toString();
      sendInfo('校园卡', '获取校园卡余额:${balance}');
      notifyListeners();
      return true;
    }on DioError catch(e){
      return false;
    }
  }

  //校园卡流水
  Future<bool> getBalanceHistory({bool showToasts=false})async{
    try{
      var res = await cumt.dio.get(urls[BalanceRequestType.BalanceHis]);
      var map = jsonDecode(res.toString());
      map = CumtFormat.parseBalanceHis(map);
      detailInfo = BalanceDetailModel.fromJson(map);
      getBalanceHisDate = DateTime.now().toIso8601String();
      notifyListeners();
      return true;
    }on DioError catch(e){
      if(showToasts) showToast("获取校园卡流水失败\n ${e.message.toString()}");
      return false;
    }
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

  set detailInfo(BalanceDetailModel value) {
    Prefs.balanceHis = jsonEncode(value.toJson());
    _detailInfo = value;
  }

  String get cardNum{
    if(_cardNum==null && Prefs.cardNum!=null){
      _cardNum = Prefs.cardNum;
    }
    return _cardNum;
  }

  /// Getter

  String get balance{
    if(_balance==null && Prefs.balance!=null){
      _balance = Prefs.balance;
    }
    return _balance;
  }

  BalanceDetailModel get detailInfo{
    if(_detailInfo==null && Prefs.balanceHis!=null){
      var map = jsonDecode(Prefs.balanceHis);
      _detailInfo = BalanceDetailModel.fromJson(map);
    }
    return _detailInfo;
  }

  String get getBalanceDate{
    if(_getBalanceDate==null && Prefs.balanceRequestDate!=null){
      _getBalanceDate = Prefs.balanceRequestDate;
    }
    return _getBalanceDate;
  }

  String get getBalanceHisDate{
    if(_getBalanceHisDate==null && Prefs.balanceRequestHisDate!=null){
      _getBalanceHisDate = Prefs.balanceRequestHisDate;
    }
    return _getBalanceHisDate;
  }
}