import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyhub/animation/easy_falling_ball.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:provider/provider.dart';
import 'config.dart';

//常用圆角容器
//Widget FlyCirContainer(
//        {@required Widget child,
//        Color color = Colors.white}) =>
//    Container(
//      margin: EdgeInsets.fromLTRB(spaceCardMarginTB, 0, spaceRow, 0),
//      padding: EdgeInsets.all(spaceRow),
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(borderRadiusValue), color: color),
//      child: child,
//    );
Widget FlyFilterContainer(BuildContext context,{Widget child}){
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue)
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            //背景过滤器
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
              child: Opacity(
                opacity: 0.01,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}
Widget FlyIdCardContainer(
        {@required String title,
        @required String subTitle,
        @required String imageResource}) =>
    Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spaceCardMarginBigTB, 0, spaceCardMarginBigTB, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageResource,
                  height: ScreenUtil().setWidth(160),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(70),
                        color: colorMainText,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: spaceCardPaddingTB,
                  ),
                  FlyText.main40(subTitle, color: Colors.black38)
                ],
              ),
            )

          ],
        ),
      ),
    );
//个人资料卡
Widget FlyMyselfCard(BuildContext context,
    {String imageResource = "",
      String name = "",
      String id = "",
      String classs = "",
      String college = ""}) =>
    Container(
      padding: EdgeInsets.fromLTRB(fontSizeMini38*2, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border:Border.all(color: Colors.white,width: 3)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                imageResource,
                height: ScreenUtil().setWidth(120),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    FlyText.title45(name,color: Colors.white,fontWeight: FontWeight.bold),
                    SizedBox(width: fontSizeMini38,),
                    Container(
                      padding: EdgeInsets.fromLTRB(fontSizeMini38/2, 0, fontSizeMini38/2, 0),
                      decoration: BoxDecoration(
                          color: colorMain.withAlpha(200),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child: Row(
                        children: [
                          FlyText.mini30("内测会员",color: Colors.white,textAlign: TextAlign.center),
                          Global.prefs.getString(Global.prefsStr.rank)!=null?FlyText.mini30(" No.${Global.prefs.getString(Global.prefsStr.rank)}",color: Colors.white):Container()
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 5,),
                Container(
                  child: FlyText.mini30(college,color: Theme.of(context).accentColor,),
                ),

              ],
            ),
          ),
        ],
      ),
    );


