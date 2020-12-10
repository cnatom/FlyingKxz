import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/home_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'app_upgrade.dart';
import 'backImage_view.dart';

//跳转到当前页面
void toNavigatorPage(BuildContext context) async{
  Navigator.of(context).pushAndRemoveUntil(CustomRoute(FlyNavigatorPage(),milliseconds: 500),(route)=>route==null);
}
//底部导航栏页面,位于子页面的顶端
class FlyNavigatorPage extends StatefulWidget {
  _FlyNavigatorPageState createState() => _FlyNavigatorPageState();
}
var navigatorPageController = PageController();
class _FlyNavigatorPageState extends State<FlyNavigatorPage> with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0; //数组索引，通过改变索引值改变视图
  List<Widget> pageList;
  void initFunc() async{
    pageList = [
      HomePage(),
      DiyPage(),
      MyselfPage()
    ];
    if(Global.igUpgrade!=true&&Platform.isAndroid){
      await upgradeApp(context,auto: true);//用户没有忽略过则检查更新
    }
    Dio().get(
        "https://www.lvyingzhao.cn/action",
        queryParameters: {
          "username":Global.prefs.getString(Global.prefsStr.username)
        }
    );
    debugPrint("@@@自动登录");
    if(Global.prefs.getString(Global.prefsStr.cumtLoginUsername)!=null){
      await cumtAutoLoginGet(context,
          username: Global.prefs.getString(Global.prefsStr.cumtLoginUsername),
          password: Global.prefs.getString(Global.prefsStr.cumtLoginPassword),
          loginMethod: Global.prefs.getInt(Global.prefsStr.cumtLoginMethod));
    }
  }
  @override
  void initState() {
    super.initState();

    initFunc();
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
    return Stack(
      children: [
        BackImgView(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=>pageList[index],
            itemCount: pageList.length,
            controller: navigatorPageController,
            onPageChanged: (int index){
              setState(() {
                if(_currentIndex!=index) _currentIndex = index;
              });
            },
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              canvasColor: scaffoldBackgroundColor,
            ),
            child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                fixedColor: Colors.white,
                unselectedItemColor: colorMainTextWhite.withOpacity(0.6),
                selectedFontSize: fontSizeTip33,
                unselectedFontSize: fontSizeTip33,
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

          ),
        )
      ],
    );
  }
  @override
  bool get wantKeepAlive => true;
}



