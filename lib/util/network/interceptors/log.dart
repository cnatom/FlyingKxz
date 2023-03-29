import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
class MyLogInterceptors extends Interceptor {
  String t = '  ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('————————————————————————————————————————————————');
    print(options.method+ " " + (options.uri??'').toString());
    print(t + "请求头:");
    debugPrintMap(options.headers);
    print(t + "参数:");
    if(options.method == 'POST'){
      print(options.data.toString());
    }else{
      debugPrintMap(options.queryParameters);
    }
    return super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("接收 " + response.statusCode.toString());
    print(t + "响应体:");
    print(response.toString());
    super.onResponse(response, handler);
  }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('————————————————————————————————————————————————');
    print("错误 " + err.toString());
    print(t+'错误链接:'+err.requestOptions.uri.toString());
    debugPrintMap(err.requestOptions.queryParameters);
    super.onError(err, handler);
  }
  void debugPrintMap(Map<String,dynamic> map){
    for(var key in map.keys){
      print(t+t+t+key+' : '+map[key].toString());
    }
  }
}