/// status : 200
/// msg : "抓取成功"
/// data : [{"bookcode":"0010563662T","location":"南湖校区-南湖社科图书阅览室Ⅱ","current":"丢失"},{"bookcode":"0010598926/","location":"文昌校区-未改造图书","current":"在架"},{"bookcode":"0020680167U","location":"文昌校区-未改造图书","current":"在架"},{"bookcode":"0010062591O","location":"南湖校区-南湖社科图书阅览室Ⅱ","current":"丢失"},{"bookcode":"0010050796S","location":"南湖密集书库-南湖密集书库Ⅰ","current":"在架"},{"bookcode":"0010075556T","location":"南湖校区-南湖社科图书阅览室Ⅱ","current":"丢失"},null]

class BookDetailInfo {
  int status;
  String msg;
  List<Data> data;

  BookDetailInfo({
      this.status, 
      this.msg, 
      this.data});

  BookDetailInfo.fromJson(dynamic json) {
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

/// bookcode : "0010563662T"
/// location : "南湖校区-南湖社科图书阅览室Ⅱ"
/// current : "丢失"

class Data {
  String bookcode;
  String location;
  String current;

  Data({
      this.bookcode, 
      this.location, 
      this.current});

  Data.fromJson(dynamic json) {
    bookcode = json["bookcode"];
    location = json["location"];
    current = json["current"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["bookcode"] = bookcode;
    map["location"] = location;
    map["current"] = current;
    return map;
  }

}