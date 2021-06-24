import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/CumtSpider/cumt_format.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_page.dart';

//获取考试
//xnm: '2019' 代表2019-2020学年
//xqm: '3' 代表第1学期  '12' 代表第2学期  '16' 代表第3学期

Future<bool> examPost(BuildContext context,
    {@required String year,
    @required String term,bool auto = false}) async {
  Map<String, dynamic> _jsonMap = {"xnm": year, "xqm": term};
  try {
    if(Prefs.visitor){
      //游客模式
      var res = await Dio().post(ApiUrl.examUrl,
          data: _jsonMap, options: Options(headers: {"Authorization": "Bearer "+Prefs.token},));
      Map<String, dynamic> map = jsonDecode(res.toString());
      debugPrint(res.toString());
      if (res.statusCode == 200) {
        Global.examInfo = ExamInfo.fromJson(map);
        for(var item in Global.examInfo.data){
          Global.examList.add(ExamUnit(courseName: item.course,location: item.local,dateTime: item.time,year: item.year,month: item.month,day: item.day));
        }
        Prefs.examData = ExamUnit.examJsonEncode(Global.examList);
        return true;
      } else {
        return false;
      }
    }else{
      if(!auto)showToast('教务有关的功能正在维护中……\n请保持最新版本');
      return false;
      var res = await cumt.inquiryJw(InquiryType.Exam, year, term,);
      if(res!=''){
        Map<String, dynamic> map = jsonDecode(res.toString());
        map = CumtFormat.parseExam(map);
        Global.examInfo = ExamInfo.fromJson(map);
        //备份自定义课表数据,防止数据被覆盖
        List<ExamUnit> diyList = [];
        for(var item in Global.examList){
          if(item.diy) diyList.add(item);
        }
        //写入教务考试
        Global.examList.clear();
        for(var item in Global.examInfo.data){
          Global.examList.add(ExamUnit(courseName: item.course,location: item.local,dateTime: item.time,year: item.year,month: item.month,day: item.day));
        }
        Global.examList.addAll(diyList);
        Prefs.examData = ExamUnit.examJsonEncode(Global.examList);
        return true;
      }
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
