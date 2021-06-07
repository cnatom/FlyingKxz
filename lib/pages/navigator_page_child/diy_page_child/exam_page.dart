

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/my_bottom_sheet.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';

import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/exam_get.dart';
import 'dart:async';

import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_add_page.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/global/actionListener.dart';
import 'package:left_scroll_actions/leftScroll.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../tip_page.dart';

class ExamView extends StatefulWidget {
  @override
  _ExamViewState createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> with AutomaticKeepAliveClientMixin{
  bool loading = false;
  Timer timer;
  bool show = false;
  int countdownTime = 0;
  List<ExamUnit> examCurList = [];
  List<ExamUnit> examOutList = [];
  ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    _init();
  }
  getShowExamView({@required String year,@required String term})async{

    setState(() {loading = true;});
    if(await examPost(context,year: year, term: term))
      setState(() {loading = false;});
  }
  _refresh()async{
    setState(() {loading = true;});
    if(await examPost(context,year: Prefs.schoolYear, term: Prefs.schoolTerm)){
      showToast('刷新成功');
    }else{
      showToast('刷新失败');
    }
    setState(() {loading = false;});

  }
  List<ExamUnit> _parseToCurList(List<ExamUnit> examList,){
    List<ExamUnit> result = [];
    for(var item in examList){
      ExamUnit newData = new ExamUnit(courseName: item.courseName,location: item.location,dateTime: item.dateTime,year: item.year,month: item.month,day: item.day);
      if(newData.out){
        examOutList.add(newData);
      }else{
        result.add(newData);
      }
    }
    return result;
  }
  _init()async{
    if(Prefs.examData!=null){
      Global.examList = ExamUnit.examJsonDecode(Prefs.examData);
      examCurList = _parseToCurList(Global.examList);
    }
    setState(() {});
    if(await examPost(context, year: Prefs.schoolYear, term: Prefs.schoolTerm)){
      examOutList.clear();
      examCurList = _parseToCurList(Global.examList);
    }
    setState(() {});
  }
  //添加自定义倒计时
  void addDiyExamFunc()async{
    await showFlyModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return ExamAddView();
      },
    );
    examOutList.clear();
    examCurList = _parseToCurList(Global.examList);
    setState(() {
    });
  }
  //确定退出
  Future<bool> willSignOut(context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: FlyText.main40('确定删除此倒计时卡片？'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: FlyText.main40('确定',color: themeProvider.colorMain),),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: FlyText.mainTip40('取消',),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    examCurList.sort((a,b){
      return DateTime(a.year,a.month,a.day).compareTo(DateTime(b.year,b.month,b.day));
    });
    themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: Column(
        children: [
          FlyTContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                curView(examCurList),
                filterButton(),
                AnimatedCrossFade(
                  firstCurve: Curves.easeOutCubic,
                  secondCurve: Curves.easeOutCubic,
                  sizeCurve: Curves.easeOutCubic,
                  firstChild: Container(),
                  secondChild:Column(
                    children: [
                      SizedBox(height: spaceCardPaddingTB,),
                      curView(examOutList,outView: true)
                    ],
                  ),
                  duration: Duration(milliseconds: 300),
                  crossFadeState: show?CrossFadeState.showSecond:CrossFadeState.showFirst,
                ),
                SizedBox(height: spaceCardPaddingTB,)
              ],
            )
          ),
          SizedBox(height: 500,)
        ],
      ),
    );
  }
  Widget filterButton(){
    return InkWell(
      onTap: (){
        setState(() {
          show = !show;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyText.main35('已结束考试（${examOutList.length}）',color:themeProvider.colorNavText.withOpacity(0.5),),
          Container(
            child: Icon(!show?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: themeProvider.colorNavText.withOpacity(0.5),),
          )
        ],
      ),
    );
  }
  Widget FlyTContainer({Widget child}){
    Color headerColor = themeProvider.colorNavText.withOpacity(0.5);
    return FlyContainer(
      transValue: themeProvider.transCard*0.6,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FlyText.main35('考试倒计时',color: headerColor,),
                      SizedBox(width: 10,),
                      loading?loadingAnimationIOS():Container()
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      InkWell(
                        onTap: ()=>addDiyExamFunc(),
                        child: Icon(Icons.add,size: fontSizeMain40*1.5,color: headerColor,),
                      ),
                      InkWell(
                        onTap: ()=>_refresh(),
                        child: Icon(Icons.refresh,size: fontSizeMain40*1.5,color: headerColor,),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: spaceCardPaddingTB,),
            child??Container()
          ],
        ));
  }

  Widget examCard(String courseName,String location,String dateTime,int year,int month,int day,{bool outView = false}){
    Color colorCardText;
    Color colorLine;
    double percent;
    //计算剩余天数
    DateTime examDateTime = DateTime(year,month,day,);
    int timeLeftInt = examDateTime.difference(Global.nowDate).inDays+1;
    String timeLeft = timeLeftInt.toString();
    percent = timeLeftInt/30.0;
    if(percent>1.0)percent=1.0;
    if(timeLeftInt<=0){
      if(!outView) return Container();
        colorLine = Colors.grey;
        percent = 0.0;
    }else if(timeLeftInt<=7){
      colorLine = colorExamCard[0];
    }else if(timeLeftInt<=15){
      colorLine = colorExamCard[1];
    }else if(timeLeftInt<=30){
      colorLine = colorExamCard[2];
    }else{
      colorLine = colorExamCard[3];
    }
    colorCardText = colorLine;
    if(!themeProvider.simpleMode&&!themeProvider.darkMode){
      colorCardText = themeProvider.colorNavText;
      colorLine = themeProvider.colorNavText.withOpacity((timeLeftInt%30)/30.0);
    }
    return Container(
      margin: EdgeInsets.fromLTRB(spaceCardPaddingRL/2, 0, spaceCardPaddingRL/2, spaceCardPaddingTB),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/2, spaceCardPaddingRL*0.8, spaceCardPaddingTB),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(themeProvider.transCard),
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: [
          boxShadowMain
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                //课程名 + 剩余天数
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: FlyText.main35(courseName,fontWeight: FontWeight.w500,color: themeProvider.colorNavText,),
                    ),
                    SizedBox(width: 10,),
                    (examDateTime.day==Global.nowDate.day&&examDateTime.month==Global.nowDate.month)?Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('',style: TextStyle(fontSize: ScreenUtil().setSp(60),),),
                        FlyText.title45('今天',color: colorCardText.withAlpha(200),fontWeight: FontWeight.w600),
                        FlyText.mini30(' 加油 !!~',color: colorCardText.withAlpha(200)),

                      ],
                    ):Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlyText.mini30(outView?'已结束':'剩余',color: colorCardText),
                        SizedBox(width: 10,),
                        Text(outView?'':timeLeft.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(60),color: colorCardText,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        FlyText.mini30(outView?'':'天',color: colorCardText)
                      ],
                    )
                  ],
                ),
                SizedBox(height: spaceCardPaddingTB/2,),
                LinearPercentIndicator(
                  animation: true,
                  lineHeight: 7,
                  animationDuration: 500,
                  percent: percent,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: colorLine,
                  backgroundColor: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
                ),
                SizedBox(height: spaceCardPaddingTB/2,),
                //考试地点 + 考试时间
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlyText.main35(location,color: themeProvider.colorNavText.withOpacity(0.5),),
                    FlyText.main35(dateTime,color: colorCardText.withAlpha(180))
                  ],
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget nullView(){
  //   return Text("hello");
  // }
  // Widget loadingView(){
  //   return Container();
  // }
  // Widget infoView(){
  //   return SingleChildScrollView(
  //     physics: BouncingScrollPhysics(),
  //     child: Column(
  //       children: [
  //         Column(
  //           children: Global.examInfo.data.map((item){
  //             return examCard(item.course, item.local, item.time, item.year, item.month, item.day);
  //           }).toList(),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }
  // Widget infoEmptyView(){
  //   // return Container();
  //   return Container(
  //     width: double.infinity,
  //     child: InkWell(
  //       onTap: ()async{
  //         if (countdownTime == 0) {
  //           await getShowExamView(year: Prefs.schoolYear,term: Prefs.schoolTerm);
  //           setState(() {
  //           countdownTime = 5;
  //         });
  //         startCountdownTimer();//倒计时
  //         }
  //       },
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           FlyText.main40("ヾ(๑╹◡╹)ﾉ'  暂时还没有考试",color: colorMainTextWhite),
  //           FlyText.mini30(countdownTime==0?"(点击空白处刷新)":"$countdownTime秒后可再次刷新",color: colorMainTextWhite.withOpacity(0.8))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget curView(List<ExamUnit> list, {bool outView = false}){

    return Column(
      children: list.map((item){
        return InkWell(
        onTap: ()async{
          if(await willSignOut(context)){
            var delIndex = Global.examList.indexOf(item);
            // Global.examDiyInfo.data.removeAt(delIndex);
            // Prefs.examDataDiy = jsonEncode(Global.examDiyInfo.toJson());
            setState(() {
            });
          }
    },
        child: examCard(item.courseName, item.location, item.dateTime, item.year, item.month, item.day,outView: outView),
        );
      }).toList(),
    );
  }
  Widget outView(){
    return Column(
      children: examOutList.map((item){
        return examCard(item.courseName, item.location, item.dateTime, item.year, item.month, item.day,outView: true);
      }).toList(),
    );
  }
  Widget addDiyExamButton(){
    return InkWell(
      onTap: ()=>addDiyExamFunc(),
      child: FlyContainer(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(themeProvider.transCard),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              boxShadowMain
            ]
        ),

        padding: EdgeInsets.all(spaceCardPaddingRL/1.5),
        child: Icon(Icons.add,color: themeProvider.colorNavText,),
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
