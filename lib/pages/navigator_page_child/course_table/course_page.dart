//主页
import 'dart:ui';

import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/bottom_sheet.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

import 'components/course_table_child.dart';
import 'components/point_area.dart';
PageController coursePageController = new PageController(initialPage: CourseProvider.curWeek-1);
class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}
class CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin {
  CourseProvider courseProvider;
  GlobalKey<RightPointWidgetState> _rightGlobalKey = new GlobalKey<RightPointWidgetState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: CourseProvider())],
      builder: (context,_){
        courseProvider = Provider.of<CourseProvider>(context);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: Row(
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
              RightPointWidget(key: _rightGlobalKey,)
            ],
          ),
        );
      },
    );
  }
  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      brightness: Brightness.dark,
      centerTitle: true,
      title: FlyText.title45('第${CourseProvider.curWeek}周',
          fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
      leading: _buildCourseImportView(),
      actions: [
        _buildRefreshButton(),
        _buildAddButton(),
        _buildShowRightButton(),
        // IconButton(icon: Icon(Icons.build), onPressed: ()=>courseProvider.test(),color: Colors.white,),
      ],
    );
  }
  //导入课表
  Widget _buildCourseImportView(){
    return IconButton(
      icon: Icon(Icons.cloud_download_outlined),
      onPressed: ()=>_importCourse(),
      color: Colors.white,);
  }
  _importCourse()async{
    showPicker(context, _scaffoldKey,
        title: "导入课表",
        pickerDatas: Global.xqxnPickerData,
        onConfirm: (Picker picker, List value) {
      String yearStr = picker.getSelectedValues()[0].toString().substring(0, 4);
      String termStr = '${value[1] + 1}';
      courseProvider.get(Prefs.token,yearStr , termStr);
        });

  }

  Widget _buildRefreshButton(){
    return FlyWidgetBuilder(
        whenFirst: CourseProvider.curWeek!=CourseProvider.initialWeek,
        firstChild: IconButton(
          icon: Icon(
            EvilIcons.refresh,
            color: Theme.of(context).accentColor,
          ),
          onPressed: (){
            courseProvider.changeWeek(CourseProvider.initialWeek);
            coursePageController.jumpToPage(CourseProvider.initialWeek-1,);
            _rightGlobalKey.currentState.initScroll();
          },
        ),
        secondChild: Container());
  }
  Widget _buildAddButton(){
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Theme.of(context).accentColor,
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
        color: Theme.of(context).accentColor,
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
    return FlyFilterContainer(
      context,
      child: Row(
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
      )
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
            week,color: Colors.white,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}",color: Colors.white,)
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
            week,color: Colors.white,
          ),
          FlyText.mini25("${subDate.month}/${subDate.day}",color: Colors.white,)
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

    return FlyFilterContainer(
      context,child: Column(
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
    )
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
              style: TextStyle(fontSize: height * 0.22,color: Colors.white),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14,color: Colors.white),
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
              style: TextStyle(fontSize: height * 0.22,color: Colors.white),
            ),
            for(int i = 0;i<subTimeList.length;i++)Text(
              subTimeList[i]+(i!=0?'\n':''),
              style: TextStyle(fontSize: height * 0.14,color: Colors.white),
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
class RightPointWidget extends StatefulWidget {
  RightPointWidget({Key key}):super(key:key);
  @override
  RightPointWidgetState createState() => RightPointWidgetState();
}

class RightPointWidgetState extends State<RightPointWidget> {
  bool showRight = false;
  GlobalKey<PointAreaState> pointAreaKey = new GlobalKey<PointAreaState>();
  show(){
    showRight = !showRight;
    setState(() {
    });
    pointAreaKey.currentState.changeWeekOffset(CourseProvider.curWeek);
  }
  initScroll(){
    pointAreaKey.currentState.changeWeekOffset(CourseProvider.initialWeek);
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: Curves.easeOutCubic,
      secondCurve: Curves.easeOutCubic,
      sizeCurve: Curves.easeOutCubic,
      firstChild: PointArea(key:pointAreaKey),
      secondChild: Container(),
      duration: Duration(milliseconds: 200),
      crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
    );
  }
}

class CourseAddView extends StatefulWidget {
  @override
  _CourseAddViewState createState() => _CourseAddViewState();
}

class _CourseAddViewState extends State<CourseAddView> {
  //构建页面所需数据
  var titleController = new TextEditingController();
  var locationController = new TextEditingController();
  var teacherController = new TextEditingController();
  var remarkController = new TextEditingController();
  List<String> lessonStrList = ["未选择"];
  List<String> weekStrList = ["未选择"];
  //需要返回的数据
  String title;
  String location;
  String teacher;

