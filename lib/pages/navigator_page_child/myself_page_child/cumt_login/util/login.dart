import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../ui/toast.dart';
import 'locations.dart';
import 'package:dio/dio.dart';
import 'account.dart';




class CumtLogin {

  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: 1000,
      sendTimeout: 1000,
      receiveTimeout: 1000
    ),
  );



  /// 注销
  static Future<String> logout(
      {@required CumtLoginAccount account}) async {
    try {
      String url = account.cumtLoginLocation?.logoutUrl;
      //配置dio信息
      Response res = await dio.get(url);
      //Json解码为Map
      Map<String, dynamic> map =
          jsonDecode(res.toString().substring(1, res.toString().length - 1));
      return map["msg"].toString();
    } catch (e) {
      return '网络错误(X_X)';
    }
  }

  static Future<void> autoLogin()async{
    CumtLoginAccount account = CumtLoginAccount();
    if(!account.isEmpty){
      var res = await login(account: account);
      showToast(res);
    }
  }
  /// 登录
  static Future<String> login(
      {@required CumtLoginAccount account}) async {
    try {
      String url = account.cumtLoginLocation.loginUrl(account.username, account.password, account.cumtLoginMethod);
      Response res = await dio.get(url);
      Map<String, dynamic> map =
          jsonDecode(res.toString().substring(1, res.toString().length - 1));
      debugPrint(map.toString());
      if (map['result'] == "1") {
        CumtLoginAccount.addList(account);
        return '登录成功！';
      } else {
        switch (map["ret_code"]) {
          case "2":
            {
              CumtLoginAccount.addList(account);
              return '您已登录校园网';
            }
          case "1":
            {
              if (map['msg'] == "dXNlcmlkIGVycm9yMg==") {
                return '账号或密码错误';
              } else if (map['msg'] == 'dXNlcmlkIGVycm9yMQ==') {
                return '账号不存在，请切换运营商再尝试';
              } else if (map['msg'] == 'UmFkOkxpbWl0IFVzZXJzIEVycg==') {
                return '您的登陆超限\n请在"用户自助服务系统"下线终端。';
              } else if(map['msg']=='bGRhcCBhdXRoIGVycm9y'){
                return '用户名或密码错误';
              }else{
                return '未知错误，但是不影响使用';
              }
            }
        }
        return "";
      }
    } catch (e) {
      return "登录失败，确保您已经连接校园网(CUMT_Stu或CUMT_tec)";
    }
  }
}
