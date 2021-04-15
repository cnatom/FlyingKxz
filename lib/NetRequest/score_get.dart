import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/score_info.dart';


Future<Null> scoreGet(BuildContext context,int type,{@required String term, @required String year, @required String token}) async {
  String url = ApiUrl.scoreUrl;
  if(type==1)url = ApiUrl.scoreAllUrl;
  debugPrint(type.toString());
  debugPrint(url);
  Response res;
  Dio dio = Dio();
  try {
    Map<String,dynamic> _jsonMap = {"xnm": year=="全部学年"?"0":year.substring(0,4), "xqm": term};
    //配置dio信息
    res = await dio.post(url, data: _jsonMap,options: Options(
      headers: {
        "Authorization":"Bearer "+token,
      }
    ));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (res.statusCode==200) {
      Global.scoreInfo = ScoreInfo.fromJson(map);
    }else{
      showToast(context, "网络异常QAQ");
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, "发生了点小错误(X_X)");
  }
}