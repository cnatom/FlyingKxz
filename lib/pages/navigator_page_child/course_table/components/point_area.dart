
//单个点阵组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

import '../../course_page.dart';
import 'course_table.dart';


class PointArea extends StatefulWidget {

  @override
  _PointAreaState createState() => _PointAreaState();
}
class _PointAreaState extends State<PointArea> {
  CourseProvider courseProvider;
  ///格子高度
  double gridHeight;
  double gridWidth;
  List<CourseData> dl;
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    courseProvider = Provider.of<CourseProvider>(context);
    debugPrint("build PointArea");
    _init(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: _buildColumn(),
    );
  }



  void _init(BuildContext context){
    debugPrint("PointInit");
    this.gridHeight = MediaQuery.of(context).size.height/13.0;
    this.gridWidth = gridHeight*0.618;
    this.themeData = Theme.of(context);
  }
  void handleCurWeekChange(int week){
    courseProvider.changeWeek(week);
    pageController.jumpToPage(week-1,);
  }
  Widget _buildColumn(){
    final List<Widget> col = [];
    for(int i = 1;i<=22;i++){
      col.add(_buildButtons(i));
    }
    return Column(
      children: col,
    );
  }
  Widget _buildButtons(int week){
    return InkWell(
      onTap: () => handleCurWeekChange(week),
      child: Container(
        width: gridWidth,
        height: gridHeight,
        child: FlyWidgetBuilder(
          whenFirst: week == CourseProvider.curWeek,
          firstChild: _buildCurWeekCard(week),
          secondChild: _buildWeekCard(week),
        ),
      ),
    );
  }
  Widget _buildCurWeekCard(int week){
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("第",style: TextStyle(fontSize: gridHeight*0.15),),
              Text("$week",style: TextStyle(fontSize: gridHeight*0.21),),
              Text("周",style: TextStyle(fontSize: gridHeight*0.15),)
            ],
          ),
          _buildPoints(week)
        ],
      ),
    );
  }
  Widget _buildWeekCard(int week){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("第",style: TextStyle(fontSize: gridHeight*0.15),),
            Text("$week",style: TextStyle(fontSize: gridHeight*0.21),),
            Text("周",style: TextStyle(fontSize: gridHeight*0.15),)
          ],
        ),
        _buildPoints(week)
      ],
    );
  }
  Widget _buildPoints(int week) {
    List pointArray = courseProvider.getPointArray[week];
    //一个点
    Widget singlePoint(int light) {
      return Container(
        width: gridWidth / 9,
        height: gridWidth / 9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: light > 0
                ? colorMain.withOpacity(0.8)
                : themeData.unselectedWidgetColor),
      );
    }
    return Container(
      height: gridWidth * 0.9,
      width: gridWidth * 0.9,
      padding: EdgeInsets.all(gridWidth * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for(int i = 1;i<=5;i++)
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[for(int j = 1;j<=5;j++)singlePoint(pointArray[i][j])],
                ),
                SizedBox(
                  height: gridWidth / 100,
                )
              ],
            )
        ],
      ),
    );
  }

}