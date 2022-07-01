

import 'package:flutter/material.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/custome_router.dart';
//跳转到当前页面
void toNullPage(BuildContext context) async {
  Navigator.of(context).pushAndRemoveUntil(
      CustomRoute(NullPage(), milliseconds: 1000), (route) => route == null);
}
class NullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(),
              Text('本测试版本已过期\n请加入交流群839372371\n获取正式版本（或测试版本）\n'
                  '我们的官网：kxz.atcumt.com',
                textAlign: TextAlign.center,style: TextStyle(color: colorMainText,fontSize: fontSizeMain40,fontWeight: FontWeight.bold,letterSpacing: 3),),
              Container()
            ]
        ),
      ),
    );
  }
}
