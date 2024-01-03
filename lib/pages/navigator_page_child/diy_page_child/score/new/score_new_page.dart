import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/import_score_new_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/import_button.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_card.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/top_area.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/ui.dart';
import '../../../../../util/logger/log.dart';
import '../../../../../util/security/security.dart';
import 'model/score_item.dart';
import 'model/score_provider.dart';

void toScoreNewPage(BuildContext context) {
  Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => ScoreNewPage()));
}

class ScoreNewPage extends StatefulWidget {
  const ScoreNewPage({Key key});

  @override
  State<ScoreNewPage> createState() => _ScoreNewPageState();
}

class _ScoreNewPageState extends State<ScoreNewPage> {
  ThemeProvider themeProvider;
  ScoreProvider scoreProvider;

  // TODO: 记得补全
  void _toSetPage() {
    print("toSetPage");
  }

  // TODO: 记得补全
  void _showHelp() {

  }

  // TODO: 记得补全
  _import() async {
    List<Map<String,dynamic>> result = await Navigator.push(
        context, CupertinoPageRoute(builder: (context) => ImportScoreNewPage()));
    if (result == null || result.isEmpty) return;
    scoreProvider.assignmentConversionAndCalculation(result);
    Logger.log("Score", "提取,成功", {"info": SecurityUtil.base64Encode(result.toString())});
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ScoreProvider(),
      builder: (context, child) {
        scoreProvider = Provider.of<ScoreProvider>(context);
        return Scaffold(
          appBar: FlyAppBar(context, '成绩（需内网或VPN）', actions: [
            _buildActionIconButton(Icons.settings,
                onPressed: () => _toSetPage()),
            _buildActionIconButton(Icons.help_outline,
                onPressed: () => _showHelp())
          ]),
          body: Padding(
            padding: EdgeInsets.fromLTRB(
              spaceCardMarginRL, 0, spaceCardMarginRL, 0),
            child: Column(
              children: [
                // 顶部区域
                FlyContainer(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      boxShadow: [boxShadowMain]),
                  child: Column(
                    children: [
                      ScoreProfile(
                        showFilter: false,
                        jiaquan: "100.0",
                        jidian: "5.00",
                      ),
                    ],
                  ),
                ),
                // 下面
                Expanded(
                  child: Wrap(
                    runSpacing: spaceCardMarginTB,
                    children: [
                      Container(),
                      ScoreCard(scoreItem: ScoreItem.stubNormal()),
                      ScoreCard(scoreItem: ScoreItem.stubNormal()),
                      ScoreCard(scoreItem: ScoreItem.stubSpecial()),

                      ScoreImportButton(context: context, onTap: () => _import())
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget scoreCard(ScoreItem scoreItem) {
  //   //卡片主题色
  //   // Color colorCard;
  //   // int zongpingInt;
  //   // if (isNumeric(zongping)) {
  //   //   zongpingInt = int.parse(zongping);
  //   //   if (zongpingInt >= 90) {
  //   //     colorCard = Colors.deepOrangeAccent;
  //   //   } else if (zongpingInt >= 80) {
  //   //     colorCard = Colors.blue;
  //   //   } else if (zongpingInt >= 60) {
  //   //     colorCard = Colors.green;
  //   //   } else {
  //   //     colorCard = Colors.grey;
  //   //   }
  //   // } else {
  //   //   zongpingInt = 100;
  //   //   colorCard = Colors.deepOrangeAccent;
  //   //   zongping = zongping.substring(0);
  //   // }
  //   //圆形进度指示器
  //   Widget progressIndicator({@required dynamic value,Color color = Colors.grey}) => Container(
  //     child: Container(
  //       margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL * 0.8, 0),
  //       child: CircularPercentIndicator(
  //         radius: fontSizeMain40 * 1.5,
  //         lineWidth: 3.0,
  //         animation: false,
  //         animationDuration: 800,
  //         percent: value / 100.0,
  //         center: FlyText.main40(value.toString(),
  //             color: color, fontWeight: FontWeight.bold),
  //         circularStrokeCap: CircularStrokeCap.round,
  //         progressColor: color,
  //         backgroundColor: Theme.of(context).disabledColor,
  //       ),
  //     ),
  //   );
  //   //水平内容
  //   Widget _rowContent(String title, String content,Color color) {
  //     return Row(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         FlyText.miniTip30(
  //           "$title：",
  //         ),
  //         FlyText.main35(content, color: color)
  //       ],
  //     );
  //   }
  //
  //   //垂直内容
  //   Widget _columnContent(String title, String content,Color color) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         FlyText.miniTip30(title),
  //         SizedBox(
  //           height: ScreenUtil().setWidth(10),
  //         ),
  //         Text(
  //           content,
  //           style: TextStyle(fontSize: fontSizeMini38, color: color),
  //         )
  //       ],
  //     );
  //   }
  //
  //   //主体
  //   return Container(
  //     margin: EdgeInsets.fromLTRB(0, 0,
  //         0, spaceCardMarginTB),
  //     padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
  //         spaceCardPaddingRL, spaceCardPaddingTB),
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(borderRadiusValue),
  //         color: Theme.of(context).cardColor,
  //         boxShadow: [boxShadowMain]),
  //     child: InkWell(
  //       onTap: () {
  //       },
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               progressIndicator(value: 100.0,color: Colors.grey),
  //               //进度圈右侧信息区域
  //               Expanded(
  //                 flex: 3,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: <Widget>[
  //                     //课程名   总评:100
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                             child: FlyText.main35(scoreItem.courseName,
  //                                 fontWeight: FontWeight.bold)),
  //                         FlyText.mini30(
  //                           scoreItem.type,
  //                           color: scoreItem.type == '正常考试' ? colorMain : Colors.red,
  //                         )
  //                       ],
  //                     ),
  //                     Divider(
  //                       height: fontSizeMini38 / 1.5,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: <Widget>[
  //                         Expanded(
  //                           child: _rowContent('学分', scoreItem.xuefen.toString(),Colors.grey),
  //                         ),
  //                         Expanded(
  //                           child: _rowContent('绩点', scoreItem.jidian.toString(),Colors.grey),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               //筛选切换
  //               AnimatedCrossFade(
  //                 alignment: Alignment.topCenter,
  //                 firstCurve: Curves.easeOutCubic,
  //                 secondCurve: Curves.easeOutCubic,
  //                 sizeCurve: Curves.easeOutCubic,
  //                 firstChild: Container(
  //                   height: fontSizeMini38 * 3,
  //                 ),
  //                 secondChild: Container(
  //                   padding: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
  //                   height: fontSizeMini38 * 3,
  //                   child: CupertinoSwitch(
  //                       activeColor: themeProvider.colorMain.withAlpha(200),
  //                       value: scoreItem.filtered,
  //                       onChanged: (v) {
  //                         // setState(() {
  //                         //   if (isNumeric(zongping)) {
  //                         //     scoreFilter[curIndex] = !scoreFilter[curIndex];
  //                         //     _calcuTotalScore();
  //                         //   } else {
  //                         //     if (ScoreMap.data[zongping] == null) {
  //                         //       showToast(
  //                         //           '特殊成绩"$zongping"的绩点和总评未定义\n请点击右上角小齿轮添加定义',
  //                         //           duration: 5);
  //                         //     } else {
  //                         //       scoreFilter[curIndex] = !scoreFilter[curIndex];
  //                         //       _calcuTotalScore();
  //                         //     }
  //                         //   }
  //                         // });
  //                       }),
  //                 ),
  //                 duration: Duration(milliseconds: 200),
  //                 crossFadeState: scoreItem.filtered
  //                     ? CrossFadeState.showSecond
  //                     : CrossFadeState.showFirst,
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionIconButton(IconData iconData,
      {Key key, VoidCallback onPressed}) {
    return IconButton(
        key: key,
        icon: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed);
  }
}
