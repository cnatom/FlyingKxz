import 'dart:convert';

import '../../../../Model/global.dart';

/// status : 200
/// msg : "抓取成功"
/// data : [{"local":"博1-C104","time":"2019-11-02(19:00-20:40)","course":"高等数学A（1）(16版，","type":"2019-2020-1正常考试","year":2019,"month":11,"day":2},{"local":"博2-A202","time":"2019-11-18(19:00-20:40)","course":"信息学科概论","type":"2019-2020-1正常考试","year":2019,"month":11,"day":18},{"local":"计-31机房","time":"2019-11-27(10:15-11:55)","course":"计算机基础训练","type":"2019-2020-1正常考试","year":2019,"month":11,"day":27},{"local":"博3-B303","time":"2020-01-06(08:00-09:40)","course":"高等数学A（2）(16版，","type":"2019-2020-1正常考试","year":2020,"month":1,"day":6},{"local":"博4-C307","time":"2020-01-07(10:15-11:55)","course":"综合英语（1）(16版，","type":"2019-2020-1正常考试","year":2020,"month":1,"day":7}]

/// data : [{"local":"博4-C308","time":"2021-01-15(10:15-11:55)","course":"通信原理","type":"2020-2021-1正常考试","year":2021,"month":1,"day":15},{"local":"博4-B103","time":"2020-12-19(10:15-11:55)","course":"数字信号处理","type":"2020-2021-1正常考试","year":2020,"month":12,"day":19},{"local":"博5-C301","time":"2020-11-28(19:00-20:40)","course":"微机原理与应用B","type":"2020-2021-1正常考试","year":2020,"month":11,"day":28},{"local":"博4-C107","time":"2020-11-20(08:00-09:40)","course":"近距离无线通信技术","type":"2020-2021-1正常考试","year":2020,"month":11,"day":20},{"local":"博1-B101","time":"2020-09-11(10:15-11:55)","course":"无线通信基础","type":"2020-2021-1学期初补考","year":2020,"month":9,"day":11}]
class ExamData {
  String? courseName;
  String? location;
  String? dateTime;
  int? year;
  int? month;
  int? day;
  bool out = false;
  bool diy = false;
  ExamData({
    this.courseName,
    this.location,
    this.dateTime,
    this.year,
    this.month,
    this.day,
    this.diy = false
  }) {
    year =  year??int.tryParse(dateTime?.substring(0,4)??'');
    month = month??int.tryParse(dateTime?.substring(5,7)??'');
    day =  day??int.tryParse(dateTime?.substring(8,10)??'');
    DateTime examDateTime = DateTime(year??0, month??0, day??0,);
    int? timeLeftInt = examDateTime.difference(Global.nowDate).inDays + 1;
    if (timeLeftInt < 0) out = true;
  }
  static String? examJsonEncode(List<ExamData?> list) {
    var l = [];
    for (var item in list) {
      l.add(item?.toJson());
    }
    return jsonEncode(l);
  }

  static List<ExamData> examJsonDecode(String prefs) {
    List<dynamic> list = jsonDecode(prefs);
    List<ExamData> result = [];
    for (var item in list) {
      ExamData newUnit = new ExamData(
          courseName: item['courseName'],
          location: item['location'],
          dateTime: item['dateTime'],
          year: item['year'],
          month: item['month'],
          day: item['day'],
          diy: item['diy']);
      result.add(newUnit);
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['courseName'] = courseName;
    map['location'] = location;
    map['dateTime'] = dateTime;
    map['year'] = year;
    map['month'] = month;
    map['day'] = day;
    map['out'] = out;
    map['diy'] = diy;
    return map;
  }
}

// class ExamInf {
//   List<ExamData> _data;
//
//   List<ExamData> get data => _data;
//
//   ExamInfo({List<ExamData> data}) {
//     _data = data;
//   }
//
//   ExamInfo.fromJson(dynamic json) {
//     if (json["data"] != null) {
//       _data = [];
//       json["data"].forEach((v) {
//         _data.add(ExamData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     if (_data != null) {
//       map["data"] = _data.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }

/// local : "博4-C308"
/// time : "2021-01-15(10:15-11:55)"
/// course : "通信原理"
/// type : "2020-2021-1正常考试"
/// year : 2021
/// month : 1
/// day : 15

// class ExamData {
//   String? _local;
//   String? _time;
//   String? _course;
//   String? _type;
//   int? _year;
//   int? _month;
//   int? _day;
//
//   String? get local => _local;
//   String? get time => _time;
//   String? get course => _course;
//   String? get type => _type;
//   int? get year => _year;
//   int? get month => _month;
//   int? get day => _day;
//
//   ExamData(
//       {String? local,
//       String? time,
//       String? course,
//       String? type,
//       int? year,
//       int? month,
//       int? day}) {
//     _local = local;
//     _time = time;
//     _course = course;
//     _type = type;
//     _year = year;
//     _month = month;
//     _day = day;
//   }
//
//   ExamData.fromJson(dynamic json) {
//     _local = json["local"];
//     _time = json["time"];
//     _course = json["course"];
//     _type = json["type"];
//     _year = json["year"];
//     _month = json["month"];
//     _day = json["day"];
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map["local"] = _local;
//     map["time"] = _time;
//     map["course"] = _course;
//     map["type"] = _type;
//     map["year"] = _year;
//     map["month"] = _month;
//     map["day"] = _day;
//     return map;
//   }
// }

/// local : "博1-C104"
/// time : "2019-11-02(19:00-20:40)"
/// course : "高等数学A（1）(16版，"
/// type : "2019-2020-1正常考试"
/// year : 2019
/// month : 11
/// day : 2
