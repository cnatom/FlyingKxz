import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';

import 'bean.dart';

/* 课程数据类
 * CourseProvider().init("myToken","2019","1");
 * CourseProvider.db["1"]["2"]["3"] 返回第1周第2行第3列的课程数据
 * CourseProvider.remove("English");
 * CourseProvider.add(CourseData(map));
 */
class CourseProvider extends ChangeNotifier{
  static List<List<CourseData>> info = new List<List<CourseData>>(25);
  static int curWeek;
  static DateTime curMondayDate;
  static DateTime curDateTime;
  static DateTime admissionDate;
  int get getCurWeek=>curWeek;
  DateTime get getCurMondayDate=>curMondayDate;
  DateTime get getCurTime=>curDateTime;
  _initDateTime(){
    admissionDate = DateTime.parse(Prefs.admissionDate);
    var difference = DateTime.now().difference(admissionDate);
    curWeek = difference.inDays~/7 + 1;
    curMondayDate = admissionDate.add(Duration(days: 7*(curWeek-1)));
    curDateTime = DateTime.now();
  }
  changeWeek(int week){
    curWeek = week;
    curMondayDate = admissionDate.add(Duration(days: 7*(curWeek-1)));
    notifyListeners();
  }
  void test(){
    for(int index = 0;index<info[1].length;index++){
      print("$index @name: ${info[1][index].name} @week ${info[1][index].weeksStr} @weekList: ${info[1][index].weekList.toString()}");
    }
  }
  init(){
    get(Prefs.token,Prefs.schoolYear,Prefs.schoolTerm);
  }
  get(String token,String year,String term) {
    _initDateTime();
    info.fillRange(0, info.length,[]);
    debugPrint('@@init');
    _getJsonInfo(token, year, term).then((courseBean){
      if(courseBean!=null){
        debugPrint("@_initDL");
        for(var course in courseBean.data.kbList){
          //"4-6周,8-13周"->["4-6周","8-13周"]
          var courseWeek = course.zcd.split(',');
          // ["4-6周","8-13周"] -> [4,5,6,8,9,10,11,12,13]
          List<int> weekList = [];
          for(var week in courseWeek){
            weekList.addAll(_strWeekToList(week));
          }

          CourseData newCourseData = new CourseData(
              weekList: weekList,
              weekDay: int.parse(course.xqj),
              lessonNum: int.parse(course.jcs.split('-')[0]),
              name: course.kcmc,
              location: course.cdmc,
              teacher: course.xm,
              weeksStr: course.zcd,
              credit: course.xf,
              type: course.xslxbj,
              durationStr: course.jcs);
          for(int week in weekList){
            info[week].add(newCourseData);
            // debugPrint("@add info[$week] of ${newCourseData.name} List ${newCourseData.weekList.toString()} instance ${info[week].last.name}");
          }
        }
      }


    });
  }


  Future<CourseBean> _getJsonInfo(String token,String year,String term)async{
    debugPrint('@getJsonInfo');
    CourseBean courseBean = new CourseBean();
    Dio dio = new Dio();
    try{
      Response res = await dio.get(Global.apiUrl.courseUrl, queryParameters: {
        "xnm":year,
        "xqm":term
      }, options: Options(headers: {
        "token": token
      }));
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      courseBean = CourseBean.fromJson(map);
      Prefs.courseData = res.toString();
      return courseBean;
    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }
  bool _alreadyStored(){
    if(Prefs.courseData==null) return false;
    return true;
  }

  //用于周次转换
  //"5周"->[5]    "5-12周(单)"->[5, 7, 9, 11]   "13-18周(双)"->[14, 16, 18]   "11-14周"->[11, 12, 13, 14]
  List<int> _strWeekToList(String week) {
    List<int> weekList = new List();
    if (week.contains("单")) {
      week = week.replaceAll("周(单)", "");
      List temp = week.split('-');
      int i = int.parse(temp[0]).isOdd
          ? int.parse(temp[0])
          : int.parse(temp[0]) + 1;
      int j = int.parse(temp[1]);
      for (; i <= j; i += 2) weekList.add(i);
    } else if (week.contains("双")) {
      week = week.replaceAll("周(双)", "");
      List temp = week.split('-');
      int i = int.parse(temp[0]).isEven
          ? int.parse(temp[0])
          : int.parse(temp[0]) + 1;
      int j = int.parse(temp[1]);
      for (; i <= j; i += 2) weekList.add(i);
    } else {
      week = week.replaceAll("周", "");
      List temp = week.split('-');
      if (temp.length != 1) {
        int i = int.parse(temp[0]);
        int j = int.parse(temp[1]);
        for (; i <= j; i++) weekList.add(i);
      } else {
        weekList.add(int.parse(temp[0]));
      }
    }
    return weekList;
  }
}


class CourseColor{
  static Map<String,Color> c = {};
  static int _curIndex = 0;
  static final List<Color> _colorLessonCard = [
    Color.fromARGB(255, 102,204,153),
    Color(0xFF6699FF),
    Color.fromARGB(255, 255,153,153),
    Color.fromARGB(255, 166,145,248),
    Color.fromARGB(255, 62,188,202),
    Color.fromARGB(255, 255,153,102),
    Color(0xFF4ecccc),
    Color(0xFFff9bcb)
  ];
  CourseColor(String str){
    if(!c.containsKey('1')){
      c[str] = _colorLessonCard[_curIndex++];
      _curIndex%=(_colorLessonCard.length-1);
    }
  }
  //CourseColor.fromStr("English")返回English的色彩
  static Color fromStr(String str){
    return c[str];
  }
}
class CourseData {
  //用于展示信息
  String name; //课程名
  String type; //课程类别 如:"★"
  String location; //上课地点
  String teacher; //教师姓名
  String credit; //学分
  String weeksStr; //周次的Str 如："1-4周,6-10周"
  String durationStr; //1-2节 只展示给重叠课程卡片
  //用于定位
  List weekList; //在几周有课 [1,2,3,4]代表1-4周都有课
  int weekDay; //周几col
  int lessonNum; //第几节课row
  int duration; //持续时间
  CourseData({
    @required this.weekList,
    @required this.weekDay,
    @required this.lessonNum,
    @required this.name,
    @required this.location,
    @required this.teacher,
    @required this.weeksStr,
    @required this.credit,
    @required this.type,
    @required this.durationStr}){
    var split = durationStr.split('-');    //"1-4" -> ["1","4"]
    duration = int.parse(split[1])-int.parse(split[0])+1; // ["1","4"] -> 4
    CourseColor(name);
  }
  //用于显示课表信息
  Map display(){
    return {
      'name':name,
      'type':type,
      'location':location,
      'teacher':teacher,
      'credit': credit,
      'weeksStr':weeksStr,
      'durationStr':durationStr,
      'duration':duration
    };
  }
}
