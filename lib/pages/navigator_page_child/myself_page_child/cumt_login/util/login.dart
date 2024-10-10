import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'locations.dart';
import 'package:dio/dio.dart';
import 'account.dart';

/// 登录结果
class CumtLoginResult {
  static const String SUCCESS = '校园网登录成功！';
  static const String LOGGED_IN = '您已登录校园网';
  static const String WRONG_ACCOUNT_OR_PASSWORD = '账号或密码错误';
  static const String ACCOUNT_NOT_EXIST = '账号不存在，请切换运营商再尝试';
  static const String LOGIN_LIMIT_EXCEEDED = '您的登陆超限';
  static const String WRONG_USERNAME_OR_PASSWORD = '用户名或密码错误';
  static const String UNKNOWN_ERROR = '未知错误';
  static const String TIMEOUT_ERROR = '登录超时';
  static const String NETWORK_ERROR = '登录失败';
  static const String MOBILE_ERROR = '正在通过流量连接';
  static const String NOT_OPEN_NETWORK = '未打开网络';
}

class CumtLogin {
  static Dio dio = Dio(
    BaseOptions(connectTimeout: Duration(seconds: 1), sendTimeout: Duration(seconds: 1), receiveTimeout: Duration(seconds: 1)),
  );

  /// 注销
  static Future<String> logout({required CumtLoginAccount account}) async {
    try {
      String? url = account.cumtLoginLocation.logoutUrl;
      //配置dio信息
      Response res = await dio.get(url);
      //Json解码为Map
      Map<String, dynamic> map =
      jsonDecode(res.toString().substring(1, res
          .toString()
          .length - 1));
      return map["msg"].toString();
    } catch (e) {
      return '网络错误(X_X)';
    }
  }

  //自动登录
  static Future<String> autoLogin({required CumtLoginAccount account}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      if (!account.isEmpty) {
        var res = await login(account: account);
        return res;
      }else{
        return "账号为空";
      }
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return CumtLoginResult.MOBILE_ERROR;
    } else {
      return CumtLoginResult.NOT_OPEN_NETWORK;
    }
  }

  //处理登录结果
  static String _handleLoginResult(Map<String, dynamic> map) {
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
            switch (map['msg']) {
              case 'dXNlcmlkIGVycm9yMg==':
                return CumtLoginResult.WRONG_ACCOUNT_OR_PASSWORD;
              case 'dXNlcmlkIGVycm9yMQ==':
                return CumtLoginResult.ACCOUNT_NOT_EXIST;
              case 'UmFkOkxpbWl0IFVzZXJzIEVycg==':
                return CumtLoginResult.LOGIN_LIMIT_EXCEEDED;
              case 'bGRhcCBhdXRoIGVycm9y':
                return CumtLoginResult.WRONG_USERNAME_OR_PASSWORD;
              default:
                return CumtLoginResult.UNKNOWN_ERROR +
                    "\n${map['msg'].toString()}";
            }
          }
      }
      return "";
    }
  }

  /// 登录
  static Future<String> login({required CumtLoginAccount account}) async {
    try {
      String url = account.cumtLoginLocation.loginUrl(
          account.username, account.password, account.cumtLoginMethod);
      Response res = await dio.get(url,queryParameters: {
        'user_password':account.password
      });
      Map<String, dynamic> map = jsonDecode(res.toString().substring(1, res.toString().length - 1));
      var result = _handleLoginResult(map);
      if (result == CumtLoginResult.SUCCESS ||
          result == CumtLoginResult.LOGGED_IN) {
        CumtLoginAccount.addList(account);
        account.refreshAccountPrefs();
      }
      return result;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return CumtLoginResult.TIMEOUT_ERROR;
      }else{
        return CumtLoginResult.NETWORK_ERROR;
      }
    }
  }
}