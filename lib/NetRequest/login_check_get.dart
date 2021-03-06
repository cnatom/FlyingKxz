import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/login_info.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:url_launcher/url_launcher.dart';

//获取登录json数据
Future<bool> loginCheckGet(BuildContext context,
    {@required String username}) async {
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio
        .get(ApiUrl.loginCheckUrl, queryParameters: {"username": username});
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (map['isNeedActive']!=null&&map['isNeedActive']) {
      debugPrint("账号未激活");
      showToast(context, "账号未激活\n\n3秒钟后将跳转至激活页面",gravity: 1,duration: 4);
      Future.delayed(Duration(seconds: 3),(){
        launch("http://authserver.cumt.edu.cn/retrieve-password/accountActivation/index.html");
      });
    } else if (map['isNeed']!=null&&map['isNeed']) {
      debugPrint("需要验证码");
      showToast(context, "QAQ\n\n检测到您登录失败次数过多\n\n"
          "融合门户网站出现验证码\n\n"
            "需要您在该网站\"成功登录一次\"以取消验证码\n\n"
          "12秒钟后将跳转至登录页面",gravity: 1,duration: 13);
      Future.delayed(Duration(seconds: 12),(){
        launch("http://authserver.cumt.edu.cn/authserver/login");
      });

    } else {
      debugPrint("不需要验证码");
      return true;
    }

    return false;
  } catch (e) {
    debugPrint(e.toString());
    showToast(context, '连接失败（X_X)');
    return false;
  }
}
