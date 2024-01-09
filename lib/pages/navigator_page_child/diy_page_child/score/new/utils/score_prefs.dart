import 'package:shared_preferences/shared_preferences.dart';

// ScorePrefs.scoreList = {"sss":"sss"}
// ScorePrefs.scoreList
class ScorePrefs{

  static SharedPreferences _prefs;

  // 初始化，只能调用一次，且在使用前调用
  static Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  static final String _scoreListKey = 'newScoreList';
  static final String _scoreMapKey = 'newScoreMap2';

  static String get scoreList => _prefs.getString(_scoreListKey);
  static String get scoreMap => _prefs.getString(_scoreMapKey);

  static set scoreList(String value) =>_prefs.setString(_scoreListKey, value);
  static set scoreMap(String value) =>_prefs.setString(_scoreMapKey, value);

}