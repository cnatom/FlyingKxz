import 'dart:io';

import 'package:flutter/material.dart';

import 'text.dart';
void initConfigInfo(){
  colorMain = Color(0xff00c5a8);
  colorSecond = Color(0xFF33CC99).withAlpha(255);
  colorMainText = Color.fromARGB(255, 0, 0, 0);
  colorMainTextWhite = Colors.white;
  colorIconBackground = Color.fromARGB(255, 244,245,249);
  colorShadow = Color(0XFFCCCCCC);
  scaffoldBackgroundColor = Color.fromARGB(255, 255,255,255);
  colorPageBackground = Color.fromARGB(255, 247,247,247);
  colorLoginPageMain = Color.fromARGB(255, 40,216,161);

  borderRadiusValue = 10;
  colorLessonCard = [
    Color.fromARGB(255, 102,204,153),
    Color(0xFF6699FF),
    Color.fromARGB(255, 255,153,153),
    Color.fromARGB(255, 166,145,248),
    Color.fromARGB(255, 62,188,202),
    Color.fromARGB(255, 255,153,102),
    Color(0xFF4ecccc),
    Color(0xFFff9bcb)
  ];
  colorFuncButton = [
    Color.fromARGB(255, 88,188,216),
    Color.fromARGB(255, 238,121,192),
    Color.fromARGB(255, 125,123,227),
    Color.fromARGB(255, 93,169,248),
    Color.fromARGB(255, 90,138,234),
    Color.fromARGB(255, 82,172,98),
    Color.fromARGB(255, 229,105,72),
  ];
  colorExamCard = [
    Colors.red,//红色
    Colors.deepOrangeAccent,//橙黄色
    Colors.blue,//蓝色
    Colors.green,//绿色
    Color.fromARGB(255, 191,188,183),//灰色
  ];
  boxShadowMain = BoxShadow(
      blurRadius: 10,
      spreadRadius: 0.05,
      color: Colors.black12.withAlpha(10)
  );
}
double deviceWidth;
double deviceHeight;

//背景图文件
File backImgFile;
Image backImg;
//色彩管理
Color colorMain = Color(0xff00c5a8);
Color colorSecond = Color(0xFF33CC99).withAlpha(255);
Color colorMainText = Color.fromARGB(255, 0, 0, 0);
Color colorMainTextWhite = Colors.white;
Color colorIconBackground = Color.fromARGB(255, 244,245,249);
Color colorShadow = Color(0XFFCCCCCC);
Color scaffoldBackgroundColor = Color.fromARGB(255, 255,255,255);
Color colorPageBackground = Color.fromARGB(255, 247,247,247);
Color colorLoginPageMain = Color.fromARGB(255, 40,216,161);

List<Color> colorLessonCard;
List<Color> colorFuncButton;
List<Color> colorExamCard;



Icon FlyIconRightGreyArrow({Color color = Colors.white})=> Icon(
  Icons.keyboard_arrow_right,
  size: sizeIconMain50,
  color: color,
);


//容器圆角值
double borderRadiusValue;

//阴影
BoxShadow boxShadowMain;

