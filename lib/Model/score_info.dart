class ScoreInfo {
  var status;
  String msg;
  List<Data> data;

  ScoreInfo({this.status, this.msg, this.data});

  ScoreInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String courseName;
  String xuefen;
  String zongping;
  var jidian;
  List<ScoreDetail> scoreDetail;

  Data(
      {this.courseName,
        this.xuefen,
        this.zongping,
        this.jidian,
        this.scoreDetail});

  Data.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    xuefen = json['xuefen'];
    zongping = json['zongping'];
    jidian = json['jidian'];
    if (json['scoreDetail'] != null) {
      scoreDetail = new List<ScoreDetail>();
      json['scoreDetail'].forEach((v) {
        scoreDetail.add(new ScoreDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['xuefen'] = this.xuefen;
    data['zongping'] = this.zongping;
    data['jidian'] = this.jidian;
    if (this.scoreDetail != null) {
      data['scoreDetail'] = this.scoreDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScoreDetail {
  String name;
  String score;

  ScoreDetail({this.name, this.score});

  ScoreDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['score'] = this.score;
    return data;
  }
}
