

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

class PointArray extends StatefulWidget {
  final Color colorFirst;
  final Color colorSecond;
  PointArray({Key key, this.colorFirst, this.colorSecond}):super(key: key);
  @override
  _PointArrayState createState() => _PointArrayState();
}

class _PointArrayState extends State<PointArray> {
  double widgetWidth;//容器边长
  CourseProvider courseProvider;
  @override
  Widget build(BuildContext context) {
    this.widgetWidth = MediaQuery.of(context).size.height/50;
    courseProvider = Provider.of<CourseProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(),
        Container(
          height: MediaQuery.of(context).size.height/2.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(23, (index){
              if(index == 0) return Container();
              return _point(index);
            }),
          ),
        ),
        Container(),
        Container()
      ],
    );
  }
  Widget _point(int index){
    double size = widgetWidth/4;
    return Container(
      width: index==courseProvider.curWeek?size*1.5:size,
      height: index==courseProvider.curWeek?size*1.5:size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: index==courseProvider.curWeek?widget.colorFirst: widget.colorSecond
      ),
    );
  }
}
