import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:photo_view/photo_view.dart';


//跳转到当前页面
void toSchoolCalendarPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolCalendarPage()));
}

class SchoolCalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: FlyWhiteAppBar(context, "校历"),
        body: Container(
          color: Colors.white,
            child: PhotoView(
              imageProvider: AssetImage("images/xiaoli_child.png",),
            )
        ),
      ),
    );
  }
}
