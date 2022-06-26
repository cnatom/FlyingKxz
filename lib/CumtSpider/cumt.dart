
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/balance_detail_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/CumtSpider/cumt_format.dart';
import 'package:flying_kxz/Model/video__data.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../FlyingUiKit/toast.dart';
import '../pages/tip_page.dart';
import 'cumt_interceptors.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;

Cumt cumt = new Cumt();
enum InquiryType {Course,Score,ScoreAll,Exam,Balance,BalanceHistory,Power}
class Cumt {
  bool haveLogin;
  String username = Prefs.username??'';
  String password = Prefs.password??'';
  Map<InquiryType,String> _urlMap = {
    InquiryType.Course:'http://jwxt.cumt.edu.cn/jwglxt/kbcx/xskbcx_cxXsKb.html',
    InquiryType.Score:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxXsKccjList.html',
    InquiryType.ScoreAll:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html',
    InquiryType.Exam:'http://jwxt.cumt.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html',
    InquiryType.Balance:'http://portal.cumt.edu.cn/ykt/balance',//校园卡余额
    InquiryType.BalanceHistory:'http://portal.cumt.edu.cn/ykt/flow?flow_num=20',
    InquiryType.Power:'http://www.houqinbao.com/hydropower/index.php?m=PayWeChat&c=IndexKd&a=find&schoolcode=13579'
  };
  Map<InquiryType,String> _urlVisitorMap = {
    InquiryType.Course:'https://user.kxz.atcumt.com/jwxt/timetable',
    InquiryType.Score:'https://user.kxz.atcumt.com/jwxt/grades',
    InquiryType.ScoreAll:'https://user.kxz.atcumt.com/jwxt/grades',
    InquiryType.Exam:'https://user.kxz.atcumt.com/jwxt/exam',
    InquiryType.Balance:'https://api.kxz.atcumt.com/card/balance',
    InquiryType.BalanceHistory:'https://api.kxz.atcumt.com/card/history'
  };
  CookieJar cookieJar;
   Dio dio = new Dio(BaseOptions(
    headers: {
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"},
    validateStatus: (status) { return status < 500; },
    sendTimeout: 3000,
    receiveTimeout: 3000,
    connectTimeout: 3000,));

  Future<void> init()async{
    haveLogin = false;
    cookieJar = new CookieJar();
    // dio.interceptors.add(new CumtInterceptors());
    dio.interceptors.add(new CookieManager(cookieJar,));
  }
  Future<void> clearCookie()async{
    try{
      await cookieJar.deleteAll();
    }catch(e){
      print(e.toString());
    }
  }
  Future<bool> login(String username,String password)async{
    try{
      if(haveLogin) return true;
      var res = await dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',options: Options(followRedirects:true,));
      if(res.toString().length>35000){
        //解析并登录
        var document = parser.parse(res.data);
        var pwdSalt = document.body.querySelector("#pwdEncryptSalt").attributes['value']??'';
        var execution = document.body.querySelectorAll('#execution')[2].attributes['value']??'';
        var newPassword = await _pwdAes(password??Prefs.password, pwdSalt);
        var loginResponse = await dio.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',data: FormData.fromMap({
          'username': username??Prefs.username,
          'password': newPassword,
          '_eventId': 'submit',
          'cllt': 'userNameLogin',
          'execution': execution,
        }),options: Options(followRedirects: false),);
        //检查单点登录
        if(loginResponse.statusCode==200&&loginResponse.headers.value('X-Frame-Options')=="DENY"){
          print('检测到登录冲突，正在注销其他设备登录态');
          var document = parser.parse(loginResponse.data);
          var execution = document.body.querySelector("input[name='execution']").attributes['value']??'';
          loginResponse = await dio.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',data: FormData.fromMap({
            '_eventId': 'continue',
            'execution': execution,
          }),options: Options(followRedirects: false),);
        }

        if(loginResponse.statusCode==401){
            showToast('账号或密码错误\n（挂VPN也可能会无法登录）');
            return false;
          }
          if(loginResponse.headers.value('location')!=null&&loginResponse.headers.value('location').contains('improveInfo')){
            showToast('登录失败\n密码包含了用户的敏感信息(如：帐户、手机号或邮箱等)，请前往融合门户修改密码',duration: 5);
            return false;
          }
        var res1 = await dio.get(loginResponse.headers.value('location'),options: Options(followRedirects: false));
        haveLogin = true;
        Prefs.username = username;
        Prefs.password = password;
        return true;
      }
      return true;
    }on DioError catch(e){
      _handleError(e);
      return false;
    }

  }
  //在每次请求前都要检查
  _handleError(DioError e,)async{
    switch(e.type){
      case DioErrorType.connectTimeout:
        showToast('连接超时QAQ');
        break;
      case DioErrorType.sendTimeout:
        showToast( '发送超时QAQ');
        break;
      case DioErrorType.receiveTimeout:
        showToast( '接收超时QAQ');
        break;
      case DioErrorType.response:
        showToast( '响应码错误QAQ');
        break;
      case DioErrorType.cancel:
        showToast( '请求被取消QAQ');
        break;
      case DioErrorType.other:
        showToast( '未知错误QAQ');
        break;
    }
  }
  static Future<bool> checkConnect()async{
    try{
      showToast('正在检测内网环境……',duration: 4);
      var res = await Dio(BaseOptions(connectTimeout: 4000,receiveTimeout: 4000,sendTimeout: 4000)).get('http://jwxt.cumt.edu.cn/jwglxt');
      if(res!=null){
        showToast('已连接内网！');
      }
      return true;
    }on DioError catch(e){
      showToast('未连接内网');
      return false;
    }
  }
  Future<void> logout()async{
    var res = await dio.get('http://portal.cumt.edu.cn/portal/sso/logout');
    print(res.toString());
  }
  //获取姓名手机号
  Future<Map<String,dynamic>> getNamePhone()async{
    if(await login(username, password)){
      var res = await dio.get('http://portal.cumt.edu.cn/portal/api/v1/api/http/8',);
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      map = map['entities'][0];
      var result = {
        'name':map['name']??'',
        'phone':map['phone']??''
      };
      return result;
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
