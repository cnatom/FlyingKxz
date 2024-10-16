import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/course_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';

import '../../../../util/util.dart';

/* 课程数据类
 * CourseProvider().init("myToken","2019","1");
 * CourseProvider.db["1"]["2"]["3"] 返回第1周第2行第3列的课程数据
 * CourseProvider.remove("English");
 * CourseProvider.add(CourseData(map));
 */
class CourseProvider extends ChangeNotifier {
  var info = List<List<CourseData>>.generate(26, (index) => []);
  var infoByCourse = <CourseData>[];
  var pointArray = List.generate(26, (index) => []);
  late int curWeek; // 现在切换的周
  late int initialWeek; // 当前周
  late DateTime curMondayDate;
  late DateTime admissionDate;

  DateTime get getCurMondayDate => curMondayDate;

  List get getPointArray => pointArray;

  CourseProvider() {
    _init();
  }

  _init() {
    if (Prefs.courseData != null) {
      _initDateTime();
      _initData();
      _handlePrefs();
    } else {
      _initDateTime();
      _initData();
    }
  }

  handleCourseList(List<dynamic> list) {
    _initData();
    _initDateTime();
    List loggerInfo = []; // 用于记录日志
    for (var item in list) {
      CourseData courseData = new CourseData(
        weekList: item['weekList'],
        weekNum: item['weekNum'],
        lessonNum: item['lessonNum'],
        title: item['title'],
        location: item['location'],
        teacher: item['teacher'],
        credit: item['credit'],
        durationNum: item['durationNum'],
      );
      infoByCourse.add(courseData);
      for (int week in item['weekList']) {
        info[week].add(courseData);
        pointArray[week][courseData.lessonNum! ~/ 2 + 1][courseData.weekNum]++;
      }
      loggerInfo.add({
        "title": courseData.title,
        "location": courseData.location,
        "teacher": courseData.teacher,
        "credit": courseData.credit,
        "weekList": courseData.weekList,
        "weekNum": courseData.weekNum,
        "lessonNum": courseData.lessonNum,
      });
    }
    _savePrefs();
    notifyListeners();
    Logger.log("Course", "导入,成功",
        {"info": SecurityUtil.base64Encode(loggerInfo.toString())});
  }

  /// 修改当前周
  /// CourseProvider().changeWeek(5);
  changeWeek(int week) {
    curWeek = week;
    curMondayDate = admissionDate.add(Duration(days: 7 * (curWeek - 1)));
    notifyListeners();
  }

  /// 增加课程
  /// CourseProvider().add(
  /// )
  void add(CourseData newCourseData) {
    infoByCourse.add(newCourseData);
    for (int week in newCourseData.weekList!) {
      info[week].add(newCourseData);
      pointArray[week][newCourseData.lessonNum! ~/ 2 + 1]
          [newCourseData.weekNum]++;
    }
    _savePrefs();
    notifyListeners();
  }

  /// 删除课程
  /// CourseProvider().del()
  void del(CourseData delCourseData) {
    for (int i = 0; i < infoByCourse.length; i++) {
      if (_equal(delCourseData, infoByCourse[i])) {
        infoByCourse.removeAt(i--);
      }
    }
    for (var week in delCourseData.weekList!) {
      for (int i = 0; i < info[week].length; i++) {
        if (_equal(info[week][i], delCourseData)) {
          info[week].removeAt(i--);
          pointArray[week][delCourseData.lessonNum! ~/ 2 + 1]
              [delCourseData.weekNum]--;
        }
      }
    }
    _savePrefs();
    notifyListeners();
  }

  /// 设置开学日期
  /// CourseProvider().setAdmissionDateTime()
  void setAdmissionDateTime(String newDateTimeStr) {
    Prefs.admissionDate = newDateTimeStr;
    admissionDate = DateTime.parse(newDateTimeStr);
    var difference = DateTime.now().difference(admissionDate);
    curWeek = difference.inDays ~/ 7 + 1;
    if (curWeek <= 0 || curWeek > 22) {
      curWeek = 1;
      curMondayDate = admissionDate;
    } else {
      curMondayDate = admissionDate.add(Duration(days: 7 * (curWeek - 1)));
    }
    initialWeek = curWeek;
    CoursePageState.coursePageController.dispose();
    CoursePageState.coursePageController = new PageController(
      initialPage: curWeek - 1,
    );
    notifyListeners();
  }

  bool _equal(CourseData courseData1, CourseData courseData2) {
    if (courseData1.title == courseData2.title &&
        courseData1.lessonNum == courseData2.lessonNum &&
        courseData1.weekNum == courseData2.weekNum) {
      return true;
    }
    return false;
  }

  //课程列表打包存储到本地
  _savePrefs() {
    var result = [];
    for (CourseData courseData in infoByCourse) {
      result.add(courseData.toJson());
    }
    Prefs.courseData = jsonEncode(result);
  }

  //Prefs列表-> info,pointArray,infoByCourse
  _handlePrefs() {
    List courseList = jsonDecode(Prefs.courseData ?? '');
    for (Map courseMap in courseList) {
      CourseData courseData = CourseData.fromJson(courseMap);
      infoByCourse.add(courseData);
      for (int week in courseData.weekList!) {
        info[week].add(courseData);
        pointArray[week][courseData.lessonNum! ~/ 2 + 1][courseData.weekNum]++;
      }
    }
  }

  _initDateTime() {
    String admissionDateStr;
    if (Prefs.admissionDate == null) {
      DateTime nowDate = DateTime.now();
      int year, term;
      if (nowDate.isBefore(DateTime(nowDate.year, 2, 1))) {
        year = nowDate.year - 1;
        term = 1;
      } else if (nowDate.isAfter(DateTime(nowDate.year, 8, 1))) {
        year = nowDate.year;
        term = 1;
      } else {
        year = nowDate.year - 1;
        term = 2;
      }
      if (term == 2) {
        admissionDateStr = (year + 1).toString() + '-03-01';
      } else {
        admissionDateStr = year.toString() + '-09-01';
      }
      Prefs.admissionDate = admissionDateStr;
    }
    admissionDate = DateTime.parse(Prefs.admissionDate ?? '');
    var difference = DateTime.now().difference(admissionDate);
    curWeek = difference.inDays ~/ 7 + 1;
    if (curWeek <= 0 || curWeek > 22) curWeek = 1;
    initialWeek = curWeek;
    curMondayDate = admissionDate.add(Duration(days: 7 * (curWeek - 1)));
  }

  _initData() {
    infoByCourse = [];
    for (int i = 0; i < info.length; i++) {
      info[i] = [];
      pointArray[i] = [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
      ];
    }
  }
}
