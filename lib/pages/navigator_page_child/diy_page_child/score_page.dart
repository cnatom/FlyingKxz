import 'dart:ui';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/NetRequest/score_get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
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
  String curScoreYearStr = "全部学年",curScoreTermStr = "全部学期";//当前所选的学期学年信息
  String curScoreYear,curScoreTerm;
  String jiaquanTotal;//总加权
  String jidianTotal;//总绩点
  double xfjdSum;//学分*绩点的和
  double xfcjSum;//学分*成绩的和
  double xfSum;//学分的和
  List<bool> scoreFilter = new List();//true为计入总分 false不计入总分
  bool makeupFilter = false;
  bool showFilter = false;//是否启动筛选
  bool scoreDetailAllExpand = false;//是否全部展开闭合
  List<CrossFadeState> scoreDetailCrossFadeState = new List(); //控制详细列表的展开闭合
  bool loading;//是否显示加载动画
  bool selectAll =  true;
  double opacityFloatButton = 0.0;//是否显示回到顶部按钮
  ThemeProvider themeProvider;
  var topCrossFadeState = CrossFadeState.showFirst; 
  Color selectedMainColor = colorMainText;
  @override
  void initState() {
    super.initState();
    curScoreYearStr = Prefs.schoolYear+'-'+(int.parse(Prefs.schoolYear)+1).toString();
    curScoreTermStr = "第${Prefs.schoolTerm}学期";
    curScoreTerm = Prefs.schoolTerm;
    curScoreYear = Prefs.schoolYear;
    getShowScoreView(year: curScoreYearStr,term: Prefs.schoolTerm);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: FlyAppBar(context, '成绩',actions: [
        IconButton(icon: Icon(Icons.help_outline,color: Theme.of(context).primaryColor,), onPressed: (){
          FlyDialogDIYShow(context, content: Wrap(
            children: [
              FlyText.main40('【加权筛选】"筛选"功能可忽略某些不计入加权的学科成绩\n\n'
                  '【成绩明细】点击成绩卡片可查看其明细\n\n'
                  '【全选操作】点击筛选后还可进行"全选""取消全选"操作，你注意到了吗？\n',maxLine: 100,),
              FlyText.miniTip30("平均成绩仅供参考\n实际数据请参照学生手册自行计算。",maxLine: 100,)
            ],
          ));
        })
      ]),
      body: Column(
        children: [
          FlyContainer(
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
                _searchBarButton('点击查询'+(makeupFilter?'（带补考无明细）':''),
                    "$curScoreYearStr $curScoreTermStr",
                    onTap: ()=>showPicker(context, scaffoldKey,
                        pickerDatas: PickerData.xqxnWithAllTermPickerData,
                        colorRight: themeProvider.colorMain,
                        onConfirm: (Picker picker, List value) {
                          debugPrint(value.toString());
                          getShowScoreView(year: picker.getSelectedValues()[0].toString(),term: '${(value[1]).toString()}');
                        })),
              ],
            ),
          ),

          SizedBox(height: spaceCardMarginTB,),
          Expanded(
            child: Scrollbar(
              child: Padding(
                padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      runSpacing: spaceCardMarginTB,
                      children: [
                        _makeUpFilter(),
                        curView()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
  //计算总加权和总绩点
  void calcuTotalScore(){
    xfjdSum = 0;
    xfSum = 0;
    xfcjSum = 0;
    try{
      for(int i = 0;i < Global.scoreInfo.data.length;i++){
        if(scoreFilter[i]==false) continue;
        xfjdSum += double.parse(Global.scoreInfo.data[i].xuefen)*double.parse(Global.scoreInfo.data[i].jidian.toString());
        xfcjSum += double.parse(Global.scoreInfo.data[i].xuefen)*int.parse(Global.scoreInfo.data[i].zongping);
        xfSum += double.parse(Global.scoreInfo.data[i].xuefen);
      }
      jiaquanTotal = (xfcjSum/xfSum).toStringAsFixed(2);
      jidianTotal = (xfjdSum/xfSum).toStringAsFixed(2);
    }catch(e){
      jiaquanTotal = "计算失败";
      jidianTotal = "计算失败";
    }
  }
  Widget _makeUpFilter(){
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/2, spaceCardPaddingRL, spaceCardPaddingTB/2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlyText.main35("包含补考成绩（带补考无明细）"),
          CupertinoSwitch(
              activeColor: themeProvider.colorMain.withAlpha(200),
              value: makeupFilter,
              onChanged: (v){
                if(!loading){
                  makeupFilter = !makeupFilter;
                  getShowScoreView(year: curScoreYear,term: curScoreTerm);
                }
              }
          )
        ],
      ),
    );
  }
  Widget _searchBarButton(String title,String content,{GestureTapCallback onTap}){
    return Container(
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          highlightColor: Colors.black12,
          onTap: onTap,
          child: Container(
            height: fontSizeMini38*3.5,
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlyText.main35(title,),
                    FlyText.miniTip30(content,),
                  ],
                ),
                Icon(
                  Icons.search,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
                    Text(jiaquanTotal!=null&&jiaquanTotal!='NaN'?jiaquanTotal:"00.00", style: TextStyle(color: themeProvider.colorMain,fontWeight: FontWeight.bold,fontSize: fontSizeMain40),)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlyText.mini30("绩点：",),
                    Text(jidianTotal!=null&&jiaquanTotal!='NaN'?jidianTotal:"0.00", style: TextStyle(color: themeProvider.colorMain,fontWeight: FontWeight.bold,fontSize: fontSizeMain40),)
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
        String type = '',
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
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL*0.8, 0),
            child: CircularPercentIndicator(
              radius: fontSizeMain40*3,
              lineWidth: 3.0,
              animation: true,
              animationDuration: 800,
              percent: zongpingInt / 100.0,
              center: FlyText.main40(zongping,
                  color: colorCard, fontWeight: FontWeight.bold),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: color,
              backgroundColor: Theme.of(context).disabledColor,
            ),
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
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Theme.of(context).cardColor,
        boxShadow: [
          boxShadowMain
        ]
      ),
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
                progressIndicator(color: colorCard),
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
                          )),
                          FlyText.mini30(type,color: type=='正常考试'?colorMain:Colors.red,)
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
                    padding: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
                    height: fontSizeMini38*3,
                    child: CupertinoSwitch(
                        activeColor: themeProvider.colorMain.withAlpha(200),
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
              secondChild:Column(
                children: <Widget>[
                  Divider(
                    height: fontSizeMini38,
                    color: Colors.black12.withAlpha(10),
                  ),
                  FlyWidgetBuilder(
                    whenFirst: makeupFilter,
                    firstChild: Center(
                      child: FlyText.mainTip35("包含补考成绩时，无法获取成绩明细"),
                    ),
                    secondChild: scoreDetail!=null?Row(
                        children: scoreDetail.map((item) {
                          return Expanded(
                            child: _columnContent(
                                item.name.toString(), item.score.toString()),
                          );
                        }).toList()):Container(),
                  )
                ],
              ),
              duration: Duration(milliseconds: 300),
              crossFadeState: scoreDetailCrossFadeState[curIndex],
            ):Container()
          ],
        ),
      ),
    );
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
    int type = makeupFilter?1:0;
    await scoreGet(context,type, token:Prefs.token,year: year,term: term);
    curScoreYear = year;
    curScoreTerm = term;
    curScoreYearStr = year;
    curScoreTermStr = term=="0"?"全部学期":"第$term学期";
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
    return Container(
      padding: EdgeInsets.all(spaceCardMarginTB),
      alignment: Alignment.center,
      child: loadingAnimationIOS(),
    );
  }
  Widget infoView(){
    int _crossFadeStateIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: <Widget>[
            Global.scoreInfo.data!=null&&Global.scoreInfo.data.isNotEmpty?Column(
              children: [
                Wrap(
                  runSpacing: spaceCardMarginTB,
                    children: Global.scoreInfo.data.map((item){
                      return chengjiCard(
                        _crossFadeStateIndex++,
                        courseName: item.courseName,
                        xuefen: item.xuefen,
                        jidian: item.jidian.toString(),
                        zongping: item.zongping,
                        type: item.type??'',
                        scoreDetail: item.scoreDetail,);
                    }).toList()
                ),
              ],
            ):Container(),
            SizedBox(height: ScreenUtil().setSp(300),),
          ],
        ),
      ),
    );
  }
  Widget infoEmptyView(){
    return Container(
      height: MediaQuery.of(context).size.height/2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.main40("∑(っ°Д°;)っ没有本学期的成绩",),
            FlyText.mini30("（ 换个学期试一试 ？） "),
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
        child = Global.scoreInfo.data.isEmpty?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }

  @override
  bool get wantKeepAlive => true;
}