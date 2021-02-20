import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FlyingUiKit/config.dart';
import 'Model/global.dart';
import 'dart:io';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    //设置android状态栏为透明的沉浸。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _init()async{
    await Prefs.init();
    ThemeProvider.init();
  }
  @override
  void initState() {
    super.initState();
    _init();
  }
  @override
  Widget build(BuildContext context)=>MultiProvider(
    providers: [ChangeNotifierProvider.value(value: ThemeProvider())],
    builder: (context,_){
      final themeProvider = Provider.of<ThemeProvider>(context);

      return MaterialApp(
        themeMode: themeProvider.themeMode,
        theme: FlyThemes.lightTheme,
        darkTheme: FlyThemes.darkTheme,
        //添加国际化
        localizationsDelegates: [
          GlobalMaterialLocalizations .delegate,
          GlobalWidgetsLocalizations .delegate,
          DefaultCupertinoLocalizations .delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'), // English
          const Locale('zh', 'Hans'), // China
          const Locale('zh', ''), // China
        ],
        locale: Locale("zh"),
        debugShowCheckedModeBanner: false,
        home: StartPage(),
      );
    },
  );


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
    if (Global.prefs.getString(Global.prefsStr.backImg) != null) {
      if (await File(Global.prefs.getString(Global.prefsStr.backImg)).exists())
        backImgFile = File(Global.prefs.getString(Global.prefsStr.backImg));
    }
    await getSchoolYearTerm();

    // //内测结束
    // if(DateTime.now().isAfter(DateTime.parse('2021-01-24'))){
    //   toNullPage(context);
    //   return;
    // }
    //是否登录过
    if (Prefs.username!=null) {
      toNavigatorPage(context);
    } else {
      Global.prefs.setBool(Global.prefsStr.isFirstLogin, true);
      toLoginPage(context); //第一次登录进入登录页
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
    if (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width <
        1.5) {
      deviceHeight = 1080;
      deviceWidth = 1920;
    }
    ScreenUtil.init(context,
        height: deviceHeight, width: deviceWidth); //初始化参考屏幕信息
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}



