import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/login_info.dart';
import 'package:flying_kxz/Model/prefs.dart';

//获取登录json数据
Future<bool> loginVisitor(BuildContext context, int loginCount,
    {@required String username, @required String password}) async {
  Response res;
  Dio dio = Dio();
  try {
    Map _jsonMap = {'username': username, 'password': password};
    res = await dio.post(ApiUrl.loginUrl, data: _jsonMap);
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (res.statusCode == 200) {
      //登录成功
      Global.loginInfo = LoginInfo.fromJson(map);
      Prefs.token = Global.loginInfo.token;
      Prefs.name = Global.loginInfo.name;
      Prefs.username = username;
      Prefs.phone = Global.loginInfo.phone;
      return true;
    } else {
      return false;
    }
  }on DioError catch (e) {
    if(e.response != null){
      showToast(context, e.response.toString());
    }else{
      showToast(context, "请检查网络连接");
    }
    return false;
  }
}

