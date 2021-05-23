
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'cumt_interceptors.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;

enum InquiryType {Course,Score,ScoreAll,Exam}
class Cumt {
  String username = '';
  String password = '';
  Map<InquiryType,String> _urlMap = {
    InquiryType.Course:'http://jwxt.cumt.edu.cn/jwglxt/kbcx/xskbcx_cxXsKb.html',
    InquiryType.Score:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxXsKccjList.html',
    InquiryType.ScoreAll:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html',
    InquiryType.Exam:'http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxXsKccjList.html'
  };
  Map<String,dynamic> _baseHeader = {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    "X-Requested-With": "XMLHttpRequest"};
  CookieJar _cookieJar = new PersistCookieJar(ignoreExpires: false);
  Dio _dio = new Dio();

  Cumt(this.username,this.password){
    _dio.interceptors.add(new CumtInterceptors());
    _dio.interceptors.add(new CookieManager(_cookieJar,));
    // _dio.interceptors.add(new LogInterceptor());
  }
  Future<void> login()async{
    await _cookieJar.deleteAll();
    var officialHtml = await _dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A//portal.cumt.edu.cn/casservice',options: Options(headers: _baseHeader));
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
    }),options: Options(headers: _baseHeader,followRedirects: false,validateStatus: (status) { return status < 500; }),);
    print(loginResponse.headers.toString());
    var loginLoopRes = await _dio.get(loginResponse.headers.value('Location'),options: Options(headers: _baseHeader,followRedirects: true,validateStatus: (status) { return status < 500; }));
    // 登录教务系统
    var jwRes = await _dio.get('http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin',options: Options(headers: _baseHeader,followRedirects:false,validateStatus: (status) { return status < 500; }));
    print(jwRes.headers.toString());
    var jwLoopRes = await _dio.get(jwRes.headers.value('location'),options: Options(headers: _baseHeader,validateStatus: (status) { return status < 500; }));
    var jwCookieRes = await _dio.get(jwLoopRes.redirects[1].location.toString(),options: Options(headers: _baseHeader));
  }

  Future<void> inquiry(InquiryType inquiryType,String xnm,String xqm)async{
    var res = await _dio.post(_urlMap[inquiryType],options: Options(headers: _baseHeader,validateStatus: (status) { return status < 1000; }),
      data:FormData.fromMap({
        'doType':'query',
        'xnm': xnm,
        'xqm': xqm
      }),queryParameters: {
        'su':username,
        'gnmkdm':'N253508'
      },);
    print(res.toString());
  }
  Future<void> initVideo()async{
    var res = await _dio.get('http://class.cumt.edu.cn/Login/Login?returnUrl=http://class.cumt.edu.cn/CourseVideo/CourseVideoDemandIndex',options: Options(headers: _baseHeader,followRedirects: false,validateStatus: (status) { return status < 1000; }));
  }
  Future<void> searchVideo({String courseName = ''})async{
    var dataMap = {
      'page':'1',
      'rows':'5',
    };
    if(courseName!='') dataMap['CourseName'] = courseName;
    var res = await _dio.post('http://class.cumt.edu.cn/StudentCourseVideo/coursedemandimg',data: FormData.fromMap(dataMap),options: Options(headers: _baseHeader));
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
    var cookies = await _cookieJar.loadForRequest(Uri.parse(url));
    if(cookies!=null){
      for(var cookie in cookies){
        print('   '+cookie.toString());
      }
    }
  }
}
