import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/balance_info.dart';
import 'package:flying_kxz/Model/book_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/rank_info.dart';

Future<bool> balanceGet({@required String newToken}) async {
  if(newToken==null)return false;
  Map<String,dynamic> _headerMap = {
    "token":newToken,
    "action":"index"
  };
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(
      Global.apiUrl.balanceUrl,
      options: Options(headers: _headerMap)
    );
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    debugPrint("@balanceGet:"+res.toString());
    debugPrint(res.toString());
    if (map['status']==200) {
      Global.balanceInfo = BalanceInfo.fromJson(map);
      String balance = Global.balanceInfo.data.balance.toString();
      balance = (double.parse(balance)/100).toStringAsFixed(2);
      Prefs.balance = balance;
      return true;
    }else{
      return false;
    }
  }catch(e){
    Global.rankInfo = new RankInfo();
    return false;
  }

}
