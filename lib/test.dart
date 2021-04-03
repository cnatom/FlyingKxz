import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

import 'FlyingUiKit/container.dart';
import 'FlyingUiKit/custome_router.dart';
//跳转到当前页面
void toTestPage(BuildContext context){
  Navigator.of(context).pushAndRemoveUntil(CustomRoute(TestPage(),milliseconds: 500),(route)=>route==null);
}
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 238,242,245),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(spaceCardMarginRL),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil.statusBarHeight*2,),
              FlyContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadiusValue),
                            color: colorMain.withOpacity(0.2)
                          ),
                          padding: EdgeInsets.all(spaceCardPaddingRL/4),
                          child: Icon(IconData(0xe61a,fontFamily: "CY"),color: colorMain,size: fontSizeMain40*2.3,),
                        ),
                        SizedBox(height: fontSizeMain40,),
                        FlyText.main35("图书馆",color: Colors.black45,)
                      ],
                    ),
                    FlyText.main35("AAV"),
                    FlyText.main35("AAV"),
                    FlyText.main35("AAV"),
                    FlyText.main35("AAV"),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
