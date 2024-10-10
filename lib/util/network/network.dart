import 'package:dio/dio.dart';

import 'interceptors/log.dart';

class Network {
  static Dio? _dio;

  static Dio get dio {
    if(_dio == null){
      _dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: 5), receiveTimeout: Duration(seconds: 5), sendTimeout: Duration(seconds: 5)));
      _dio?.interceptors.add(new MyLogInterceptors());
    }
    return _dio!;
  }

  static Future<Response?> get(url, {Map<String, dynamic>? params}) async {
    try {
      Response response = await dio.get(url, queryParameters: params);
      return response;
    } on DioException catch (e) {
      print(e.toString());
      return null;
    }
  }
  static Future<Response?> post(url, {Map<String, dynamic>? params}) async {
    try {
      Response response = await dio.post(url, data: params);
      return response;
    } on DioException catch (e) {
      return null;
    }
  }
}
