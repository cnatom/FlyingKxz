/// status : 200
/// msg : "ok"
/// data : [{"title":"我校干部师生热议全国“两会”召开","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/d4/c513a590292/page.htm","time":"2021-03-05","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/d4/c513a590292/page.htm"},{"title":"中国安全产业协会副理事长徐筱慧来我校调研交流","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/bb/c513a590267/page.htm","time":"2021-03-07","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/bb/c513a590267/page.htm"},{"title":"我校召开学术委员会换届大会","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/9c/c513a590236/page.htm","time":"2021-03-05","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/9c/c513a590236/page.htm"},{"title":"江苏省教育厅副厅长顾月华来校专题调研高考综合改革工作","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/b4/c513a590260/page.htm","time":"2021-03-05","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/b4/c513a590260/page.htm"},{"title":"我校召开新学期实验室重点工作推进会","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/d7/c513a590295/page.htm","time":"2021-03-05","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/d7/c513a590295/page.htm"},{"title":"我校召开2021年重点科技工作布置会","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/c1/c513a590273/page.htm","time":"2021-03-05","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/c1/c513a590273/page.htm"},{"title":"教育部网站报道我校体育工作做法","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/5d/c513a590173/page.htm","time":"2021-03-04","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/5d/c513a590173/page.htm"},{"title":"我校6名教师入选2020年江苏省“社科英才”和“社科优青”","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/ff/c513a590079/page.htm","time":"2021-03-03","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/ff/c513a590079/page.htm"},{"title":"我校组织收看2021年教育系统全面从严治党工作视频会议","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/db/c513a590043/page.htm","time":"2021-03-02","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/db/c513a590043/page.htm"},{"title":"我校校友、富平县县委书记郭志英在脱贫攻坚战中立新功","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/e2/c513a590050/page.htm","time":"2021-03-02","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/e2/c513a590050/page.htm"},{"title":"我校2名教授入选2020年享受国务院政府特殊津贴专家","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/c2/c513a590018/page.htm","time":"2021-03-02","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/c2/c513a590018/page.htm"},{"title":"开学第一天我校线上教学平稳进行","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/8f/c513a589967/page.htm","time":"2021-03-01","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/8f/c513a589967/page.htm"},{"title":"我校新增10个国家级一流本科专业建设点","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/90/c513a589968/page.htm","time":"2021-03-01","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/90/c513a589968/page.htm"},{"title":"我校新增4个本科专业","link":"http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/00/3c/c513a589884/page.htm","time":"2021-02-28","location":"https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/00/3c/c513a589884/page.htm"}]

class NewsInfo {
  int _status;
  String _msg;
  List<Data> _data;

  int get status => _status;
  String get msg => _msg;
  List<Data> get data => _data;

  NewsInfo({
      int status, 
      String msg, 
      List<Data> data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  NewsInfo.fromJson(dynamic json) {
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

/// title : "我校干部师生热议全国“两会”召开"
/// link : "http://www.cumt.edu.cnhttp://xwzx.cumt.edu.cn/01/d4/c513a590292/page.htm"
/// time : "2021-03-05"
/// location : "https://api.kxz.atcumt.com/daily/sd_new?url=http://xwzx.cumt.edu.cn/01/d4/c513a590292/page.htm"

class Data {
  String _title;
  String _link;
  String _time;
  String _location;

  String get title => _title;
  String get link => _link;
  String get time => _time;
  String get location => _location;

  Data({
      String title, 
      String link, 
      String time, 
      String location}){
    _title = title;
    _link = link;
    _time = time;
    _location = location;
}

  Data.fromJson(dynamic json) {
    _title = json["title"];
    _link = json["link"];
    _time = json["time"];
    _location = json["location"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["link"] = _link;
    map["time"] = _time;
    map["location"] = _location;
    return map;
  }

}