import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import 'app_upgrade.dart';
import 'navigator_page_child/course_table/course_page.dart';



//跳转到当前页面
void toNavigatorPage(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      FadeTransitionRouter(FlyNavigatorPage(), milliseconds: 500),
      (route) => route == null);
}

// 底部Navigator按钮数据类
class BottomNavigationBarModel {
  final String title;
  final IconData iconData;
  BottomNavigationBarModel(this.title, this.iconData);
}


//底部导航栏页面,位于子页面的顶端
class FlyNavigatorPage extends StatefulWidget {
  const FlyNavigatorPage({Key key}) : super(key: key);

  @override
  State<FlyNavigatorPage> createState() => FlyNavigatorPageState();
}

var navigatorPageController = PageController(initialPage: 0);

class FlyNavigatorPageState extends State<FlyNavigatorPage>
    with AutomaticKeepAliveClientMixin,WidgetsBindingObserver{
  int _currentIndex = 0; //数组索引，通过改变索引值改变视图
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  ThemeProvider themeProvider;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkUpgrade(context); //检查软件更新
    Logger.log("Navigator", "打开",{});
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// 生命周期回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      navigatorPageController.jumpToPage(0);
    }
  }

  final List<BottomNavigationBarModel> _buttonBarItem = [
    BottomNavigationBarModel("主页", FeatherIcons.home),
    BottomNavigationBarModel('发现', OMIcons.explore),
    BottomNavigationBarModel('我的', Icons.person_outline),
  ];



  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Intro(
      padding: const EdgeInsets.all(0),
      borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
      buttonTextBuilder: (order) => '好的',
      child: FlyNavBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(),
          )),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        items: _buttonBarItem
            .map((item) => _buildBottomNavigationItem(item.title, item.iconData)).toList(),
        onTap: (int index) {
          navigatorPageController.jumpToPage(index);
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedFontSize: fontSizeTip33,
        unselectedFontSize: fontSizeTip33,
        selectedItemColor:
            themeProvider.simpleMode ? themeProvider.colorMain : null,
        unselectedItemColor: themeProvider.simpleMode ? Colors.black45 : null,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed);
  }

  PageView _buildBody() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        CoursePage(),
        DiyPage(),
        MyselfPage(),
      ],
      controller: navigatorPageController,
      onPageChanged: (int index) {
        setState(() {
          if (_currentIndex != index) _currentIndex = index;
        });
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationItem(String title, IconData iconData,
      {double size}){
    return BottomNavigationBarItem(
        label: title,
        icon: Icon(
          iconData,
          size: size,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

