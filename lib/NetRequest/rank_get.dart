import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/book_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/rank_info.dart';

Future<bool> rankGet({@required String username}) async {
  Map<String,dynamic> _jsonMap = {
    "username":username,
  };
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(
      Global.apiUrl.rankUrl, queryParameters: _jsonMap,
    );
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    debugPrint("@rankGet:"+res.toString());
    debugPrint(res.toString());
    if (res.statusCode==200) {
      Global.rankInfo = RankInfo.fromJson(map);
      Global.prefs.setString(Global.prefsStr.rank, Global.rankInfo.data.rank.toString());
      return true;
    }else{
      return false;
    }
  }catch(e){
    Global.rankInfo = new RankInfo();
    return false;
  }

}
