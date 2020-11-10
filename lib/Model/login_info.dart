/// code : 0
/// data : {"name":"牟金腾","college":"计算机科学与技术学院","classname":"数据科学与大数据技术2019-02班","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDQwNjQ4NzkuMDcxMDYzMywiZGF0YSI6eyJ1c2VybmFtZSI6IjA4MTkyOTg4IiwicGFzc3dvcmQiOiJSZWRzdW5qaW55aSJ9fQ.0qW1yHo3efhuXhQgLnKedfgS48Kr9nXiEBRK477xRSs"}
/// msg : "登录成功"

class LoginInfo {
  int code;
  Data data;
  String msg;

  LoginInfo({
      this.code, 
      this.data, 
      this.msg});

  LoginInfo.fromJson(dynamic json) {
    code = json["code"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["msg"] = msg;
    return map;
  }

}

/// name : "牟金腾"
/// college : "计算机科学与技术学院"
/// classname : "数据科学与大数据技术2019-02班"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MDQwNjQ4NzkuMDcxMDYzMywiZGF0YSI6eyJ1c2VybmFtZSI6IjA4MTkyOTg4IiwicGFzc3dvcmQiOiJSZWRzdW5qaW55aSJ9fQ.0qW1yHo3efhuXhQgLnKedfgS48Kr9nXiEBRK477xRSs"

class Data {
  String name;
  String college;
  String classname;
  String token;

  Data({
      this.name, 
      this.college, 
      this.classname, 
      this.token});

  Data.fromJson(dynamic json) {
    name = json["name"];
    college = json["college"];
    classname = json["classname"];
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["college"] = college;
    map["classname"] = classname;
    map["token"] = token;
    return map;
  }

}