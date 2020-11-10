

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';

import 'login_page.dart';
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logo.png',width: ScreenUtil().setWidth(deviceWidth*0.3),),
                  SizedBox(height: fontSizeMini38,),
                  Text('翔工作室出品',style: TextStyle(color: colorLoginPageMain,fontSize: fontSizeMain40,fontWeight: FontWeight.bold,letterSpacing: 3),)
                ],
              ),
              Text('本次测试已结束\n2020.10.6 - 2020.12.31\n\n感谢您对我们的支持\n我们将会继续对产品进行打磨\n不久后将会发布正式版\n\n反馈建议QQ群：839372371',
                textAlign: TextAlign.center,style: TextStyle(color: colorMainText,fontSize: fontSizeMain40,fontWeight: FontWeight.bold,letterSpacing: 3),),
              Container()
            ]
        ),
      ),
    );
  }
}
