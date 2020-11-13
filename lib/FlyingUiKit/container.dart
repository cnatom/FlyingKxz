import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyhub/animation/easy_falling_ball.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/global.dart';

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
                  FlyTextMain40(subTitle, color: Colors.black38)
                ],
              ),
            )

          ],
        ),
      ),
    );

//个人资料卡
Widget FlyMyselfCard(
    {String imageResource = "",
      String name = "",
      String id = "",
      String classs = "",
      String college = ""}) =>
    Container(
      padding: EdgeInsets.fromLTRB(fontSizeMini38*2, 0, 0, 0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              imageResource,
              height: ScreenUtil().setWidth(170),
              fit: BoxFit.fill,
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
                    FlyTextTitle50(name,color: colorMain,fontWeight: FontWeight.bold),
                    SizedBox(width: fontSizeMini38,),
                    Container(
                      padding: EdgeInsets.fromLTRB(fontSizeMini38/2, 0, fontSizeMini38/2, 0),
                      decoration: BoxDecoration(
                          color: colorMain.withAlpha(200),
                          borderRadius: BorderRadius.circular(2)
                      ),
                      child: Row(
                        children: [
                          FlyTextTip30("内测会员",color: Colors.white,textAlign: TextAlign.center),
                          Global.prefs.getString(Global.prefsStr.rank)!=null?FlyTextTip30(" No.${Global.prefs.getString(Global.prefsStr.rank)}",color: Colors.white):Container()
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 5,),
                FlyTextTip30("账号: " + id),
                Container(
                  child: FlyTextTip30(college),
                ),

              ],
            ),
          ),
        ],
      ),
    );


