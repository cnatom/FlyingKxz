//特殊字体组件
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';

import '../config.dart';

Widget FlyTitle(String title,{Color textColor = Colors.black}) => Container(
  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
          fontSize: fontSizeTitle45,
          fontWeight: FontWeight.bold,
        ),
      ),

    ],
  ),
);
