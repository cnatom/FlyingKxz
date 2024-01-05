import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/model/score_new_map.dart';
import 'score_item.dart';

class ScoreProvider extends ChangeNotifier {
  List<ScoreItem> _scoreList = []; //成绩列表
  double _jiaquanTotal = 0.0; //加权总分
  double _jidianTotal = 0.0; //绩点总分

  bool _showFilterView = false;

  assignmentConversionAndCalculation(List<Map<String, dynamic>> list) {
    scoreList = list.map((scoreJson) => ScoreItem.fromJson(scoreJson)).toList();
  }

  void _calculate(List<ScoreItem> list) {
    double xfjdSum = 0; //学分*绩点的和
    double xfcjSum = 0; //学分*成绩的和
    double xfSum = 0; //学分的和
    for (var item in list) {
      if (!item.includeWeighting) continue;
      if(item.zongping is num){
        xfjdSum += item.zongping * item.xuefen;
      }else{
        xfjdSum += ScoreNewMap().getZonping(item.zongping.toString()) * item.xuefen;
      }
      xfcjSum += item.jidian * item.xuefen;
      xfSum += item.xuefen;
    }
    _jiaquanTotal = (xfcjSum / xfSum);
    _jidianTotal = (xfjdSum / xfSum);
  }

  bool isNull() {
    return _scoreList == null || _scoreList.isEmpty;
  }

  toggleShowFilterView(){
    _showFilterView = !_showFilterView;
    notifyListeners();
  }

  // getter
  List<ScoreItem> get scoreList => _scoreList;

  double get jiaquanTotal => _jiaquanTotal;

  double get jidianTotal => _jidianTotal;

  bool get showFilterView => _showFilterView;

  // setter
  set scoreList(List<ScoreItem> value) {
    _scoreList = value;
    _calculate(_scoreList);
    notifyListeners();
  }
}
