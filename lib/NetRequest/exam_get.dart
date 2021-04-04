import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';

//获取考试
//xnm: '2019' 代表2019-2020学年
//xqm: '3' 代表第1学期  '12' 代表第2学期  '16' 代表第3学期

Future<bool> examPost(BuildContext context,
    {@required String token,
    @required String year,
    @required String term}) async {
  Map<String, dynamic> _jsonMap = {"xnm": year, "xqm": term};
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(ApiUrl.examUrl,
        queryParameters: _jsonMap, options: Options(headers: {"token": token,"action":"jwxt"},receiveTimeout: 5,sendTimeout: 5));
    //Json解码为Map
    Map<String, dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (map['status'] == 200) {
      Prefs.examData = res.toString();
      Global.examInfo = ExamInfo.fromJson(map);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
