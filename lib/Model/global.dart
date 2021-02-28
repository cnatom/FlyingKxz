

//实体类实例汇总
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/Model/balance_info.dart';
import 'package:flying_kxz/Model/power_info.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/rank_info.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:flying_kxz/Model/swiper_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'book_detail_info.dart';
import 'book_info.dart';
import 'course_info.dart';
import 'exam_info.dart';
import 'login_info.dart';

//获取当前学年学期
Future<void> getSchoolYearTerm()async{
  /******************
   * 2021年修复的第一个bug
   * 希望2021年少点bug,多点关爱
   * 2021.1.1
   ******************/
  int year,term;
  if(Global.nowDate.isBefore(DateTime(Global.nowDate.year,2,1))){
    year = Global.nowDate.year-1;
    term = 1;
  }else if(Global.nowDate.isAfter(DateTime(Global.nowDate.year,8,1))){
    year = Global.nowDate.year;
    term = 1;
  }else{
    year = Global.nowDate.year-1;
    term = 2;
  }
  Prefs.schoolYear = year.toString();
  Prefs.schoolTerm = term.toString();
}

class Global{
  static ApiUrl apiUrl = new ApiUrl();//网络请求url汇总
  static CourseInfo courseInfo = new CourseInfo(); //课表信息
  static LoginInfo loginInfo = new LoginInfo();//登录信息
  static ScoreInfo scoreInfo = new ScoreInfo();//成绩信息
  static ExamInfo examInfo = new ExamInfo();//考试信息
  static ExamInfo examDiyInfo = new ExamInfo(msg: '',status: '0',data: []);//自定义倒计时
  static BookInfo bookInfo = new BookInfo();//图书馆书籍信息
  static BookDetailInfo bookDetailInfo = new BookDetailInfo();
  static DateTime nowDate = DateTime.now(); //当前日期
  static PowerInfo powerInfo = new PowerInfo();//电量信息
  static BalanceInfo balanceInfo = new BalanceInfo();//校园卡余额
  static SwiperInfo swiperInfo = new SwiperInfo();//轮播图
  static RankInfo rankInfo = new RankInfo();//内测用户排名
  static bool igUpgrade;//是否忽略更新
  static String curVersion;
  static clearPrefsData(){
    loginInfo = new LoginInfo();
    courseInfo = new CourseInfo();
    scoreInfo = new ScoreInfo();
    examInfo = new ExamInfo();
    Prefs.prefs.clear();
    getSchoolYearTerm();
  }


}

class ApiUrl{
  String loginUrl = "https://api.kxz.atcumt.com/jwxt/login";//登录请求
  String newLoginUrl = "https://api.kxz.atcumt.com/new/login";//登录请求
  String courseUrl = "https://api.kxz.atcumt.com/jwxt/kb";//课表查询
  String scoreUrl = "https://api.kxz.atcumt.com/jwxt/grade";//成绩查询
  String examUrl = "https://api.kxz.atcumt.com/jwxt/exam";//考试查询
  String bookUrl = "https://api.kxz.atcumt.com/lib/book";//书籍查询
  String powerAutoUrl = "https://api.kxz.atcumt.com/daily/au_df";//自动电量查询
  String powerUrl = "https://api.kxz.atcumt.com/daily/df";//电量手动查询
  String swiperUrl = "http://api.kxz.atcumt.com/daily/home_image";//轮播图
  String rankUrl = "https://api.kxz.atcumt.com/admin/user_id";//用户内测排名
  String feedbackUrl = "https://api.kxz.atcumt.com/admin/feedback";//反馈
  String cumtLoginUrl = "http://10.2.5.251:801/eportal/";//校园网登陆
  String appUpgradeUrl = "https://api.kxz.atcumt.com/admin/version";//检查App更新
  String balanceUrl = "https://api.kxz.atcumt.com/new/simpleBalance";//校园卡余额
}
