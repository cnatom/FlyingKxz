import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';


//发送反馈
Future<Null> feedbackPost(BuildContext context,{@required String text}) async {
  try {
    Map _jsonMap = {'data': text,};
    Response res;
    Dio dio = Dio();
    res = await dio.post(Global.apiUrl.feedbackUrl, data: _jsonMap);
    debugPrint(res.toString());
  } catch (e) {
    debugPrint(e.toString());
  }
}
