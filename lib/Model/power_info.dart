/// status : 200
/// msg : "ok"
/// data : 794.77

class PowerInfo {
  int _status;
  String _msg;
  double _data;

  int get status => _status;
  String get msg => _msg;
  double get data => _data;

  PowerInfo({
      int status, 
      String msg, 
      double data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  PowerInfo.fromJson(dynamic json) {
    _status = json["status"];
    _msg = json["msg"];
    _data = json["data"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["msg"] = _msg;
    map["data"] = _data;
    return map;
  }

}