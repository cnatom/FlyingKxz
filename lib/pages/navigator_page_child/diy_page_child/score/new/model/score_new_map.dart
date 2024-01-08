import 'dart:convert';
import 'package:flying_kxz/Model/prefs.dart';

// ScoreNewMap.
class ScoreNewMap{
  // 单例
  static ScoreNewMap _instance;
  ScoreNewMap._internal() {
    _init();
  }
  factory ScoreNewMap() => _instance ?? ScoreNewMap._internal();

  Map<String,dynamic> data;
  Map<String,dynamic> _defaultData;

  _init(){
    _instance = this;
    _defaultData = {
      "免修":{"jidian":5.0, "zongping":100.0},
      "优秀": {"jidian":4.5, "zongping":90.0},
      "良好":{"jidian":3.5, "zongping":85.0},
      "中等":{"jidian":2.5, "zongping":75.0},
      "合格":{"jidian":1.0, "zongping":65.0},
      "及格":{"jidian":1.0, "zongping":65.0},
      "不合格":{"jidian":0.0, "zongping":0.0},
      "不及格":{"jidian":0.0, "zongping":0.0},
      "未评价":{"jidian":0.0, "zongping":0.0},
      "旷考":{"jidian":0.0, "zongping":0.0},
      "缓考":{"jidian":0.0, "zongping":0.0},
    };
    if(Prefs.scoreMap!=null){
      data = jsonDecode(Prefs.scoreMap);
    }else{
      data = _defaultData;
      _saveFromMap(data);
    }
  }

  _saveFromMap(Map<String,dynamic> data){
    Prefs.scoreMap = jsonEncode(data);
  }

  double getZonping(String key){
    return double.tryParse(data[key]["zongping"].toString())??-1.0;
  }

  double getJidian(String key){
    return double.tryParse(data[key]["jidian"].toString())??-1.0;
  }

  refresh(){
    data = _defaultData;
    _saveFromMap(data);
  }
}