import 'dart:convert';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/utils/score_prefs.dart';

class ScoreNewMap{
  static Map<String,dynamic> _data;
  static Map<String,dynamic> _default = {
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

  static Map<String, dynamic> get data{
    if(_data == null){
      if(ScorePrefs.scoreMap!=null){
        _data = jsonDecode(ScorePrefs.scoreMap);
      }else{
        _data = _default;
        saveFromMap(_data);
      }
    }
    return _data;
  }

  static double getZonping(String key){
    return double.parse(data[key]['zongping'].toString());
  }

  static saveFromMap(Map<String,dynamic> data){
    ScorePrefs.scoreMap = jsonEncode(data);
  }

  static refresh(){
    _data = _default;
    saveFromMap(data);
  }
}