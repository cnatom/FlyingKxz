/// status : 200
/// msg : "抓取成功"
/// data : [{"local":"博1-C104","time":"2019-11-02(19:00-20:40)","course":"高等数学A（1）(16版，","type":"2019-2020-1正常考试","year":2019,"month":11,"day":2},{"local":"博2-A202","time":"2019-11-18(19:00-20:40)","course":"信息学科概论","type":"2019-2020-1正常考试","year":2019,"month":11,"day":18},{"local":"计-31机房","time":"2019-11-27(10:15-11:55)","course":"计算机基础训练","type":"2019-2020-1正常考试","year":2019,"month":11,"day":27},{"local":"博3-B303","time":"2020-01-06(08:00-09:40)","course":"高等数学A（2）(16版，","type":"2019-2020-1正常考试","year":2020,"month":1,"day":6},{"local":"博4-C307","time":"2020-01-07(10:15-11:55)","course":"综合英语（1）(16版，","type":"2019-2020-1正常考试","year":2020,"month":1,"day":7}]

class ExamInfo {
  int status;
  String msg;
  List<Data> data;

  ExamInfo({
      this.status, 
      this.msg, 
      this.data});

  ExamInfo.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// local : "博1-C104"
/// time : "2019-11-02(19:00-20:40)"
/// course : "高等数学A（1）(16版，"
/// type : "2019-2020-1正常考试"
/// year : 2019
/// month : 11
/// day : 2

class Data {
  String local;
  String time;
  String course;
  String type;
  int year;
  int month;
  int day;

  Data({
      this.local, 
      this.time, 
      this.course, 
      this.type, 
      this.year, 
      this.month, 
      this.day});

  Data.fromJson(dynamic json) {
    local = json["local"];
    time = json["time"];
    course = json["course"];
    type = json["type"];
    year = json["year"];
    month = json["month"];
    day = json["day"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["local"] = local;
    map["time"] = time;
    map["course"] = course;
    map["type"] = type;
    map["year"] = year;
    map["month"] = month;
    map["day"] = day;
    return map;
  }

}