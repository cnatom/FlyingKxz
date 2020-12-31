//主页
import 'dart:convert';

import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/course_get.dart';
import 'package:flying_kxz/Model/course_info.dart';
import 'package:flying_kxz/pages/navigator_page_child/home_page_child/test_view.dart';

import 'myself_page_child/cumtLogin_view.dart';

class CourseData {
  List weeks;//在几周有课 [1,2,3,4]代表1-4周都有课
  String weeksStr;//周次的Str 如："1-4周,6-10周"
  String creditScore;//学分
  String type;//课程类别 如:"★"
  int weekDay; //周几
  int lessonNum; //第几节课
  double duration; //持续时间
  String courseName; //课程名
  String location; //上课地点
  String teacher; //教师姓名
  String lessonFromToWhen;//1-2节 只展示给重叠课程卡片
  CourseData(this.weeks,this.weekDay, this.lessonNum,
      {this.duration = 2.0, this.courseName, this.location, this.teacher,this.weeksStr,this.creditScore,this.type,this.lessonFromToWhen});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var openDate = DateTime.parse('2020-09-07'); //开学日期

var difference = Global.nowDate.difference(openDate); //当前-开学日期天数
var currentWeek = difference.inDays ~/ 7;
var selectedWeek = currentWeek; //当前选中周
DateTime mondayDate = openDate.add(Duration(days: 7 * currentWeek)); //当前周的周一
Map<String, Color> colorCourse = new Map<String, Color>(); //课程的颜色
List<Color> colorExpand = new List<Color>(); //课程的颜色
Color colorSelectWeekCard = Colors.black12.withAlpha(15);
var point = new List();//右侧矩阵点数据
List<CourseData> courseDataList = List();

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var crossFadeState = CrossFadeState.showSecond;
  ScrollController scrollController = new ScrollController(initialScrollOffset: (ScreenUtil().setWidth(deviceWidth/10)+fontSizeMain40)*(selectedWeek),keepScrollOffset: true);
  Color greyMask = Colors.transparent;
  double mMaxScrollExtent = (1.4*ScreenUtil().setWidth(deviceWidth/9)+fontSizeMain40)*22;//最大滑动像素距离
  bool loading = false;//是否显示加载动画
  List<Widget> repeatCards = new List();//用来存放重叠卡片Widget

