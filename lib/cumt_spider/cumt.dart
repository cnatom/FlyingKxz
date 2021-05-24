
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:path_provider/path_provider.dart';
import 'cumt_interceptors.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;

Cumt cumt = new Cumt();
enum InquiryType {Course,Score,ScoreAll,Exam}
class Cumt {
  String username = Prefs.username??'';
  String password = Prefs.password??'';
  Map<InquiryType,String> _urlMap = {
    InquiryType.Course:'http://jwxt.cumt.edu.cn/jwglxt/kbcx/xskbcx_cxXsKb.html',
    InquiryType.Score:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxXsKccjList.html',
    InquiryType.ScoreAll:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html',
    InquiryType.Exam:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxXsKccjList.html'
  };
  Map<InquiryType,String> _urlVisitorMap = {
    InquiryType.Course:ApiUrl.courseUrl,
    InquiryType.Score:ApiUrl.scoreUrl,
    InquiryType.ScoreAll:ApiUrl.scoreUrl,
    InquiryType.Exam:ApiUrl.examUrl
  };

  CookieJar cookieJar;
  Dio _dio = new Dio(BaseOptions(headers: {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"},validateStatus: (status) { return status < 500; },sendTimeout: 5000,receiveTimeout: 5000,connectTimeout: 5000,));

  Future<void> init()async{
    Directory tempDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
        ignoreExpires: false,
        storage: FileStorage(tempDir.path)
    );
    _dio.interceptors.add(new CumtInterceptors());
    _dio.interceptors.add(new CookieManager(cookieJar,));
    // _dio.interceptors.add(new LogInterceptor());

  }
  Future<bool> login(String username,String password)async{
    try{
      Directory tempDir = await getApplicationDocumentsDirectory();
      if(!(await tempDir.list().isEmpty)) cookieJar.deleteAll();
      this.username = username;
      this.password = password;
      var officialHtml = await _dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A//portal.cumt.edu.cn/casservice',);
      //解析并登录
      var document = parser.parse(officialHtml.data);
      var pwdSalt = document.body.querySelector("#pwdEncryptSalt").attributes['value']??'';
      var execution = document.body.querySelectorAll('#execution')[2].attributes['value']??'';
      var newPassword = await _pwdAes(password, pwdSalt);
      print(newPassword);
      var loginResponse = await _dio.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',data: FormData.fromMap({
        'username': username,
        'password': newPassword,
        '_eventId': 'submit',
        'cllt': 'userNameLogin',
        'execution': execution,
        'rememberMe':'true'
      }),options: Options(followRedirects: false),);
      print(loginResponse.headers.toString());
      var loginLoopRes = await _dio.get(loginResponse.headers.value('Location'),options: Options(followRedirects: false));
      // 登录教务系统
      var jwRes = await _dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin',options: Options(followRedirects:false,));
      print(jwRes.headers.toString());
      var jwLoopRes = await _dio.get(jwRes.headers.value('location'),);
      var jwCookieRes = await _dio.get(jwLoopRes.redirects[1].location.toString());
      Prefs.username = username;
      Prefs.password = password;
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }
  Future<void> logout()async{
    var res = await _dio.get('http://portal.cumt.edu.cn/portal/sso/logout');
    print(res.toString());
  }
  Future<Map<String,dynamic>> getNamePhone()async{
    var res = await _dio.get('http://portal.cumt.edu.cn/portal/api/v1/api/http/8',);
    if(res.toString().length>10000){
      if(await _refreshCookies()){
        return await getNamePhone();
      }
    }
    var map = jsonDecode(res.toString());
    map = map['entities'][0];
    var result = {
      'name':map['name']??'',
      'phone':map['phone']??''
    };
    return result;
  }
  Future<bool> _refreshCookies()async{
    if(await login(username, password)) return true;
    return false;
  }
  Future<String> inquiry(InquiryType inquiryType,String xnm,String xqm)async{
    var url = Prefs.visitor?_urlVisitorMap[inquiryType]:_urlMap[inquiryType];
    var transMap = {
      '0':'',
      '1':'3',
      '2':'12',
      '3':'16'
    };
    xqm = transMap[xqm];
    if(xnm=='0') xnm = '';
    try{
      var formMap = {
        'doType':'query',
        'xnm': xnm,
        'xqm': xqm
      };
      if(inquiryType == InquiryType.Score || inquiryType == InquiryType.ScoreAll) formMap['queryModel.showCount'] = '300';
      var res = await _dio.post(url,
        data:FormData.fromMap(formMap),queryParameters: {
          'su':username,
          'gnmkdm':'N253508'
        },);
      debugPrint(res.toString());
      return res.toString();
    }on DioError catch(e){
      debugPrint(e.toString());
      //cookie过期重新获取
      if(e.response.statusCode!=200){
        if(await _refreshCookies()){
          return await inquiry(inquiryType, xnm, xqm);
        }
      }
      return '';
    }
  }
  /// 2020-2021 -> 2020   全部学年 -> ''
  /// 第1学期 -> 1   全部学期 -> ''
  static List<String> transYearTerm(String year,String term){
    List<String> result = ['',''];
    if(year == '全部学年'){
      result[0] = '';
    }else{
      result[0] = year.substring(0,4);
    }
    //学期转换
    if(term == '全部学期'){
      result[1] = '';
    }else{
      result[1] = term.substring(1,2);
    }
    return result;
  }
  Future<void> initVideo()async{
    var res = await _dio.get('http://class.cumt.edu.cn/Login/Login?returnUrl=http://class.cumt.edu.cn/CourseVideo/CourseVideoDemandIndex',options: Options(followRedirects: false));
  }
  Future<void> searchVideo({String courseName = ''})async{
    var dataMap = {
      'page':'1',
      'rows':'5',
    };
    if(courseName!='') dataMap['CourseName'] = courseName;
    var res = await _dio.post('http://class.cumt.edu.cn/StudentCourseVideo/coursedemandimg',data: FormData.fromMap(dataMap),);
    print(res.toString().substring(0,300));
  }
  Future<String> _pwdAes(String password, String salt) async {
    try {
      Response response;
      var queryParameters = {'pwd': password, 'salt': salt};
      response = await Dio().get('https://service-0gxixtbh-1300058565.sh.apigw.tencentcs.com/release/password', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      print(e.response.toString());
    }
    return '';
  }
  void printCookies(String url)async{
    print('打印cookie 来自  '+url);
    var cookies = await cookieJar.loadForRequest(Uri.parse(url));
    if(cookies!=null){
      for(var cookie in cookies){
        print('   '+cookie.toString());
      }
    }
  }
}
