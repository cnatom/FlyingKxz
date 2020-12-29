/// status : 200
/// msg : "请求成功"
/// data : {"cardNumber":"119192","balance":"8385"}

class BalanceInfo {
  int _status;
  String _msg;
  Data _data;

  int get status => _status;
  String get msg => _msg;
  Data get data => _data;

  BalanceInfo({
      int status, 
      String msg, 
      Data data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  BalanceInfo.fromJson(dynamic json) {
    _status = json["status"];
    _msg = json["msg"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["msg"] = _msg;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// cardNumber : "119192"
/// balance : "8385"

class Data {
  String _cardNumber;
  String _balance;

  String get cardNumber => _cardNumber;
  String get balance => _balance;

  Data({
      String cardNumber, 
      String balance}){
    _cardNumber = cardNumber;
    _balance = balance;
}

  Data.fromJson(dynamic json) {
    _cardNumber = json["cardNumber"];
    _balance = json["balance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardNumber"] = _cardNumber;
    map["balance"] = _balance;
    return map;
  }

}