import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/login_info.dart';
import 'package:flying_kxz/Model/prefs.dart';

//获取登录json数据
Future<bool> loginPost(BuildContext context, int loginCount,
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
      Prefs.isFirstLogin = true;
      return true;
    } else {
      showToast(
          context,
          map['msg'].toString() +
              (loginCount > 2 ? '\n\n多次登陆失败请点击"无法登录"联系我们' : ""));
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, '连接失败（X_X)');
    return false;
  }
}

