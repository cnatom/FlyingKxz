import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/background/background_provider.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

import 'Model/global.dart';
import 'cumt/cumt.dart';
import 'ui/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _ifAndroidSetStatusBarTransparent();
  Future.wait([
    Prefs.init(),
  ]).whenComplete(() {
    if (Prefs.password == null) {
      Global.clearPrefsData();
    }
    initConfigInfo();
    ThemeProvider.init(); // 初始化主题
    CumtLoginPrefs.init(); //初始化校园网登录模块
    Cumt.getInstance().init(); //初始化爬虫模块
    runApp(MyApp()); //启动App
  });
}

void _ifAndroidSetStatusBarTransparent() {
  if (UniversalPlatform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: PowerProvider()),
        ChangeNotifierProvider.value(value: BalanceProvider()),
        ChangeNotifierProvider.value(value: BackgroundProvider()),
      ],
      builder: (context, _) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          navigatorKey: FlyNavigatorPageState.navigatorKey,
          themeMode: themeProvider.themeMode,
          theme: FlyThemes.lightThemeTest(themeProvider),
          darkTheme: FlyThemes.darkThemeTest(themeProvider),
          builder: (context, child) {
            child = BotToastInit()(context, child);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)), // 固定字体缩放比例
              child: child,
            );
          },
          navigatorObservers: [BotToastNavigatorObserver()],
          //添加国际化
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'), // 美国英语
              const Locale('zh', 'CN'), // 中文简体
              //其他Locales
            ],
          locale: Locale("zh"),
          debugShowCheckedModeBanner: false,
          home: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: StartPage()),
        );
      },
    );
  }
}

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  late BackgroundProvider backgroundProvider;

  Future<void> initFunc(BuildContext context) async {
    // 获取当前App版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Global.curVersion = packageInfo.version;
    //初始化配置（无需context）
    deviceWidth = 1080;
    deviceHeight = 1920;
    //宽屏设备时，修改屏幕参考信息
    if (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width <
        1.5) {
      deviceHeight = 1080;
      deviceWidth = 1920;
    }
    //初始化参考屏幕信息
    ScreenUtil.init(context, designSize: Size(deviceWidth, deviceHeight));
    //初始化配置
    initSize();
    // 缓存壁纸
    await backgroundProvider.precacheBackground(context);
    // 选择跳转
    if (Prefs.password != null) {
      toNavigatorPage(context);
    } else {
      Global.clearPrefsData();
      toLoginPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    backgroundProvider = Provider.of<BackgroundProvider>(context);
    return FutureBuilder(
      future: initFunc(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(),
        );
      }
    );
  }
}
