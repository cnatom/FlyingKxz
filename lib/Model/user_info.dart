/// name : "xxx"
/// college : "信息与控制工程学院"
/// classname : "电子信息工程2017-10班"

class UserInfo {
  String _name;
  String _college;
  String _classname;

  String get name => _name;
  String get college => _college;
  String get classname => _classname;

  UserInfo({
      String name, 
      String college, 
      String classname}){
    _name = name;
    _college = college;
    _classname = classname;
}

  UserInfo.fromJson(dynamic json) {
    _name = json["name"];
    _college = json["college"];
    _classname = json["classname"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["college"] = _college;
    map["classname"] = _classname;
    return map;
  }

}