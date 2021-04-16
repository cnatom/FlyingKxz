import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/balance_detail_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/login_info.dart';
import 'package:flying_kxz/Model/prefs.dart';

//获取登录json数据
Future<bool> balanceDetailPost() async {
  Response res;
  Dio dio = Dio();
  try {
    res = await dio.post(ApiUrl.balanceDetailUrl,options: Options(
      headers: {"Authorization":"Bearer "+Prefs.token}
    ));
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (res.statusCode == 200) {
      Global.balanceDetailInfo = BalanceDetailInfo.fromJson(map);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

