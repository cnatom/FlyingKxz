

import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

//获取本地信息
//Prefs.init()
//Prefs.getSchoolYear()
//Prefs.setSchoolYear()

class Prefs{

  static SharedPreferences prefs;
  static String _backImg = 'backImg';//背景图
  static String _username = 'username';//用户名
  static String _password = 'password2';//密码
  static String _phone = 'phone';//电话号码
  static String _name = 'name';//姓名
  static String _token = 'NewToken1.2.0';//token信息
  static String _college = 'college';//学院
  static String _className = 'className';//班级
  static String _power = 'powerNew';//宿舍电量
  static String _powerMax = 'powerMaxNew';//宿舍最大电量
  static String _powerBuilding = "powerBuilding";// 研梅
  static String _powerRoomid = "powerRoomid";// M2B421
  static String _powerRequestDate = "powerRequestDate";// 最近查询宿舍电量的时间
  static String _balance = 'balance';//校园卡余额
  static String _balanceHis = 'balanceHis';//校园卡流水
  static String _balanceRequestDate = 'balanceRequestDate'; // 最近查询校园卡的时间
  static String _balanceRequestHisDate = 'balanceRequestHisDate'; // 最近查询校园卡流水的时间
  static String _cardNum = 'cardNum';//卡号
  static String _rank = 'rank';//用户内测排名
  static String _courseData = 'courseData';//课表
  static String _examData = 'examData';//考试
  static String _examDataDiy = 'examDataDiy';//自定义考试
  static String _schoolYear = 'schoolYear';//当前学年
  static String _schoolTerm = 'schoolTerm';//当前学期
  static String _cumtLoginUsername = "cumtLoginUsername";//校园网账号
  static String _cumtLoginPassword = "cumtLoginPassword";//校园网账号
  static String _cumtLoginMethod = "cumtLoginMethod";//登录方式
  static String _admissionDate = "admissionDate1";//开学日期
  static String _themeData = "themeData";
  static String _visitor = "visitor";//游客模式
  static String _timesMap = "timesMap";
  static String _scoreMap = "scoreMap";//针对特殊成绩的处理
  static String _courseIcsUrl = "courseIcsUrl";//订阅日历url
  static String _courseIcsDate = "courseIcsDate";//订阅日历url


  static String get examDataDiy => prefs.getString(_examDataDiy);
  static String get backImg => prefs.getString(_backImg);
  static String get username => prefs.getString(_username);
  static String get password => prefs.getString(_password);
  static String get phone => prefs.getString(_phone);
  static String get name => prefs.getString(_name);
  static String get token => prefs.getString(_token);
  static String get college => prefs.getString(_college);
  static String get className => prefs.getString(_className);
  static double get power => prefs.getDouble(_power);
  static double get powerMax => prefs.getDouble(_powerMax);
  static String get powerBuilding => prefs.getString(_powerBuilding);
  static String get powerRoomid => prefs.getString(_powerRoomid);
  static String get powerRequestDate => prefs.getString(_powerRequestDate);
  static String get balance => prefs.getString(_balance);
  static String get balanceHis => prefs.getString(_balanceHis);
  static String get balanceRequestDate => prefs.getString(_balanceRequestDate);
  static String get balanceRequestHisDate => prefs.getString(_balanceRequestHisDate);
  static String get cardNum => prefs.getString(_cardNum);
  static String get rank => prefs.getString(_rank);
  static String get courseData => prefs.getString(_courseData);
  static String get examData => prefs.getString(_examData);
  static String get schoolYear => prefs.getString(_schoolYear);
  static String get schoolTerm => prefs.getString(_schoolTerm);
  static String get cumtLoginUsername => prefs.getString(_cumtLoginUsername);
  static String get cumtLoginPassword => prefs.getString(_cumtLoginPassword);
  static int get cumtLoginMethod => prefs.getInt(_cumtLoginMethod);
  static String get admissionDate=> prefs.getString(_admissionDate);
  static String get themeData => prefs.getString(_themeData);
  static bool get visitor => prefs.getBool(_visitor);
  static String get timesMap => prefs.getString(_timesMap);
  static String get scoreMap => prefs.getString(_scoreMap);
  static String get courseIcsUrl => prefs.getString(_courseIcsUrl);
  static String get courseIcsDate => prefs.getString(_courseIcsDate);

