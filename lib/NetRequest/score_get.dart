import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/score_info.dart';


Future<Null> scoreGet(BuildContext context,int type,{@required String term, @required String year, @required String token}) async {
  String url = ApiUrl.scoreUrl;
  if(type==1)url = ApiUrl.scoreAllUrl;
  try {
    Map<String,dynamic> _jsonMap = {"xnm": year=="全部学年"?"0":year.substring(0,4), "xqm": term};
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(url, queryParameters: _jsonMap,options: Options(
      headers: {
        "token":token,
        "action":"jwxt"
      }
    ));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(map.toString());
    if (map['status']==200) {
      if(map['msg']=='请求成功'){
        Global.scoreInfo = ScoreInfo.fromJson(map);
      }else{
        showToast(context, map['msg'].toString());
      }
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, "发生了点小错误(X_X)");
  }
}