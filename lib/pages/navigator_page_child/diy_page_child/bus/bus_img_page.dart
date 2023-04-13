
//跳转到当前页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/ui.dart';
import '../../../../util/logger/log.dart';

void toBusImagePage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolCalendarPage()));
  Logger.log('SchoolBus', '查看校车图片',{});
}

class SchoolCalendarPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FlyWebView(title: "校车时刻",initialUrl: "https://www.cumt.edu.cn/ggfw/list.htm",);
  }
}
