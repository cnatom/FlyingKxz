

//实体类实例汇总
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/Model/power_info.dart';
import 'package:flying_kxz/Model/rank_info.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:flying_kxz/Model/swiper_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'book_detail_info.dart';
import 'book_info.dart';
import 'course_info.dart';
import 'exam_info.dart';
import 'login_info.dart';
//从本地提取历史信息
Future<void> getSchoolYearTerm()async{
  //获取当前学年学期
  if(DateTime(2020,Global.nowDate.month,Global.nowDate.day).isAfter(DateTime(2020,8,1))){
    Global.prefs.setString(Global.prefsStr.schoolYear, Global.nowDate.year.toString());
    Global.prefs.setString(Global.prefsStr.schoolTerm, '1');
  }else{
    Global.prefs.setString(Global.prefsStr.schoolYear, (Global.nowDate.year-1).toString());
    Global.prefs.setString(Global.prefsStr.schoolTerm, '2');
  }
}

class Global{
  static GlobalKey<ScaffoldState> scaffoldKeyDiy = GlobalKey<ScaffoldState>();//用于弹出picker
  static SharedPreferences prefs;
  static ApiUrl apiUrl = new ApiUrl();//网络请求url汇总
  static PrefsStr prefsStr = new PrefsStr();//prefs信息的String标题
  static CourseInfo courseInfo = new CourseInfo(); //课表信息
  static LoginInfo loginInfo = new LoginInfo();//登录信息
  static ScoreInfo scoreInfo = new ScoreInfo();//成绩信息
  static ExamInfo examInfo = new ExamInfo();//考试信息
  static BookInfo bookInfo = new BookInfo();//图书馆书籍信息
  static BookDetailInfo bookDetailInfo = new BookDetailInfo();
  static DateTime nowDate = DateTime.now(); //当前日期
  static PowerInfo powerInfo = new PowerInfo();//电量信息
  static SwiperInfo swiperInfo = new SwiperInfo();//轮播图
  static RankInfo rankInfo = new RankInfo();//内测用户排名
  static clearPrefsData(){
    loginInfo = new LoginInfo();
    courseInfo = new CourseInfo();
    scoreInfo = new ScoreInfo();
    examInfo = new ExamInfo();
    Global.prefs.clear();
    getSchoolYearTerm();
  }
  static List xqxnPickerData = [
    [
      "2021-2022",
      "2020-2021",
      "2019-2020",
      "2018-2019",
      "2017-2018",
      "2016-2017"
    ],
    [
      '第1学期',
      '第2学期',
      '第3学期',
    ],
  ];
  static List xqxnWithAllTermPickerData = [
    [
      "2021-2022",
      "2020-2021",
      "2019-2020",
      "2018-2019",
      "2017-2018",
      "2016-2017"
    ],
    [
      '全部学期',
      '第1学期',
      '第2学期',
      '第3学期',
    ],
  ];

}

class ApiUrl{
  String loginUrl = "https://api.kxz.atcumt.com/jwxt/login";//登录请求
  String courseUrl = "https://api.kxz.atcumt.com/jwxt/kb";//课表查询
  String scoreUrl = "https://api.kxz.atcumt.com/jwxt/grade";//成绩查询
  String examUrl = "https://api.kxz.atcumt.com/jwxt/exam";//考试查询
  String bookUrl = "https://api.kxz.atcumt.com/lib/book";//书籍查询
  String powerUrl = "https://api.kxz.atcumt.com/daily/au_df";//自动电量查询
  String swiperUrl = "http://api.kxz.atcumt.com/daily/home_image";//轮播图
  String rankUrl = "https://api.kxz.atcumt.com/admin/user_id";//用户内测排名
  String feedbackUrl = "https://api.kxz.atcumt.com/admin/feedback";//反馈

}

class PrefsStr{
  String username = 'username';//用户名
  String name = 'name';
  String token = 'token';//token信息
  String college = 'college';//学院
  String iClass = 'class';//班级
  String power = 'power';//宿舍电量
  String rank = 'rank';//用户内测排名
  String courseDataLoc = 'courseDataLoc';//课表
  String examDataLoc = 'examDataLoc';//考试
  String examYear = 'examYear';//考试学年
  String examTerm = 'examTerm';//考试学期
  String schoolYear = 'schoolYear';//当前学年
  String schoolTerm = 'schoolTerm';//当前学期
  String isFirstLogin = 'isFirstLogin';//是否初次登陆
}