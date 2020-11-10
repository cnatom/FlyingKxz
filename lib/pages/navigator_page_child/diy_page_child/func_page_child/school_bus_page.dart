import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:photo_view/photo_view.dart';


//跳转到当前页面
void toSchoolBusPage(BuildContext context) {

  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolBusPage()));
}
//跳转到当前页面
//void toLoginPage(BuildContext context) async {
//  Navigator.of(context).pushAndRemoveUntil(
//      CustomRoute(LoginPage(), milliseconds: 1000), (route) => route == null);
//}

class SchoolBusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: FlyWhiteAppBar(context, "校车"),
        body: Container(
            child: PhotoView(
              imageProvider: AssetImage("images/xiaoche_child.png"),
            )
        ),
      ),
    );
  }
}
