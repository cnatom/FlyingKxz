import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/exam_add_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/exam_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/import_exam_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../ui/sheet.dart';
import '../../../navigator_page.dart';

class ExamView extends StatefulWidget {
  @override
  _ExamViewState createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> with AutomaticKeepAliveClientMixin{
  Timer? timer;
  bool show = false;
  int countdownTime = 0;
  List<ExamData> examCurList = [];
  List<ExamData> examOutList = [];
  late ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    _init();
  }
  import()async{
    var importList = await Navigator.push(context, CupertinoPageRoute(builder: (context)=>ImportExamPage()));
    if(importList==null||importList.isEmpty) return;
    // List<Map<String,dynamic>> importList = CumtFormat.parseExam(html);
    //写入教务考试
    for(var item in importList){
      Global.examList.add(
          ExamData(
            courseName: item['courseName'],
            location: item['location'],
            dateTime: item['dateTime'],
          )
      );
    }
    Prefs.examData = ExamData.examJsonEncode(Global.examList);
    examOutList.clear();
    examCurList = _parseToCurList(Global.examList.cast<ExamData>());
    setState(() {});
    showToast('导入成功');
    Logger.log('Exam', '导入,成功',{'info':importList});
  }
  List<ExamData> _parseToCurList(List<ExamData> examList,){
    List<ExamData> result = [];
    for(var item in examList){
      if(item.out!=null){
        examOutList.add(item);
      }else{
        result.add(item);
      }
    }
    result.sort((a,b){
      return DateTime(a.year??0,a.month??0,a.day??0).compareTo(DateTime(b.year??0,b.month??0,b.day??0));
    });
    return result;
  }
  _init()async{
    if(Prefs.examData!=null){
      Global.examList = ExamData.examJsonDecode(Prefs.examData??'');
      examCurList = _parseToCurList(Global.examList.cast<ExamData>());
      setState(() {});
    }
  }
  //添加自定义倒计时
  void _add()async{
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
    examCurList = _parseToCurList(Global.examList.cast<ExamData>());
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: FlyText.main40('确定',color: themeProvider.colorMain),),
          TextButton(
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
    themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: Column(
        children: [
          flyTContainer(
            action: [
              _buildActionIconButton(Icons.add,onTap: ()=>_add()),
              _buildActionIconButton(Icons.cloud_download_outlined,onTap: ()=>import()),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                curView(examCurList),
                filterButton(),
                outView(examOutList),
                SizedBox(height: spaceCardPaddingTB,)
              ],
            )
          ),
          SizedBox(height: 500,)
        ],
      ),
    );
  }

  InkWell _buildActionIconButton(IconData iconData,{GestureTapCallback? onTap}) {
    return InkWell(
              onTap: onTap,
              child: Icon(iconData,size: fontSizeMain40*1.5,color: themeProvider.colorNavText.withOpacity(0.5),),);
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
  Widget flyTContainer({Widget? child,List<Widget>? action}){
    return FlyContainer(
      transValue: themeProvider.transCard*0.6,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlyText.main35('考试倒计时',color: themeProvider.colorNavText.withOpacity(0.5),),
                  Wrap(
                    spacing: 15,
                    children: action??[],
                  )
                ],
              ),
            ),
            SizedBox(height: spaceCardPaddingTB,),
            child??Container()
          ],
        ));
  }

  Widget examCard(String? courseName,String? location,String? dateTime,int? year,int? month,int? day,{bool outView = false}){
    Color colorCardText;
    Color colorLine;
    double percent;
    //计算剩余天数
    DateTime examDateTime = DateTime(year??0,month??0,day??0,);
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
                  barRadius: Radius.circular(10),
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
  Widget outView(List<ExamData?> list){
    return AnimatedCrossFade(
      firstCurve: Curves.easeOutCubic,
      secondCurve: Curves.easeOutCubic,
      sizeCurve: Curves.easeOutCubic,
      firstChild: Container(),
      secondChild:Column(
        children: [
          SizedBox(height: spaceCardPaddingTB,),
          curView(list,outView: true)
        ],
      ),
      duration: Duration(milliseconds: 300),
      crossFadeState: show?CrossFadeState.showSecond:CrossFadeState.showFirst,
    );
  }
  Widget curView(List<ExamData?> list, {bool outView = false}){

    return Column(
      children: list.map((item){
        return InkWell(
        onTap: ()async{
          if(await willSignOut(context)){
            //获取索引
            int delIndex = -1;
            for(int i = 0;i<list.length;i++){
              if(list[i]?.courseName==item?.courseName&&list[i]?.location==item?.location){
                delIndex = i;
                break;
              }
            }
            //按需删除
            if(outView){
              examOutList.removeAt(delIndex);
            }else{
              examCurList.removeAt(delIndex);
            }
            //刷新
            setState(() {
            });
            //存储
            Prefs.examData = ExamData.examJsonEncode(examCurList+examOutList);
            Logger.log('Exam', '删除考试',{'courseName':item?.courseName});
          }
    },
        child: examCard(item?.courseName, item?.location, item?.dateTime, item?.year, item?.month, item?.day,outView: outView),
        );
      }).toList(),
    );
  }
  Widget addDiyExamButton(){
    return InkWell(
      onTap: ()=>_add(),
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
