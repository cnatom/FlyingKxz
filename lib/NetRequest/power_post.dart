import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';

Future<bool> powerPost(BuildContext context,
    {@required String token,@required String home,@required String num}) async {
  try {
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.post(ApiUrl.powerUrl,data: {"home":home,"room":num},
    options: Options(headers: {"Authorization":"Bearer "+token}));
    //Json解码为Map
    debugPrint("@powerGet:" + res.toString());
    if (res.statusCode==200) {
      String powerStr = res.toString();
      double powerDouble = double.parse(powerStr.substring(0,powerStr.length-1));
      //没记录过最大电量，则初始化
      if(Prefs.powerMax==null) Prefs.powerMax = powerDouble;
      if(Prefs.power==null) Prefs.power = 0.0;
      //当电量比上次多时，保存最大电量
      if(powerDouble>Prefs.power){
        Prefs.powerMax = powerDouble;
      }
      //如果更换了绑定信息，则重新统计
      if(num!=Prefs.powerNum||home!=Prefs.powerHome){
        Prefs.powerMax = powerDouble;
      }
      //保存电量
      Prefs.power = powerDouble;
      //保存绑定信息
      Prefs.powerNum = num;
      Prefs.powerHome = home;
      return true;
    } else {
      return false;
    }
  }on DioError catch (e) {
    debugPrint(e.response.toString());
    return false;
  }
}
