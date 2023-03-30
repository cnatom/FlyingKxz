
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

import '../ui/toast.dart';
import 'cumt_interceptors.dart';

class Cumt{
  static Cumt _instance; //单例
  bool isLogin = false; //是否登录
  Cumt._internal();
  factory Cumt.getInstance() => _getInstance();
  static _getInstance(){
    if(_instance == null){
      _instance = Cumt._internal();
    }
    return _instance;
  }
  String username = Prefs.username??'';
  String password = Prefs.password??'';
  CookieJar cookieJar;
   Dio dio = Dio(BaseOptions(
    headers: {
      'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"},
    validateStatus: (status) { return status < 500; },
    sendTimeout: 4000,
    receiveTimeout: 4000,
    connectTimeout: 4000,));

  Future<void> init()async{
    cookieJar = new CookieJar();
    dio.interceptors.add(new CumtInterceptors());
    dio.interceptors.add(new CookieManager(cookieJar,));
    isLogin = false;
  }
  Future<void> clearCookie()async{
    try{
      await cookieJar.deleteAll();
    }catch(e){
      print(e.toString());
    }
  }
  //获取登录json数据
  Future<bool> loginCheckGet(BuildContext context,
      {@required String username}) async {
    try {
      //配置dio信息
      var res = await dio
          .get("http://authserver.cumt.edu.cn/authserver/checkNeedCaptcha.htl", queryParameters: {"username": username},);
      Map<String, dynamic> map = jsonDecode(res.toString());
      if (map['isNeedActive']!=null&&map['isNeedActive']) {
        debugPrint("账号未激活");
        showToast( "账号未激活\n\n3秒钟后将跳转至激活页面",duration: 4);
        Future.delayed(Duration(seconds: 3),(){
          launchUrl(Uri.parse("http://authserver.cumt.edu.cn/retrieve-password/accountActivation/index.html"));
        });
      } else if (map['isNeed']!=null&&map['isNeed']) {
        showToast( "QAQ\n\n检测到您登录失败次数过多\n\n"
            "融合门户网站出现验证码\n\n"
            "需要您在该网站\"成功登录一次\"以取消验证码\n\n"
            "12秒钟后将跳转至登录页面",duration: 13);
        Future.delayed(Duration(seconds: 12),(){
          launchUrl(Uri.parse("http://authserver.cumt.edu.cn/authserver/login"));
        });

      } else {
        return true;
      }

      return false;
    } catch (e) {
      showToast('连接失败（X_X)');
      return false;
    }
  }

  // 在每个需要融合门户的请求前都要调用一次
  Future<bool> loginDefault()async{
    return await login(this.username,this.password);
  }

  Future<bool> login(String username,String password)async{
    if(isLogin){
      return true;
    }
    try{
      String service = "http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice";
      var res = await dio.get('http://authserver.cumt.edu.cn/authserver/login?service=$service',options: Options(followRedirects:true,));
      if(res.toString().length>35000){
        //解析并登录
        var document = parser.parse(res.data);
        var pwdSalt = document.body.querySelector("#pwdEncryptSalt").attributes['value']??'';
        var execution = document.body.querySelectorAll('#execution')[2].attributes['value']??'';
        var newPassword = await _pwdAes(password??Prefs.password, pwdSalt);
        var loginResponse = await dio.post('http://authserver.cumt.edu.cn/authserver/login?service=$service',data: FormData.fromMap({
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
          loginResponse = await dio.post('http://authserver.cumt.edu.cn/authserver/login?service=$service',data: FormData.fromMap({
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
        var res2 =  await dio.get(loginResponse.headers.value('location'),options: Options(followRedirects: false));
        isLogin = true;
        Prefs.username = username;
        Prefs.password = password;
        debugPrint("登录融合门户成功");
        return true;
      }
      return true;
    }on DioError catch(e){
      return false;
    }

  }
  // 登录服务大厅
  Future<bool> loginFWDT(String username,String password)async{
    try{
  String service = "http://ykt.cumt.edu.cn:8088/ias/prelogin?sysid=FWDT";
      var res = await dio.get('http://authserver.cumt.edu.cn/authserver/login?service=$service',options: Options(followRedirects:true,));
      var document2 = parser.parse(res.data);
      var ssoticketid = document2.body.querySelector("input[id='ssoticketid']").attributes['value']??'';
      var res6 = await dio.post("http://ykt.cumt.edu.cn/cassyno/index",data: FormData.fromMap({
        "errorcode": "1",
        "continueurl":"",
        "ssoticketid": ssoticketid
      }),options: Options(followRedirects: false));
      return true;
    }on DioError catch(e){
      return false;
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
    }catch(e){
      showToast('未连接内网');
      debugPrint(e.toString());
      return false;
    }
  }
  Future<void> logout()async{
    var res = await dio.get('http://portal.cumt.edu.cn/portal/sso/logout');
    print(res.toString());
  }
  //获取姓名手机号
  Future<Map<String,dynamic>> getNamePhone()async{
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
