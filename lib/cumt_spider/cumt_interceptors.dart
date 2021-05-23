import 'package:dio/dio.dart';
class CumtInterceptors extends Interceptor {
  String t = '  ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('————————————————————————————————————————————————');
    print("发送 " + options.method+ " " + options.uri.toString());
    print(t + "请求头:");
    printMap(options.headers);
    print(t + "参数:");
        printMap(options.queryParameters);
    return super.onRequest(options, handler);
  }
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    print("接收 " + response.statusCode.toString());
    //输出set-cookie
    var setCookie = response.headers.map['set-cookie'];
    if(setCookie!=null){
      for(var s in setCookie){
        print(t+'set-cookie : '+s);
      }
    }
    // //打印全部
    // for(var key in response.headers.map.keys){
    //   print(t+key+' : '+response.headers[key].toString());
    // }
    super.onResponse(response, handler);
  }
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) {
    // print("返回错误 " + (err.response.statusCode??901).toString());
    print(t+'请求参数');
    printMap(err.requestOptions.queryParameters);
    super.onError(err, handler);
  }
  void printMap(Map<String,dynamic> map){
    for(var key in map.keys){
      print(t+t+t+key+' : '+map[key]);
    }
  }
}