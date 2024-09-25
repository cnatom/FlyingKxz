import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_color.dart';

// /{
// "title":"语文",
// "location":"博五",
// "teacher":"张三",
// "credit":"3",//学分
// "weekList":[1,2,3,4,5],//几周有这些课
// "weekNum":1,//星期几
// "lessonNum":1,//第几节课
// "durationNum":1,//持续节次，默认为2小节
// "remark":"备注"//没有就返回""
// }
class CourseData {
  String? _title;
  String? _location;
  String? _teacher;
  String? _credit;
  List<int>? _weekList;
  int? _weekNum;
  int? _lessonNum;
  int? _durationNum;
  String? _remark;

  set title(String? value) {
    _title = value;
    CourseColor(_title ?? '');
  }

  String? get title => _title;

  String? get location => _location;

  String? get teacher => _teacher;

  String? get credit => _credit;

  List<int>? get weekList => _weekList;

  int? get weekNum => _weekNum;

  int? get lessonNum => _lessonNum;

  int? get durationNum => _durationNum;

  String? get remark => _remark;

  CourseData(
      {String? title,
      String? location,
      String? teacher,
      String? credit,
      List<int>? weekList,
      int? weekNum,
      int? lessonNum,
      int? durationNum,
      String? remark}) {
    _title = title ?? '';
    _location = location ?? '';
    _teacher = teacher ?? '';
    _credit = credit ?? '';
    _weekList = weekList ?? [];
    _weekNum = weekNum ?? -1;
    _lessonNum = lessonNum ?? -1;
    _durationNum = durationNum ?? -1;
    _remark = remark ?? '';
    CourseColor(_title??'');
  }

  CourseData.fromJson(dynamic json) {
    _title = json["title"];
    _location = json["location"];
    _teacher = json["teacher"];
    _credit = json["credit"];
    _weekList = json["weekList"] != null ? json["weekList"].cast<int>() : [];
    _weekNum = json["weekNum"];
    _lessonNum = json["lessonNum"];
    _durationNum = json["durationNum"];
    _remark = json["remark"];
    CourseColor(_title??'');
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["location"] = _location;
    map["teacher"] = _teacher;
    map["credit"] = _credit;
    map["weekList"] = _weekList;
    map["weekNum"] = _weekNum;
    map["lessonNum"] = _lessonNum;
    map["durationNum"] = _durationNum;
    map["remark"] = _remark;
    return map;
  }

  //[1,2,4,5,8]-> "1-2,4-5,8"
  static String weekListToString(List? list) {
    if (list == null || list.isEmpty) return '';
    String result = '';
    List<String> temp = [];
    String start = list[0].toString();
    String end = list[0].toString();
    if (list.length == 1) result += '$start、';
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] + 1 == list[i + 1]) {
        end = list[i + 1].toString();
        if (i == list.length - 2) result += '$start-$end、';
      } else {
        if (start == end) {
          result += '$start、';
        } else {
          result += '$start-$end、';
        }
        start = list[i + 1].toString();
        end = list[i + 1].toString();
        if (i == list.length - 2) result += '$start、';
      }
    }
    result = result.substring(0, result.length - 1);
    return result;
  }

  set location(String? value) {
    _location = value;
  }

  set teacher(String? value) {
    _teacher = value;
  }

  set credit(String? value) {
    _credit = value;
  }

  set weekList(List<int>? value) {
    _weekList = value;
  }

  set weekNum(int? value) {
    _weekNum = value;
  }

  set lessonNum(int? value) {
    _lessonNum = value;
  }

  set durationNum(int? value) {
    _durationNum = value;
  }

  set remark(String? value) {
    _remark = value;
  }
}
