import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/score_info.dart';

Future<Null> scoreGet(BuildContext context,{@required String term, @required String year, @required String token}) async {
  try {
    Map<String,dynamic> _jsonMap = {"xnm": year, "xqm": term};
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(Global.apiUrl.scoreUrl, queryParameters: _jsonMap,options: Options(
      headers: {
        "token":token
      }
    ));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    if (map['status']==200) {
      Global.scoreInfo = ScoreInfo.fromJson(map);
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, "发生了点小错误(X_X)");
  }
}