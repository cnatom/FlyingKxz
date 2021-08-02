//校园网登陆
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page.dart';

Future<bool> cumtLoginGet(BuildContext context,{@required String username,@required String password,@required int loginMethod}) async {
  Prefs.cumtLoginUsername = username;
  Prefs.cumtLoginPassword = password;
  Prefs.cumtLoginMethod = loginMethod;
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
      showToast("登录成功！\n以后打开App就会自动连接！",gravity: Toast.CENTER,duration: 2);
      sendInfo('校园网登录', '登录成功:$username,$loginMethod');
      return true;
    }else{
      switch(map["ret_code"]){
        case "2":{
          showToast("您已登录校园网");
          sendInfo('校园网登录', '已经登录校园网:$username,$loginMethod');
          break;
        }
        case "1":{
          if(map['msg']=="dXNlcmlkIGVycm9yMg=="){
            showToast( "账号或密码错误",);
            sendInfo('校园网登录', '登录失败，账号或密码错误:$username,$loginMethod');
          }else if(map['msg']=='dXNlcmlkIGVycm9yMQ=='){
            showToast( "账号不存在，请切换运营商再尝试",);
            sendInfo('校园网登录', '登录失败，请切换运营商再尝试:$username,$loginMethod');
          }else if(map['msg']=='UmFkOkxpbWl0IFVzZXJzIEVycg=='){
            showToast('您的登陆超限\n请在"用户自助服务系统"下线终端。',);
            sendInfo('校园网登录', '登陆超限:$username,$loginMethod');
          }else{
            showToast("未知错误，欢迎向我们反馈QAQ",);
            sendInfo('校园网登录', '登录失败,未知错误:$username,$loginMethod,${map['msg']}');
          }
          break;
        }
      }
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    showToast("登录失败，确保您已经连接校园网(CUMT_Stu)",);
    sendInfo('校园网登录', '登录失败,未连接校园网:$username,$loginMethod,');
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
      showToast("已自动登录校园网！");
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
    showToast(map["msg"],);
  } catch (e) {
    debugPrint(e.toString());
    showToast("网络错误(X_X)",);
    return false;
  }
}