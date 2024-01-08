import '../model/score_item.dart';

enum ScoreSortWay { name, score, credit }

abstract class ScoreSort {
  final bool isOrder;

  ScoreSort({this.isOrder = true});

  void sort(List<ScoreItem> scores);

  static create({ScoreSortWay sortWay = ScoreSortWay.name, bool isOrder = true}){
    switch(sortWay){
      case ScoreSortWay.name:
        return ScoreSortByName(isOrder: isOrder);
      case ScoreSortWay.score:
        return ScoreSortByScore(isOrder: isOrder);
      case ScoreSortWay.credit:
        return ScoreSortByCredit(isOrder: isOrder);
      default:
        return ScoreSortByName(isOrder: isOrder);
    }
  }
}

// 按照名称排序
class ScoreSortByName extends ScoreSort {
  ScoreSortByName({bool isOrder = true}):super(isOrder: isOrder);

  @override
  void sort(List<ScoreItem> scores) => scores.sort((a, b) {
    final comparison = a.courseName.compareTo(b.courseName);
    return isOrder ? comparison : -comparison;
  });
}

// 按照成绩排序
class ScoreSortByScore extends ScoreSort {
  ScoreSortByScore({bool isOrder = true}):super(isOrder: isOrder);

  @override
  void sort(List<ScoreItem> scores) {
    scores.sort((a, b) {
      final comparison = a.zongpingDouble.compareTo(b.zongpingDouble);
      return isOrder ? comparison : -comparison;
    });
  }
}

// 按照学分排序
class ScoreSortByCredit extends ScoreSort {
  ScoreSortByCredit({bool isOrder = true}):super(isOrder: isOrder);

  @override
  void sort(List<ScoreItem> scores) {
    scores.sort((a, b) {
      final comparison = a.xuefen.compareTo(b.xuefen);
      return isOrder ? comparison : -comparison;
    });
  }
}

