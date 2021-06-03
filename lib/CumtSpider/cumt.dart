
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/balance_detail_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/rank_info.dart';
import 'package:flying_kxz/CumtSpider/cumt_format.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:path_provider/path_provider.dart';
import 'cumt_interceptors.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;

Cumt cumt = new Cumt();
enum InquiryType {Course,Score,ScoreAll,Exam,Balance,BalanceHistory,Power}
class Cumt {
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
  Dio _dio = new Dio(BaseOptions(
    headers: {
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"},
    validateStatus: (status) { return status < 500; },
    sendTimeout: 5000,
    receiveTimeout: 5000,
    connectTimeout: 5000,));

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
  Future<bool> login(String username,String password,{BuildContext context})async{
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
      var loginResponse = await _dio.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',data: FormData.fromMap({
        'username': username,
        'password': newPassword,
        '_eventId': 'submit',
        'cllt': 'userNameLogin',
        'execution': execution,
        'rememberMe':'true'
      }),options: Options(followRedirects: false),);
      if(loginResponse.statusCode==401){
        showToast(context, '账号或密码错误');
        return false;
      }
      var loginLoopRes = await _dio.get(loginResponse.headers.value('Location'),options: Options(followRedirects: false));
      // 登录教务系统
      var jwRes = await _dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin',options: Options(followRedirects:false,));
      var jwLoopRes = await _dio.get(jwRes.headers.value('location'),);
      var jwCookieRes = await _dio.get(jwLoopRes.redirects[1].location.toString());
      Prefs.username = username;
      Prefs.password = password;
      return true;
    }on DioError catch(e){
      _handleError(e,context:context);
      debugPrint(e.toString());
      return false;
    }
  }
  _handleError(DioError e,{BuildContext context})async{
    if(context!=null){
      switch(e.type){
        case DioErrorType.connectTimeout:
          showToast(context, '连接超时，请确保您已连接学校内网',duration: 3);
          Future.delayed(Duration(seconds: 3),(){
            toTipPage(context);
          });
          break;
        case DioErrorType.sendTimeout:
          showToast(context, '发送超时QAQ');
          break;
        case DioErrorType.receiveTimeout:
          showToast(context, '接收超时QAQ');
          break;
        case DioErrorType.response:
          showToast(context, '响应码错误QAQ');
          break;
        case DioErrorType.cancel:
          showToast(context, '请求被取消QAQ');
          break;
        case DioErrorType.other:
          showToast(context, '未知错误QAQ');
          break;
      }
    }
  }
  static Future<String> checkConnect()async{
    try{
      await Dio(BaseOptions(connectTimeout: 5000)).get('http://jwxt.cumt.edu.cn/sso/jziotlogin');
      return '🎉已连接内网';
    }on DioError catch(e){
      if(e.type==DioErrorType.connectTimeout){
        return '未连接内网';
      }
      return e.response.statusCode.toString();
    }
  }
  Future<void> logout()async{
    var res = await _dio.get('http://portal.cumt.edu.cn/portal/sso/logout');
    print(res.toString());
  }
  //获取姓名手机号
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
  //请求失败时刷新Cookie
  Future<bool> _refreshCookies()async{
    if(await login(username, password)) return true;
    return false;
  }
  //获取校园卡余额
  Future<bool> getBalance()async{
    if(Prefs.visitor){
      Prefs.cardNum = '123456';
      Prefs.balance = '52.1';
      return true;
    }
    try{
      var res = await _dio.get(_urlMap[InquiryType.Balance]);
      print(res.toString().length);
      if(res.toString().length>10000){
        if(await _refreshCookies()){
          return await getBalance();
        }else{
          return false;
        }
      }
      var map = jsonDecode(res.toString());
      Prefs.cardNum = map['data']['ZH'];
      Prefs.balance = (double.parse(map['data']['YE'])/100).toStringAsFixed(2);
      return true;
    }on DioError catch(e){
      if(await _refreshCookies()){
        return await getBalance();
      }else{
        return false;
      }
    }
  }
  //校园卡流水
  Future<bool> getBalanceHistory()async{
    try{
      var res = await _dio.get(_urlMap[InquiryType.BalanceHistory]);
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      map = CumtFormat.parseBalanceHis(map);
      Global.balanceDetailInfo = BalanceDetailInfo.fromJson(map);
      return true;
    }on DioError catch(e){
      if(await _refreshCookies()){
        return await getBalanceHistory();
      }else{
        return false;
      }
    }
  }
  //宿舍电量查询
  Future<bool> getPower(String home,String num)async{
    var host = "http://www.houqinbao.com/hydropower/index.php?rebind=1&m=PayWeChat&c=Index&a=bingding&token=&openid"
    "=oUiRowd11jcJJHzVjZHgbb7OyWqE&schoolcode=13579&payopenid= ";
    await _dio.get(host);
    try{
      var data = {'flatname': home, 'roomname': num};
      var res = await _dio.post(_urlMap[InquiryType.Power],data: FormData.fromMap(data));
      var match = new RegExp('dushu\":(.*?),').firstMatch(res.toString());
      var power = match.group(0).substring(7,13);
      print(res.toString());
      var powerDouble = double.parse(power);
      //没记录过最大电量，则初始化
      if(Prefs.powerMax==null) Prefs.powerMax = powerDouble;
      if(Prefs.power==null) Prefs.power = 0.0;
      //当电量比上次多时，保存最大电量
      if(powerDouble>Prefs.power){
        Prefs.powerMax = powerDouble;
      }
      //如果更换了绑定信息，则重新统计
      if(num!=Prefs.powerNum||home!=Prefs.powerHome){
        Prefs.powerMax = powerDouble;
      }
      //保存电量
      Prefs.power = powerDouble;
      //保存绑定信息
      Prefs.powerNum = num;
      Prefs.powerHome = home;
      return true;
    }on DioError catch(e){
      if(await _refreshCookies()){
        return await getBalanceHistory();
      }else{
        return false;
      }
    }
  }
  //查询
  Future<String> inquiry(InquiryType inquiryType,String xnm,String xqm)async{
    var url = Prefs.visitor?_urlVisitorMap[inquiryType]:_urlMap[inquiryType];
    var transMap = {
      '0':'',
      '1':'3',
      '2':'12',
      '3':'16'
    };
    xqm = transMap[xqm]??'';
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
      return res.toString();
    }on DioError catch(e){
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
