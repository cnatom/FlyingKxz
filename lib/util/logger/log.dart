import 'dart:convert';
import 'dart:io';

import 'package:flying_kxz/util/network/network.dart';

import '../../Model/global.dart';
import '../../Model/prefs.dart';
import 'data.dart';
export 'data.dart';

class Logger {
  static Future<void> log(
      String page, String action, Map<String, dynamic> data,) async {
    LoggerData info = LoggerData(
      username: Prefs.username ?? '',
      action: action??"",
      data: jsonEncode(data)??"",
      page: page??"",
      name: Prefs.name??"",
      platform: Platform.operatingSystem??"",
      version: Global.curVersion??"",
    );
    print(info.toJson());
    Network.post("http://118.195.147.37:5000/admin/action_new",
        params: info.toJson());
  }
}
