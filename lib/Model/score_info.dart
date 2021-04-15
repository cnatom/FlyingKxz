/// data : [{"courseName":"创新创业实践","xuefen":"2.0","jidian":"2.5","zongping":"75","type":"正常考试","scoreDetail":[{"name":"期末(100%)","score":"中等"},{"name":"总评","score":"中等"}]},null]

class ScoreInfo {
  List<Data> _data;

  List<Data> get data => _data;

  ScoreInfo({
      List<Data> data}){
    _data = data;
}

  ScoreInfo.fromJson(dynamic json) {
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
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

/// courseName : "创新创业实践"
/// xuefen : "2.0"
/// jidian : "2.5"
/// zongping : "75"
/// type : "正常考试"
/// scoreDetail : [{"name":"期末(100%)","score":"中等"},{"name":"总评","score":"中等"}]

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

/// name : "期末(100%)"
/// score : "中等"

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