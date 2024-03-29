import 'package:dio/dio.dart';

import 'interceptors/log.dart';

class Network {
  static Dio _dio;

  static Dio get dio {
    if(_dio == null){
      _dio = Dio(BaseOptions(
      connectTimeout: 5000, receiveTimeout: 5000, sendTimeout: 5000));
      _dio.interceptors.add(new MyLogInterceptors());
    }
    return _dio;
  }

  static Future<Response> get(url, {Map<String, dynamic> params}) async {
    try {
      Response response = await dio.get(url, queryParameters: params);
      return response;
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
  }
  static Future<Response> post(url, {Map<String, dynamic> params}) async {
    try {
      Response response = await dio.post(url, data: params);
      return response;
    } on DioError catch (e) {
      return null;
    }
  }
}
