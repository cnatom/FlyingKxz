import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/import_score_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/score_info.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/score_map.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/score_set_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:flying_kxz/util/util.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../Model/prefs.dart';

//跳转到当前页面
void toScorePage(BuildContext context) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => Intro(
              padding: const EdgeInsets.all(0),
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadiusValue)),
              buttonTextBuilder: (order) => '好的',
              child: ScorePage())));
  Logger.log('Score', '进入',{});
}

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = new ScrollController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String jiaquanTotal; //总加权
  String jidianTotal; //总绩点

  List<bool> scoreFilter; //true为计入总分 false不计入总分
  bool makeupFilter = false;
  bool showFilter = false; //是否启动筛选
  bool scoreDetailAllExpand = false; //是否全部展开闭合
  List<CrossFadeState> scoreDetailCrossFadeState = new List(); //控制详细列表的展开闭合
  bool selectAll = true;
  double opacityFloatButton = 0.0; //是否显示回到顶部按钮
  ThemeProvider themeProvider;
  var topCrossFadeState = CrossFadeState.showFirst;
  Color selectedMainColor = colorMainText;

  @override
  void initState() {
    super.initState();
    scoreFilter = [];
    ScoreMap.init();
  }

  @override
  void dispose() {
    super.dispose();
    Global.scoreInfo = new ScoreInfo();
  }

  _import() async {
    var result = await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => ImportScorePage()));
    if (result == null || result.isEmpty) return;
    _show(result);
    Logger.log("Score", "提取,成功", {"info": SecurityUtil.base64Encode(result.toString())});
  }

  _show(dynamic json) async {
    setState(() {
      jiaquanTotal = null;
      jidianTotal = null;
    });
    //发送请求
    // InquiryType type = makeupFilter?InquiryType.ScoreAll:InquiryType.Score;
    Global.scoreInfo = ScoreInfo.fromJson({'data': json});
    //打理后事
    scoreDetailCrossFadeState.clear();
    scoreFilter.clear();
    //添加开展动画控制器 并 计算总加权和总绩点
    for (int i = 0; i < Global.scoreInfo.data.length; i++) {
      scoreFilter.add(true);
      scoreDetailCrossFadeState.add(CrossFadeState.showFirst);
    }
    _calcuTotalScore();
    setState(() {});

  }

  //计算总加权和总绩点
  //学分 总评 绩点
  void _calcuTotalScore() {
    if (Global.scoreInfo.data == null) return;
    double xfjdSum = 0; //学分*绩点的和
    double xfcjSum = 0; //学分*成绩的和
    double xfSum = 0; //学分的和
    try {
      for (int i = 0; i < Global.scoreInfo.data.length; i++) {
        var cur = Global.scoreInfo.data[i];
        String zongping = cur.zongping;
        String jidian = cur.jidian;
        String xuefen = cur.xuefen;
        if (!isNumeric(zongping)) {
          if (ScoreMap.data[zongping] != null) {
            jidian = ScoreMap.data[zongping]['jidian'] ?? 'null';
            zongping = ScoreMap.data[zongping]['zongping'] ?? 'null';
          } else {
            scoreFilter[i] = false;
          }
        }
        if (scoreFilter[i] == false) continue;
        xfjdSum += double.parse(xuefen) * double.parse(jidian.toString());
        xfcjSum += double.parse(xuefen) * int.parse(zongping);
        xfSum += double.parse(xuefen);
      }
      jiaquanTotal = (xfcjSum / xfSum).toStringAsFixed(2);
      jidianTotal = (xfjdSum / xfSum).toStringAsFixed(2);
    } catch (e) {
      print(e.toString());
      jiaquanTotal = "计算失败";
      jidianTotal = "计算失败";
    }
    setState(() {});
  }

  _toSetPage() async {
    await Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ScoreSetPage()));
    _calcuTotalScore();
    setState(() {});
  }

  _introduce(BuildContext context){
    String prefsTag = "score_page_introduce";
    if(Prefs.prefs.getBool(prefsTag)==null){
      Intro.of(context).start();
      Prefs.prefs.setBool(prefsTag, true);
    }
  }

  _showHelp() {
    FlyDialogDIYShow(context,
        content: Wrap(
          children: [
            FlyText.main40(
              '【内网环境】为确保数据安全，请连接学校内的wifi或vpn进行成绩导入\n\n'
              '【加权筛选】"筛选"功能可忽略某些不计入加权的学科成绩\n\n'
              '【特殊成绩】不同学院年级对于"优秀""良好"等特殊成绩的规定不同，请参照学生手册自行修改对应的学分绩点（点击右上角齿轮）\n\n'
              '【全选操作】点击筛选后还可进行"全选""取消全选"操作，你注意到了吗？\n',
              maxLine: 100,
            ),
            FlyText.miniTip30(
              "仅供参考，出现意外情况开发者概不负责",
              maxLine: 100,
            )
          ],
        ));
  }




  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: FlyAppBar(context, '成绩（需内网或VPN）', actions: [
        IntroStepBuilder(
          order: 4,
          text: '在这里设置"优秀""良好"等评级的具体成绩',
          builder: (context,key) =>_buildActionIconButton(Icons.settings,key: key,onPressed: ()=>_toSetPage())
        ),
        _buildActionIconButton(Icons.help_outline,onPressed: ()=>_showHelp())
      ]),
      body: Column(
        children: [
          _buildControlCard(context),
          SizedBox(
            height: spaceCardMarginTB,
          ),
          Expanded(
            child: _buildScoreList(),
          )
        ],
      ),
    );
  }

  // 成绩列表
  Scrollbar _buildScoreList() {
    return Scrollbar(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  spaceCardMarginRL, 0, spaceCardMarginRL, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                child: curView(),
              ),
            ),
          );
  }

  // 上方控制中心
  FlyContainer _buildControlCard(BuildContext context) {
    return FlyContainer(
          margin:
              EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(borderRadiusValue),
              boxShadow: [boxShadowMain]),
          child: Column(
            children: [
              topArea(),
              _searchBarButton('点击导入成绩', "自动计算，自由筛选", onTap: () => _import()),
            ],
          ),
        );
  }

  IconButton _buildActionIconButton(IconData iconData, {Key key,VoidCallback onPressed}) {
    return IconButton(
      key: key,
          icon: Icon(
            iconData,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: onPressed);
  }

  Widget _searchBarButton(String title, String content,
      {GestureTapCallback onTap}) {
    return IntroStepBuilder(
      order: 1,
      text: "从教务系统导入成绩",
      onWidgetLoad: ()=>_introduce(context),
      builder: (context,key) {
        return Container(
          key: key,
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            child: InkWell(
              splashColor: Colors.black12,
              borderRadius: BorderRadius.circular(10),
              highlightColor: Colors.black12,
              onTap: onTap,
              child: Container(
                height: fontSizeMini38 * 3.5,
                padding: EdgeInsets.fromLTRB(
                    spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FlyText.main35(
                          title,
                        ),
                        FlyText.miniTip30(
                          content,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.cloud_download_outlined,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  //总绩点 + 展开闭合组件
  Widget topArea() {
    //展开闭合组件
    Widget expandChip({Key key}) {
      return InkWell(
        key: key,
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => FlyWebView(
                    title: "成绩明细查询（暂不支持导出）",
                    check: true,
                    initialUrl:
                        "http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxDgXsxmcj.html?gnmkdm=N305007&layout=default",
                  )));
        },
        child: Container(
          height: fontSizeMini38 * 3,
          child: Row(
            children: [
              // scoreDetailAllExpand?FlyText.main35('详细信息',):FlyText.main35('简略信息',),
              FlyText.main35(
                '成绩明细',
              ),
              Icon(
                Icons.chevron_right,
                size: fontSizeMini38,
              )
              // scoreDetailAllExpand?Icon(Icons.expand_more,size: fontSizeMini38,):Icon(Icons.expand_less,size: fontSizeMini38),
            ],
          ),
        ),
      );
    }

    Widget filterChip({Key key}) {
      return InkWell(
        key: key,
        onTap: () {
          setState(() {
            showFilter = !showFilter;
          });
        },
        child: Container(
          height: fontSizeMini38 * 3,
          child: Row(
            children: [
              FlyText.main35('筛选', fontWeight: FontWeight.w300),
              Icon(
                MdiIcons.filterOutline,
                size: fontSizeMini38 * 1.2,
              ),
            ],
          ),
        ),
      );
    }

    Widget selectAllChip() {
      return InkWell(
        onTap: () {
          setState(() {
            selectAll = !selectAll;
            scoreFilter.fillRange(0, scoreFilter.length, selectAll);
            _calcuTotalScore();
          });
        },
        child: Container(
          height: fontSizeMini38 * 3,
          child: Row(
            children: [
              selectAll
                  ? FlyText.main35(
                      '取消全选',
                    )
                  : FlyText.main35(
                      '全部选择',
                    ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding:
          EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
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
                    FlyText.mini30(
                      "加权：",
                    ),
                    Text(
                      jiaquanTotal != null && jiaquanTotal != 'NaN'
                          ? jiaquanTotal
                          : "00.00",
                      style: TextStyle(
                          color: themeProvider.colorMain,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeMain40),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlyText.mini30(
                      "绩点：",
                    ),
                    Text(
                      jidianTotal != null && jiaquanTotal != 'NaN'
                          ? jidianTotal
                          : "0.00",
                      style: TextStyle(
                          color: themeProvider.colorMain,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeMain40),
                    )
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
                Builder(builder: (context){
                  if(showFilter) return selectAllChip();
                  return IntroStepBuilder(
                    order: 2,
                    text: "查看具体的平时分与考试分",
                    builder: (context,key) {
                      return expandChip(key: key);
                    }
                  );
                }),
                IntroStepBuilder(
                  order: 3,
                  text: "如果某些学科成绩不计入加权\n点击这里将其筛选吧",
                  builder: (context,key) => filterChip(key: key)
                ),
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
    return double.tryParse(s) != null;
  }

  //成绩卡片
  Widget scoreCard(
    int curIndex, {
    String courseName = 'CourseName',
    String xuefen = '0',
    String jidian = '0',
    String zongping = '0',
    String type = '',
    List<ScoreDetail> scoreDetail,
  }) {
    //卡片主题色
    Color colorCard;
    int zongpingInt;
    if (isNumeric(zongping)) {
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
            margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL * 0.8, 0),
            child: CircularPercentIndicator(
              radius: fontSizeMain40 * 1.5,
              lineWidth: 3.0,
              animation: false,
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
          FlyText.miniTip30(
            "$title：",
          ),
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
      margin: EdgeInsets.fromLTRB(0, 0,
          0, spaceCardMarginTB),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
          spaceCardPaddingRL, spaceCardPaddingTB),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor,
          boxShadow: [boxShadowMain]),
      child: InkWell(
        onTap: () {
          // //点击展开
          // scoreDetailCrossFadeState[curIndex] =
          // scoreDetailCrossFadeState[curIndex] ==
          //     CrossFadeState.showFirst
          //     ? CrossFadeState.showSecond
          //     : CrossFadeState.showFirst;
          // setState(() {});
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
                              child: FlyText.main35(courseName,
                                  fontWeight: FontWeight.bold)),
                          FlyText.mini30(
                            type,
                            color: type == '正常考试' ? colorMain : Colors.red,
                          )
                        ],
                      ),
                      Divider(
                        height: fontSizeMini38 / 1.5,
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
                  firstChild: Container(
                    height: fontSizeMini38 * 3,
                  ),
                  secondChild: Container(
                    padding: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
                    height: fontSizeMini38 * 3,
                    child: CupertinoSwitch(
                        activeColor: themeProvider.colorMain.withAlpha(200),
                        value: scoreFilter[curIndex],
                        onChanged: (v) {
                          setState(() {
                            if (isNumeric(zongping)) {
                              scoreFilter[curIndex] = !scoreFilter[curIndex];
                              _calcuTotalScore();
                            } else {
                              if (ScoreMap.data[zongping] == null) {
                                showToast(
                                    '特殊成绩"$zongping"的绩点和总评未定义\n请点击右上角小齿轮添加定义',
                                    duration: 5);
                              } else {
                                scoreFilter[curIndex] = !scoreFilter[curIndex];
                                _calcuTotalScore();
                              }
                            }
                          });
                        }),
                  ),
                  duration: Duration(milliseconds: 200),
                  crossFadeState: showFilter
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                )
              ],
            ),
            //成绩明细 期终 期末 总评
            scoreDetailCrossFadeState.isNotEmpty
                ? AnimatedCrossFade(
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
                        FlyWidgetBuilder(
                          whenFirst: makeupFilter,
                          firstChild: Center(
                            child: FlyText.mainTip35("包含补考成绩时，无法获取成绩明细"),
                          ),
                          secondChild: scoreDetail != null
                              ? Row(
                                  children: scoreDetail.map((item) {
                                  return Expanded(
                                    child: _columnContent(item.name.toString(),
                                        item.score.toString()),
                                  );
                                }).toList())
                              : Container(),
                        )
                      ],
                    ),
                    duration: Duration(milliseconds: 300),
                    crossFadeState: scoreDetailCrossFadeState[curIndex],
                  )
                : Container()
          ],
        ),
      ),
    );
  }



  Widget nullView() {
    return Container();
  }

  Widget loadingView() {
    return Container(
      padding: EdgeInsets.all(spaceCardMarginTB),
      alignment: Alignment.center,
      child: loadingAnimationIOS(),
    );
  }

  Widget infoView() {
    int _crossFadeStateIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
      child: ListView.builder(
          itemCount: Global.scoreInfo.data.length,
          itemBuilder: (context, index) {
            var item = Global.scoreInfo.data[index];
            return scoreCard(
              _crossFadeStateIndex++,
              courseName: item.courseName,
              xuefen: item.xuefen,
              jidian: item.jidian.toString(),
              zongping: item.zongping,
              type: item.type ?? '',
              scoreDetail: item.scoreDetail,
            );
          }),
    );
  }

  Widget infoEmptyView() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.main40(
              "∑(っ°Д°;)っ没有本学期的成绩",
            ),
            FlyText.mini30("（ 换个学期试一试 ？） "),
          ],
        ),
      ),
    );
  }

  Widget curView() {
    Widget child = nullView();
    if (Global.scoreInfo.data != null) {
      child = Global.scoreInfo.data.isEmpty ? infoEmptyView() : infoView();
    }
    return child;
  }

  @override
  bool get wantKeepAlive => true;
}
