import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/utils/score_sort.dart';
import 'score_item.dart';

class ScoreModel{
  List<ScoreItem> _scoreList; //成绩列表
  double _jiaquanTotal; //加权总分
  double _jidianTotal; //绩点总分
  ScoreSort _scoreSort;

  ScoreModel(){
    _scoreList = [];
    _jidianTotal = 0.0;
    _jiaquanTotal = 0.0;
  }

  // 初始化成绩列表
  ScoreModel.fromJson(List<Map<String, dynamic>> list){
    _scoreList = list.map((scoreJson) => ScoreItem.fromJson(scoreJson)).toList();
    _calculate(_scoreList);
    _scoreSort = ScoreSort.create(sortWay: ScoreSortWay.name, isOrder: false);
    _scoreSort.sort(_scoreList);
  }

  // 成绩列表排序
  void setAndSort(ScoreSort scoreSort){
    _scoreSort = scoreSort;
    _scoreSort.sort(_scoreList);
  }

  // 单个筛选
  toggleFilter(int index){
    _scoreList[index].includeWeighting = !_scoreList[index].includeWeighting;
    _calculate(_scoreList);
  }

  // 全选筛选
  toggleAllFilter(bool value){
    for (var item in _scoreList) {
      item.includeWeighting = value;
    }
    _calculate(_scoreList);
  }

  // 设置加权倍率
  setRate(int index,double rate){
    _scoreList[index].rate = rate;
    _calculate(_scoreList);
  }

  bool isNull() => _scoreList == null || _scoreList.isEmpty;

  int get scoreListLength => _scoreList.length;

  List<ScoreItem> get scoreList => _scoreList;

  double get jiaquanTotal => _jiaquanTotal;

  double get jidianTotal => _jidianTotal;

  // 计算加权总分和绩点总分
  void _calculate(List<ScoreItem> list) {
    double xfjdSum = 0; //学分*绩点的和
    double xfcjSum = 0; //学分*成绩的和
    double xfSum = 0; //学分的和
    for (var item in list) {
      if (!item.includeWeighting) continue;
      xfjdSum += item.zongpingDouble * item.xuefen * item.rate;
      xfcjSum += item.jidian * item.xuefen * item.rate;
      xfSum += item.xuefen * item.rate;
    }
    _jiaquanTotal = (xfcjSum / xfSum);
    _jidianTotal = (xfjdSum / xfSum);
    if (_jiaquanTotal.isNaN) _jiaquanTotal = 0.0;
    if (_jidianTotal.isNaN) _jidianTotal = 0.0;
  }

}