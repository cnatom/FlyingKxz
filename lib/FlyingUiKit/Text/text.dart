//一般字体
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';

final double fontSizeTitle50 = ScreenUtil().setSp(50); //headline1
final double fontSizeTitle45 = ScreenUtil().setSp(45); //headline2
final double fontSizeMain40 = ScreenUtil().setSp(40); //body1
final double fontSizeMini38 = ScreenUtil().setSp(38); //body2
final double fontSizeTip33 = ScreenUtil().setSp(33); //subtitle1
final double fontSizeTipMini25 = ScreenUtil().setSp(25); //subtitle2
enum TextType { head1, head2, body1, body2, sub1, sub2 }
class FlyText extends StatelessWidget {
  FlyText.title50(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeTitle50;
  FlyText.title45(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeTitle45;
  FlyText.main40(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeMain40;
  FlyText.mainTip40(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine}
      ) : fontSize = fontSizeMain40,color = Color(0xff8d8d93);
  FlyText.main35(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeMini38;
  FlyText.mainTip35(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine}
      ) : fontSize = fontSizeMini38,color = Color(0xff8d8d93);
  FlyText.mini30(
      this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeTip33;
  FlyText.miniTip30(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine}
      ) : fontSize = fontSizeTip33,color = Color(0xff8d8d93);
  FlyText.mini25(
    this.text,{this.letterSpacing,this.fontWeight,this.color,this.textAlign,this.maxLine}
  ) : fontSize = fontSizeTipMini25;
  FlyText.miniTip25(
      this.text,{this.letterSpacing,this.fontWeight,this.textAlign,this.maxLine}
      ) : fontSize = fontSizeTipMini25,color = Color(0xff8d8d93);
  final TextAlign textAlign;
  final String text;
  final double fontSize;
  final Color color;
  final int maxLine;
  final int letterSpacing;
  final FontWeight fontWeight;
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
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
