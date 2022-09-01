import 'package:flutter/cupertino.dart';

/// data : [{"cardNumber":"08192988","Type":"持卡人消费","Location":"校内电车-WG226","name":"校内电车","costMoney":"-110","balance":"9670","time":"2025-02-13 16:55:34"},{"cardNumber":"08192988","Type":"持卡人消费","Location":"南湖一食堂-WG226","name":"南一201","costMoney":"-1490","balance":"18248","time":"2021-04-16 12:47:57"},{"cardNumber":"08192988","Type":"持卡人消费","Location":"南湖三食堂-WG226","name":"3201","costMoney":"-700","balance":"19738","time":"2021-04-15 12:55:59"},{"cardNumber":"08192988","Type":"银行转账","Location":"转帐前置机","name":"","costMoney":"20000","balance":"438","time":"2021-04-15 12:18:44"},{"cardNumber":"08192988","Type":"持卡人消费","Location":"图书馆第三方接入","name":"汇文系统扣款","costMoney":"-50","balance":"438","time":"2021-04-08 17:42:15"}]

class BalanceDetailModel {
  List<Data> _data;

  List<Data> get data => _data;

  BalanceDetailModel({
    List<Data> data}){
    _data = data;
  }

  BalanceDetailModel.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        Data newData = Data.fromJson(v);
        DateTime changeTime;
        try{
          changeTime = DateTime.parse(newData.time);
        }catch(e){
          debugPrint(e.toString());
          changeTime = DateTime.now().add(Duration(days: 30));
        }
        if(DateTime.now().isAfter(changeTime)){
          _data.add(newData);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// cardNumber : "08192988"
/// Type : "持卡人消费"
/// Location : "校内电车-WG226"
/// name : "校内电车"
/// costMoney : "-110"
/// balance : "9670"
/// time : "2025-02-13 16:55:34"

class Data {
  String _cardNumber;
  String _type;
  String _location;
  String _name;
  String _costMoney;
  String _balance;
  String _time;

  String get cardNumber => _cardNumber;
  String get type => _type;
  String get location => _location;
  String get name => _name;
  String get costMoney => _costMoney;
  String get balance => _balance;
  String get time => _time;

  Data({
    String cardNumber,
    String type,
    String location,
    String name,
    String costMoney,
    String balance,
    String time}){
    _cardNumber = cardNumber;
    _type = type;
    _location = location;
    _name = name;
    _costMoney = costMoney;
    _balance = balance;
    _time = time;
  }

  Data.fromJson(dynamic json) {
    _cardNumber = json["cardNumber"];
    _type = json["Type"];
    _location = json["Location"];
    _name = json["name"];
    _costMoney = json["costMoney"];
    _balance = json["balance"];
    _time = json["time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardNumber"] = _cardNumber;
    map["Type"] = _type;
    map["Location"] = _location;
    map["name"] = _name;
    map["costMoney"] = _costMoney;
    map["balance"] = _balance;
    map["time"] = _time;
    return map;
  }

}