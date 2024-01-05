import 'score_item.dart';
import 'score_new_map.dart';

class ScoreModel{
  List<ScoreItem> _scoreList; //成绩列表
  double _jiaquanTotal; //加权总分
  double _jidianTotal; //绩点总分

  ScoreModel(){
    _scoreList = [];
    _jidianTotal = 0.0;
    _jiaquanTotal = 0.0;
  }

  // 初始化成绩列表
  ScoreModel.fromJson(List<Map<String, dynamic>> list){
    _scoreList = list.map((scoreJson) => ScoreItem.fromJson(scoreJson)).toList();
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

}