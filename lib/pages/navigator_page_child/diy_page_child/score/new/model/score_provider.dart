import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'score_item.dart';

class ScoreProvider extends ChangeNotifier {
  List<ScoreItem> _scoreList = []; //成绩列表
  double _jiaquanTotal = 0.0; //加权总分
  double _jidianTotal = 0.0; //绩点总分

  List<ScoreItem> get scoreList => _scoreList;
  double get jiaquanTotal => _jiaquanTotal;
  double get jidianTotal => _jidianTotal;

  set scoreList(List<ScoreItem> value) {
    _scoreList = value;
    _calculate(_scoreList);
    notifyListeners();
  }

  scoreListFromJsonList(List<Map<String,dynamic>> list){
    scoreList = list.map((scoreJson) => ScoreItem.fromJson(scoreJson)).toList();
  }

  void _calculate(List<ScoreItem> list) {
    double xfjdSum = 0; //学分*绩点的和
    double xfcjSum = 0; //学分*成绩的和
    double xfSum = 0; //学分的和
    for (var item in list) {
      if (item.filtered) continue;
      xfjdSum += item.zongping * item.xuefen;
      xfcjSum += item.jidian * item.xuefen;
      xfSum += item.xuefen;
    }
    _jiaquanTotal = (xfcjSum / xfSum);
    _jidianTotal = (xfjdSum / xfSum);
  }

  bool isNull(){
    return _scoreList==null||_scoreList.isEmpty;
  }
}