  List<CourseData> courseDataList = [new CourseData()];
  int durationNum;
  @override
  Widget build(BuildContext context) {
    return flyBottomSheetScaffold(context,
        title: "添加课程",
        onDetermine: ()=>_onDetermine(),
        onCancel: ()=>Navigator.of(context).pop(),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: spaceCardMarginBigTB*2,
            children: <Widget>[
              inputBar('课程', titleController),
              inputBar('地点(选填)', locationController),
              inputBar('老师(选填)', teacherController),
              inputBar('备注(选填)', remarkController,maxLines: 3),
              Wrap(
                children: List.generate(lessonStrList.length, (index){
                  return  _buildPickers(index);
                },growable: true),
              ),
              Divider(),
              _buildAddSubButtons()
            ],
          ),
        )
    );
  }
  Widget _buildAddSubButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        courseDataList.length>1?IconButton(icon: Icon(Icons.remove,), onPressed: ()=>_subDate()):Container(),
        IconButton(icon: Icon(Icons.add), onPressed: ()=>_addDate()),
      ],
    );
  }
  _addDate(){
    courseDataList.add(new CourseData());
    lessonStrList.add('未选择');
    weekStrList.add('未选择');
    setState(() {

    });
  }
  _subDate(){
    courseDataList.removeLast();
    lessonStrList.removeLast();
    weekStrList.removeLast();
    setState(() {
    });
  }
  Widget _buildPickers(int index){
    return Wrap(
      runSpacing: spaceCardMarginBigTB*2,
      children: [
        Divider(height: 0,),
        Center(child: FlyText.miniTip30('No.${index+1}'),),
        _buildChooseButton("周数",weekStrList[index]??"未选择", ()=>_weekPick(index)),
        _buildChooseButton("节次", lessonStrList[index]??"未选择", ()=>_lessonPick(index)),
      ],
    );
  }
  _weekPick(int index)async{
    List<int> weekList;
    weekList = await FlyDialogDIYShow(context, content: WeekListPicker());
    if(weekList==null)return;
    courseDataList[index].weekList = weekList;
    weekStrList[index] = CourseData.weekListToString(weekList);
    setState(() {

    });
  }
  _lessonPick(int index)async{
      List result = [];
      int weekNum;
      int lessonNum;
      int durationNum;
      result = await FlyDialogDIYShow(context, content: LessonWeekNumPicker());
      if(result==null) return;
      weekNum = result[0];
      lessonNum = result[1];
      durationNum = result[2];
      setState(() {
        lessonStrList[index] = '周$weekNum  第$lessonNum'+(durationNum!=1?'-${lessonNum+durationNum-1}':'')+'节';
      });
      courseDataList[index].weekNum = weekNum;
      courseDataList[index].lessonNum = lessonNum;
      courseDataList[index].durationNum = durationNum;
  }

  Widget _buildChooseButton(String title,String subTitle,GestureTapCallback onTap){
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spaceCardMarginRL),
        child: Row(
          children: [
            Expanded(
              child: FlyText.title45(title),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FlyText.main40(subTitle,maxLine: 2,),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right_rounded,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  bool _checkCompleteness(){
    for(int i = 0;i<lessonStrList.length;i++){
      if(lessonStrList[i]=="未选择"||weekStrList[i]=="未选择"){
        showToast(context, "请填写完整哦");
        return false;
      }
    }
    if(titleController.text.isEmpty){
      showToast(context, "请填写完整哦");
      return false;
    }
    return true;
  }
  _onDetermine(){
    //确定回调
    if(_checkCompleteness()){
      for(var courseData in courseDataList){
        courseData.title = titleController.text;
        courseData.location = locationController.text;
        courseData.teacher = teacherController.text;
        courseData.remark = remarkController.text;
      }
      Navigator.of(context).pop(courseDataList);
    }
  }

  Widget inputBar(String hintText,TextEditingController controller,
      {FormFieldSetter<String> onSaved,bool autofocus = false,int maxLines = 1}){
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      decoration: BoxDecoration(
          color: Theme.of(context).unselectedWidgetColor,
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: TextFormField(
        cursorColor: colorMain,
        autofocus: autofocus,
        maxLines: maxLines,
        style: TextStyle(fontSize: fontSizeTitle45,),
        controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: fontSizeTitle45,),
          border: InputBorder.none, //下划线
          hintText: hintText, //点击后显示的提示语
        ),
        onSaved: onSaved,
      ),
    );
  }
}
class WeekListPicker extends StatefulWidget {
  @override
  _WeekListPickerState createState() => _WeekListPickerState();
}

