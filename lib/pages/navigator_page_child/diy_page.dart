//课表页面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/example_page.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/applets.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/func_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_page.dart';
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
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: Global.scaffoldKeyDiy,
        body: Column(
          children: <Widget>[
            SizedBox(height: ScreenUtil.statusBarHeight,),
            //AppBar
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: TabBar(
                  controller: mController,
                  labelColor: colorMainText,
                  labelStyle: TextStyle(fontSize: fontSizeTitle45,fontWeight: FontWeight.bold,fontFamily: "SY"),
                  unselectedLabelStyle: TextStyle(fontSize: fontSizeTitle45,fontFamily: "SY",fontWeight: FontWeight.bold,),
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.grey.withAlpha(200),
//                  indicatorWeight: 3,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3,color: colorMainText),
                      insets: EdgeInsets.fromLTRB(fontSizeMain40*1.2, 0, fontSizeMain40*1.2, 0)
                  ),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "考试",
                    ),
                    Tab(
                      text: "发现",
                    ),
                    Tab(
                      text: "成绩",
                    ),

                  ]),
            ),
            Divider(height: 0,),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: mController,
                  children: <Widget>[
                    ExamPage(),
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

