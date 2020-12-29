//校园网登陆
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/score_info.dart';

Future<bool> cumtLoginGet(BuildContext context,{@required String username,@required String password,@required int loginMethod}) async {
  Global.prefs.setString(Global.prefsStr.cumtLoginUsername, username);
  Global.prefs.setString(Global.prefsStr.cumtLoginPassword, password);
  Global.prefs.setInt(Global.prefsStr.cumtLoginMethod, loginMethod);
  try {
    String method;
    switch(loginMethod) {
      case 0:method = "";break;//校园网
      case 1:method = "%40telecom";break;//电信
      case 2:method = "%40unicom";break;//联通
      case 3:method = "%40cmcc";break;//移动
    }
    Response res;
    Dio dio = Dio();
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password");
    //配置dio信息
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password",);
    //Json解码为Map
    debugPrint(res.toString());
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    debugPrint(map.toString());
    if (map['result']=="1") {
      showToast(context, "登录成功！\n以后打开App就会自动连接！",gravity: Toast.CENTER,duration: 2);
      return true;
    }else{
      switch(map["ret_code"]){
        case "2":{
          showToast(context, "您已登录校园网");
          break;
        }
        case "1":{
          if(map['msg']=="dXNlcmlkIGVycm9yMg=="){
            showToast(context, "账号或密码错误",);
          }else if(map['msg']=='dXNlcmlkIGVycm9yMQ=='){
            showToast(context, "账号不存在，请切换运营商再尝试",);
          }else if(map['msg']=='UmFkOkxpbWl0IFVzZXJzIEVycg=='){
            showToast(context, '您的登陆超限\n请在"用户自助服务系统"下线终端。',);
          }else{
            showToast(context, "未知错误，欢迎向我们反馈QAQ",);
          }
          break;
        }
      }
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, "登录失败，确保您已经连接校园网(CUMT_Stu)",);
    return false;
  }
}
Future<bool> cumtAutoLoginGet(BuildContext context,{@required String username,@required String password,@required int loginMethod}) async {
  try {
    String method;
    switch(loginMethod) {
      case 0:method = "";break;//校园网
      case 1:method = "%40telecom";break;//电信
      case 2:method = "%40unicom";break;//联通
      case 3:method = "%40cmcc";break;//移动
    }
    Response res;
    Dio dio = Dio();
    //配置dio信息
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password");
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account="+username+method+"&user_password=$password",);
    //Json解码为Map
    debugPrint(res.toString());
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    if (map['result']=="1") {
      showToast(context, "已自动登录校园网！");
      return true;
    }
    return false;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
Future<bool> cumtLogoutGet(BuildContext context)async{
  try {
    Response res;
    Dio dio = Dio();
    debugPrint("http://10.2.5.251:801/eportal/?c=Portal&a=logout&login_method=1");
    //配置dio信息
    res = await dio.get("http://10.2.5.251:801/eportal/?c=Portal&a=logout&login_method=1",);
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString().substring(1,res.toString().length-1));
    showToast(context, map["msg"],);
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, "网络错误(X_X)",);
    return false;
  }
}