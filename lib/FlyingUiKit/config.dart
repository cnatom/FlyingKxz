import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'dart:io';
double deviceWidth = 1080;
double deviceHeight = 1920;

//色彩管理
final Color colorMain = Color.fromARGB(255, 1,176,117).withAlpha(255);
// final Color colorMain = Colors.pinkAccent;
final Color colorSecond = Color.fromARGB(255, 228,247,241).withAlpha(255);
final Color colorMainText = Color.fromARGB(255, 12, 21, 60);
final Color colorIconBackground = Color.fromARGB(255, 244,245,249);
final Color colorShadow = Colors.black45;
final Color scaffoldBackgroundColor = Color.fromARGB(255, 255,255,255);
final Color colorPageBackground = Color.fromARGB(255, 247,247,247);

final Color colorLoginPageMain = Color.fromARGB(255, 40,216,161);

final List<Color> colorLessonCard = [
  Colors.blueAccent,
  Colors.deepOrange,
  Colors.green,
  Colors.deepPurple,
  Colors.redAccent,
  Colors.blue,
  Colors.pink,
  Colors.red,
  Colors.pinkAccent,
  Colors.teal.withAlpha(200)
];
final List<Color> colorFuncButton = [
  Color.fromARGB(255, 88,188,216),
  Color.fromARGB(255, 238,121,192),
  Color.fromARGB(255, 125,123,227),
  Color.fromARGB(255, 93,169,248),
  Color.fromARGB(255, 90,138,234),
  Color.fromARGB(255, 82,172,98),
  Color.fromARGB(255, 229,105,72),


];
final List<Color> colorExamCard = [
  Colors.red,//红色
  Colors.deepOrangeAccent,//橙黄色
  Colors.blue,//蓝色
  Colors.green,//绿色
  Color.fromARGB(255, 191,188,183),//灰色

];
//字体大小管理
final double fontSizeHomeAppBar60 = ScreenUtil().setSp(60);
final double fontSizeChildAppBar50 = ScreenUtil().setSp(50);
final double fontSizeTitle50 = ScreenUtil().setSp(50);
final double fontSizeTitle45 = ScreenUtil().setSp(45);
final double fontSizeMain40 = ScreenUtil().setSp(40);
final double fontSizeMini38 = ScreenUtil().setSp(38);
final double fontSizeTip33 = ScreenUtil().setSp(33);
final double fontSizeTipMini25 = ScreenUtil().setSp(25);

//图标
final Icon FlyIconBackIOS = Icon(
  Icons.arrow_back_ios,
  color: colorMainText,
  size: fontSizeMini38,
);
final Icon FlyIconRightGreyArrow = Icon(
  Icons.keyboard_arrow_right,
  color: Colors.black12,
  size: fontSizeTitle50,
);
//边距等配置
final double spaceCardMarginBigTB = ScreenUtil().setSp(20);
final double spaceCardMarginTB = ScreenUtil().setSp(15);//上下外边距
final double spaceCardPaddingTB = ScreenUtil().setSp(15);//上下内边距
final double spaceCardMarginRL = ScreenUtil().setWidth(30);//左右外边距
final double spaceCardPaddingRL = ScreenUtil().setWidth(50);//左右内边距

//容器圆角值
final double borderRadiusValue = fontSizeMini38;

//用于取消蓝色回弹效果
//ScrollConfiguration(
//       behavior: MyBehavior(),
//        child: ListView(),
//      );
class MyBehavior  extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if(Platform.isAndroid||Platform.isFuchsia){
      return child;
    }else{
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}