  List<String> lessonWeekList = [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];
  List<String> lessonTimeList = [
    "08:00\n08:50",
    "08:55\n09:45",
    "10:15\n11:05",
    "11:10\n12:00",
    "14:00\n14:50",
    "14:55\n15:45",
    "16:15\n17:05",
    "17:10\n18:00",
    "19:00\n19:50",
    "19:55\n20:45",

  ];
  Widget baseTable({Color color}) => Expanded(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: color, width: 0.5))),
        ),
      );

  //用于周次转换
  //"5周"->[5]    "5-12周(单)"->[5, 7, 9, 11]   "13-18周(双)"->[14, 16, 18]   "11-14周"->[11, 12, 13, 14]
  List strWeekToList(String week) {
    List weekList = new List();
    if (week.contains("单")) {
      week = week.replaceAll("周(单)", "");
      List temp = week.split('-');
      int i =
      int.parse(temp[0]).isOdd ? int.parse(temp[0]) : int.parse(temp[0]) + 1;
      int j = int.parse(temp[1]);
      for (; i <= j; i += 2) weekList.add(i);
    } else if (week.contains("双")) {
      week = week.replaceAll("周(双)", "");
      List temp = week.split('-');
      int i =
      int.parse(temp[0]).isEven ? int.parse(temp[0]) : int.parse(temp[0]) + 1;
      int j = int.parse(temp[1]);
      for (; i <= j; i += 2) weekList.add(i);
    } else {
      week = week.replaceAll("周", "");
      List temp = week.split('-');
      if (temp.length != 1) {
        int i = int.parse(temp[0]);
        int j = int.parse(temp[1]);
        for (; i <= j; i++) weekList.add(i);
      } else {
        weekList.add(int.parse(temp[0]));
      }
    }
    return weekList;
  }

  //根据Global.kbInfo的数据构建课表卡片
  void showCourseCards(){
    int colorIndex = 0;
    for (var item in Global.courseInfo.data.kbList) {
      //当前课程第几周上
      var courseWeek = item.zcd.split(',');
      for (var week in courseWeek) {
        //将"5-12周(单)" 转为 [5, 7, 9, 11]
        List weeks = strWeekToList(week);
        //存储课程信息
        int weekDay = int.parse(item.xqj); //周几上课
        int lessonNum = int.parse(item.jcs.split('-')[0]); //第几节
        double lessonDuration = double.parse(item.jcs.split('-')[1]) -
            double.parse(item.jcs.split('-')[0]) +
            1; //持续多少节
        //设置点阵数据
        for(var week in weeks){
          point[week-1][lessonNum~/2][weekDay-1]++;
        }
        //添加课程卡片信息
        courseDataList.add(new CourseData(
            weeks, weekDay, lessonNum,
            duration: lessonDuration,
            courseName: item.kcmc,
            teacher: item.xm,
            location: item.cdmc,
            weeksStr: item.zcd,
            type: item.xslxbj,
            creditScore: item.xf,
            lessonFromToWhen: item.jc));
      }
      //设置课程卡片颜色
      if (colorIndex > colorLessonCard.length - 1) {
        colorIndex = 0;
      }
      colorCourse[item.kcmc] = colorCourse[item.kcmc] == null
          ? colorLessonCard[colorIndex++]
          : colorCourse[item.kcmc];
    }
    setState(() {});
  }

  getShowCourseData({@required String xnm,@required String xqm})async{
    setState(() {loading = true;});//显示加载
    courseDataList.clear();//清除课表卡片信息列表
    colorExpand.clear();//清除右侧按钮被点击效果
    point.clear();
    for (int i = 0; i <= 21; i++) {
      colorExpand.add(Colors.transparent);
      point.add([
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
      ]);
    }
    await courseGet(context, Global.prefs.getString(Global.prefsStr.token),xnm: xnm,xqm: xqm);
    setState(() {loading = false;});//停止加载
    showCourseCards();
  }


  void setWeek({@required int mCurrentWeek}) {
    selectedWeek = mCurrentWeek;
    mondayDate = openDate.add(Duration(days: 7 * selectedWeek));//顶部周一日期
    colorExpand.fillRange(0, colorExpand.length,Colors.transparent);//全部为透明
    colorExpand[mCurrentWeek] = colorSelectWeekCard;//为选中卡片填充背景
    setState(() {
    });
  }
  //调整右侧滚动条位置
  void setRightScrollPosition({int toWeek}){
    double aimPosition = (ScreenUtil().setWidth(deviceWidth/10)+fontSizeMain40)*(toWeek-1);
    if(aimPosition>mMaxScrollExtent){
      scrollController.jumpTo(mMaxScrollExtent);
      return;
    }
    scrollController.jumpTo(aimPosition);
  }

  //单个点阵组件
  Widget pointWidget({@required List pointList,@required double width}) {
    //右侧单个点阵只取5*5的布局
    List pointList_temp = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ];
    for(int i = 0;i<5;i++){
      for(int j = 0;j<5;j++){
        pointList_temp[j][i] = pointList[j][i];
      }
    }
    //一个点
    Widget singlePoint(int light) {
      return Container(
        width: width / 9,
        height: width / 9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: light > 0 ? colorMain : Colors.black12),
      );
    }
    //点阵
    return Container(
      height: width * 0.9,
      width: width * 0.9,
      padding: EdgeInsets.all(width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: pointList_temp.map((item){
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  singlePoint(item[0]),
                  singlePoint(item[1]),
                  singlePoint(item[2]),
                  singlePoint(item[3]),
                  singlePoint(item[4]),
                ],
              ),
              SizedBox(
                height: width / 100,
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget pointArea() {
    double width = ScreenUtil().setWidth(deviceWidth/10);
    int curWeek = 0;
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: point.map((item){
          int curWeek_temp = curWeek++;
          return Container(
            margin: EdgeInsets.fromLTRB(width/10, 0, width/10, width/20),
            child: Material(
              color: colorExpand[curWeek_temp],
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                highlightColor: colorSelectWeekCard,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                onTap: ()=>setWeek(mCurrentWeek: curWeek_temp),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, width / 6, 0, width / 6),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlyTextTipMini25("第", color: colorMainText),
                          FlyTextMain40((curWeek_temp+1).toString(),color: colorMainText),
                          FlyTextTipMini25("周", color: colorMainText),
                        ],
                      ),
                      pointWidget(width: width,pointList: item)
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //初始化点矩阵数据
    colorExpand.clear();
    point.clear();
    for (int i = 0; i <= 21; i++) {
      colorExpand.add(Colors.transparent);
      point.add([
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
      ]);
    }
    //初始化选中色彩
    colorExpand[selectedWeek] = colorSelectWeekCard;
    if(Global.prefs.getString(Global.prefsStr.courseDataLoc)!=null){
      //有查询历史则直接展示
      Global.courseInfo = CourseInfo.fromJson(jsonDecode(Global.prefs.getString(Global.prefsStr.courseDataLoc)));
      showCourseCards();
    }else if(Global.prefs.getBool(Global.prefsStr.isFirstLogin)){
      //刚登录则自动获取课表
      getShowCourseData(xnm: Global.prefs.getString(Global.prefsStr.schoolYear), xqm: Global.prefs.getString(Global.prefsStr.schoolTerm));
      Global.prefs.setBool(Global.prefsStr.isFirstLogin, false);
    }else{
      setState(() {
      });
    }

  }
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    int lessonWeekListIndex = 1; //左侧课程序列号
    int mondayDuration = -1;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: FlatButton(
          child: Text("Test"),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TestPage()));
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: FlyTextTitle45('第${(selectedWeek+1).toString()}周',
            fontWeight: FontWeight.w600,color: colorMainTextWhite),
        centerTitle: true,
        actions: <Widget>[
          selectedWeek==currentWeek?Container():IconButton(
            icon: Icon(EvilIcons.refresh,color: colorMainTextWhite,),
            onPressed: (){
              setWeek(mCurrentWeek: currentWeek);
              setRightScrollPosition(toWeek: selectedWeek+1);
            },
          ),
          IconButton(
            icon: Icon(Icons.add,color: colorMainTextWhite,),
            onPressed: (){
              showPicker(context, _scaffoldKey,
                  pickerDatas: Global.xqxnPickerData,
                  onConfirm: (Picker picker, List value) {
                    getShowCourseData(xnm: picker.getSelectedValues()[0].toString().substring(0,4), xqm: '${value[1]+1}');
                  });
            },
          ),
          IconButton(
            icon: Icon(
              Boxicons.bx_menu_alt_right,
              color: colorMainTextWhite,
            ),
            onPressed: () {
              setState(() {
                crossFadeState = crossFadeState == CrossFadeState.showFirst
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst;
                if(scrollController.position.maxScrollExtent>0){
                  mMaxScrollExtent = scrollController.position.maxScrollExtent;
                }
                setRightScrollPosition(toWeek: selectedWeek+1);
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, fontSizeMini38/2, fontSizeMini38/10, fontSizeMini38/3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(transparentValue*0.8),
        ),
        child: Row(
          children: <Widget>[
            //左侧课表区域
            Expanded(
              child: Column(
                children: <Widget>[
                  //顶部(周一，周二，周三……)
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: FlyTextTip30(mondayDate
                                      .add(Duration(days: mondayDuration)).month.toString(),color: colorMainText.withAlpha(200),)
                              ),
                              SizedBox(
                                height: fontSizeMini38 / 3,
                              ),
                              Center(
                                child: FlyTextTipMini25(
                                  '月',color:colorMainText.withAlpha(200),),
                              ),
                              SizedBox(height: fontSizeTip33/5,)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: lessonWeekList.map((item) {
                            mondayDuration++;
                            var addedDate = mondayDate
                                .add(Duration(days: mondayDuration));
                            var mondayMonth = addedDate.month;
                            var mondayDay = addedDate.day;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, fontSizeTip33/5),
                                child: addedDate.month==Global.nowDate.month&&addedDate.day==Global.nowDate.day?Container(
                                  decoration: BoxDecoration(
                                      color: colorMain.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(2)
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                          child: FlyTextTip30(item,color: colorMainTextWhite,)
                                      ),
                                      SizedBox(
                                        height: fontSizeMini38 / 3,
                                      ),
                                      Center(
                                        child: FlyTextTipMini25(
                                          '${mondayMonth}/${mondayDay}',color:colorMainTextWhite,),
                                      )
                                    ],
                                  ),
                                ):Column(
                                  children: <Widget>[
                                    Center(
                                        child: FlyTextTip30(item,color: colorMainText)
                                    ),
                                    SizedBox(
                                      height: fontSizeMini38 / 3,
                                    ),
                                    Center(
                                      child: FlyTextTipMini25(
                                          '${mondayMonth}/${mondayDay}',color: colorMainText),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  //课表部分
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        //左侧 节数+时间表
                        Expanded(
                          child: Column(
                            children: lessonTimeList.map((item) {
                              return Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text((lessonWeekListIndex++)
                                        .toString(),style: TextStyle(fontSize: ScreenUtil().setHeight(deviceHeight/60),color: colorMainText),),
                                    Text(item,style: TextStyle(fontSize: ScreenUtil().setHeight(deviceHeight/90),color: colorMainText.withOpacity(0.8)),),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        //中间课程卡片排列区域
                        Expanded(
                          flex: 8,
                          child: Container(
                            child: LayoutBuilder(
                              builder: (context, parSize) {
                                double heightCard = parSize.maxHeight / 10;
                                double widthCard = parSize.maxWidth / 7;
                                //详细信息卡片
                                Widget dialogKbWidget({
                                  @required String courseName,//课程名称
                                  @required String type,//课程类型
                                  @required String location,//教室
                                  @required String teacher,//教室姓名
                                  @required String weeksStr,//周数
                                  String lessonFromToWhen,//1-2节
                                  @required String credicScore,//学分
                                  Color color = Colors.green
                                }){
                                  Widget rowKbContent(String title,String content){
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        FlyTextMini35("$title     ", color: colorMainText.withAlpha(150)),
                                        FlyTextMini35(content, color: colorMainText,maxLine: 3)
                                      ],
                                    );
                                  }
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(fontSizeMini38*2, fontSizeMini38*1.5, fontSizeMini38*2, fontSizeMini38),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(borderRadiusValue),
                                        color: Colors.white.withAlpha(255)
                                    ),
                                    child: Wrap(
                                      children: [
                                        Row(
                                          children: [
                                            Container(height: fontSizeTitle45,width: fontSizeTitle45/5,color: color,),
                                            SizedBox(width: fontSizeTitle45*0.6,),
                                            Expanded(
                                              child: FlyTextTitle45(courseName + " " + type,maxLine: 3,),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(fontSizeTitle45*0.8),
                                          child: Wrap(
                                            runSpacing : fontSizeMini38/2,
                                            children: [
                                              rowKbContent('地点',location),
                                              rowKbContent('老师',teacher),
                                              rowKbContent('学分',credicScore),
                                              rowKbContent('周次',weeksStr),
                                              lessonFromToWhen==null?Container():rowKbContent('节次',lessonFromToWhen),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                  );
                                }
                                Widget lessonSingleCard(
                                    {@required int weekDay,
                                      @required int lesson,
                                      @required String courseName,
                                      @required String courseLoc,
                                      @required String teacherName,
                                      GestureTapCallback onTap,
                                      Color color = Colors.black12,
                                      double duration = 2}) {
                                  return Positioned(
                                    top: heightCard * (lesson - 1),
                                    left: widthCard * (weekDay - 1),
                                    child: InkWell(
                                      onTap: onTap,
                                      child:Container(
                                        height: heightCard * duration,
                                        width: widthCard,
                                        padding:
                                        EdgeInsets.all(widthCard / 40),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              widthCard / 35),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color: color.withOpacity(0.95)),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(courseName,style: TextStyle(fontSize: ScreenUtil().setSp(33),color:Colors.white),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                              SizedBox(height: ScreenUtil().setSp(10),),
                                              Text(courseLoc,style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Colors.white),textAlign: TextAlign.center,)
//                                                    FlyTextTipMini25(teacherName,
//                                                        color: color,maxLine: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                Widget lessonMultiCard(
                                    {
                                      @required int week,
                                      @required int weekDay,
                                      @required int lesson,
                                      GestureTapCallback onTap,
                                      Color color = Colors.blueGrey,
                                      double duration = 2}) {
                                  return Positioned(
                                    top: heightCard * (lesson - 1),
                                    left: widthCard * (weekDay - 1),
                                    child: InkWell(
                                      onTap: (){
                                        //寻找重复课程的课程数据
                                        if(repeatCards.isNotEmpty)repeatCards.clear();
                                        for(int i = 0;i<courseDataList.length;i++){
                                          if(courseDataList[i].weekDay==weekDay&&courseDataList[i].lessonNum==lesson&&courseDataList[i].weeks.contains(week+1)){
                                            repeatCards.add(dialogKbWidget(
                                                courseName: courseDataList[i].courseName,
                                                type: courseDataList[i].type,
                                                location: courseDataList[i].location,
                                                teacher: courseDataList[i].teacher,
                                                weeksStr: courseDataList[i].weeksStr,
                                                credicScore: courseDataList[i].creditScore,
                                                color:colorCourse[
                                                courseDataList[i].courseName],
                                                lessonFromToWhen: courseDataList[i].lessonFromToWhen
                                            ));
                                          }
                                        }

                                        showFlyDialog(context, child: Wrap(
                                          runSpacing:fontSizeMini38,
                                          children: repeatCards,
                                        ));
                                        //遍历查找重叠的课程

                                      },
                                      child:Container(
                                        height: heightCard * duration,
                                        width: widthCard,
                                        padding:
                                        EdgeInsets.all(widthCard / 30),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              widthCard / 30),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2),
                                              color: color.withAlpha(30)),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlyTextTipMini25("重叠课程", color: color, fontWeight: FontWeight.w600,maxLine: 3),
                                              FlyTextTipMini25("查看详情",
                                                  color: color,maxLine: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return loading?Center(
                                  child: loadingAnimationTwoCircles(),
                                ):Stack(
                                  children: <Widget>[
                                    //底线
                                    Column(
                                      children: <Widget>[for(int i = 0;i<10;i++)baseTable(color: i.isOdd?Colors.black26.withAlpha(10):Colors.transparent),],
                                    ),
                                    Stack(
                                      children: courseDataList == null
                                          ? [Container()]
                                          : courseDataList.map((item) {
                                        if (item.weeks.contains(selectedWeek+1)) {
                                          //如果课程有重叠
                                          if(point[selectedWeek][item.lessonNum~/2][item.weekDay-1]>1){
                                            return lessonMultiCard(
                                              week:selectedWeek,
                                              weekDay: item.weekDay,
                                              lesson:
                                              item.lessonNum,
                                            );
                                          }
                                          //无重叠时
                                          return lessonSingleCard(
                                              weekDay: item.weekDay,
                                              lesson:
                                              item.lessonNum,
                                              duration:
                                              item.duration,
                                              color: colorCourse[
                                              item.courseName],
                                              courseName:
                                              item.courseName,
                                              courseLoc:
                                              item.location,
                                              teacherName:
                                              item.teacher,
                                              onTap:(){
                                                showFlyDialog(context, child: dialogKbWidget(
                                                    courseName: item.courseName,
                                                    type: item.type,
                                                    location: item.location,
                                                    teacher: item.teacher,
                                                    weeksStr: item.weeksStr,
                                                    credicScore: item.creditScore,
                                                    color:colorCourse[
                                                    item.courseName]
                                                ));
                                              });
                                        } else {
                                          return Container();
                                        }
                                      }).toList(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
            AnimatedCrossFade(
              firstCurve: Curves.easeOutCubic,
              secondCurve: Curves.easeOutCubic,
              sizeCurve: Curves.easeOutCubic,
              firstChild: pointArea(),
              secondChild: Container(),
              duration: Duration(milliseconds: 200),
              crossFadeState: crossFadeState,
            ),
          ],
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}


