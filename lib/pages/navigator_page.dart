import 'dart:io';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/FlyingUiKit/notice.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:flying_kxz/NetRequest/userInfo_post.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'app_upgrade.dart';
import 'navigator_page_child/course_table/course_page.dart';

Future<void> sendInfo(String page,String action)async{
  var info = {
    "username":Prefs.username,
    "action":action,
    "page":page,
    "info":{
      "name":Prefs.name,
      "time":DateTime.now().toString(),
      "system":Platform.operatingSystem,
      "version":Global.curVersion
    }
  };
  var res = Dio().post(
    "https://www.lvyingzhao.cn/action",
    data: info
  );
  print(page+':'+action);
}
//跳转到当前页面
void toNavigatorPage(BuildContext context){
  Navigator.of(context).pushAndRemoveUntil(CustomRoute(FlyNavigatorPage(),milliseconds: 500),(route)=>route==null);
}
//底部导航栏页面,位于子页面的顶端
class FlyNavigatorPage extends StatefulWidget {
  FlyNavigatorPageState createState() => FlyNavigatorPageState();
}
var navigatorPageController = PageController(initialPage: 0);
class FlyNavigatorPageState extends State<FlyNavigatorPage> with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0; //数组索引，通过改变索引值改变视图

  static GlobalKey<NavigatorState> navigatorKey=GlobalKey();
  ThemeProvider themeProvider;
  //校园网自动登录
  void cumtAutoLogin()async{
    if(Prefs.cumtLoginUsername!=null){
      await cumtAutoLoginGet(context,
          username: Prefs.cumtLoginUsername,
          password: Prefs.cumtLoginPassword,
          loginMethod: Prefs.cumtLoginMethod);
      sendInfo('校园网登录', '自动登录了校园网:${Prefs.cumtLoginUsername},${Prefs.cumtLoginMethod}');
    }
  }
  //获取用户信息
  // getUserInfo()async{
  //   if(Prefs.college==null||Prefs.className==null){
  //     await userInfoPost(context, token: Prefs.token);
  //   }
  // }
  @override
  void initState() {
    super.initState();
    cumtAutoLogin();//自动登录校园网
    // getUserInfo();//获取用户信息
    // noticeGetInfo();//获取通知信息
    checkUpgrade(context);//检查软件更新
    sendInfo('主页', '初始化主页');
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
            physics: NeverScrollableScrollPhysics(),
            children: [
              CoursePage(),
              // InfoPage(),
              DiyPage(),
              MyselfPage(),
              // TestPage()
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
                // _bottomNavigationBar("资讯", Icons.article_outlined,badgeShowList[1]),
                _bottomNavigationBar('发现',OMIcons.explore,),
                _bottomNavigationBar('我的',Icons.person_outline,),
                // _bottomNavigationBar('我的',Icons.person_outline,badgeShowList[3]),

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



