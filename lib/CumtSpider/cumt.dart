
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
  bool haveLoginJw;
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
  CookieJar cookieJarJw;
   Dio dio = new Dio(BaseOptions(
    headers: {
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"},
    validateStatus: (status) { return status < 500; },
    sendTimeout: 3000,
    receiveTimeout: 3000,
    connectTimeout: 3000,));
   Dio dioJw = new Dio(BaseOptions(
     headers: {
       'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
       "X-Requested-With": "XMLHttpRequest"},
     validateStatus: (status) { return status < 500; },
     sendTimeout: 3000,
     receiveTimeout: 3000,
     connectTimeout: 3000,));

  Future<void> init()async{
    haveLoginJw = false;
    haveLogin = false;
    cookieJar = new CookieJar();
    cookieJarJw = new CookieJar();
    dio.interceptors.add(new CumtInterceptors());
    dio.interceptors.add(new CookieManager(cookieJar,));
    dioJw.interceptors.add(new CumtInterceptors());
    dioJw.interceptors.add(new CookieManager(cookieJarJw,));
  }
  Future<void> clearCookie()async{
    try{
      await cookieJar.deleteAll();
    }catch(e){
      print(e.toString());
    }
    try{
      await cookieJarJw.deleteAll();
    }catch(e){
      print(e.toString());
    }
  }
  Future<bool> login(String username,String password)async{
    print(username+' '+password);
    try{
      if(haveLogin) return true;
      var res = await dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',options: Options(followRedirects:true,));
      print("字段长度："+res.toString().length.toString());
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
          if(loginResponse.statusCode==401){
            showToast('账号或密码错误');
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
    // try{
    //   this.username = username;
    //   this.password = password;
    //   var officialHtml = await dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A//portal.cumt.edu.cn/casservice',);
    //   //解析并登录
    //   var document = parser.parse(officialHtml.data);
    //   var pwdSalt = document.body.querySelector("#pwdEncryptSalt").attributes['value']??'';
    //   var execution = document.body.querySelectorAll('#execution')[2].attributes['value']??'';
    //   var newPassword = await _pwdAes(password, pwdSalt);
    //   var loginResponse = await dio.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',data: FormData.fromMap({
    //     'username': username,
    //     'password': newPassword,
    //     '_eventId': 'submit',
    //     'cllt': 'userNameLogin',
    //     'execution': execution,
    //     'rememberMe':'true'
    //   }),options: Options(followRedirects: false),);
    //   if(loginResponse.statusCode==401){
    //     showToast('账号或密码错误');
    //     return false;
    //   }
    //   await redirect(loginResponse.headers.value('Location'));
    //   Prefs.username = username;
    //   Prefs.password = password;
    //   return true;
    // }on DioError catch(e){
    //   _handleError(e,);
    //   debugPrint(e.toString());
    //   return false;
    // }
  }
  Future<bool> loginJw()async{
    print(username+' '+password);
    try{
      if(await checkConnect()){
        if(haveLoginJw) return true;
        // 登录教务系统
        var jwRes = await dioJw.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin',options: Options(followRedirects:true,));
        print("字段长度："+jwRes.toString().length.toString());
        print(jwRes.toString());
        if(jwRes.toString().length>35000){
          //解析并登录
          var document = parser.parse(jwRes.data);
          var pwdSalt = document.body.querySelector("#pwdEncryptSalt").attributes['value']??'';
          print(pwdSalt);
          var execution = document.body.querySelectorAll('#execution')[2].attributes['value']??'';
          print(execution);
          var newPassword = await _pwdAes(Prefs.password, pwdSalt);
          var loginResponse = await dioJw.post('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin',data: FormData.fromMap({
            'username': Prefs.username,
            'password': newPassword,
            '_eventId': 'submit',
            'cllt': 'userNameLogin',
            'execution': execution,
          }),options: Options(followRedirects: false),);
          print({
            'username': username,
            'password': newPassword,
            '_eventId': 'submit',
            'cllt': 'userNameLogin',
            'execution': execution,
          });
          var res1 = await dioJw.get(loginResponse.headers.value('location'),options: Options(followRedirects: false));
          var res2 = await dioJw.get(res1.headers.value('location'),options: Options(followRedirects: false));
          var res3 = await dioJw.get(res2.headers.value('location'),options: Options(followRedirects: false));
          haveLoginJw = true;
          return true;
        }
        return true;
      }else{
        toTipPage();
        return false;
      }

    }catch(e){
      print(e.toString());
      return false;
    }
  }
  //检查教务Cookie
  Future<bool> checkJwCookie()async{
    try{
      var res = await dio.get('http://jwxt.cumt.edu.cn/jwglxt');
      print(res.toString());
      if(res.statusCode==302){
        return false;
      }
      return true;
    }on DioError catch(e){
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
      print("正在检查内网");
      var res = await Dio(BaseOptions(connectTimeout: 4000)).get('http://jwxt.cumt.edu.cn/jwglxt');
      print('已连接内网');
      return true;
    }on DioError catch(e){
      print('未连接内网');
      return false;
    }
  }
  Future<void> logout()async{
    var res = await dio.get('http://portal.cumt.edu.cn/portal/sso/logout');
    print(res.toString());
  }
  Future<void> logoutJw()async{
    var resJw = await dio.get('http://jwxt.cumt.edu.cn/jwglxt/logout?t=1623069320417&login_type=');
    print(resJw.toString());
  }
  //获取姓名手机号
  Future<Map<String,dynamic>> getNamePhone()async{
    if(await login(username, password)){
      var res = await dio.get('http://portal.cumt.edu.cn/portal/api/v1/api/http/8',);
      var map = jsonDecode(res.toString());
      map = map['entities'][0];
      var result = {
        'name':map['name']??'',
        'phone':map['phone']??''
      };
      return result;
    }
  }

  //获取校园卡余额
  Future<bool> getBalance()async{

    if(Prefs.visitor){
      Prefs.cardNum = '123456';
      Prefs.balance = '52.1';
      return true;
    }
    try{
      await login(username, password);
      var res = await dio.get(_urlMap[InquiryType.Balance]);
      print(res.toString().length);
      var map = jsonDecode(res.toString());
      Prefs.cardNum = map['data']['ZH'];
      Prefs.balance = (double.parse(map['data']['YE'])/100).toStringAsFixed(2);
      sendInfo('校园卡', '获取校园卡余额:${Prefs.balance}');
      return true;
    }on DioError catch(e){
      print('获取校园卡余额失败');
      return false;
    }
  }
  //校园卡流水
  Future<bool> getBalanceHistory()async{

    try{
      await login(username, password);
      var res = await dio.get(_urlMap[InquiryType.BalanceHistory]);
      debugPrint(res.toString());
      var map = jsonDecode(res.toString());
      map = CumtFormat.parseBalanceHis(map);
      Global.balanceDetailInfo = BalanceDetailInfo.fromJson(map);
      return true;
    }on DioError catch(e){
      print('获取校园卡流水失败');
      return false;
    }
  }
  bool checkTimes(InquiryType inquiryType){
    return true;
    var map = {};
    var key = _urlMap[inquiryType].substring(0,33);
    Map<String,dynamic> curMap;
    var now = DateTime.now();
    //提取Prefs
    if(Prefs.timesMap!=null){
      map = jsonDecode(Prefs.timesMap);
      curMap = map[key];
    }
    print(map.toString());
    if(curMap==null){
      map[key] = {
        'date': now.toString(),
        'times': 2
      };
      Prefs.timesMap = jsonEncode(map);
      return true;
    }else{
      var preDate = DateTime.parse(curMap['date']);
      if(now.isBefore(preDate.add(Duration(hours: 1)))){
        //一小时之内
        if(curMap['times']>0){
          curMap['times']--;
          map[key] = curMap;
          Prefs.timesMap = jsonEncode(map);
          return true;
        }else{
          showToast('此功能每小时最多查询3次，过会再来吧～',duration: 3);
          return false;
        }
      }else{
        //过了一小时，刷新time
        curMap['date'] = now.toString();
        curMap['times'] = 2;
        map[key] = curMap;
        Prefs.timesMap = jsonEncode(map);
        return true;
      }
    }
  }
  //宿舍电量查询
  Future<bool> getPower(String home,String num)async{
    await login(username, password);
    var host = "http://www.houqinbao.com/hydropower/index.php?rebind=1&m=PayWeChat&c=Index&a=bingding&token=&openid"
        "=oUiRowd11jcJJHzVjZHgbb7OyWqE&schoolcode=13579&payopenid= ";
    await dio.get(host);
    try{
      var data = {'flatname': home, 'roomname': num};
      var res = await dio.post('http://www.houqinbao.com/hydropower/index.php?m=PayWeChat&c=IndexKd&a=find&schoolcode=13579',data: FormData.fromMap(data));
      var map = jsonDecode(res.toString());
      if(map['code']!=40001){
        print(map['data']['dushu'].toString());
        var power = map['data']['dushu'].toString();
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
        sendInfo('宿舍电量', '查询电量:$home,$num,$powerDouble');
        return true;
      }
      return false;
    }on DioError catch(e){
      print("获取宿舍电量失败");
      return false;
    }
  }
  //查询
  Future<String> inquiryJw(InquiryType inquiryType,String xnm,String xqm,)async{
    if(await loginJw()){
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
        var res = await dioJw.post(url,
          data:FormData.fromMap(formMap),queryParameters: {
            'su':username,
            'gnmkdm':'N253508'
          },);
        showToast('获取成功！');
        debugPrint(res.toString());
        return res.toString();
      }on DioError catch(e){
        //cookie过期重新获取
        return '';
      }
    }
    return '';
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
  Future<bool> searchVideo({String courseName})async{
    await login(username, password);
    try{
      var res1 = await dio.get('http://class.cumt.edu.cn/Login/Login?returnUrl=http://class.cumt.edu.cn/CourseVideo/CourseVideoDemandIndex', options: Options(followRedirects: false));
      var res2 = await dio.get(res1.headers.value('location'),options: Options(followRedirects: false));
      var res3 = await dio.get(res2.headers.value('location'),options: Options(followRedirects: false));
      var res4 = await dio.get(res3.headers.value('location'),options: Options(followRedirects: false));
      var dataMap = {
        'page':'1',
        'rows':'300',
      };
      if(courseName!=null) dataMap['CourseName'] = courseName;
      var res = await dio.post('http://class.cumt.edu.cn/StudentCourseVideo/coursedemandimg',data: FormData.fromMap(dataMap),);
      print(res.toString());
      Global.videoInfo = VideoInfo.fromJson(jsonDecode(res.toString()));
      return true;
    }on DioError catch(e){
      print('查询视频失败');
      return false;
    }
  }
  Future<bool> getVideoDetail(CourseDateList data)async{
    var courseID = data.courseID;
    var courseCode = data.courseCode;
    var courseDate = data.date;
    // var courseName = widget.videoData.course.courseName;
    var a = await cumt.dio.get('http://class.cumt.edu.cn/StudentCourseVideo/StudentCourseVideoDemandInfo',
        queryParameters: {
          'CourseID':courseID,
          'CourseCode':courseCode,
          'CourseDate':courseDate,
          // 'CourseName':courseName
        });
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
