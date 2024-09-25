import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/ui/config.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.light;
  static late bool _darkMode; //夜间模式
  static late bool _simpleMode; //简洁模式

  static late double _transBack; //背景透明度
  static late double _blurBack; //背景模糊度
  static late double _transCard; //卡片透明度 最大0.5
  static late Color _colorMain;
  static late Color _colorNavText;

  ///卡片内的文字,过白时变黑;

  static final int _colorDefaultValue = 4278240425;

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
    "simpleMode": false,
    "transBack": 0.25,
    "blurBack": 8.0,
    "transCard": 0.1,
    "colorMain": _colorDefaultValue
  };
  static Map _lightDefault = {
    "darkMode": false,
    "simpleMode": true,
    "transBack": 0.85,
    "blurBack": 20.0,
    "transCard": 0.8,
    "colorMain": _colorDefaultValue
  };
  static Map _darkDefault = {
    "darkMode": true,
    "simpleMode": false,
    "transBack": 1.0,
    "blurBack": 8.0,
    "transCard": 0.8,
    "colorMain": _colorDefaultValue
  };

  ///初始化主题数据
  static init() {
    if (Prefs.themeData == null) {
      _initFromJson(_diyDefault);
      _themeMode = ThemeMode.light;
      _savePrefs();
    } else {
      _initFromJson(jsonDecode(Prefs.themeData!));
    }
  }

  //恢复默认配置
  _restore() {
    debugPrint("@restore");
    _changeTheme(_diyDefault);
  }

  ///本地化存储
  static _savePrefs() {
    Prefs.themeData = jsonEncode(_toJson());
  }

  static _changeTheme(dynamic json) {
    _darkMode = json["darkMode"];
    _simpleMode = json["simpleMode"];
    _blurBack = json["blurBack"];
    _transCard = json["transCard"];
    _transBack = json["transBack"];
    _colorNavText = _simpleMode ? Colors.black : Colors.white;
    _themeMode = _darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  ///Map->类的变量
  static _initFromJson(dynamic json) {
    _darkMode = json["darkMode"];
    _simpleMode = json["simpleMode"];
    _blurBack = json["blurBack"];
    _transCard = json["transCard"];
    _transBack = json["transBack"];
    _colorMain = Color(json['colorMain']);
    _colorNavText = _simpleMode ? Colors.black : Colors.white;
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
    map['colorMain'] = _colorToHex(_colorMain);
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
    if (_simpleMode) {
      _changeTheme(_lightDefault);
    } else {
      _restore();
    }
    notifyListeners();
    _savePrefs();
  }

  set darkMode(bool value) {
    _darkMode = value;
    if (darkMode) {
      _changeTheme(_darkDefault);
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

  set colorMain(Color color) {
    _colorMain = color;
    notifyListeners();
    _savePrefs();
  }

  static int _colorToHex(Color color) {
    int result;
    try {
      result = int.parse('0x${color.value.toRadixString(16).padLeft(8, '0')}');
    } catch (e) {
      debugPrint(e.toString());
      result = 0x00bafd;
    }
    return result;
  }
}

class FlyThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    //弹窗背景色
    dialogTheme: DialogTheme(backgroundColor: Color(0xff1c1c1e)),
    //按钮按下的色彩
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    //文字主色
    primaryColor: Colors.white,
    useMaterial3: false,
    //子页面背景色
    scaffoldBackgroundColor: Colors.black,
    //输入框色彩
    disabledColor: Color(0xff6C6C6C).withOpacity(0.7),
    //未选中项色彩
    unselectedWidgetColor: Color(0xff6C6C6C).withOpacity(0.5),
    //卡片色彩
    cardColor: Color(0xff151517),
    //指示器色彩
    indicatorColor: Colors.white,
    //输入指示器颜色
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    //Chip未选中色彩
    canvasColor: Color(0xff6C6C6C).withOpacity(0.5),
    appBarTheme: AppBarTheme(
      //控制系统顶栏文字色
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
    ),
    colorScheme: ColorScheme.dark(
        primary: colorMain,
        secondary: colorMain,
      surface: Colors.black
    )
        .copyWith(
          secondary: Colors.white,
        )
        .copyWith(surface: Colors.black.withOpacity(0.9)),
  );
  static final diyTheme =
      ThemeData(scaffoldBackgroundColor: Colors.transparent);
  static final lightTheme = ThemeData(
    splashColor: Colors.transparent,
    dialogTheme: DialogTheme(backgroundColor: Colors.white),
    highlightColor: Colors.transparent,
    useMaterial3: false,
    //子页面背景色
    scaffoldBackgroundColor: Color(0xfff2f5f7),
    //文字主色
    primaryColor: Colors.black,
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
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      //AppBar阴影大小
      elevation: 0,
      color: Colors.transparent,
    ),
    //卡片背景
    cardColor: Colors.white,
    //指示器颜色
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    colorScheme: ColorScheme.light(
        primary: colorMain,
        secondary: colorMain,
        surface: Color(0xfff2f5f7)
    )
        .copyWith(
          secondary: Colors.white,
        )
        .copyWith(surface: Color(0xfff2f5f7).withOpacity(0)),
  );
}
