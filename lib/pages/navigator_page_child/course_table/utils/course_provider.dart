import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/point_components/point_matrix.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/bean.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';


/* 课程数据类
 * CourseProvider().init("myToken","2019","1");
 * CourseProvider.db["1"]["2"]["3"] 返回第1周第2行第3列的课程数据
 * CourseProvider.remove("English");
 * CourseProvider.add(CourseData(map));
 */
class CourseProvider extends ChangeNotifier{
  // ignore: deprecated_member_use
  static var info = new List<List<CourseData>>(26);
  // ignore: deprecated_member_use
  static var _infoByCourse = new List<CourseData>();
  static var pointArray = new List(26);

  static int curWeek;
  static int initialWeek;
  static DateTime curMondayDate;
  static DateTime admissionDate;
  static bool _haveInit = false;
  static bool loading = false;
  int get getCurWeek=>curWeek;
  DateTime get getCurMondayDate=>curMondayDate;
  List get getPointArray => pointArray;

  CourseProvider(){
    init();
  }
  ///初始化课表数据
  ///CourseProvider().init();
  init(){
    if(loading)return;
    debugPrint("@init");
    if(Prefs.courseData!=null){
      debugPrint("@already init");
      if(!_haveInit){
        _initDateTime();
        _initData();
        _handlePrefs();
        notifyListeners();
      }

    }else{
      get(Prefs.token,Prefs.schoolYear,Prefs.schoolTerm);
    }
    _haveInit = true;
  }
  ///获取2019年第1学期课表
  ///CourseProvider().get("token","2019","1");
  get(String token,String year,String term) {
    debugPrint('@get');
    loading = true;
    notifyListeners();
    String newDateTimeStr;
    if(term=='1'){
      newDateTimeStr = '$year-09-07';
    }else{
      newDateTimeStr = '${int.parse(year)+1}-03-01';
    }
    setAdmissionDateTime(newDateTimeStr);
    _initData();
    Future.wait([_getJsonInfo(token, year, term)]).then((courseBeans){
      var courseBean = courseBeans[0];
      _handleCourseBean(courseBean);
      _savePrefs();
    }).whenComplete((){
      notifyListeners();
      loading = false;
    });
  }
  /// 修改当前周
  /// CourseProvider().changeWeek(5);
  changeWeek(int week){
    curWeek = week;
    curMondayDate = admissionDate.add(Duration(days: 7*(curWeek-1)));
    notifyListeners();
  }
  /// 增加课程
  /// CourseProvider().add(
  /// )
  void add(CourseData newCourseData){
    _infoByCourse.add(newCourseData);
    for(int week in newCourseData.weekList){
      info[week].add(newCourseData);
      pointArray[week][newCourseData.lessonNum~/2+1][newCourseData.weekNum]++;
    }
    _savePrefs();
    notifyListeners();
  }
  /// 删除课程
  /// CourseProvider().del()
  void del(CourseData delCourseData){
    for(int i = 0;i<_infoByCourse.length;i++){
      if(_equal(delCourseData, _infoByCourse[i])){
        _infoByCourse.removeAt(i--);
      }
    }
    for(var week in delCourseData.weekList){
      for(int i = 0;i<info[week].length;i++){
        if(_equal(info[week][i], delCourseData)){
          info[week].removeAt(i--);
          pointArray[week][delCourseData.lessonNum~/2+1][delCourseData.weekNum]--;
        }
      }
    }
    notifyListeners();
  }
  /// 设置开学日期
  /// CourseProvider().setAdmissionDateTime()
  void setAdmissionDateTime(String newDateTimeStr){
    Prefs.admissionDate = newDateTimeStr;
    admissionDate = DateTime.parse(newDateTimeStr);
    var difference = DateTime.now().difference(admissionDate);
    curWeek = difference.inDays~/7 + 1;
    if(curWeek<=0||curWeek>22) curWeek = 1;
    initialWeek = curWeek;
    curMondayDate = admissionDate.add(Duration(days: 7*(curWeek-1)));
    notifyListeners();
  }
  /// 用于测试数据
  /// CourseProvider().test();
  void test(){
    for(int index = 1;index<=22;index++){
      debugPrint("第$index周课程");
      for(var course in info[index]){
        debugPrint(course.toJson().toString());
      }
      for(var i in pointArray[index]){
        debugPrint(i.toString());
      }
    }
    for(int i = 0;i<_infoByCourse.length;i++){
      debugPrint(_infoByCourse[i].title);
    }
  }
  bool _equal(CourseData courseData1,CourseData courseData2){
    if(courseData1.title==courseData2.title&&
    courseData1.lessonNum==courseData2.lessonNum&&
    courseData1.weekNum==courseData2.weekNum){
      return true;
    }
    return false;
  }
  //课程列表打包存储到本地
  _savePrefs(){
    debugPrint("@savePrefs");
    var result = [];
    for(CourseData courseData in _infoByCourse){
      result.add(courseData.toJson());
      debugPrint(courseData.title);
    }
    Prefs.courseData = jsonEncode(result);
  }
  //Prefs列表-> info,pointArray,infoByCourse
  _handlePrefs(){
    debugPrint("@handlePrefs");
    List courseList = jsonDecode(Prefs.courseData);
    for(Map courseMap in courseList){
      CourseData courseData = CourseData.fromJson(courseMap);
      _infoByCourse.add(courseData);
      for(int week in courseData.weekList){
        info[week].add(courseData);
        pointArray[week][courseData.lessonNum~/2+1][courseData.weekNum]++;
      }
    }
  }
  _initDateTime(){
    admissionDate = DateTime.parse(Prefs.admissionDate);
    var difference = DateTime.now().difference(admissionDate);
    curWeek = difference.inDays~/7 + 1;
    if(curWeek<=0) curWeek = 1;
    initialWeek = curWeek;
    curMondayDate = admissionDate.add(Duration(days: 7*(curWeek-1)));
  }
  _handleCourseBean(CourseBean courseBean){
    if(courseBean!=null){
      // var nameMap = new Map();
      for(var course in courseBean.kbList){
        // //防止添加重复课程
        // if(nameMap.containsKey(course.kcmc)){
        //   continue;
        // }else{
        //   nameMap[course.kcmc] = true;
        // }
        //"4-6周,8-13周"->["4-6周","8-13周"]
        var courseWeek = course.zcd.split(',');
        // ["4-6周","8-13周"] -> [4,5,6,8,9,10,11,12,13]
        List<int> weekList = [];
        for(var week in courseWeek){
          weekList.addAll(_strWeekToList(week));
        }
        int duration = int.parse(course.jcs.split('-')[1]) - int.parse(course.jcs.split('-')[0]) + 1;
        CourseData newCourseData = new CourseData(
            weekList: weekList,
            weekNum: int.parse(course.xqj),
            lessonNum: int.parse(course.jcs.split('-')[0]),
            title: course.kcmc,
            location: course.cdmc,
            teacher: course.xm,
            credit: course.xf,
            durationNum: duration,);
        _infoByCourse.add(newCourseData);
        for(int week in weekList){
          info[week].add(newCourseData);
          pointArray[week][newCourseData.lessonNum~/2+1][newCourseData.weekNum]++;
        }

      }

    }
  }
  _initData(){
    _infoByCourse = [];
    for(int i =0;i<info.length;i++){
      info[i] = [];
      pointArray[i] = [
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
        [0, 0, 0, 0, 0,0,0,0],
      ];
    }
  }
  Future<CourseBean> _getJsonInfo(String token,String year,String term)async{
    debugPrint('@getJsonInfo');
    CourseBean courseBean = new CourseBean();
    Dio dio = new Dio();
    try{
      Response res = await dio.post(ApiUrl.courseUrl, data: {
        "xnm":year,
        "xqm":term
      }, options: Options(headers: {
        "Authorization": "Bearer "+token,
      }));
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      courseBean = CourseBean.fromJson(map);
      return courseBean;
    }catch(e){
      debugPrint(e.toString());
      return null;
    }
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




