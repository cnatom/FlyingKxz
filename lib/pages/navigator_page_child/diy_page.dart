
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/func_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score_page.dart';
class DiyPage extends StatefulWidget {
  @override
  _DiyPageState createState() => _DiyPageState();
}

class _DiyPageState extends State<DiyPage> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {
  TabController mController; //Tab控制器
  Widget funcButton({@required String imageResource,@required String title,@required subTitle,@required GestureTapCallback onTap,Color color = Colors.grey}){
    return Container(
      width: ScreenUtil().setWidth(deviceWidth/2)-spaceCardPaddingTB/2,
      padding: EdgeInsets.fromLTRB(0,spaceCardPaddingTB, spaceCardPaddingTB, 0),

      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(spaceCardMarginRL),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              color: Colors.white
          ),
          child: Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(deviceWidth/12),
                height: ScreenUtil().setWidth(deviceWidth/12),
                padding: EdgeInsets.all(ScreenUtil().setWidth(deviceWidth/60)),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(200)
                ),
                child: Image.asset(
                  imageResource,
                  height: ScreenUtil().setWidth(160),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(deviceWidth/40),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlyTextMini35(title,fontWeight: FontWeight.bold),
                  FlyTextTip30(subTitle)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    mController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        key: Global.scaffoldKeyDiy,
        body: Column(
          children: <Widget>[
            SizedBox(height: ScreenUtil.statusBarHeight,),
            //AppBar
            Container(
              margin: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, fontSizeMini38),
              width: double.infinity,
              child: TabBar(
                  controller: mController,
                  labelColor: colorMainTextWhite,
                  labelStyle: TextStyle(fontSize: fontSizeTitle50,fontWeight: FontWeight.w600,),
                  unselectedLabelColor: colorMainTextWhite.withOpacity(0.5),
                  unselectedLabelStyle: TextStyle(fontSize: fontSizeTitle45,fontWeight: FontWeight.w600,),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.transparent),
                  ),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "发现",
                    ),
                    Tab(
                      text: "成绩",
                    ),

                  ]),
            ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: mController,
                  children: <Widget>[
                    FuncPage(),
                    ScorePage(),
                  ],
                ),
              )
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

