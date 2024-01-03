
class ScoreItem {
  String _courseName; // 课程名
  double _xuefen; // 学分
  double _jidian; // 绩点
  dynamic _zongping; // 总评
  String _type; // 考试类型
  bool _filtered = false; // 是否不计入加权，ture为不计入

  ScoreItem(
      {String courseName,
      double xuefen,
      double jidian,
      dynamic zongping,
      String type}) {
    this._courseName = courseName;
    this._xuefen = xuefen;
    this._jidian = jidian;
    this.zongping = zongping;
    this._type = type;
  }

  ScoreItem.stubNormal(){
    this._courseName = '课程名';
    this._xuefen = 2;
    this._jidian = 4.0;
    this.zongping = 80;
    this._type = '正常考试';
  }
  ScoreItem.stubSpecial(){
    this._courseName = '课程名';
    this._xuefen = 3.0;
    this._jidian = 4.0;
    this.zongping = "补考";
    this._type = '考试类型';
    this._filtered = true;
  }

  factory ScoreItem.fromJson(Map<String, dynamic> json)=>ScoreItem(
    courseName: json["courseName"],
    xuefen: json["xuefen"],
    jidian: json["jidian"],
    zongping: json["zongping"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "courseName": courseName,
    "xuefen": xuefen,
    "jidian": jidian,
    "zongping": zongping,
    "type": type,
  };

  // MARK: Getter & Setter

  dynamic get zongping => _zongping;

  set zongping(dynamic value) {
    dynamic result = double.tryParse("$value");
    if(result == null){
      _zongping = value;
    }else{
      _zongping = result;
    }
  }


  bool get filtered => _filtered;

  set filtered(bool value) {
    _filtered = value;
  }

  String get type => _type;


  double get jidian => _jidian;


  double get xuefen => _xuefen;


  String get courseName => _courseName;
}
