import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/import_score_new_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/utils/score_sort.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/import_button.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_card/score_card.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_filter_console.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_profile.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/search_bar.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:flying_kxz/ui/focus.dart';
import 'package:flying_kxz/ui/scroll.dart';
import 'package:provider/provider.dart';
import '../../../../../ui/ui.dart';
import '../../../../../util/logger/log.dart';
import '../../../../../util/security/security.dart';
import 'model/score_provider.dart';
import 'utils/score_prefs.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ScorePrefs.init();
      _initScoreFromLocal();
    });
  }

  // 存储数据到本地
  _saveScoreToLocal(List<Map<String,dynamic>> list){
    ScorePrefs.scoreList = jsonEncode(list);
  }

  // 存储导入时间
  _saveImportTime(){
    ScorePrefs.scoreImportTime = DateTime.now().toString().substring(0, 16);
    scoreProvider.importTime = ScorePrefs.scoreImportTime;
  }

  // 从本地初始化数据
  _initScoreFromLocal(){
    // 初始化成绩数据
    String scoreList = ScorePrefs.scoreList;
    if(scoreList == null) return;
    List<dynamic> list = jsonDecode(scoreList);
    list = list.map((e) => e as Map<String,dynamic>).toList();
    scoreProvider.setAndCalScoreList(list);
    // 初始化导入时间
    if(ScorePrefs.scoreImportTime != null){
      scoreProvider.importTime = ScorePrefs.scoreImportTime;
    }
  }

  // 导入成绩
  _import() async {
    List<Map<String, dynamic>> result = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => ImportScoreNewPage()));
    if (result == null || result.isEmpty) return;
    scoreProvider.setAndCalScoreList(result);
    Future.delayed(Duration(milliseconds: 500), () {
      scoreProvider.toggleShowConsole();
    });
    showToast("🎉导入成功！");
    _saveScoreToLocal(result); // 存储成绩数据到本地
    _saveImportTime(); // 存储导入时间到本地
    Logger.log("Score", "提取,成功",
        {"info": SecurityUtil.base64Encode(result.toString())});
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ScoreProvider(),
      builder: (context, child) {
        scoreProvider = Provider.of<ScoreProvider>(context);
        return Scaffold(
          appBar: buildAppBar(context),
          body: FlyUnfocus(
            context,
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      buildTop(context),
                      SizedBox(height: spaceCardMarginTB,),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadiusValue),
                          child: FlyScrollView(
                            controller: scoreProvider.scrollController,
                            child: Column(
                              children: [
                                ScoreSearchBar(onChanged: (value){
                                  scoreProvider.search(value);
                                }),
                                buildConsoleArea(context),
                                buildImportTime(),
                                buildScoreList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FlyAnimatedCrossFade(
                    alignment: Alignment.bottomCenter,
                    firstChild: ScoreImportButton(context: context, onTap: () => _import()),
                    secondChild: Container(),
                    showSecond: scoreProvider.showConsole,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildImportTime(){
    return scoreProvider.importTime == null
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
            child: FlyText.miniTip30("导入时间：" + scoreProvider.importTime),
          );
  }

  Widget buildScoreList(){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: scoreProvider.scoreListLength,
      itemBuilder: (context, index) {
        if(scoreProvider.inSearchResult(index)){
          double bottomPadding = (index == scoreProvider.scoreListLength - 1)
              ? spaceCardPaddingTB + 200
              : spaceCardPaddingTB;
          return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
            child: ScoreCard(
                scoreItem: scoreProvider.getScoreItem(index),
                showFilterView: scoreProvider.showFilterView,
                onFilterChange: (value) {
                  scoreProvider.toggleFilter(index);
                },
                showRateView: scoreProvider.showRateView,
                onRateChange: (rate) {
                  scoreProvider.setRate(index, rate);
                }
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }


  Widget buildConsoleArea(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
    child: FlyAnimatedCrossFade(
      showSecond: scoreProvider.showConsole,
      firstChild: Container(),
      secondChild: ScoreFilterConsole(),
    ),
  );

  Widget buildAppBar(BuildContext context) {
    return FlyAppBar(context, '成绩（需内网或VPN）');
  }

  Widget buildTop(BuildContext context) => ScoreProfile(
        jiaquan: scoreProvider.jiaquanTotal,
        jidian: scoreProvider.jidianTotal,
      );
}
