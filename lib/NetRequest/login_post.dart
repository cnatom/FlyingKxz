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
  try {
    Map _jsonMap = {'username': username, 'password': password};
    Response res;
    Dio dio = Dio();
    //配置dio信息

    res = await dio.post(Global.apiUrl.loginUrl, data: _jsonMap);
    Map<String, dynamic> map = jsonDecode(res.toString());

    debugPrint(res.toString());
    if (map['code'] == 0) {
      //登录成功
      Global.loginInfo = LoginInfo.fromJson(map);
      Prefs.token = Global.loginInfo.data.token.toString();
      Prefs.username = username;
      Prefs.name = Global.loginInfo.data.name;
      Prefs.iClass = Global.loginInfo.data.classname;
      Prefs.college = Global.loginInfo.data.college;
      Prefs.isFirstLogin = true;
      return true;
    } else {
      showToast(
          context,
          map['msg'].toString() +
              (loginCount > 2 ? '\n\n多次登陆失败请点击"无法登陆"联系我们' : ""));
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, '请检查您的网络连接');
    return false;
  }
}
