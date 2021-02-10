import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
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
      //未选中项色彩
      unselectedWidgetColor: Color(0xff6C6C6C).withOpacity(0.5),
      //卡片色彩
      cardColor: Color(0xff1c1c1e),
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
      )
  );
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
    //未选中项色彩
    unselectedWidgetColor: Colors.black12.withOpacity(0.1),
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
    cardColor: Colors.white.withOpacity(0.9),
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
