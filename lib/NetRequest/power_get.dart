import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';

Future<bool> powerPost(BuildContext context,
    {@required String token,@required String home,@required String num}) async {
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.post(ApiUrl.powerUrl,data: {"home":home,"room":num},
    options: Options(headers: {"Authorization":"Bearer "+token}));
    //Json解码为Map
    debugPrint("@powerGet:" + res.toString());
    if (res.statusCode==200) {
      Prefs.power = res.toString();
      Prefs.powerNum = num;
      Prefs.powerHome = home;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
