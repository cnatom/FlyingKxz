import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/swiper_info.dart';

//获取轮播图json数据
swiperGet() async {
  try{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(
      "http://api.kxz.atcumt.com/daily/home_image",
    );
    debugPrint(res.toString());
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    Global.swiperInfo = SwiperInfo.fromJson(map);
  }catch(e){
    print(e.toString());
  }

}