import 'package:flutter/cupertino.dart';

/// username : ""
/// action : ""
/// data : {"":""}
/// page : ""
/// time : ""
/// info : {"name":"","system":"","version":"","phone":""}

class LoggerData {
  String _username;
  String _action;
  Map<String,dynamic> _data;
  String _page;
  String _time;
  LoggerData({
    @required String username,
    @required String action,
    @required Map<String,dynamic> data,
    @required String page,
    @required String time,
  }){
    _username = username;
    _action = action;
    _data = data;
    _page = page;
    _time = time;
  }

  LoggerData.fromJson(dynamic json) {
    _username = json['username'];
    _action = json['action'];
    _data = json['data'];
    _page = json['page'];
    _time = json['time'];
  }

  LoggerData copyWith({  String username,
    String action,
    Map<String,dynamic> data,
    String page,
    String time,
    LoggerBaseData info,
  }) => LoggerData(  username: username ?? _username,
    action: action ?? _action,
    data: data ?? _data,
    page: page ?? _page,
    time: time ?? _time,
  );
  String get username => _username;
  String get action => _action;
  Map<String,dynamic> get data => _data;
  String get page => _page;
  String get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['action'] = _action;
    map['data'] = _data;
    map['page'] = _page;
    map['time'] = _time;
    return map;
  }

}

/// name : ""
/// system : ""
/// version : ""
/// phone : ""

class LoggerBaseData {
  LoggerBaseData({
    @required String name,
    @required String system,
    @required String version,
    @required String phone,}){
    _name = name;
    _system = system;
    _version = version;
    _phone = phone;
  }

  LoggerBaseData.fromJson(dynamic json) {
    _name = json['name'];
    _phone = json['phone'];
    _system = json['system'];
    _version = json['version'];
  }
  String _name;
  String _system;
  String _version;
  String _phone;
  LoggerBaseData copyWith({  String name,
    String system,
    String version,
    String phone,
  }) => LoggerBaseData(  name: name ?? _name,
    system: system ?? _system,
    version: version ?? _version,
    phone: phone ?? _phone,
  );
  String get name => _name;
  String get system => _system;
  String get version => _version;
  String get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['system'] = _system;
    map['version'] = _version;
    map['phone'] = _phone;
    return map;
  }

}