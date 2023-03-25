import 'package:shared_preferences/shared_preferences.dart';


class CumtLoginPrefs {
  static Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
  }
  static SharedPreferences prefs;
  static const String _cumtLoginUsername = "cumtLoginUsername1";
  static const String _cumtLoginPassword = "cumtLoginPassword1";
  static const String _cumtLoginAccountList = "cumtLoginAccountList1";
  static const String _cumtLoginMethod = "cumtLoginMethod1";
  static const String _cumtLoginLocation = "cumtLoginLocation1";


  static String get cumtLoginUsername => _get(_cumtLoginUsername);
  static String get cumtLoginPassword => _get(_cumtLoginPassword);
  static String get cumtLoginAccountList => _get(_cumtLoginAccountList);
  static String get cumtLoginMethod => _get(_cumtLoginMethod);
  static String get cumtLoginLocation => _get(_cumtLoginLocation);

  static set cumtLoginUsername(String value) => _set(_cumtLoginUsername, value);
  static set cumtLoginPassword(String value) => _set(_cumtLoginPassword, value);
  static set cumtLoginAccountList(String value) => _set(_cumtLoginAccountList, value);
  static set cumtLoginMethod(String value) => _set(_cumtLoginMethod, value);
  static set cumtLoginLocation(String value) => _set(_cumtLoginLocation, value);


  static String _get(String key) => prefs?.getString(key)??"";
  static _set(String key, String value) => prefs?.setString(key, value);
}
