//主页
import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';
import 'components/add_components/course_add_view.dart';
import 'components/course_table_child.dart';
import 'components/point_components/point_main.dart';
import 'components/back_curWeek.dart';

PageController coursePageController = new PageController(initialPage: CourseProvider.curWeek-1,);
class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}
class CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin {
  CourseProvider courseProvider;
  ThemeProvider themeProvider;
  GlobalKey<PointMainState> _rightGlobalKey = new GlobalKey<PointMainState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CourseProvider()),
      ],
      builder: (context,_){
        courseProvider = Provider.of<CourseProvider>(context);
        themeProvider = Provider.of<ThemeProvider>(context);
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
                show: CourseProvider.curWeek!=CourseProvider.initialWeek,
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
      title: FlyText.title45('第${CourseProvider.curWeek}周',
          fontWeight: FontWeight.w600, color: themeProvider.colorNavText),
      leading: _buildCourseImportView(),
      actions: [
        _buildRefreshButton(),
        _buildAddButton(),
        _buildShowRightButton(),
        IconButton(
          icon: Icon(CommunityMaterialIcons.calendar_import),
          onPressed: ()=>_importCourse(),
          color: themeProvider.colorNavText,)
      ],
    );
  }
  //导入课表
  Widget _buildCourseImportView(){
    return IconButton(
      icon: Icon(Icons.cloud_download_outlined),
      onPressed: ()=>_importCourse(),
      color: themeProvider.colorNavText,);
  }
  _importCourse()async{
    showPicker(context, _scaffoldKey,
        title: "导入课表",
        pickerDatas: PickerData.xqxnPickerData,
        onConfirm: (Picker picker, List value) {
      String yearStr = picker.getSelectedValues()[0].toString().substring(0, 4);
      String termStr = '${value[1] + 1}';
      courseProvider.get(Prefs.token,yearStr , termStr);
        });

  }
  _backToCurWeek(){
    courseProvider.changeWeek(CourseProvider.initialWeek);
    coursePageController.jumpToPage(CourseProvider.initialWeek-1,);
    _rightGlobalKey.currentState.initScroll();
  }
  Widget _buildRefreshButton(){
    return FlyWidgetBuilder(
        whenFirst: CourseProvider.curWeek!=CourseProvider.initialWeek,
        firstChild: IconButton(
          icon: Icon(
            EvilIcons.refresh,
            color: themeProvider.colorNavText,
          ),
          onPressed: ()=>_backToCurWeek(),
        ),
        secondChild: Container());
  }
  Widget _buildAddButton(){
    return IconButton(
      icon: Icon(
        Icons.add,
        color: themeProvider.colorNavText,
      ),
      onPressed: ()=>_addCourse(),
    );
  }
  _addCourse()async{
    List newCourseDataList;
    newCourseDataList = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
        )

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
            Text(
              num,
              style: TextStyle(fontSize: height * 0.22,color: themeProvider.colorNavText),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14,color: themeProvider.colorNavText),
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
              style: TextStyle(fontSize: height * 0.22,color: themeProvider.colorNavText),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14,color: themeProvider.colorNavText),
            )
          ],
        ),
      );
    });
  }

  Widget _buildBody() {
    return FlyWidgetBuilder(
      whenFirst: CourseProvider.loading,
      firstChild: Center(child: loadingAnimationTwoCircles(),),
      secondChild: Padding(
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
              physics: BouncingScrollPhysics(),
              controller: coursePageController,
              onPageChanged: (value)=>courseProvider.changeWeek(value+1),
              scrollDirection: Axis.vertical,
              children: children,
            );
          },
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}



