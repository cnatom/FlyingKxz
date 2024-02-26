
import 'dart:convert';

import 'package:flying_kxz/Model/prefs.dart';

class ScoreMap{
  static Map<String,dynamic> data;
  static Map<String,dynamic> _default;
  static init(){
    _default = {
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
      data = _default;
      saveFromMap(data);
    }
  }

  static saveFromMap(Map<String,dynamic> data){
    Prefs.scoreMap = jsonEncode(data);
  }

  static refresh(){
    data = _default;
    saveFromMap(data);
  }
}