import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
class CumtInterceptors extends Interceptor {
  String t = '  ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('————————————————————————————————————————————————');
    debugPrint("发送 " + options.method+ " " + (options.uri??'').toString());
    debugPrint(t + "请求头:");
    debugPrintMap(options.headers);
    debugPrint(t + "参数:");
    debugPrintMap(options.queryParameters);
    return super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("接收 " + response.statusCode.toString());
    debugPrint(t + "响应体:");
    print(response.toString());
    debugPrint(t + "header:");
    print(response.headers.toString());
    super.onResponse(response, handler);
  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('————————————————————————————————————————————————');
    debugPrint("错误 " + err.toString());
    debugPrint(t+'错误链接:'+err.requestOptions.uri.toString());
    debugPrintMap(err.requestOptions.queryParameters);
    super.onError(err, handler);
  }
  void debugPrintMap(Map<String,dynamic> map){
    for(var key in map.keys){
      debugPrint(t+t+t+key+' : '+map[key]);
    }
  }
}