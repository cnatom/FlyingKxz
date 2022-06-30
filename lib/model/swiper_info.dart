/// status : 200
/// msg : "ok"
/// data : [{"imageUrl":"http://www.cumt.edu.cn/_upload/article/images/96/0b/0da3a1784bb1a9f194c4db466cf9/d01d0c8f-38bb-4be9-869c-f908d927e783.jpg"},null]

class SwiperInfo {
  int _status;
  String _msg;
  List<Data> _data;

  int get status => _status;
  String get msg => _msg;
  List<Data> get data => _data;

  SwiperInfo({
      int status, 
      String msg, 
      List<Data> data}){
    _status = status;
    _msg = msg;
    _data = data;
}

  SwiperInfo.fromJson(dynamic json) {
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

/// imageUrl : "http://www.cumt.edu.cn/_upload/article/images/96/0b/0da3a1784bb1a9f194c4db466cf9/d01d0c8f-38bb-4be9-869c-f908d927e783.jpg"

class Data {
  String _imageUrl;

  String get imageUrl => _imageUrl;

  Data({
      String imageUrl}){
    _imageUrl = imageUrl;
}

  Data.fromJson(dynamic json) {
    _imageUrl = json["image-url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["image-url"] = _imageUrl;
    return map;
  }

}