import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/model/score_model.dart';
import '../utils/score_sort.dart';
import 'score_item.dart';

class ScoreProvider extends ChangeNotifier {
  // 成绩Model
  ScoreModel _scoreModel = ScoreModel();

  double get jiaquanTotal => _scoreModel.jiaquanTotal;

  double get jidianTotal => _scoreModel.jidianTotal;

  int get scoreListLength => _scoreModel.scoreListLength;

  ScoreItem getScoreItem(int index) => _scoreModel.scoreList[index];

  setAndCalScoreList(List<Map<String, dynamic>> list) {
    _scoreModel = ScoreModel.fromJson(list);
    notifyListeners();
  }

  // 搜索
  String _searchResult = '';

  String get searchResult => _searchResult;

  bool inSearchResult(int index) => _searchResult!=null && _scoreModel.scoreList[index].courseName.contains(_searchResult);

  search(String name){
    _searchResult = name;
    notifyListeners();
  }
  // 排序方式
  ScoreSortWay _sortWay = ScoreSortWay.name;

  ScoreSortWay get sortWay => _sortWay;

  set sortWay(ScoreSortWay value) {
    _sortWay = value;
    _sort();
  }

  // 排序顺序
  bool _isOrder = false;

  bool get isOrder => _isOrder;

  set isOrder(bool value) {
    _isOrder = value;
    _sort();
  }

  // 排序
  _sort(){
    _scoreModel.setAndSort(ScoreSort.create(sortWay: _sortWay, isOrder: _isOrder));
    notifyListeners();
  }

  // 显示操作面板
  ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  bool _showConsole = false;

  bool get showConsole => _showConsole;

  toggleShowConsole(){
    _showConsole = !_showConsole;
    _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    notifyListeners();
  }

  // 显示筛选视图
  bool _showFilterView = false;

  bool get showFilterView => _showFilterView;

  toggleShowFilterView({bool value}){
    if(value != null){
      _showFilterView = value;
    }else{
      _showFilterView = !_showFilterView;
    }
    notifyListeners();
  }

  // 筛选调整
  bool _chooseAll = true;

  bool get chooseAll => _chooseAll;

  toggleFilter(int index){
    _scoreModel.toggleFilter(index);
    _chooseAll = false;
    notifyListeners();
  }

  toggleAllFilter(bool value){
    _scoreModel.toggleAllFilter(value);
    _chooseAll = value;
    notifyListeners();
  }

  // 加权倍率显示
  bool _showRateView = false;

  bool get showRateView => _showRateView;

  toggleShowRateView(bool value){
    _showRateView = value;
    notifyListeners();
  }

  // 加权倍率调整
  setRate(int index, double rate){
    _scoreModel.setRate(index,rate);
    notifyListeners();
  }

}