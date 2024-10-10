import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../../navigator_page.dart';


//跳转到当前页面
void toSchoolCalendarPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolCalendarPage()));
  Logger.log('SchoolCalendar', '进入',{});
}

class SchoolCalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FlyWebView(title: "校历",initialUrl: "https://www.cumt.edu.cn/ggfw/xnxl.htm",);
  }
}
