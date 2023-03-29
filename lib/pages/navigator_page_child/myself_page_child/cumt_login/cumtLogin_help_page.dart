
//跳转到当前页面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../../../../ui/ui.dart';
import '../../../../util/logger/log.dart';

void toCumtLoginHelpPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => CumtLoginHelpPage()));
  Logger.sendInfo('CumtLoginHelp', '进入', {});
}

class CumtLoginHelpPage extends StatefulWidget {
  @override
  _CumtLoginHelpPageState createState() => _CumtLoginHelpPageState();
}

class _CumtLoginHelpPageState extends State<CumtLoginHelpPage> {
  Widget helpItem(
      String imageResource,
      String text,
      ) =>
      Wrap(
        children: [
          FlyText.title45(
            text,
            maxLine: 100,
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(deviceWidth * 0.1)),
            child: Container(
              decoration: BoxDecoration(boxShadow: [boxShadowMain]),
              child: Center(
                child: Image.asset(
                  imageResource,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "校园网自动登录秘籍"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(spaceCardMarginRL),
          child: Wrap(
            children: [
              helpItem("images/cumtLoginHelp1.png",
                  '1、在系统设置中连接校园网CUMT_Stu，并等待上方出现wifi标志（很重要！）'),
              helpItem("images/cumtLoginHelp5.png",
                  '2、连接网络后可能会自动弹出登录页面，点击取消，选择"不连接互联网使用"（以iOS为例，其他系统也差不多）'),
              helpItem("images/cumtLoginHelp6.png",
                  '3、为避免再弹出登录页面，可以进入CUMT_Stu详情页面，关闭"自动登录"功能。'),
              helpItem("images/cumtLoginHelp2.png",
                  '4、打开矿小助输入账号密码就可以登录了\n（第二次打开这个框框就不用填账号密码了哦）'),
              helpItem('images/cumtLoginHelp1.png',
                  "你以为这就结束了？？？\n用脚趾头想想也知道那必不可能（滑稽\n\n矿小助还可以一键登录校园网\n(前提是你已经用上述步骤手动登录过了)\n\n1、连接wifi，等待出现wifi标志"),
              helpItem('images/cumtLoginHelp3.png', "2、打开矿小助"),
              helpItem(
                  'images/cumtLoginHelp4.png',
                  "然后就可以愉快的上网了～\n\n"
                      "Q:什么情况下会触发自动登录函数？\n1.初始化矿小助时\n2.将矿小助从后台调出时（版本号需 > 1.4.06）\n\n"
                      "如果喜欢的话可以将矿小助推荐给其他人哦～\n\n"
                      "——用爱发电的程序员小哥")
            ],
          ),
        ),
      ),
    );
  }
}
