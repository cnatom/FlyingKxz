import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../ui/toast.dart';
import 'locations.dart';
import 'package:dio/dio.dart';
import 'account.dart';

/// 登录结果
class CumtLoginResult {
  static const String SUCCESS = '校园网登录成功！';
  static const String LOGGED_IN = '您已登录校园网';
  static const String WRONG_ACCOUNT_OR_PASSWORD = '账号或密码错误';
  static const String ACCOUNT_NOT_EXIST = '账号不存在，请切换运营商再尝试';
  static const String LOGIN_LIMIT_EXCEEDED = '您的登陆超限\n请在"用户自助服务系统"下线终端。';
  static const String WRONG_USERNAME_OR_PASSWORD = '用户名或密码错误';
  static const String UNKNOWN_ERROR = '未知错误，但是不影响使用';
  static const String NETWORK_ERROR = '登录失败，确保您已经连接校园网(CUMT_Stu或CUMT_tec)';
}

class CumtLogin{

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

  //自动登录
  static Future<String> autoLogin({@required CumtLoginAccount account})async{
    if(!account.isEmpty){
      var res = await login(account: account);
      if(res==CumtLoginResult.SUCCESS||res==CumtLoginResult.LOGGED_IN) {
        return res;
      }else{
        return "登录失败~";
      }
    }
    return "";
  }

  //处理登录结果
  static String _handleLoginResult(Map<String,dynamic> map){
    if (map['result'] == "1") {
      return CumtLoginResult.SUCCESS;
    } else {
      switch (map["ret_code"]) {
        case "2":
          {
            return CumtLoginResult.LOGGED_IN;
          }
        case "1":
          {
            switch(map['msg']){
              case 'dXNlcmlkIGVycm9yMg==':
                return CumtLoginResult.WRONG_ACCOUNT_OR_PASSWORD;
              case 'dXNlcmlkIGVycm9yMQ==':
                return CumtLoginResult.ACCOUNT_NOT_EXIST;
              case 'UmFkOkxpbWl0IFVzZXJzIEVycg==':
                return CumtLoginResult.LOGIN_LIMIT_EXCEEDED;
              case 'bGRhcCBhdXRoIGVycm9y':
                return CumtLoginResult.WRONG_USERNAME_OR_PASSWORD;
              default:
                return CumtLoginResult.UNKNOWN_ERROR;
            }
          }
      }
      return "";
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
      var result = _handleLoginResult(map);
      if(result==CumtLoginResult.SUCCESS||result==CumtLoginResult.LOGGED_IN){
        CumtLoginAccount.addList(account);
      }
      return result;
    } catch (e) {
      return CumtLoginResult.NETWORK_ERROR;
    }
  }
}
