/// status : 200
/// msg : "ok"
/// data : {"home":"梅2楼","num":"B4211","balance":87.59}

class PowerInfo {
  int status;
  String msg;
  Data data;

  PowerInfo({
      this.status, 
      this.msg, 
      this.data});

  PowerInfo.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

/// home : "梅2楼"
/// num : "B4211"
/// balance : 87.59

class Data {
  String home;
  String num;
  double balance;

  Data({
      this.home, 
      this.num, 
      this.balance});

  Data.fromJson(dynamic json) {
    home = json["home"];
    num = json["num"];
    balance = json["balance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["home"] = home;
    map["num"] = num;
    map["balance"] = balance;
    return map;
  }

}