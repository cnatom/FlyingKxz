import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/login_info.dart';
import 'package:flying_kxz/Model/prefs.dart';


//获取登录json数据
Future<bool> newLoginPost(BuildContext context,{@required String username, @required String password}) async {
  try {
    Map _jsonMap = {'username': username, 'password': password};
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.post(Global.apiUrl.newLoginUrl, data: _jsonMap);
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (map['code'] == 0) {
      //登录成功
      Prefs.newToken = map['token'].toString();
      return true;
    }else{
      showToast(context, map['msg'].toString());
      return false;
    }
  } catch (e) {

    debugPrint(e.toString());
    showToast(context, '发生了一点小错误（X_X)');
    return false;
  }
}
