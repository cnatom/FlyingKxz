import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/home_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

//跳转到当前页面
void toNavigatorPage(BuildContext context) async{
  Navigator.of(context).pushAndRemoveUntil(CustomRoute(FlyNavigatorPage(),milliseconds: 500),(route)=>route==null);
}
//底部导航栏页面,位于子页面的顶端
class FlyNavigatorPage extends StatefulWidget {
  _FlyNavigatorPageState createState() => _FlyNavigatorPageState();
}

class _FlyNavigatorPageState extends State<FlyNavigatorPage> with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0; //数组索引，通过改变索引值改变视图
  List<Widget> pageList;
  void initFunc()async{
    pageList = [
      HomePage(),
      DiyPage(),
      MyselfPage()
    ];
//    await UmengAnalyticsPlugin.init(
//        androidKey: '5f9cf50745b2b751a92066ae', iosKey: "5f9cfd5645b2b751a9206776", logEnabled: true
//    );
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
    var _pageController = PageController();
    return Scaffold(
      backgroundColor: colorPageBackground,
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index)=>pageList[index],
        itemCount: pageList.length,
        controller: _pageController,
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
          elevation: 1,
          fixedColor: colorMain,
          unselectedItemColor: Colors.black87,
          selectedFontSize: fontSizeMini38,
            unselectedFontSize: fontSizeMini38,
            items: [
            _bottomNavigationBar('主页',FeatherIcons.home,),
            _bottomNavigationBar('发现',OMIcons.explore,),
            _bottomNavigationBar('我的',Icons.person_outline,),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.jumpToPage(index);
          },
          type: BottomNavigationBarType.fixed),

      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
