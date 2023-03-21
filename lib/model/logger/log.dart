import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flying_kxz/model/logger/data.dart';
import 'package:flying_kxz/util/network/network.dart';

import '../../Model/global.dart';
import '../../Model/prefs.dart';
import '../../cumt/cumt.dart';

export 'data.dart';

class Logger {
  static Future<void> sendInfo(
      String page, String action, Map<String, dynamic> data) async {
    LoggerData info = LoggerData(
      username: Prefs.username??'',
      action: action,
      data: data,
      page: page,
      time: DateTime.now().toString(),
      info: LoggerInfo(
        name: Prefs.name??'',
        system: Platform.operatingSystem??'',
        version: Global.curVersion??'',
        phone: Prefs.phone??'',
      ),
    );
    print(info.toJson());
    // Network.get("https://user.kxz.atcumt.com/admin/action", params: info.toJson());
    //
    // Cumt.getInstance()
    //     .dio
    //     .post("https://user.kxz.atcumt.com/admin/action", data: info);
    // print("sendInfo:" + page + ':' + action);
  }
}
