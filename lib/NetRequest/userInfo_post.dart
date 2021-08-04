import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/exam_data.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/user_info.dart';

//获取考试
//xnm: '2019' 代表2019-2020学年
//xqm: '3' 代表第1学期  '12' 代表第2学期  '16' 代表第3学期

Future<bool> userInfoPost(BuildContext context,
    {@required String token,}) async {
  print("hello");
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.post(ApiUrl.userInfoUrl,
        options: Options(headers: {"Authorization": "Bearer "+token},));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (res.statusCode == 200) {
      Global.userInfo = UserInfo.fromJson(map);
      Prefs.className = Global.userInfo.classname;
      Prefs.college = Global.userInfo.college;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
