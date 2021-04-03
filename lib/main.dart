import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/test.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'FlyingUiKit/Text/text.dart';
import 'FlyingUiKit/config.dart';
import 'FlyingUiKit/notice.dart';
import 'Model/global.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isAndroid) {
    //设置android状态栏为透明的沉浸。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  Future.wait([Prefs.init()]).whenComplete((){
    ThemeProvider.init();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: ThemeProvider())],
      builder: (context, _) {
        themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: FlyThemes.lightTheme,
          darkTheme: FlyThemes.darkTheme,
          //添加国际化
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
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
    _getAppVersion();
    initConfigInfo();
    if (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width <
        1.5) {
      deviceHeight = 1080;
      deviceWidth = 1920;
    }
    ScreenUtil.init(context,
        height: deviceHeight, width: deviceWidth); //初始化参考屏幕信息
    initSize();

    if (Prefs.backImg != null) {
      if (await File(Prefs.backImg).exists())
        backImgFile = File(Prefs.backImg);
    }
    await getSchoolYearTerm();
    toTestPage(context);
    return;
    //是否登录过
    if (Prefs.token != null) {
      toNavigatorPage(context);
    } else {
      Prefs.isFirstLogin = true;
      Global.clearPrefsData();
      toLoginPage(context); //第一次登录进入登录页
    }

  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    initFunc(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}