  static set examDataDiy(String value) =>prefs.setString(_examDataDiy, value);
  static set backImg(String value) =>prefs.setString(_backImg, value);
  static set username(String value) =>prefs.setString(_username, value);
  static set password(String value) =>prefs.setString(_password, value);
  static set phone(String value) =>prefs.setString(_phone, value);
  static set name(String value) =>prefs.setString(_name, value);
  static set token(String value) =>prefs.setString(_token, value);
  static set college(String value) =>prefs.setString(_college, value);
  static set className(String value) =>prefs.setString(_className, value);
  static set power(double value) =>prefs.setDouble(_power, value);
  static set powerMax(double value) =>prefs.setDouble(_powerMax, value);
  static set powerRoomid(String value) =>prefs.setString(_powerRoomid, value);
  static set powerBuilding(String value) =>prefs.setString(_powerBuilding, value);
  static set powerRequestDate(String value) =>prefs.setString(_powerRequestDate, value);
  static set balance(String value) =>prefs.setString(_balance, value);
  static set balanceHis(String value) =>prefs.setString(_balanceHis, value);
  static set balanceRequestDate(String value) =>prefs.setString(_balanceRequestDate, value);
  static set balanceRequestHisDate(String value) =>prefs.setString(_balanceRequestHisDate, value);
  static set cardNum(String value) =>prefs.setString(_cardNum, value);
  static set rank(String value) =>prefs.setString(_rank, value);
  static set courseData(String value) =>prefs.setString(_courseData, value);
  static set examData(String value) =>prefs.setString(_examData, value);
  static set schoolYear(String value) =>prefs.setString(_schoolYear, value);
  static set schoolTerm(String value) =>prefs.setString(_schoolTerm, value);
  static set cumtLoginUsername(String value) =>prefs.setString(_cumtLoginUsername, value);
  static set cumtLoginPassword(String value) =>prefs.setString(_cumtLoginPassword, value);
  static set cumtLoginMethod(int value) =>prefs.setInt(_cumtLoginMethod, value);
  static set admissionDate(String value) =>prefs.setString(_admissionDate, value);
  static set themeData(String value) =>prefs.setString(_themeData, value);
  static set visitor(bool value) =>prefs.setBool(_visitor, value);
  static set timesMap(String value) =>prefs.setString(_timesMap, value);
  static set scoreMap(String value) =>prefs.setString(_scoreMap, value);
  static set courseIcsUrl(String value) =>prefs.setString(_courseIcsUrl, value);
  static set courseIcsDate(String value) =>prefs.setString(_courseIcsDate, value);

  static Future<void> init()async{
    prefs = await SharedPreferences.getInstance();
    _initSchoolYearTerm();
    _initAdmissionDate();
  }
  //获取当前学年学期
  static void  _initSchoolYearTerm()async{
    DateTime nowDate = DateTime.now();
    int year,term;
    if(nowDate.isBefore(DateTime(nowDate.year,2,1))){
      year = nowDate.year-1;
      term = 1;
    }else if(nowDate.isAfter(DateTime(nowDate.year,8,1))){
      year = nowDate.year;
      term = 1;
    }else{
      year = nowDate.year-1;
      term = 2;
    }
    Prefs.schoolYear = year.toString();
    Prefs.schoolTerm = term.toString();
  }
  //获取开学日期
static void _initAdmissionDate(){
    if(Prefs.admissionDate==null){
      if(schoolTerm == '2'){
        Prefs.admissionDate = (int.parse(schoolYear)+1).toString()+'-03-01';
      }else{
        Prefs.admissionDate = schoolYear+'-09-01';
      }
    }
}


}