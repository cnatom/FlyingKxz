import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void changeTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class FlyThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    buttonColor: colorMain.withOpacity(0.8),
    dialogBackgroundColor: Color(0xff1c1c1e),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    accentColor: Colors.white,
    primaryColor: Colors.white, //AppBar的文本色
    scaffoldBackgroundColor: Colors.black, //子页面背景色
    backgroundColor: Colors.black.withOpacity(0.9), //主页面背景色
    colorScheme: ColorScheme.dark(), //字体颜色
    unselectedWidgetColor: Color(0xff6C6C6C).withOpacity(0.5),
    cardColor: Color(0xff1c1c1e),
    indicatorColor: Colors.white,
    cursorColor: colorMain,
    canvasColor: colorMain,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      elevation: 0,
      color: Colors.black,
    ),
  );
  static final diyTheme =
      ThemeData(scaffoldBackgroundColor: Colors.transparent);
  static final lightTheme = ThemeData(
      buttonColor: colorMain,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: Color(0xfff2f5f7), //子页面背景色
      backgroundColor: Color(0xfff2f5f7).withOpacity(0), //主页面背景色
      primaryColor: Colors.black,
      accentColor: Colors.white, //用作字体色彩
      unselectedWidgetColor: Color(0xfff3f3f3),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white54, //底部导航蓝未选中色
          selectedItemColor: Colors.white),
      appBarTheme: AppBarTheme(
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
        color: Colors.transparent, //AppBar背景色
      ),
      colorScheme: ColorScheme.light(), //主文字色彩
      cardColor: Colors.white.withOpacity(0.9) //卡片背景
      );
}
