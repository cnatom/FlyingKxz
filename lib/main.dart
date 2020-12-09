

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/pages/app_upgrade.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/null_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/PickerLocalizationsDelegate.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FlyingUiKit/config.dart';
import 'Model/global.dart';
import 'dart:io';
void main() {
  if (Platform.isAndroid) {
    //设置android状态栏为透明的沉浸。
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        // fontFamily: "SY",
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
    ),
    localizationsDelegates: [
      PickerLocalizationsDelegate.delegate,
    ],
    debugShowCheckedModeBanner: false,
    home: StartPage(),
  ));
}
//启动页
class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  //获取当前App版本
  void _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Global.curVersion = packageInfo.version;
  }
  Future<void> initFunc(BuildContext context) async {
    //提取本地信息
    Global.prefs = await SharedPreferences.getInstance();
    await getSchoolYearTerm();
    if(Global.prefs.getString(Global.prefsStr.backImg)!=null) fileBackImg = File(Global.prefs.getString(Global.prefsStr.backImg));
    //内测结束
    if(DateTime.now().isAfter(DateTime.parse('2020-12-31'))){
      toNullPage(context);
      return;
    }
    if(Global.igUpgrade!=true){
      upgradeApp(context,auto: true);//用户没有忽略过则检查更新
    }
    //是否登录过
    if (Global.prefs.getBool(Global.prefsStr.isFirstLogin)==false){
      toNavigatorPage(context);
    } else{
      Global.prefs.setBool(Global.prefsStr.isFirstLogin, true);
      toLoginPage(context);//第一次登录进入登录页
    }
  }
  @override
  void initState() {
    super.initState();
    initFunc(context);
    _getAppVersion();
  }
  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width<1){
      deviceHeight = 1920;
      deviceWidth = 1920;
    }
    ScreenUtil.init(context, height: deviceHeight, width: deviceWidth);//初始化参考屏幕信息
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}

