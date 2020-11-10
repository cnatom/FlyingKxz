//各种按钮
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';

import 'config.dart';

Widget FlyTitleIconButton(String title,String imageResource)=>Column(
  children: <Widget>[
    Material(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      color: colorIconBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        onTap: (){},
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue)
          ),
          width: ScreenUtil().setWidth(deviceWidth/5.5),
          padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(30), 0, ScreenUtil().setHeight(30)),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(imageResource,width: ScreenUtil().setWidth(80),),

              ),
              SizedBox(height: spaceCardMarginBigTB/2,),
              FlyTextMini35(title,color: colorMainText,letterSpacing: 1)
            ],
          ),
        ),
      ),
    ),

  ],
);


Widget FlyRecFlatButton(String title,{double width=100,GestureTapCallback onTap})=>Material(
  color: colorMain,
  borderRadius: BorderRadius.circular(10),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, fontSizeMini38*0.8, 0, fontSizeMini38*0.8),
      width: width,
      child: FlyTextTitle45(title,letterSpacing: 2,color: Colors.white),
    ),
  ),
);

Widget FlyRecFlatSecondButton(String title,{double width=100,GestureTapCallback onTap})=>Material(
  color: colorSecond,
  borderRadius: BorderRadius.circular(10),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, fontSizeMini38*0.8, 0, fontSizeMini38*0.8),
      width: width,
      child: FlyTextTitle45(title,letterSpacing: 2,color: colorMain),
    ),
  ),
);
Widget FlyRowMyselfItemButton({@required String imageResource,@required String title,String preview = '',GestureTapCallback onTap})=>Container(
  color: Colors.white,
  child: InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40*1.3, spaceCardPaddingRL, fontSizeMain40*1.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(imageResource,height: fontSizeMain40*1.3,),
              SizedBox(width: spaceCardPaddingTB,),
              FlyTextMini35(title)
            ],
          ),
          FlyIconRightGreyArrow
        ],
      ),
    ),
  ),
);

Widget FlyPreviewCardButton(
    {@required String title,
      @required String content,
      @required String subContent,
      Color color = Colors.green,
      GestureTapCallback onTap}) =>
    Material(
      color: color.withAlpha(10),
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(spaceCardPaddingTB),
          width: ScreenUtil().setWidth(deviceWidth / 2.3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlyTextMini35(title, color: Colors.black38),
              SizedBox(
                height: fontSizeMini38 / 6,
              ),
              Text(
                content,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: fontSizeMini38 / 6,
              ),
              FlyTextTip30(subContent, color: color.withAlpha(150)),
            ],
          ),
        ),
      ),
    );

//小按钮
Widget FlyGreyFlatButton(String text, {VoidCallback onPressed,double fontSize}) => FlatButton(
  onPressed: onPressed,
  highlightColor: Colors.transparent, //点击后的颜色为透明
  splashColor: Colors.transparent, //点击波纹的颜色为透明
  child: Text(
    text,
    style: TextStyle(
        color: Colors.black38, //字体颜色
        fontSize: fontSizeMini38),
  ),
);

Widget FlySearchBarButton(String title,String content,{GestureTapCallback onTap}){
  return Material(
    shadowColor: colorShadow,
    color: scaffoldBackgroundColor.withAlpha(240),
    child: InkWell(
      highlightColor: Colors.black12,
      onTap: onTap,
      child: Container(
        height: fontSizeMini38*3.5,
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlyTextMini35(title),
                FlyTextMini35(content,color: Colors.black38),
              ],
            ),
            Icon(
              Icons.search,
              color: colorMainText.withAlpha(100),
            )
          ],
        ),
      ),
    ),
  );
}
Widget FlyFloatButton(String heroTag,{@required IconData iconData,@required VoidCallback onPressed,bool mini = false}){
  return FloatingActionButton(
    heroTag: heroTag,
    mini: mini,
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(fontSizeMini38),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withAlpha(240),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withAlpha(20),
                blurRadius: 3,
              )
            ]
        ),
        child: Icon(iconData,color: colorMain.withAlpha(200),),
      ),
    ),
  );
}