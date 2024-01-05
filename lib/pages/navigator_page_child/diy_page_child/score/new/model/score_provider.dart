import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/model/score_model.dart';
import 'score_item.dart';

class ScoreProvider extends ChangeNotifier {
  // 成绩Model
  ScoreModel _scoreModel = ScoreModel();

  setAndCalScoreList(List<Map<String, dynamic>> list) {
    _scoreModel = ScoreModel.fromJson(list);
    notifyListeners();
  }
  
  int get scoreListLength => _scoreModel.scoreListLength;

  double get jiaquanTotal => _scoreModel.jiaquanTotal;

  double get jidianTotal => _scoreModel.jidianTotal;

  ScoreItem getScoreItem(int index) => _scoreModel.scoreList[index];

  // 启动筛选
  bool _showFilterView = false;

  toggleShowFilterView(){
    _showFilterView = !_showFilterView;
    notifyListeners();
  }

  bool get showFilterView => _showFilterView;
}
