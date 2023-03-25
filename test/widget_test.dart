import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

import 'package:flutter_test/flutter_test.dart';


Future<bool> login(String username, String password,{String service = "http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice"}) async {
  Dio dio = Dio();
  try {
    var res = await dio.get(
        'http://authserver.cumt.edu.cn/authserver/login?service=$service',
        options: Options(
          followRedirects: true,
        ));
    if (res.toString().length > 35000) {
      //解析并登录
      var document = parser.parse(res.data);
      var pwdSalt =
          document.body.querySelector("#pwdEncryptSalt").attributes['value'] ??
              '';
      var execution =
          document.body.querySelectorAll('#execution')[2].attributes['value'] ??
              '';
      var newPassword = await _pwdAes(password, pwdSalt);
      var data = FormData.fromMap({
        'username': username,
        'password': newPassword,
        '_eventId': 'submit',
        'cllt': 'userNameLogin',
        'execution': execution,
      });
      var loginResponse = await dio.post(
        'http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',
        data: data,
        options: Options(followRedirects: false),
      );
      //检查单点登录
      if (loginResponse.statusCode == 200 &&
          loginResponse.headers.value('X-Frame-Options') == "DENY") {
        print('检测到登录冲突，正在注销其他设备登录态');
        var document = parser.parse(loginResponse.data);
        var execution = document.body
                .querySelector("input[name='execution']")
                .attributes['value'] ??
            '';
        loginResponse = await dio.post(
          'http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice',
          data: FormData.fromMap({
            '_eventId': 'continue',
            'execution': execution,
          }),
          options: Options(followRedirects: false),
        );
      }

      if (loginResponse.statusCode == 401) {
        print('账号或密码错误\n（挂VPN也可能会无法登录）');
        return false;
      }
      if (loginResponse.headers.value('location') != null &&
          loginResponse.headers.value('location').contains('improveInfo')) {
        print('登录失败\n密码包含了用户的敏感信息(如：帐户、手机号或邮箱等)，请前往融合门户修改密码');
        return false;
      }
      await dio.get(loginResponse.headers.value('location'),
          options: Options(followRedirects: false));
      print("登录融合门户成功");
      return true;
    }
    return true;
  } on DioError catch (e) {
    print(e.toString());
    return false;
  }
}

Future<String> _pwdAes(String password, String salt) async {
  try {
    Response response;
    var queryParameters = {'pwd': password, 'salt': salt};
    response = await Dio().get(
        'https://service-0gxixtbh-1300058565.sh.apigw.tencentcs.com/release/password',
        queryParameters: queryParameters);
    if (response.statusCode == 200) {
      return response.data;
    }
  } on DioError catch (e) {
    print(e.response.toString());
  }
  return '';
}

void main() {
  test("logger", () async {
    await login("08192988", "Redsunjinyi");
  });
}
