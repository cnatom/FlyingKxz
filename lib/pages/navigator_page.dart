import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'app_upgrade.dart';
import 'backImage_view.dart';
import 'navigator_page_child/course_table/course_page.dart';

//跳转到当前页面
void toNavigatorPage(BuildContext context){
  Navigator.of(context).pushAndRemoveUntil(CustomRoute(FlyNavigatorPage(),milliseconds: 500),(route)=>route==null);
}
//底部导航栏页面,位于子页面的顶端
class FlyNavigatorPage extends StatefulWidget {
  _FlyNavigatorPageState createState() => _FlyNavigatorPageState();
}
var navigatorPageController = PageController();
class _FlyNavigatorPageState extends State<FlyNavigatorPage> with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0; //数组索引，通过改变索引值改变视图
  ThemeProvider themeProvider;
  void initFunc() async{
    Dio().get(
        "https://www.lvyingzhao.cn/action",
        queryParameters: {
          "username":Prefs.username,
          "version":Global.curVersion,
          "platform":Platform.operatingSystem
        }
    );
    if(Prefs.cumtLoginUsername!=null){
      await cumtAutoLoginGet(context,
          username: Prefs.cumtLoginUsername,
          password: Prefs.cumtLoginPassword,
          loginMethod: Prefs.cumtLoginMethod);
    }
  }
  @override
  void initState() {
    super.initState();
    initFunc();
    checkUpgrade(context);
  }
  BottomNavigationBarItem _bottomNavigationBar(String title,IconData iconData,{double size})=>BottomNavigationBarItem(
      label: title,
      icon: Icon(
        iconData,
        size: size,
      )
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return FlyNavBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            physics: BouncingScrollPhysics(),
            children: [
              CoursePage(),
              DiyPage(),
              MyselfPage()
            ],
            controller: navigatorPageController,
            onPageChanged: (int index){
              setState(() {
                if(_currentIndex!=index) _currentIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedFontSize: fontSizeTip33,
              unselectedFontSize: fontSizeTip33,
              selectedItemColor: themeProvider.simpleMode?themeProvider.colorMain:null,
              unselectedItemColor: themeProvider.simpleMode?Colors.black45:null,
              items: [
                _bottomNavigationBar('主页',FeatherIcons.home,),
                _bottomNavigationBar('发现',OMIcons.explore,),
                _bottomNavigationBar('我的',Icons.person_outline,),
              ],
              currentIndex: _currentIndex,
              onTap: (int index) {
                navigatorPageController.jumpToPage(index);
              },
              type: BottomNavigationBarType.fixed),
        )
    );
  }
  @override
  bool get wantKeepAlive => true;
}



