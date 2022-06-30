/// status : 200
/// msg : "ok"
/// data : {"rank":1}

class RankInfo {
  int status;
  String msg;
  Data data;

  RankInfo({
      this.status, 
      this.msg, 
      this.data});

  RankInfo.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

/// rank : 1

class Data {
  int rank;

  Data({
      this.rank});

  Data.fromJson(dynamic json) {
    rank = json["rank"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rank"] = rank;
    return map;
  }

}