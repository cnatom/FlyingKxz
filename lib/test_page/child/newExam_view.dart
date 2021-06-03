import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/exam_get.dart';
import 'dart:async';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_add_page.dart';
import 'package:flying_kxz/test_page/component/unit_card.dart';
import 'package:provider/provider.dart';
class NewExamView extends StatefulWidget {
  @override
  _NewExamViewState createState() => _NewExamViewState();
}

class _NewExamViewState extends State<NewExamView> with AutomaticKeepAliveClientMixin{
  bool loading = false;
  Timer timer;
  int countdownTime = 0;
  ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    initExamData();
    initDiyData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return FlyUnitCard(
      0xe61b,
      "考试倒计时",
      "暂无考试",
      loading: loading,
      child: Column(
      children: [
        Container(
            width: double.infinity,
            child: curView()
        ),
        // Column(
        //   children: Global.examDiyInfo.data.map((item){
        //     return InkWell(
        //       onTap: ()async{
        //         if(await willSignOut(context)){
        //           var delIndex = Global.examDiyInfo.data.indexOf(item);
        //           Global.examDiyInfo.data.removeAt(delIndex);
        //           Prefs.examDataDiy = jsonEncode(Global.examDiyInfo.toJson());
        //           setState(() {
        //           });
        //         }
        //       },
        //       child: examCard(item.course, item.local, item.time, item.year, item.month, item.day),
        //     );
        //   }).toList(),
        // ),
        SizedBox(height: spaceCardMarginTB,),
        addDiyExamButton()
      ],
    ),);
  }

  getShowExamView({@required String year,@required String term})async{
    setState(() {loading = true;});
    if(await examPost(context,year: year, term: term))
      setState(() {loading = false;});
  }
  initExamData()async{
    var localExamInfo = Prefs.examData;
    if(localExamInfo!=null){
      Global.examInfo = ExamInfo.fromJson(jsonDecode(localExamInfo));
      loading = true;
      await examPost(context,
          year: Prefs.schoolYear, term: Prefs.schoolTerm);
      loading = false;
    }else{
      getShowExamView(year: Prefs.schoolYear, term: Prefs.schoolTerm);//首次使用
    }
  }

  initDiyData()async{
    var localDiyInfo = Prefs.examDataDiy;
    if(localDiyInfo!=null){
      // Global.examDiyInfo = ExamInfo.fromJson(jsonDecode(localDiyInfo));
      setState(() {
      });
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
  //添加自定义倒计时
  void addDiyExamFunc()async{
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return ExamAddView();
      },
    );
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
            child: FlyText.main40('确定',color: colorMain),),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: FlyText.mainTip40('取消',),
          ),
        ],
      ),
    ) ??
        false;
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
    return FlyContainer(
      margin: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginBigTB),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/2, spaceCardPaddingRL, spaceCardPaddingTB),
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
                  FlyText.title45('今天',color: colorCard.withAlpha(200),fontWeight: FontWeight.w600),
                  FlyText.mini30(' 加油 !!~',color: colorCard.withAlpha(200)),

                ],
              ):Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlyText.mini30('剩余',color: colorCard.withAlpha(200)),
                  SizedBox(width: 10,),
                  Text(timeLeft.toString(),style: TextStyle(fontSize: ScreenUtil().setSp(60),color: colorCard,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                  SizedBox(width: 10,),
                  FlyText.mini30('天',color: colorCard.withAlpha(200))
                ],
              )
            ],
          ),
          SizedBox(height: spaceCardPaddingTB/3,),
          LinearProgressIndicator(
            backgroundColor: Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
            minHeight: 7,
            value: timeLeftInt/30,
            valueColor: new AlwaysStoppedAnimation<Color>(colorCard.withAlpha(180)),
          ),
          SizedBox(height: spaceCardPaddingTB/3,),
          //考试地点 + 考试时间
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlyText.main35(location,color: themeProvider.colorNavText.withOpacity(0.5),),
              FlyText.main35(dateTime,color: colorCard.withAlpha(180))
            ],
          )
        ],
      ),
    );
  }
  Widget nullView(){
    return Container();
  }
  Widget loadingView(){
    return Container();
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

        ],
      ),
    );
  }
  Widget infoEmptyView(){
    return Container();
    // return Container(
    //   width: double.infinity,
    //   child: InkWell(
    //     onTap: ()async{
    //       if (countdownTime == 0) {
    //         await getShowExamView(year: Global.prefs.getString(Global.prefsStr.schoolYear),term: Global.prefs.getString(Global.prefsStr.schoolTerm));
    //         setState(() {
    //         countdownTime = 5;
    //       });
    //       startCountdownTimer();//倒计时
    //       }
    //     },
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         FlyText.main40("ヾ(๑╹◡╹)ﾉ'  暂时还没有考试",color: colorMainTextWhite),
    //         FlyText.mini30(countdownTime==0?"(点击空白处刷新)":"$countdownTime秒后可再次刷新",color: colorMainTextWhite.withOpacity(0.8))
    //       ],
    //     ),
    //   ),
    // );
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
  Widget addDiyExamButton(){
    return InkWell(
      onTap: ()=>addDiyExamFunc(),
      child: FlyContainer(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(themeProvider.simpleMode?1:themeProvider.transCard),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              boxShadowMain
            ]
        ),

        padding: EdgeInsets.all(spaceCardPaddingRL/1.5),
        child: Icon(Icons.add,color: themeProvider.colorMain,),
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
