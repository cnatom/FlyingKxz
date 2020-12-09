//文字组件
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'config.dart';
//一般字体
Widget FlyTextTitle50(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal}) => Text(text,style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeTitle50, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);
Widget FlyTextTitle45(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal}) => Text(text,style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeTitle45, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);
Widget FlyTextMain40(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal}) => Text(text, style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeMain40, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);
Widget FlyTextMini35(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal}) => Text(text, style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeMini38, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);
Widget FlyTextTip30(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black38,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal})=>Text(text, style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeTip33, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);
Widget FlyTextTipMini25(String text,{double wordSpacing,int maxLine,TextAlign textAlign = TextAlign.start,Color color = Colors.black38,double letterSpacing = 0,FontWeight fontWeight = FontWeight.normal})=>Text(text, style: TextStyle(fontWeight: fontWeight,fontSize: fontSizeTipMini25, color: color,letterSpacing: letterSpacing,wordSpacing: wordSpacing),maxLines: maxLine,overflow: TextOverflow.ellipsis,textAlign: textAlign,);

//特殊字体组件
Widget FlyTitle(String title,{Color textColor = Colors.black}) => Container(
  margin: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: fontSizeMini38/4,
        height: fontSizeTitle45,
        decoration: BoxDecoration(color: colorSecond,borderRadius: BorderRadius.circular(borderRadiusValue)),
      ),
      SizedBox(width: ScreenUtil().setSp(35),),
      Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: fontSizeTitle45,
          fontWeight: FontWeight.bold,
        ),
      ),

    ],
  ),
);

Widget FlyTitleSecond(String title) => Container(
  margin: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          color: colorMainText,
          fontSize: fontSizeMain40,
          fontWeight: FontWeight.bold,
        ),
      ),

    ],
  ),
);