class _WeekListPickerState extends State<WeekListPicker> {
  List<int> weekList = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 20,
        children: [
          _buildTitle('选择周次(多选)'),
          _buildWeekPicker(),
          Wrap(
            runSpacing: 20,
            children: [
              _buildPreview(),
              _buildButton(onTap:()=>_submit())
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPreview(){
    return Center(
      child: FlyText.miniTip30(CourseData.weekListToString(weekList),maxLine: 5,),
    );
  }
  Widget _buildWeekPicker(){
    return Wrap(
      spacing: 10,
      children: List.generate(22, (index) {
        int week = index+1;
        return ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          label: FlyText.mini30(week.toString()),
          selected: weekList.contains(week),
          onSelected: (v) {
            setState(() {
              if(v){
                weekList.add(week);
              }else{
                weekList.removeWhere((element) => element==week);
              }
              weekList.sort();
            });
            debugPrint(weekList.toString());
          },
        );
      }).toList(),
    );
  }
  Widget _buildTitle(String title){
    return Center(child: FlyText.title50(title,fontWeight: FontWeight.bold,),);
  }
  _submit(){
    if(weekList.isEmpty){
      Navigator.of(context).pop();
    }else{
      Navigator.of(context).pop(weekList);
    }
  }
  Widget _buildButton({GestureTapCallback onTap}){
    return Center(
      child:  InkWell(
        child: FlyText.main40('确定',color: colorMain,fontWeight: FontWeight.bold,),
        onTap: onTap,
      ),
    );
  }

}

class LessonWeekNumPicker extends StatefulWidget {
  @override
  _LessonWeekNumPickerState createState() => _LessonWeekNumPickerState();
}

class _LessonWeekNumPickerState extends State<LessonWeekNumPicker> {
  int weekNum=1;
  int lessonNum=1;
  int duration = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 20,
        children: [
          _buildTitle('选择小节'),
          _buildLocPicker(),
          Divider(),
          _buildTitle('持续几小节？'),
          _buildDurationPicker(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPreview(),
              _buildButton(),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildTitle(String title){
    return Center(child: FlyText.title50(title,fontWeight: FontWeight.bold,),);
  }
  Widget _buildPreview(){
    return FlyText.miniTip30('周$weekNum  第$lessonNum'+(duration!=1?'-${lessonNum+duration-1}':'')+'节');
  }
  Widget _buildLocPicker(){
    return Wrap(
      children: [
        //周1-周7
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(8, (i){
            if(i==0)return Expanded(child: Center(child: FlyText.miniTip30('节'),),flex: 1,);
            return Expanded(flex: 2,child: Center(child: FlyWidgetBuilder(
              whenFirst: weekNum==i,
              firstChild: FlyText.mini30('周$i',color: colorMain,fontWeight: FontWeight.bold,),
              secondChild: FlyText.miniTip30('周$i',),
            ),
            ));
          },),
        ),
        //节次 [][][][][][][]
        Wrap(
          children: List.generate(11, (lesson){
            if(lesson == 0) return Container();
            return _buildRow(lesson);
          }),
        ),
      ],
    );
  }
  _submit(){
    Navigator.of(context).pop([weekNum,lessonNum,duration]);
  }
  Widget _buildButton(){
    return Center(
      child:  InkWell(
        child: FlyText.main40('确定',color: colorMain,fontWeight: FontWeight.bold,),
        onTap: ()=>_submit(),
      ),
    );
  }
  bool check({int lesson,int dur}){
    if(lesson==null)lesson = lessonNum;
    if(dur==null)dur = duration;
    if(lesson+dur-1>10){
      showToast(context, "节次超限啦(X_X)",gravity: 1);
      return false;
    }
    return true;
  }
  Widget _buildDurationPicker(){

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          int dur = index+1;
          return ChoiceChip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            label: FlyText.mini30(dur.toString()),
            selected: duration==dur,
            onSelected: (v) {
              if(v){
                if(check(dur: dur)) setState(() {
                  duration = dur;
                });
              }
              debugPrint(weekNum.toString()+'  '+lessonNum.toString());
            },
          );
        }).toList(),
      ),
    );
  }
  Widget _buildRow(int lesson){
    return  Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(8, (week) {
          if(week==0)return Expanded(
            child: Center(child: FlyWidgetBuilder(
              whenFirst: lesson==lessonNum,
              firstChild: FlyText.mini30('$lesson',color: colorMain,fontWeight: FontWeight.bold,),
              secondChild: FlyText.miniTip30('$lesson',),
            ),),
          );
          return Expanded(
            flex: 2,
            child: ChoiceChip(
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              label: Container(height: 30,width: 30,),
              selected: weekNum==week&&lessonNum==lesson,
              onSelected: (v) {
                if(v){
                  if(check(lesson: lesson))setState(() {
                    weekNum = week;
                    lessonNum = lesson;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

}