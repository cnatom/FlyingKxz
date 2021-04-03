import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/Model/prefs.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.light;
  static bool _darkMode;//夜间模式
  static bool _simpleMode;//简洁模式

  static double _transBack; //背景透明度
  static double _blurBack; //背景模糊度
  static double _transCard; //卡片透明度 最大0.5
  static Color _colorMain = Color(0xff00c5a8); //主题色彩
  static Color _colorNavText;///卡片内的文字,过白时变黑;


  bool get simpleMode => _simpleMode;
  ThemeMode get themeMode => _themeMode;
  bool get darkMode => _darkMode;
  double get transBack => _transBack;
  double get blurBack => _blurBack;
  double get transCard => _transCard;
  Color get colorMain => _colorMain;
  Color get colorNavText => _colorNavText;

  static Map _diyDefault = {
    "darkMode": false,
    "simpleMode":false,
    "transBack": 0.5,
    "blurBack": 8.0,
    "transCard": 0.05,
  };
  static Map _lightDefault = {
    "darkMode": false,
    "simpleMode":true,
    "transBack": 0.5,
    "blurBack": 10.0,
    "transCard": 0.1,
  };
  static Map _darkDefault = {
    "darkMode": true,
    "simpleMode":false,
    "transBack": 1.0,
    "blurBack": 8.0,
    "transCard": 0.8,
  };
  ThemeProvider(){
    notifyListeners();
  }
  notify(){
    notifyListeners();
  }
  ///初始化主题数据
  static init() {
    if (Prefs.themeData == null) {
      _initFromJson(_lightDefault);
      _themeMode = ThemeMode.light;
      _savePrefs();
    } else {
      _initFromJson(jsonDecode(Prefs.themeData));
    }
  }
  //恢复默认配置
  _restore(){
    debugPrint("@restore");
    _initFromJson(_diyDefault);
  }
  ///本地化存储
  static _savePrefs() {
    Prefs.themeData = jsonEncode(_toJson());
  }

  ///Map->类的变量
  static _initFromJson(dynamic json) {
    _darkMode = json["darkMode"];
    _simpleMode = json["simpleMode"];
    _blurBack = json["blurBack"];
    _transCard = json["transCard"];
    _transBack = json["transBack"];
    _colorNavText = _simpleMode?Colors.black:Colors.white;
    _themeMode = _darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  ///将类数据打包成Map
  static Map<String, dynamic> _toJson() {
    var map = <String, dynamic>{};
    map["darkMode"] = _darkMode;
    map["simpleMode"] = _simpleMode;
    map["transBack"] = _transBack;
    map["blurBack"] = _blurBack;
    map["transCard"] = _transCard;
    return map;
  }

  set themeMode(ThemeMode value) {
    _themeMode = value;
    _darkMode = _themeMode == ThemeMode.dark ? true : false;
    notifyListeners();
    _savePrefs();
  }
  set simpleMode(bool value) {
    _simpleMode = value;
    if(_simpleMode){
      _initFromJson(_lightDefault);
    }else{
      _restore();
    }
    notifyListeners();
    _savePrefs();
  }
  set darkMode(bool value) {
    _darkMode = value;
    if (darkMode) {
      _initFromJson(_darkDefault);
    } else {
      _restore();
    }
    notifyListeners();
    _savePrefs();
  }

  set transBack(double value) {
    if (value > 0 && value < 1) {
      _transBack = value;
      notifyListeners();
      _savePrefs();
    }
  }


  set blurBack(double value) {
    _blurBack = value;
    notifyListeners();
    _savePrefs();
  }

  set transCard(double value) {
    _transCard = value;
    notifyListeners();
    _savePrefs();
  }

  set colorMain(Color value) {
    _colorMain = value;
    notifyListeners();
    _savePrefs();
  }

}

class FlyThemes {
  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      buttonColor: colorMain.withOpacity(0.8),
      //弹窗背景色
      dialogBackgroundColor: Color(0xff1c1c1e),
      //按钮按下的色彩
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      //文字主色
      primaryColor: Colors.white,
      //AppBar的文本色
      accentColor: Colors.white,
      //子页面背景色
      scaffoldBackgroundColor: Colors.black,
      //主页面背景色
      backgroundColor: Colors.black.withOpacity(0.9),
      //输入框色彩
      disabledColor: Color(0xff6C6C6C).withOpacity(0.7),
      //未选中项色彩
      unselectedWidgetColor: Color(0xff6C6C6C).withOpacity(0.5),
      //卡片色彩
      cardColor: Color(0xff151517),
      //指示器色彩
      indicatorColor: Colors.white,
      cursorColor: colorMain,
      //Chip未选中色彩
      canvasColor: Color(0xff6C6C6C).withOpacity(0.5),
      appBarTheme: AppBarTheme(
        //控制系统顶栏文字色
        brightness: Brightness.dark,
        //AppBar阴影大小
        elevation: 0,
        color: Colors.black,
      ),
      //chip按钮主题
      chipTheme: ChipThemeData(
        //选中项背景色彩，两个最好是一样
        selectedColor: colorMain,
        secondarySelectedColor: colorMain,
        //选中项文字色彩
        labelStyle: TextStyle(color: Colors.white54),
        //未选中项背景色彩
        disabledColor: Color(0xff6C6C6C).withOpacity(0.5),
        //未选中项文字色彩
        secondaryLabelStyle: TextStyle(color: Colors.white),
        //暂时没啥用的参数，但不能没有
        brightness: Brightness.dark,
        padding: EdgeInsets.all(4.0),
        shape: StadiumBorder(),
        backgroundColor: Colors.transparent,
      ));
  static final diyTheme =
      ThemeData(scaffoldBackgroundColor: Colors.transparent);
  static final lightTheme = ThemeData(
    buttonColor: colorMain,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    //子页面背景色
    scaffoldBackgroundColor: Color(0xfff2f5f7),
    //主页面背景色
    backgroundColor: Color(0xfff2f5f7).withOpacity(0),
    //文字主色
    primaryColor: Colors.black,
    //AppBar文字
    accentColor: Colors.white,
    //输入框色彩
    disabledColor: Color(0xffecedef),
    //未选中项色彩
    unselectedWidgetColor: Color(0xff6C6C6C).withOpacity(0.5),
    //底部导航栏
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.white.withOpacity(0.5), //底部导航蓝未选中色
        selectedItemColor: Colors.white),
    appBarTheme: AppBarTheme(
      //控制系统顶栏文字色
      brightness: Brightness.light,
      //AppBar阴影大小
      elevation: 0,
      color: Colors.transparent,
    ),
    //卡片背景
    cardColor: Colors.white,
    // //chip按钮主题
    // chipTheme: ChipThemeData(
    //   //选中项背景色彩，两个最好是一样
    //   selectedColor: colorMain,
    //   secondarySelectedColor: colorMain,
    //   //选中项文字色彩
    //   labelStyle: TextStyle(color: Colors.white54),
    //   //未选中项背景色彩
    //   disabledColor: Color(0xfff2f2f2),
    //   //未选中项文字色彩
    //   secondaryLabelStyle: TextStyle(color: Colors.black),
    //   //暂时没啥用的参数，但不能没有
    //   brightness: Brightness.dark,
    //   padding: EdgeInsets.all(4.0),
    //   shape: StadiumBorder(),
    //   backgroundColor: Colors.transparent,
    // )
  );
}
