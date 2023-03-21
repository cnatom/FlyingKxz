import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/model/logger/log.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../../navigator_page.dart';


//跳转到当前页面
void toSchoolCalendarPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolCalendarPage()));
  Logger.sendInfo('SchoolCalendar', '进入',{});
}

class SchoolCalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: FlyAppBar(context, "校历"),
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
