/// status : 200
/// msg : "ok"
/// data : {"title":"中国安全产业协会副理事长徐筱慧来我校调研交流","header":{"author":"刘勇","time":"2021-03-07"},"about":["新闻来源：科学技术研究院 刘辉","摄影：刘勇","责任编辑：刘尧","审核:黄军利"],"content":["3月5日上午，中国安全产业协会副理事长徐筱慧一行来校调研。学校在行健楼B401会议室召开座谈会，副校长周福宝出席会议并讲话。","周福宝副校长简要介绍了学校的历史沿革、学科建设和校地校企合作情况。他表示，学校与徐工集团等地方企业围绕矿业智能装备、安全应急装备等领域开展了较好的合作，取得了显著的成效，希望学校与徐工集团等企业进一步深化合作，围绕安全、信息、材料、机械等多学科进行科研攻关，解决工程领域“卡脖子”难题，打造校企合作的示范样本与成功案例。","徐筱慧副理事长高度评价了我校的办学水平。她说，中国矿业大学是安全应急产业领域的龙头高校，此次调研的目的是整合校企合作优秀资源，寻找志同道合、匹配互补的业务合作伙伴，推动横向科研项目高质量高效率完成。","与会双方围绕金属焊接、数值模拟、塑性成形、铸造技术、智能制造等领域进行了交流研讨。","学校科学技术研究院相关负责人，机电工程学院、材料与物理学院部分教师，上海交通大学材料科学与工程学院和上交大（徐州）新材料研究院相关负责同志参加了调研座谈。"," "]}

class NewsDetailInfo {
  int _status;
  String _msg;
  Data _data;

  int get status => _status;
  String get msg => _msg;
  Data get data => _data;

  NewsDetailInfo({
      int status, 
      String msg, 
      Data data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  NewsDetailInfo.fromJson(dynamic json) {
    _status = json["status"];
    _msg = json["msg"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["msg"] = _msg;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// title : "中国安全产业协会副理事长徐筱慧来我校调研交流"
/// header : {"author":"刘勇","time":"2021-03-07"}
/// about : ["新闻来源：科学技术研究院 刘辉","摄影：刘勇","责任编辑：刘尧","审核:黄军利"]
/// content : ["3月5日上午，中国安全产业协会副理事长徐筱慧一行来校调研。学校在行健楼B401会议室召开座谈会，副校长周福宝出席会议并讲话。","周福宝副校长简要介绍了学校的历史沿革、学科建设和校地校企合作情况。他表示，学校与徐工集团等地方企业围绕矿业智能装备、安全应急装备等领域开展了较好的合作，取得了显著的成效，希望学校与徐工集团等企业进一步深化合作，围绕安全、信息、材料、机械等多学科进行科研攻关，解决工程领域“卡脖子”难题，打造校企合作的示范样本与成功案例。","徐筱慧副理事长高度评价了我校的办学水平。她说，中国矿业大学是安全应急产业领域的龙头高校，此次调研的目的是整合校企合作优秀资源，寻找志同道合、匹配互补的业务合作伙伴，推动横向科研项目高质量高效率完成。","与会双方围绕金属焊接、数值模拟、塑性成形、铸造技术、智能制造等领域进行了交流研讨。","学校科学技术研究院相关负责人，机电工程学院、材料与物理学院部分教师，上海交通大学材料科学与工程学院和上交大（徐州）新材料研究院相关负责同志参加了调研座谈。"," "]

class Data {
  String _title;
  Header _header;
  List<String> _about;
  List<String> _content;

  String get title => _title;
  Header get header => _header;
  List<String> get about => _about;
  List<String> get content => _content;

  Data({
      String title, 
      Header header, 
      List<String> about, 
      List<String> content}){
    _title = title;
    _header = header;
    _about = about;
    _content = content;
}

  Data.fromJson(dynamic json) {
    _title = json["title"];
    _header = json["header"] != null ? Header.fromJson(json["header"]) : null;
    _about = json["about"] != null ? json["about"].cast<String>() : [];
    _content = json["content"] != null ? json["content"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    if (_header != null) {
      map["header"] = _header.toJson();
    }
    map["about"] = _about;
    map["content"] = _content;
    return map;
  }

}

/// author : "刘勇"
/// time : "2021-03-07"

class Header {
  String _author;
  String _time;

  String get author => _author;
  String get time => _time;

  Header({
      String author, 
      String time}){
    _author = author;
    _time = time;
}

  Header.fromJson(dynamic json) {
    _author = json["author"];
    _time = json["time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["author"] = _author;
    map["time"] = _time;
    return map;
  }

}