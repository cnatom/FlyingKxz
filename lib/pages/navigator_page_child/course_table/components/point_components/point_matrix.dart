
//单个点阵组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

import '../../course_page.dart';

class PointMatrix extends StatefulWidget {
  final BuildContext context;
  PointMatrix({Key key, this.context}):super(key: key);
  @override
  PointMatrixState createState() => PointMatrixState();

}
class PointMatrixState extends State<PointMatrix> {
  CourseProvider courseProvider;
  ThemeProvider themeProvider;
  ScrollController scrollController = new ScrollController();
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
    themeProvider = Provider.of<ThemeProvider>(context);
    _init(context);
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: _buildColumn(),
    );
  }

  void changeWeekOffset(int week){
    var aimPosition = gridHeight*(week-1);
    var mMaxScrollExtent = gridHeight*22;
    debugPrint("$aimPosition  $mMaxScrollExtent ${scrollController.position.extentInside}");
    if (aimPosition > mMaxScrollExtent) {
      scrollController.jumpTo(mMaxScrollExtent);
      return;
    }
    scrollController.jumpTo(aimPosition);
  }

  void _init(BuildContext context){
    this.gridHeight = MediaQuery.of(context).size.height/13.0;
    this.gridWidth = gridHeight*0.618;
    this.themeData = Theme.of(context);
  }
  void handleCurWeekChange(int week){
    courseProvider.changeWeek(week);
    coursePageController.jumpToPage(week-1,);
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
        color: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("第",style: TextStyle(fontSize: gridHeight*0.15,color: themeProvider.colorNavText),),
              Text("$week",style: TextStyle(fontSize: gridHeight*0.21,color: themeProvider.colorNavText),),
              Text("周",style: TextStyle(fontSize: gridHeight*0.15,color: themeProvider.colorNavText),)
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
            Text("第",style: TextStyle(fontSize: gridHeight*0.15,color: themeProvider.colorNavText),),
            Text("$week",style: TextStyle(fontSize: gridHeight*0.21,color: themeProvider.colorNavText),),
            Text("周",style: TextStyle(fontSize: gridHeight*0.15,color: themeProvider.colorNavText),)
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
                ? themeProvider.colorMain.withOpacity(0.8)
                : themeData.unselectedWidgetColor.withOpacity(0.2)),
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