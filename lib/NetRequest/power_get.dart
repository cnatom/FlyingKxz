import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/power_info.dart';
import 'package:flying_kxz/Model/prefs.dart';

// ignore: missing_return
Future<bool> powerGet(BuildContext context,
    {@required String token,@required String home,@required String num}) async {
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(ApiUrl.powerUrl,queryParameters: {"home":home,"num":num},
        options: Options(headers: {"token": token}));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint("@powerGet:" + res.toString());
    if (map['status'] == 200&&map['data']!='null') {
      Global.powerInfo = PowerInfo.fromJson(map);
      Prefs.power = Global.powerInfo.data.toString();
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
