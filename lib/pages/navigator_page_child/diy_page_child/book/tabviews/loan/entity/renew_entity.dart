import 'package:flutter/cupertino.dart';

/// success : true
/// message : "操作成功"
/// errCode : 200
/// errorCode : null
/// data : {"result":{"19107065 帝制的终结":"未达到允许续借日期"},"fail":1,"success":0}
class RenewDialogInfo {
  final String? title;
  List<String>? resultList = [];

  RenewDialogInfo({required this.title, this.resultList});
}

class RenewEntity {
  RenewEntity({
    bool? success,
    String? message,
    int? errCode,
    dynamic? errorCode,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _errCode = errCode;
    _errorCode = errorCode;
    _data = data;
  }

  RenewEntity.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _errCode = json['errCode'];
    _errorCode = json['errorCode'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  int? _errCode;
  dynamic _errorCode;
  Data? _data;

  RenewEntity copyWith({
    bool? success,
    String? message,
    int? errCode,
    dynamic errorCode,
    Data? data,
  }) =>
      RenewEntity(
        success: success ?? _success,
        message: message ?? _message,
        errCode: errCode ?? _errCode,
        errorCode: errorCode ?? _errorCode,
        data: data ?? _data,
      );

  bool? get success => _success;

  String? get message => _message;

  int? get errCode => _errCode;

  dynamic get errorCode => _errorCode;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['errCode'] = _errCode;
    map['errorCode'] = _errorCode;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// result : {"19107065 帝制的终结":"未达到允许续借日期"}
/// fail : 1
/// success : 0

class Data {
  Data({
    Map<String, dynamic>? result,
    int? fail,
    int? success,
  }) {
    _result = result;
    _fail = fail;
    _success = success;
  }

  Data.fromJson(dynamic json) {
    _result = json['result'];
    _fail = json['fail'];
    _success = json['success'];
  }

  Map<String, dynamic>? _result;
  int? _fail;
  int? _success;

  Data? copyWith({
    Map<String, dynamic>? result,
    int? fail,
    int? success,
  }) =>
      Data(
        result: result ?? _result,
        fail: fail ?? _fail,
        success: success ?? _success,
      );

  Map<String, dynamic>? get result => _result;

  int? get fail => _fail;

  int? get success => _success;

  Map<String, dynamic>? toJson() {
    final map = <String, dynamic>{};
    map['result'] = _result;
    map['fail'] = _fail;
    map['success'] = _success;
    return map;
  }
}

/// 19107065 帝制的终结 : "未达到允许续借日期"
