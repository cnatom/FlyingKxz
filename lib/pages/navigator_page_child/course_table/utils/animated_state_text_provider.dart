import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/animated_state_text.dart';

class AnimatedStateTextProvider extends ChangeNotifier {
  String _stateText = '';
  int? _lastWeek;
  AnimatedStateTextDirection _direction = AnimatedStateTextDirection.up;
  bool _initialized = false;

  AnimatedStateTextDirection get direction => _direction;

  String get stateText => _stateText;

  void init({required int initWeek}) {
    if(_initialized) return;
    _stateText = '第$initWeek周';
    _lastWeek = initWeek;
    _initialized = true;
  }

  void updateText(String text){
    _stateText = text;
    notifyListeners();
  }

  void restoreText(){
    _stateText = '第$_lastWeek周';
    notifyListeners();
  }

  void restoreDirection(){
    _direction = AnimatedStateTextDirection.up;
  }

  void changeWeek(int week) {
    if (_lastWeek != null) {
      _direction = week > _lastWeek! ? AnimatedStateTextDirection.up : AnimatedStateTextDirection.down;
    }
    _lastWeek = week;
    _stateText = '第$week周';
    notifyListeners();
  }
}