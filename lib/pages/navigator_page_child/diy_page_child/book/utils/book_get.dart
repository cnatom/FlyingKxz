import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';

import '../model/book_info.dart';

//获取课表数据
//xnm: '2019' 代表2019-2020学年
//xqm: '3' 代表第1学期  '12' 代表第2学期  '16' 代表第3学期

Future<bool> bookGet({@required String book,@required String page,@required String row}) async {
  Map<String,dynamic> _jsonMap = {
    "book":book,
    "page":page,
    "row":row
  };
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(
      ApiUrl.bookUrl, queryParameters: _jsonMap,
    );
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (res.statusCode==200) {
      Global.bookInfo = BookInfo.fromJson(map);
      return true;
    }else{
      return false;
    }
  }catch(e){
    Global.bookInfo = new BookInfo();
    return false;
  }

}
