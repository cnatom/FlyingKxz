/// code : 0
/// data : {"name":"牟金腾","college":"计算机科学与技术学院","classname":"数据科学与大数据技术2019-02班","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDQ5Nzc1NTQuMTEwNjk1MSwiZGF0YSI6eyJ1c2VybmFtZSI6IjA4MTkyOTg4IiwicGFzc3dvcmQiOiJSZWRzdW5qaW55aSJ9fQ.LdbQsBgf_PPSrPW9Cf8ANLTHWM5O0Pv1FCM1vVlMAbE"}
/// msg : "登录成功"

class LoginInfo {
  int _code;
  Data _data;
  String _msg;

  int get code => _code;
  Data get data => _data;
  String get msg => _msg;

  LoginInfo({
      int code, 
      Data data, 
      String msg}){
    _code = code;
    _data = data;
    _msg = msg;
}

  LoginInfo.fromJson(dynamic json) {
    _code = json["code"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    _msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    map["msg"] = _msg;
    return map;
  }

}

/// name : "牟金腾"
/// college : "计算机科学与技术学院"
/// classname : "数据科学与大数据技术2019-02班"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDQ5Nzc1NTQuMTEwNjk1MSwiZGF0YSI6eyJ1c2VybmFtZSI6IjA4MTkyOTg4IiwicGFzc3dvcmQiOiJSZWRzdW5qaW55aSJ9fQ.LdbQsBgf_PPSrPW9Cf8ANLTHWM5O0Pv1FCM1vVlMAbE"

class Data {
  String _name;
  String _college;
  String _classname;
  String _token;

  String get name => _name;
  String get college => _college;
  String get classname => _classname;
  String get token => _token;

  Data({
      String name, 
      String college, 
      String classname, 
      String token}){
    _name = name;
    _college = college;
    _classname = classname;
    _token = token;
}

  Data.fromJson(dynamic json) {
    _name = json["name"];
    _college = json["college"];
    _classname = json["classname"];
    _token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["college"] = _college;
    map["classname"] = _classname;
    map["token"] = _token;
    return map;
  }

}