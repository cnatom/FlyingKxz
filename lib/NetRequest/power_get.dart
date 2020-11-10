import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/power_info.dart';

// ignore: missing_return
Future<bool> powerGet(BuildContext context,{@required String token}) async {
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(Global.apiUrl.powerUrl,options: Options(
        headers: {
          "token":token
        }
    ));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint("@powerGet:"+res.toString());
    if (map['status']==200) {
      Global.powerInfo = PowerInfo.fromJson(map);
      Global.prefs.setString(Global.prefsStr.power, Global.powerInfo.data.balance.toString());
      return true;
    }else{
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}