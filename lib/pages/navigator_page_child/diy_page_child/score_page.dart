import 'dart:convert';
import 'dart:ui';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:flying_kxz/pages/backImage_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';

import 'package:flying_kxz/NetRequest/exam_get.dart';
import 'package:flying_kxz/NetRequest/score_get.dart';
//跳转到当前页面
void toScorePage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => ScorePage()));
}

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>  with AutomaticKeepAliveClientMixin{
  ScrollController controller = new ScrollController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String curScoreYear = "全部学年",curScoreTerm = "全部学期";//当前所选的学期学年信息
  String jiaquanTotal;//总加权
  String jidianTotal;//总绩点
  double xfjdSum;//学分*绩点的和
  double xfcjSum;//学分*成绩的和
  double xfSum;//学分的和
  List<bool> scoreFilter = new List();//true为计入总分 false不计入总分
  bool showFilter = false;//是否启动筛选
  bool scoreDetailAllExpand = false;//是否全部展开闭合
  List<CrossFadeState> scoreDetailCrossFadeState = new List(); //控制详细列表的展开闭合
  bool loading;//是否显示加载动画
  bool selectAll =  true;
  double opacityFloatButton = 0.0;//是否显示回到顶部按钮
  var topCrossFadeState = CrossFadeState.showFirst;
  //计算总加权和总绩点
  void calcuTotalScore(){
    xfjdSum = 0;
    xfSum = 0;
    xfcjSum = 0;
    for(int i = 0;i < Global.scoreInfo.data.length;i++){
      if(scoreFilter[i]==false) continue;
      xfjdSum += double.parse(Global.scoreInfo.data[i].xuefen)*double.parse(Global.scoreInfo.data[i].jidian.toString());
      xfcjSum += double.parse(Global.scoreInfo.data[i].xuefen)*int.parse(Global.scoreInfo.data[i].zongping);
      xfSum += double.parse(Global.scoreInfo.data[i].xuefen);
    }
    jiaquanTotal = (xfcjSum/xfSum).toStringAsFixed(2);
    jidianTotal = (xfjdSum/xfSum).toStringAsFixed(2);
  }
  Color selectedMainColor = colorMainText;
  //总绩点 + 展开闭合组件
  Widget topArea(){
    //展开闭合组件
    Widget expandChip(){
      return InkWell(
        onTap: (){
          setState(() {
            if(scoreDetailAllExpand==true){
              scoreDetailCrossFadeState.fillRange(0, scoreDetailCrossFadeState.length,CrossFadeState.showFirst);
              scoreDetailAllExpand = false;
            }else{
              scoreDetailCrossFadeState.fillRange(0, scoreDetailCrossFadeState.length,CrossFadeState.showSecond);
              scoreDetailAllExpand = true;
            }
          });
        },
        child: Container(
          height: fontSizeMini38*3,
          child:Row(
            children: [
              scoreDetailAllExpand?FlyText.main35('详细信息',):FlyText.main35('简略信息',),
              scoreDetailAllExpand?Icon(Icons.expand_more,size: fontSizeMini38,):Icon(Icons.expand_less,size: fontSizeMini38),

            ],
          ),
        ),
      );
    }
    Widget filterChip(){
      return InkWell(
        onTap: (){
          setState(() {
            showFilter = !showFilter;
          });
        },
        child: Container(
          height: fontSizeMini38*3,
          child:Row(
            children: [
              FlyText.main35('筛选',fontWeight: FontWeight.w300),
              Icon(MdiIcons.filterOutline,size: fontSizeMini38*1.2,),
            ],
          ),
        ),
      );
    }
    Widget selectAllChip(){
      return InkWell(
        onTap: (){
          setState(() {
            selectAll = !selectAll;
            scoreFilter.fillRange(0, scoreFilter.length,selectAll);
            calcuTotalScore();
          });
        },
        child: Container(
          height: fontSizeMini38*3,
          child:Row(
            children: [
              selectAll?FlyText.main35('取消全选',):FlyText.main35('全部选择',),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlyText.mini30("加权：", ),
                    Text(jiaquanTotal!=null&&jiaquanTotal!='NaN'?jiaquanTotal:"00.00", style: TextStyle(color: colorMain,fontWeight: FontWeight.bold,fontSize: fontSizeMain40),)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlyText.mini30("绩点：",),
                    Text(jidianTotal!=null&&jiaquanTotal!='NaN'?jidianTotal:"0.00", style: TextStyle(color: colorMain,fontWeight: FontWeight.bold,fontSize: fontSizeMain40),)
                  ],
                ),
                Container(),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showFilter?selectAllChip():expandChip(),
                filterChip(),
              ],
            ),
          )
        ],
      ),
    );
  }
  //判断String是否是纯数字
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  //成绩卡片
  Widget chengjiCard(
      int curIndex,
      {String courseName = 'CourseName',
      String xuefen = '0',
      String jidian = '0',
      String zongping = '0',
      List<ScoreDetail> scoreDetail,}) {
    //卡片主题色
    Color colorCard;
    int zongpingInt;
    if(isNumeric(zongping)){
      zongpingInt = int.parse(zongping);
      if (zongpingInt >= 90) {
        colorCard = Colors.deepOrangeAccent;
      } else if (zongpingInt >= 80) {
        colorCard = Colors.blue;
      } else if (zongpingInt >= 60) {
        colorCard = Colors.green;
      } else {
        colorCard = Colors.grey;
      }
    } else {
      zongpingInt = 100;
      colorCard = Colors.deepOrangeAccent;
      zongping = zongping.substring(0);
    }
    //圆形进度指示器
    Widget progressIndicator({Color color = Colors.grey}) => Container(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: new AlwaysStoppedAnimation<Color>(color.withAlpha(180)),
            value: zongpingInt / 100.0,
          ),
        );
    //水平内容
    Widget _rowContent(String title, String content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlyText.miniTip30("$title：",),
          FlyText.main35(content, color: colorCard)
        ],
      );
    }

    //垂直内容
    Widget _columnContent(String title, String content) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlyText.miniTip30(title),
          SizedBox(
            height: ScreenUtil().setWidth(10),
          ),
          Text(
            content,
            style: TextStyle(fontSize: fontSizeMini38, color: colorCard),
          )
        ],
      );
    }
    //主体
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, 0, spaceCardPaddingTB),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Theme.of(context).cardColor,
        boxShadow: [
          boxShadowMain
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                //点击展开
                scoreDetailCrossFadeState[curIndex] =
                scoreDetailCrossFadeState[curIndex] ==
                    CrossFadeState.showFirst
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst;
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //圆形进度圈
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL*0.8, 0),
//                              color: Colors.red,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            FlyText.main40(zongping,
                                color: colorCard, fontWeight: FontWeight.bold),
                            LayoutBuilder(
                              builder: (context, parSize) {
                                return Container(
                                  child: progressIndicator(color: colorCard),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      //进度圈右侧信息区域
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //课程名   总评:100
                            Row(
                              children: [
                                Expanded(
                                  child: FlyText.main35(
                                    courseName,fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: fontSizeMini38/1.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: _rowContent('学分', xuefen),
                                ),
                                Expanded(
                                  child: _rowContent('绩点', jidian),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      //筛选切换
                      AnimatedCrossFade(
                        alignment: Alignment.topCenter,
                        firstCurve: Curves.easeOutCubic,
                        secondCurve: Curves.easeOutCubic,
                        sizeCurve: Curves.easeOutCubic,
                        firstChild: Container(height: fontSizeMini38*3,),
                        secondChild: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, fontSizeMini38, 0),
                          height: fontSizeMini38*3,
                          child: CupertinoSwitch(
                              activeColor: colorMain.withAlpha(200),
                              value: scoreFilter[curIndex],
                              onChanged: (v){
                                setState(() {
                                  scoreFilter[curIndex] = !scoreFilter[curIndex];
                                  calcuTotalScore();
                                });
                              }
                          ),
                        ),
                        duration: Duration(milliseconds: 200),
                        crossFadeState: showFilter?CrossFadeState.showSecond:CrossFadeState.showFirst,
                      )
                    ],
                  ),
                  //成绩明细 期终 期末 总评
                  scoreDetailCrossFadeState.isNotEmpty?AnimatedCrossFade(
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeOutCubic,
                    sizeCurve: Curves.easeOutCubic,
                    firstChild: Container(),
                    secondChild: Column(
                      children: <Widget>[
                        Divider(
                          height: fontSizeMini38,
                          color: Colors.black12.withAlpha(10),
                        ),
                        Row(
                            children: scoreDetail.map((item) {
                              return Expanded(
                                child: _columnContent(
                                    item.name.toString(), item.score.toString()),
                              );
                            }).toList())
                      ],
                    ),
                    duration: Duration(milliseconds: 300),
                    crossFadeState: scoreDetailCrossFadeState[curIndex],
                  ):Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    curScoreYear = Prefs.schoolYear+'-'+(int.parse(Prefs.schoolYear)+1).toString();
    curScoreTerm = "第${Prefs.schoolTerm}学期";
    getShowScoreView(year: curScoreYear,term: Prefs.schoolTerm);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getShowScoreView({@required String year,@required String term})async{
    setState(() {
      loading = true;
      jiaquanTotal = null;
      jidianTotal = null;
    });
    await scoreGet(context, token:Prefs.token,year: year,term: term);
    curScoreYear = year;
    curScoreTerm = term=="0"?"全部学期":"第$term学期";
    scoreDetailCrossFadeState.clear();
    scoreFilter.clear();
    //添加开展动画控制器 并 计算总加权和总绩点
    for(int i = 0;i < Global.scoreInfo.data.length;i++){
      scoreFilter.add(true);
      scoreDetailCrossFadeState.add(CrossFadeState.showFirst);
    }
    calcuTotalScore();
    setState(() {loading = false;});
  }

  Widget nullView(){
    return Center(
      child: FlyText.main40("（￣︶￣）↗点上面查成绩",color: colorMainText),
    );
  }
  Widget loadingView(){
    return Center(
      child: loadingAnimationTwoCircles(),
    );
  }
  Widget infoView(){
    int _crossFadeStateIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(0, spaceCardMarginTB, 0, 0),
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Global.scoreInfo.data!=null&&Global.scoreInfo.data.isNotEmpty?Column(
                children: [
                  Column(
                      children: Global.scoreInfo.data.map((item){
                        return chengjiCard(
                          _crossFadeStateIndex++,
                          courseName: item.courseName,
                          xuefen: item.xuefen,
                          jidian: item.jidian.toString(),
                          zongping: item.zongping,
                          scoreDetail: item.scoreDetail,);
                      }).toList()
                  ),
                ],
              ):Container(),
              Center(child: FlyText.mini30('\n"筛选"功能可忽略某些不计入加权的成绩\n点击卡片可查看成绩明细',textAlign: TextAlign.center),),
              SizedBox(height: ScreenUtil().setSp(300),),
            ],
          ),
        ),
      ),
    );
  }
  Widget infoEmptyView(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyText.main40("∑(っ°Д°;)っ没有本学期的成绩",color: colorMainText),
          FlyText.mini30("（ 换个学期试一试 ？） ",color: colorMainText),
        ],
      ),
    );
  }
  Widget curView(){
    Widget child = nullView();
    switch(loading) {
      case true:child = loadingView();break;
      case false:{
        child = Global.scoreInfo.data.isEmpty?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: FlyAppBar(context, '成绩',),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(borderRadiusValue),
              boxShadow: [
                boxShadowMain
              ]
            ),
            child: Column(
              children: [
                topArea(),
                FlySearchBarButton('点击查询',
                    "${curScoreYear} ${curScoreTerm}",
                    onTap: ()=>showPicker(context, scaffoldKey,
                        pickerDatas: PickerData.xqxnWithAllTermPickerData,
                        onConfirm: (Picker picker, List value) {
                          debugPrint(value.toString());
                          getShowScoreView(year: picker.getSelectedValues()[0].toString(),term: '${(value[1]).toString()}');
                        })),
              ],
            ),
          ),
          Expanded(
            child: curView(),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}