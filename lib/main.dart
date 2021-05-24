import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/pages/null_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'FlyingUiKit/Text/text.dart';
import 'FlyingUiKit/Theme/theme.dart';
import 'FlyingUiKit/config.dart';
import 'Model/global.dart';
import 'dart:io';
import 'cumt_spider/cumt.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isAndroid) {
    //设置android状态栏为透明的沉浸。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  /// Prefs.init() 提取存储在本地的信息
  Future.wait([Prefs.init()]).whenComplete((){
    if(Prefs.password==null){
      Global.clearPrefsData();
      backImgFile = null;
    }
    ThemeProvider.init();// 初始化主题
    cumt.init();//初始化爬虫模块
    //启动App
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


  Future<void> initFunc(BuildContext context) async {

    // 获取当前App版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Global.curVersion = packageInfo.version;
    initConfigInfo();
    //宽屏设备时，修改屏幕信息
    if (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width <
        1.5) {
      deviceHeight = 1080;
      deviceWidth = 1920;
    }
    //初始化参考屏幕信息
    ScreenUtil.init(context,
        height: deviceHeight, width: deviceWidth);
    initSize();
    if(DateTime.now().isAfter(DateTime(2021,6,1))){
      toNullPage(context);
      return;
    }
    //初始化背景图路径
    if (Prefs.backImg != null) {
      if (await File(Prefs.backImg).exists())
        backImgFile = File(Prefs.backImg);
    }
    await getSchoolYearTerm();
    // toTestPage(context);
    // return;
    //是否登录过
    // toNavigatorPage(context);
    // return;
    if (Prefs.password != null) {
      toNavigatorPage(context);
    } else {
      Global.clearPrefsData();
      backImgFile = null;
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
