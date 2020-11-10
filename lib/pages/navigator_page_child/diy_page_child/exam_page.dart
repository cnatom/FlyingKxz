

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
  bool loading;
  Timer timer;
  int countdownTime = 0;

  getShowExamView({@required String year,@required String term})async{
    setState(() {loading = true;});
    await examPost(context, token:Global.prefs.getString(Global.prefsStr.token), year: year, term: term);
    setState(() {loading = false;});
  }
  initData()async{
    loading = false;
    if(Global.prefs.getString(Global.prefsStr.examDataLoc)!=null){
      Global.examInfo = ExamInfo.fromJson(jsonDecode(Global.prefs.getString(Global.prefsStr.examDataLoc)));//加载之前的考试数据
      await examPost(context, token:Global.prefs.getString(Global.prefsStr.token),
          year: Global.prefs.getString(Global.prefsStr.examYear), term: Global.prefs.getString(Global.prefsStr.examTerm));//刷新数据
      setState(() {});
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
    DateTime examDateTime = DateTime(year,month,day);
    int timeLeftInt = examDateTime.difference(Global.nowDate).inDays;
    String timeLeft = timeLeftInt.toString();
    if(timeLeftInt<0){
      colorCard = colorExamCard[4];
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadiusValue),

      ),
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB*2, spaceCardMarginRL, 0),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, ScreenUtil().setSp(20)),
      child: Column(
        children: [
          //课程名 + 剩余天数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FlyTextMini35(courseName,fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10,),
              timeLeftInt>=0?Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlyTextTip30('剩余',color: colorCard.withAlpha(200)),
                  SizedBox(width: 10,),
                  Text(timeLeft.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(60),color: colorCard,fontWeight: FontWeight.bold,fontFamily: "SY"),textAlign: TextAlign.center,),
                  SizedBox(width: 10,),
                  FlyTextTip30('天',color: colorCard.withAlpha(200))
                ],
              ):Row(
                children: [
                  Text("",style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
                  Text("已结束",style: TextStyle(fontSize: ScreenUtil().setSp(45),color: colorCard,fontWeight: FontWeight.bold,fontFamily: "SY"),textAlign: TextAlign.center,)

                ],
              ),
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
          FlyTextMain40("（￣︶￣）↘  点右下角查询考试",color: Colors.black38),
        ],
      ),
    );
  }
  Widget loadingView(){
    return Center(
      child: loadingAnimationIOS(),
    );
  }
  Widget infoView(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: fontSizeMini38*3,),
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
      height: double.infinity,
      width: double.infinity,
      child: InkWell(
        onTap: ()async{
          if (countdownTime == 0) {
            debugPrint("当前学期"+Global.prefs.getString(Global.prefsStr.schoolTerm));
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
            FlyTextMain40("ヾ(๑╹◡╹)ﾉ'  暂时还没有考试",color: Colors.black38),
            FlyTextTip30(countdownTime==0?"(点击空白处获取当前学年学期考试信息)":"$countdownTime秒后可再次获取")
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
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: colorPageBackground,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [

            Positioned(child: curView()),
            Positioned(
              bottom: spaceCardMarginRL,
              right: spaceCardMarginRL,
              child: FlyFloatButton('ExamPage',iconData: Icons.search,
                  onPressed: ()=>showPicker(context, Global.scaffoldKeyDiy, pickerDatas: Global.xqxnPickerData, onConfirm: (Picker picker, List value) {
                    getShowExamView(year: picker.getSelectedValues()[0].toString().substring(0,4),term: '${(value[1]+1).toString()}');
                  })),
            ),
            Container(
              width: double.infinity,
              height: fontSizeMini38*3,
              color: Colors.white.withAlpha(240),
              padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlyTextMini35("${Global.prefs.getString(Global.prefsStr.examYear)}-${int.parse(Global.prefs.getString(Global.prefsStr.examYear))+1}"+" 学年   ",color: Colors.black38),
                  FlyTextMini35("第"+Global.prefs.getString(Global.prefsStr.examTerm)+"学期",color: Colors.black38)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
