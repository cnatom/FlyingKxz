
//单个点阵组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/provider.dart';
import 'package:provider/provider.dart';


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
  ScrollController scrollController;

  void _init(BuildContext context){
    this.gridHeight = MediaQuery.of(context).size.height/13.0;
    this.gridWidth = gridHeight*0.618;
    // this.dl = courseProvider.info;
    this.themeData = Theme.of(context);
    scrollController = ScrollController(
        initialScrollOffset: (CourseProvider.curWeek-1)*gridHeight,
        keepScrollOffset: true);
  }

  void _handleCurWeekChange(int week){
    setState(() {
      courseProvider.changeWeek(week);
    });
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
      onTap: () => _handleCurWeekChange(week),
      child: Container(
        width: gridWidth,
        height: gridHeight,
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
      ),
    );
  }
  Widget _buildPoints(int week) {
    //右侧单个点阵只取5*5的布局
    List pointArray = [
      [0, 0, 0, 0, 0,0],
      [0, 0, 0, 0, 0,0],
      [0, 0, 0, 0, 0,0],
      [0, 0, 0, 0, 0,0],
      [0, 0, 0, 0, 0,0],
    ];
    // for(int i = 1;i<=5;i++)
    //   for(int j = 1;j<=5;j++)
    //     if(db['$week']['$i']['$j']!=null)
    //       pointArray[i][j] = 1;
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
        children: pointArray.map((item) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[for(int i = 1;i<=5;i++)singlePoint(item[i])],
              ),
              SizedBox(
                height: gridWidth / 100,
              )
            ],
          );
        }).toList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    courseProvider = Provider.of<CourseProvider>(context);
    _init(context);
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: _buildColumn(),
    );
  }
}