import 'dart:convert';
import 'package:flying_kxz/Model/prefs.dart';

// ScoreNewMap.
class ScoreNewMap{
  // 单例
  static ScoreNewMap _instance;
  ScoreNewMap._internal() {
    _instance = this;
    _defaultData = {
      "免修":{"jidian":"5.0", "zongping":"100"},
      "优秀": {"jidian":"4.5", "zongping":"90"},
      "良好":{"jidian":"3.5", "zongping":"85"},
      "中等":{"jidian":"2.5", "zongping":"75"},
      "合格":{"jidian":"1.0", "zongping":"65"},
      "及格":{"jidian":"1.0", "zongping":"65"},
      "不合格":{"jidian":"0.0", "zongping":"0"},
      "不及格":{"jidian":"0.0", "zongping":"0"},
      "未评价":{"jidian":"0.0", "zongping":"0"},
      "旷考":{"jidian":"0.0", "zongping":"0"},
      "缓考":{"jidian":"0.0", "zongping":"0"},
    };
    if(Prefs.scoreMap!=null){
      data = jsonDecode(Prefs.scoreMap);
    }else{
      data = _defaultData;
      _saveFromMap(data);
    }
  }
  factory ScoreNewMap() => _instance ?? ScoreNewMap._internal();

  Map<String,dynamic> data;
  Map<String,dynamic> _defaultData;

  _saveFromMap(Map<String,dynamic> data){
    Prefs.scoreMap = jsonEncode(data);
  }

  getZonping(String key){
    return data[key]["zongping"];
  }

  getJidian(String key){
    return data[key]["jidian"];
  }

  refresh(){
    data = _defaultData;
    _saveFromMap(data);
  }
}