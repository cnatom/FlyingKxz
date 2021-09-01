//主页
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';
import 'components/add_components/course_add_view.dart';
import 'components/course_table_child.dart';
import 'components/output_ics/output_ics_page.dart';
import 'components/point_components/point_main.dart';
import 'components/back_curWeek.dart';
import 'package:flying_kxz/FlyingUiKit/my_bottom_sheet.dart';
import 'utils/course_provider.dart';
class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}
class CoursePageState extends State<CoursePage> {

  CourseProvider courseProvider;
  ThemeProvider themeProvider;
  GlobalKey<PointMainState> _rightGlobalKey = new GlobalKey<PointMainState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static PageController coursePageController;


  @override
  void initState() {
    super.initState();
  }
  outputIcs(){
    // addCalendar(courseProvider.infoByCourse, DateTime(2021,9,1));
    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>OutputIcsPage(courseProvider.infoByCourse)));
  }
  _importCourse()async{
    var html = await Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ImportPage()));
    courseProvider.handleHtml(html);

  }
  _backToCurWeek(){
    coursePageController.animateToPage(courseProvider.initialWeek-1, curve: Curves.easeOutQuint, duration: Duration(seconds: 1),);
  }
  _addCourse()async{
    List<CourseData> newCourseDataList;
    newCourseDataList = await showFlyModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      builder: (BuildContext context) {
        return CourseAddView();
      },
    );
    if(newCourseDataList==null)return;
    for(var newCourseData in newCourseDataList){
      courseProvider.add(newCourseData);
    }
    setState(() {

    });
    sendInfo('主页', '添加了课程：${newCourseDataList[0].title}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CourseProvider()),
      ],
      builder: (context,_){
        courseProvider = Provider.of<CourseProvider>(context);
        themeProvider = Provider.of<ThemeProvider>(context);
        coursePageController = PageController(initialPage: courseProvider.curWeek-1,);
        return Scaffold(

          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTop(),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildLeft(),),
                              Expanded(child: _buildBody(), flex: 8,)
                            ],
                          ),
                        ),
                        SizedBox(height: fontSizeTip33 / 5,),
                      ],
                    ),
                  ),
                  PointMain(key: _rightGlobalKey,)
                ],
              ),
              BackCurWeekButton(
                themeProvider: themeProvider,
                onTap: ()=>_backToCurWeek(),
                show: courseProvider.curWeek!=courseProvider.initialWeek,
              )
            ],
          ),
        );
      },
    );
  }
  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      brightness: themeProvider.simpleMode?Brightness.light:Brightness.dark,
      title: FlyText.title45('第${courseProvider.curWeek}周',
          fontWeight: FontWeight.w600, color: themeProvider.colorNavText),
      leading: _buildAction(Icons.cloud_download_outlined,onPressed: ()=>_importCourse()),
      actions: [
        _buildAction(Icons.add,onPressed: ()=>_addCourse()),
        _buildAction(Boxicons.bx_share_alt,onPressed: ()=>outputIcs()),
        _buildAction(Boxicons.bx_menu_alt_right,onPressed: ()=>_rightGlobalKey.currentState.show()),
      ],
    );
  }

  Widget _buildAction(IconData iconData, {VoidCallback onPressed}){
    return IconButton(
      icon: Icon(
        iconData,
        color: themeProvider.colorNavText,
      ),
      onPressed: onPressed,
    );
  }
  Widget _buildShowRightButton(){
    return  IconButton(
      icon: Icon(
        Boxicons.bx_menu_alt_right,
        color: themeProvider.colorNavText,
      ),
      onPressed: () {
        _rightGlobalKey.currentState.show();

      },
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
        Expanded(
          flex: 8,
          child: Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: FlyWidgetBuilder(
                      whenFirst: _isToday(subDates[i]),
                      firstChild: _buildTopTodayItem(weeks[i], subDates[i]),
                      secondChild: _buildTopItem(weeks[i], subDates[i])),
                ),
            ],
          ),
        )],
    );
  }

  Widget _buildTopTodayItem(String week, DateTime subDate) {
    return Container(
      decoration: BoxDecoration(
          color: themeProvider.colorMain.withOpacity(0.1),
          border: Border(
              top: BorderSide(
                  width: 5,
                  color: themeProvider.colorMain
              )
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyText.mini30(
            week,color: themeProvider.colorNavText,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}",color: themeProvider.colorNavText,)
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
            week,color: themeProvider.colorNavText,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}",color: themeProvider.colorNavText,)
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
            FlyText.mini30(num,color: themeProvider.colorNavText),
            SizedBox(height: 3,),
            for(int i = 0;i<subTimeList.length;i++)
              FlyText.mini25(subTimeList[i]+(i!=0?'\n':''),color: themeProvider.colorNavText)
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
          color: themeProvider.colorMain.withOpacity(0.1),
          border: Border(
            left: BorderSide(
              width: 5,//宽度
              color: themeProvider.colorMain, //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.mini30(num,color: themeProvider.colorNavText),
            SizedBox(height: 3,),
            for(int i = 0;i<subTimeList.length;i++)
              FlyText.mini25(subTimeList[i]+(i!=0?'\n':''),color: themeProvider.colorNavText)
          ],
        ),
      );
    });
  }

  Widget _buildBody() {
    return courseProvider.info==null?Container():LayoutBuilder(
      builder: (context, parSize) {
        List<Widget> children = [];
        double height = parSize.maxHeight;
        double width = parSize.maxWidth;
        for(int i = 1;i<=22;i++){
          children.add(new CourseTableChild(courseProvider.info[i], width, height));
        }

        return PageView(
          physics: BouncingScrollPhysics(),
          controller: coursePageController,
          onPageChanged: (value){
            courseProvider.changeWeek(value+1);
          },
          scrollDirection: Axis.vertical,
          children: children,
        );
      },
    );
  }
  @override
  bool get wantKeepAlive => true;
}



