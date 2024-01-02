
class ScoreItem {
  String courseName;
  double xuefen;
  double jidian;
  double zongping;
  String zongpingStr;
  String type;
  bool filtered = false; // 是否不计入加权


  ScoreItem({
    this.courseName,
    this.xuefen,
    this.jidian,
    this.zongping,
    this.type,
  });

  factory ScoreItem.fromJson(Map<String, dynamic> json) => ScoreItem(
    courseName: json["courseName"],
    xuefen: double.tryParse(json["xuefen"])??0,
    jidian: double.tryParse(json["jidian"])??0,
    zongping: double.tryParse(json["zongping"])??0,
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "courseName": courseName,
    "xuefen": xuefen,
    "jidian": jidian,
    "zongping": zongping,
    "type": type,
  };
}
