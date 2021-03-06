/// status : 200
/// msg : "请求成功"
/// data : [{"courseName":"大学生心理健康教育","xuefen":"0.5","jidian":"4.00","zongping":"87","type":"正常考试","scoreDetail":[{"name":"平时(30%)","score":"98"},{"name":"期末(70%)","score":"83"},{"name":"总评","score":"88"}]},null]

class ScoreInfo {
  int _status;
  String _msg;
  List<Data> _data;

  int get status => _status;
  String get msg => _msg;
  List<Data> get data => _data;

  ScoreInfo({
      int status, 
      String msg, 
      List<Data> data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  ScoreInfo.fromJson(dynamic json) {
    _status = json["status"];
    _msg = json["msg"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["msg"] = _msg;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// courseName : "大学生心理健康教育"
/// xuefen : "0.5"
/// jidian : "4.00"
/// zongping : "87"
/// type : "正常考试"
/// scoreDetail : [{"name":"平时(30%)","score":"98"},{"name":"期末(70%)","score":"83"},{"name":"总评","score":"88"}]

class Data {
  String _courseName;
  String _xuefen;
  String _jidian;
  String _zongping;
  String _type;
  List<ScoreDetail> _scoreDetail;

  String get courseName => _courseName;
  String get xuefen => _xuefen;
  String get jidian => _jidian;
  String get zongping => _zongping;
  String get type => _type;
  List<ScoreDetail> get scoreDetail => _scoreDetail;

  Data({
      String courseName, 
      String xuefen, 
      String jidian, 
      String zongping, 
      String type, 
      List<ScoreDetail> scoreDetail}){
    _courseName = courseName;
    _xuefen = xuefen;
    _jidian = jidian;
    _zongping = zongping;
    _type = type;
    _scoreDetail = scoreDetail;
}

  Data.fromJson(dynamic json) {
    _courseName = json["courseName"];
    _xuefen = json["xuefen"];
    _jidian = json["jidian"];
    _zongping = json["zongping"];
    _type = json["type"];
    if (json["scoreDetail"] != null) {
      _scoreDetail = [];
      json["scoreDetail"].forEach((v) {
        _scoreDetail.add(ScoreDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["courseName"] = _courseName;
    map["xuefen"] = _xuefen;
    map["jidian"] = _jidian;
    map["zongping"] = _zongping;
    map["type"] = _type;
    if (_scoreDetail != null) {
      map["scoreDetail"] = _scoreDetail.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : "平时(30%)"
/// score : "98"

class ScoreDetail {
  String _name;
  String _score;

  String get name => _name;
  String get score => _score;

  ScoreDetail({
      String name, 
      String score}){
    _name = name;
    _score = score;
}

  ScoreDetail.fromJson(dynamic json) {
    _name = json["name"];
    _score = json["score"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["score"] = _score;
    return map;
  }

}