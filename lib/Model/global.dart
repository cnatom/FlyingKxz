

//实体类实例汇总
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/rank_info.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:flying_kxz/Model/swiper_info.dart';
import 'package:flying_kxz/Model/user_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'balance_detail_info.dart';
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
  static CourseInfo courseInfo = new CourseInfo(); //课表信息
  static LoginInfo loginInfo = new LoginInfo();//登录信息
  static UserInfo userInfo = new UserInfo();//用户信息
  static ScoreInfo scoreInfo = new ScoreInfo();//成绩信息
  static ExamInfo examInfo = new ExamInfo();//考试信息
  static List<ExamUnit> examList = [];//考试列表
  static BookInfo bookInfo = new BookInfo();//图书馆书籍信息
  static BookDetailInfo bookDetailInfo = new BookDetailInfo();
  static DateTime nowDate = DateTime.now(); //当前日期
  static SwiperInfo swiperInfo = new SwiperInfo();//轮播图
  static RankInfo rankInfo = new RankInfo();//内测用户排名
  static BalanceDetailInfo balanceDetailInfo = new BalanceDetailInfo();//校园卡流水
  static bool igUpgrade;//是否忽略更新
  static String curVersion;
  static clearPrefsData(){
    loginInfo = new LoginInfo();
    courseInfo = new CourseInfo();
    scoreInfo = new ScoreInfo();
    examInfo = new ExamInfo();
    examList = [];
    Prefs.prefs.clear();
    getSchoolYearTerm();
  }


}

class ApiUrl{
  //http://175.27.131.122:5000
  //https://api.kxz.atcumt.com
  //http://119.45.171.211:5000
  // static String _pubUrl = "https://api.kxz.atcumt.com";
  static String _pubUrl = "https://user.kxz.atcumt.com";
  static String _userUrl = "https://user.kxz.atcumt.com";

  static String loginUrl = "$_pubUrl/login";//新登录请求
  static String loginCheckUrl = "http://authserver.cumt.edu.cn/authserver/checkNeedCaptcha.htl";//检测是否激活
  static String userInfoUrl = "$_pubUrl/jwxt/info";//用户信息
  static String courseUrl = "$_pubUrl/jwxt/timetable";//课表查询
  static String scoreUrl = "$_pubUrl/jwxt/grades";//成绩查询
  static String scoreAllUrl = "$_pubUrl/jwxt/makeup/grades";//全成绩查询
  static String examUrl = "$_pubUrl/jwxt/exam";//考试查询
  static String bookUrl = "$_userUrl/lib/book";//书籍查询
  static String powerAutoUrl = "$_pubUrl/daily/au_df";//自动电量查询
  static String powerUrl = "$_pubUrl/electric";//电量手动查询
  static String swiperUrl = "$_pubUrl/daily/home_image";//轮播图
  static String rankUrl = "$_pubUrl/admin/user_id";//用户内测排名
  static String feedbackUrl = "$_userUrl/admin/feedback";//反馈
  static String cumtLoginUrl = "http://10.2.5.251:801/eportal/";//校园网登陆
  static String appUpgradeUrl = "$_userUrl/admin/version";//检查App更新
  static String balanceUrl = "https://api.kxz.atcumt.com/card/balance";//校园卡余额
  static String balanceDetailUrl = "https://api.kxz.atcumt.com/card/history";//校园卡流水
  static String rechargeUrl = "$_pubUrl/card/recharge";//校园卡充值

static List<String> newsUrlList = [
  "$_pubUrl/daily/sd_news",//视点新闻
  "$_pubUrl/daily/xx_news",//信息公告
  "$_pubUrl/daily/rw_news",//人文课堂
  "$_pubUrl/daily/xs_news",//学术聚焦
];
}
