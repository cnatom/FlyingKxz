//一般字体
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'config.dart';
double fontSizeTitle50; //headline1
double fontSizeTitle45; //headline2
double fontSizeMain40; //body1
double fontSizeMini38; //body2
double fontSizeTip33; //subtitle1
double fontSizeTipMini25; //subtitle2

//边距等配置
double spaceCardMarginBigTB;
double spaceCardMarginTB;//上下外边距
double spaceCardPaddingTB;//上下内边距
double spaceCardMarginRL;//左右外边距
double spaceCardPaddingRL;//左右内边距
//图标大小管理
double sizeIconMain50;
void initSize(){
  fontSizeTitle50 = ScreenUtil().setSp(50); //headline1
  fontSizeTitle45 = ScreenUtil().setSp(45); //headline2
  fontSizeMain40 = ScreenUtil().setSp(40); //body1
  fontSizeMini38 = ScreenUtil().setSp(37); //body2
  fontSizeTip33 = ScreenUtil().setSp(33); //subtitle1
  fontSizeTipMini25 = ScreenUtil().setSp(25); //subtitle2
  sizeIconMain50 = ScreenUtil().setSp(50);

  //边距等配置
  spaceCardMarginBigTB = ScreenUtil().setSp(30);
  spaceCardMarginTB = ScreenUtil().setSp(25);//上下外边距
  spaceCardPaddingTB = ScreenUtil().setSp(25);//上下内边距
  spaceCardMarginRL = ScreenUtil().setWidth(30);//左右外边距
  spaceCardPaddingRL = ScreenUtil().setWidth(50);//左右内边距
}

class FlyText extends StatelessWidget {
  FlyText.title50(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeTitle50;
  FlyText.title45(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeTitle45;
  FlyText.main40(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeMain40;
  FlyText.mainTip40(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine, this.textDecoration}
      ) : fontSize = fontSizeMain40,color = Color(0xff8d8d93);
  FlyText.main35(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeMini38;
  FlyText.mainTip35(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine, this.textDecoration}
      ) : fontSize = fontSizeMini38,color = Color(0xff8d8d93);
  FlyText.mini30(
      this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeTip33;
  FlyText.miniTip30(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine, this.textDecoration}
      ) : fontSize = fontSizeTip33,color = Color(0xff8d8d93);
  FlyText.mini25(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine, this.textDecoration}
  ) : fontSize = fontSizeTipMini25;
  FlyText.miniTip25(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine, this.textDecoration}
      ) : fontSize = fontSizeTipMini25,color = Color(0xff8d8d93);
  final TextAlign textAlign;
  final String text;
  final double fontSize;
  final Color color;
  final int maxLine;
  final int letterSpacing;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        decoration: textDecoration??TextDecoration.none,
        color: color==null?null:color,
        fontSize: fontSize,
        fontWeight: fontWeight==null?null:fontWeight
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }
}


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
