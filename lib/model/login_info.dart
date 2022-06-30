/// name : "牟金腾"
/// phone : "13070708211"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXNzd29yZCI6IkZUQUdTK1dXL1Fyb2x6aDkrOGFZNnc9PSIsInRpbWVVbml4IjoxNjE4Mjk4NDUzLCJ1c2VybmFtZSI6IjA4MTkyOTg4In0.5DCcJ79h4s9o9OltqB0lqspnIO-h4D-yxjhPgdxJRCs"

class LoginInfo {
  String name;
  String phone;
  String token;

  LoginInfo({
      this.name, 
      this.phone, 
      this.token});

  LoginInfo.fromJson(dynamic json) {
    name = json["name"];
    phone = json["phone"];
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["phone"] = phone;
    map["token"] = token;
    return map;
  }

}