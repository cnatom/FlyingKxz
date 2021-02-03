import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

import 'course_table_child.dart';
PageController pageController = new PageController(initialPage: CourseProvider.curWeek-1);
class CourseTable extends StatefulWidget {
  @override
  _CourseTableState createState() => _CourseTableState();
}
class _CourseTableState extends State<CourseTable> {
  CourseProvider courseProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    courseProvider = Provider.of<CourseProvider>(context);
    return FlyWidgetBuilder(
      whenFirst: CourseProvider.info==null,
      firstChild: Container(),
      secondChild: Column(
        children: [
          _buildTop(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildLeft(),),
                Expanded(child: _buildBody(), flex: 7,)
              ],
            ),
          )
        ],
      ),
    );
  }
  bool _isToday(DateTime dateTime) {
    var todayDate = DateTime.now();
    if (todayDate.day == dateTime.day && todayDate.month == dateTime.month) {
      return true;
    } else {
      return false;
    }
  }

  //顶部 周次+日期
  Widget _buildTop() {
    var mondayDate = courseProvider.getCurMondayDate;
    final weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日',];
    List<DateTime> subDates = [];
    for (int i = 0; i < 7; i++) {
      subDates.add(mondayDate.add(Duration(days: i)));
    }
    return Row(
      children: [
        Expanded(
          child: Container(),
        ),
        for (int i = 0; i < 7; i++)
          Expanded(
            child: FlyWidgetBuilder(
                whenFirst: _isToday(subDates[i]),
                firstChild: _buildTopTodayItem(weeks[i], subDates[i]),
                secondChild: _buildTopItem(weeks[i], subDates[i])),
          ),

      ],
    );
  }

  Widget _buildTopTodayItem(String week, DateTime subDate) {
    return Container(
      decoration: BoxDecoration(
        color: colorMain.withOpacity(0.1),
        border: Border(
          top: BorderSide(
            width: 5,
            color: colorMain
          )
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyText.mini30(
            week,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}",)
        ],
      ),
    );
  }

  Widget _buildTopItem(String week, DateTime subDate) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 5,
                  color: Colors.transparent
              )
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyText.mini30(
            week,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}")
        ],
      ),
    );
  }

  //左侧 节次+时间段
  Widget _buildLeft() {
    var lessonTimes = [
      ["08:00","08:50",],
      ["08:55","09:45"],
      ["10:15","11:05"],
      ["11:10","12:00"],
      ["14:00","14:50"],
      ["14:55","15:45"],
      ["16:15","17:05"],
      ["17:10","18:00"],
      ["19:00","19:50"],
      ["19:55","20:45"],
    ];
    DateTime _formatTime(String timeStr){
      //"08:00" -> DateTime
      DateTime result;
      DateTime now = courseProvider.getCurMondayDate.add(Duration(days: DateTime.now().weekday-1));
      result = DateTime(now.year,now.month,now.day,int.parse(timeStr.substring(0,2)),int.parse(timeStr.substring(3)));
      return result;
    }
    bool _isNow(List<String> times) {
      var now = DateTime.now();
      var firstTime = _formatTime(times[0]);
      var secondTime = _formatTime(times[1]);
      if(now.isAfter(firstTime)&&now.isBefore(secondTime)) return true;
      return false;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        for(int i = 0; i < lessonTimes.length; i++)
          Expanded(
            child: FlyWidgetBuilder(
              whenFirst: _isNow(lessonTimes[i]),
              firstChild: _buildLeftNowItem("${i + 1}", lessonTimes[i]),
              secondChild: _buildLeftItem("${i + 1}", lessonTimes[i]) ,
            ),
          ),
      ],
    );
  }

  Widget _buildLeftItem(String num, List<String> subTimeList) {
    return LayoutBuilder(builder: (context, parSize) {
      double height = parSize.maxHeight;
      return Container(
        width: parSize.maxWidth,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 5,//宽度
              color: Colors.transparent, //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              num,
              style: TextStyle(fontSize: height * 0.22),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14),
            )
          ],
        ),
      );
    });
  }
  Widget _buildLeftNowItem(String num, List subTimeList) {
    return LayoutBuilder(builder: (context, parSize) {
      double height = parSize.maxHeight;
      return Container(
        width: parSize.maxWidth,
        decoration: BoxDecoration(
          color: colorMain.withOpacity(0.1),
          border: Border(
            left: BorderSide(
              width: 5,//宽度
              color: colorMain, //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              num,
              style: TextStyle(fontSize: height * 0.22,),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14),
            )
          ],
        ),
      );
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: LayoutBuilder(
        builder: (context, parSize) {
          List<Widget> children = [];
          double height = parSize.maxHeight;
          double width = parSize.maxWidth;
          for(int i = 1;i<=22;i++){
            children.add(new CourseTableChild(CourseProvider.info[i], width, height));
          }
          return PageView(
            controller: pageController,
            onPageChanged: (value)=>courseProvider.changeWeek(value+1),
            scrollDirection: Axis.vertical,
            children: children,
          );
        },
      ),
    );
  }



}
