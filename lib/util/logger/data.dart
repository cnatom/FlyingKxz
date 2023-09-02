import 'package:flutter/cupertino.dart';

/// username : "2017210000",
/// action : "login",
/// data : "",
/// page : "login",
/// name : "张三",
/// platform : "Android",
/// version : "1.0.0",

class LoggerData {
  LoggerData({
    @required String username,
    @required String action,
    @required String data,
    @required String page,
    @required String name,
    @required String platform,
    @required String version,}){
    _username = username;
    _action = action;
    _data = data;
    _page = page;
    _name = name;
    _platform = platform;
    _version = version;
  }

  LoggerData.fromJson(dynamic json) {
    _username = json['username'];
    _action = json['action'];
    _data = json['data'];
    _page = json['page'];
    _name = json['name'];
    _platform = json['platform'];
    _version = json['version'];
  }
  String _username;
  String _action;
  String _data;
  String _page;
  String _name;
  String _platform;
  String _version;
  LoggerData copyWith({  String username,
    String action,
    String data,
    String page,
    String name,
    String platform,
    String version,
  }) => LoggerData(  username: username ?? _username,
    action: action ?? _action,
    data: data ?? _data,
    page: page ?? _page,
    name: name ?? _name,
    platform: platform ?? _platform,
    version: version ?? _version,
  );
  String get username => _username;
  String get action => _action;
  String get data => _data;
  String get page => _page;
  String get name => _name;
  String get platform => _platform;
  String get version => _version;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['action'] = _action;
    map['data'] = _data;
    map['page'] = _page;
    map['name'] = _name;
    map['platform'] = _platform;
    map['version'] = _version;
    return map;
  }

}