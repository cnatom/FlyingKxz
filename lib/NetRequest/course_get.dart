import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/course_info.dart';
import 'package:flying_kxz/Model/global.dart';

//获取课表数据
//xnm: '2019' 代表2019-2020学年
//xqm: '3' 代表第1学期  '12' 代表第2学期  '16' 代表第3学期

courseGet(BuildContext context,String token,{@required String xnm,@required String xqm}) async {
  Map<String,dynamic> _jsonMap = {
    "xnm":xnm,
    "xqm":xqm
  };
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(
      Global.apiUrl.courseUrl, queryParameters: _jsonMap,
      options: Options(
        headers: {
          "token": token
        }
      )
    );
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
//    if (map['status']==200) {
//      Global.prefs.setString(Global.prefsStr.courseDataLoc, res.toString());//将课表信息存至本地
//      Global.courseInfo = CourseInfo.fromJson(map);
//    }else{
//      showToast(context, map['msg']);
//    }
    Global.prefs.setString(Global.prefsStr.courseDataLoc, res.toString());//将课表信息存至本地
    Global.courseInfo = CourseInfo.fromJson(map);
  }catch(e){
    debugPrint(e.toString());
  }

}
