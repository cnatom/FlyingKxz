import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/rank_info.dart';

Future<bool> balancePost({@required String token}) async {
  if(token==null)return false;
  Map<String,dynamic> _headerMap = {
    "Authorization": "Bearer "+token,
  };
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.post(
        ApiUrl.balanceUrl,
      options: Options(headers: _headerMap)
    );
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    debugPrint("@balanceGet:"+res.toString());
    if (res.statusCode==200) {
      String balance = map['balance'];
      balance = (double.parse(balance)/100).toStringAsFixed(2);
      Prefs.balance = balance;
      Prefs.cardNum = map['cardNumber'];
      return true;
    }else{
      return false;
    }
  }catch(e){
    Global.rankInfo = new RankInfo();
    return false;
  }

}
