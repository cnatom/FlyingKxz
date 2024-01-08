import 'package:shared_preferences/shared_preferences.dart';

class ScorePrefs{
  // 单例
  static ScorePrefs _instance;

  ScorePrefs._internal(){
    _init();
  }

  Future<void> _init() async => _prefs = await SharedPreferences.getInstance();

  factory ScorePrefs() => _instance ?? ScorePrefs._internal();

  SharedPreferences _prefs;

  final String _scoreListKey = 'newScoreList';
  final String _scoreMapKey = 'newScoreMap';

  String get scoreList => _prefs.getString(_scoreListKey);
  String get scoreMap => _prefs.getString(_scoreMapKey);

  set scoreList(String value) =>_prefs.setString(_scoreListKey, value);
  set scoreMap(String value) =>_prefs.setString(_scoreMapKey, value);

}