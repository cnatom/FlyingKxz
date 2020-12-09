

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/exam_get.dart';
import 'dart:async';
class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with AutomaticKeepAliveClientMixin{
  bool loading = false;
  Timer timer;
  int countdownTime = 0;

  getShowExamView({@required String year,@required String term})async{
    setState(() {loading = true;});
    if(await examPost(context, token:Global.prefs.getString(Global.prefsStr.token), year: year, term: term))
    setState(() {loading = false;});
  }
  initData()async{
    if(Global.prefs.getString(Global.prefsStr.examDataLoc)!=null){
      Global.examInfo = ExamInfo.fromJson(jsonDecode(Global.prefs.getString(Global.prefsStr.examDataLoc)));//加载之前的考试数据
      setState(() {});
      if(await examPost(context, token:Global.prefs.getString(Global.prefsStr.token),
          year: Global.prefs.getString(Global.prefsStr.examYear), term: Global.prefs.getString(Global.prefsStr.examTerm))){
        setState(() {});
      }

    }else{
      getShowExamView(year: Global.prefs.getString(Global.prefsStr.schoolYear), term: Global.prefs.getString(Global.prefsStr.schoolTerm));//首次使用
    }
  }
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (countdownTime < 1) {
          timer.cancel();
        } else {
          countdownTime = countdownTime - 1;
        }
      })
    };
    timer = Timer.periodic(oneSec, callback);
  }

  Widget examCard(String courseName,String location,String dateTime,int year,int month,int day,){
    Color colorCard;
    //计算剩余天数
    DateTime examDateTime = DateTime(year,month,day,);
    int timeLeftInt = examDateTime.difference(Global.nowDate).inDays+1;
    String timeLeft = timeLeftInt.toString();
    if(timeLeftInt<=0){
      colorCard = colorExamCard[4];
      return Container();
    }else if(timeLeftInt<=7){
      colorCard = colorExamCard[0];
    }else if(timeLeftInt<=15){
      colorCard = colorExamCard[1];
    }else if(timeLeftInt<=30){
      colorCard = colorExamCard[2];
    }else{
      colorCard = colorExamCard[3];
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(transparentValue),
        borderRadius: BorderRadius.circular(borderRadiusValue),

      ),
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, spaceCardMarginBigTB),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/2, spaceCardPaddingRL, spaceCardPaddingTB),
      child: Column(
        children: [
          //课程名 + 剩余天数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FlyTextMini35(courseName,fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10,),
              examDateTime.day!=Global.nowDate.day?Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlyTextTip30('剩余',color: colorCard.withAlpha(200)),
                  SizedBox(width: 10,),
                  Text(timeLeft.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(60),color: colorCard,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                  SizedBox(width: 10,),
                  FlyTextTip30('天',color: colorCard.withAlpha(200))
                ],
              ):Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('',style: TextStyle(fontSize: ScreenUtil().setSp(60),),),
                  FlyTextTitle45('今天',color: colorCard.withAlpha(200),fontWeight: FontWeight.w600),
                  FlyTextTip30(' 加油 !!~',color: colorCard.withAlpha(200)),

                ],
              )
            ],
          ),
          SizedBox(height: spaceCardPaddingTB/3,),
          LinearProgressIndicator(
            backgroundColor: Colors.black12.withAlpha(10),
            minHeight: 7,
            value: timeLeftInt/30,
            valueColor: new AlwaysStoppedAnimation<Color>(colorCard.withAlpha(180)),
          ),
          SizedBox(height: spaceCardPaddingTB/3,),
          //考试地点 + 考试时间
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlyTextMini35(location,color: Colors.black.withAlpha(100)),
              FlyTextMini35(dateTime,color: colorCard.withAlpha(180))
            ],
          )
        ],
      ),
    );
  }
  Widget nullView(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyTextMain40("ヾ(๑╹◡╹)ﾉ'  考试信息是自动获取的哦～",color: Colors.black38),
        ],
      ),
    );
  }
  Widget loadingView(){
    return Column(
      children: [
        SizedBox(height: fontSizeMini38*2,),
        loadingAnimationIOS()
      ],
    );
  }
  Widget infoView(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Column(
            children: Global.examInfo.data.map((item){
              return examCard(item.course, item.local, item.time, item.year, item.month, item.day);
            }).toList(),
          ),
          SizedBox(height: ScreenUtil().setSp(300),),
        ],
      ),
    );
  }
  Widget infoEmptyView(){
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: ()async{
          if (countdownTime == 0) {
            await getShowExamView(year: Global.prefs.getString(Global.prefsStr.schoolYear),term: Global.prefs.getString(Global.prefsStr.schoolTerm));
            setState(() {
            countdownTime = 5;
          });
          startCountdownTimer();//倒计时
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyTextMain40("ヾ(๑╹◡╹)ﾉ'  暂时还没有考试",color: colorMainTextWhite),
            FlyTextTip30(countdownTime==0?"(点击空白处刷新)":"$countdownTime秒后可再次刷新",color: colorMainTextWhite.withOpacity(0.8))
          ],
        ),
      ),
    );
  }
  Widget curView(){
    Widget child = nullView();
    switch(loading) {
      case true:child = loadingView();break;
      case false:{
        child = Global.examInfo.data.isEmpty?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }
  @override
  void initState() {
    super.initState();
    initData();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        width: double.infinity,
        child: curView()
    );
  }

  @override
  bool get wantKeepAlive => true;
}
