import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/import_score_new_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/import_button.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_card.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_filter_console.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_help_dialog.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_profile.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_container.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/ui.dart';
import '../../../../../util/logger/log.dart';
import '../../../../../util/security/security.dart';
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
  final GlobalKey topSizeKey = GlobalKey();

  // TODO: 记得补全
  void _toSetPage() {

  }

  void showFilter() => scoreProvider.toggleShowFilterView();

  _import() async {
    List<Map<String, dynamic>> result = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => ImportScoreNewPage()));
    if (result == null || result.isEmpty) return;
    scoreProvider.setAndCalScoreList(result);
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
          body: Padding(
            padding:
                EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    // 顶部区域
                    buildTopArea(context),
                    SizedBox(
                      height: spaceCardMarginTB,
                    ),
                    buildConsoleArea(context),
                    Expanded(
                      child: buildScoreListArea(),
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
        );
      },
    );
  }

  Widget buildScoreListArea() {
    return ListView.builder(
                    itemCount: scoreProvider.scoreListLength,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, 0, spaceCardPaddingTB),
                        child: ScoreCard(
                          scoreItem: scoreProvider.getScoreItem(index),
                          showFilterView: scoreProvider.showFilterView,
                          onFilterChange: (value) {
                            scoreProvider.toggleFilter(index);
                          },
                        ),
                      );
                    });
  }

  Widget buildConsoleArea(BuildContext context) => FlyAnimatedCrossFade(
    showSecond: scoreProvider.showConsole,
    firstChild: Container(),
    secondChild: Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, spaceCardMarginTB),
      child: ScoreFilterConsole(),
    ),
  );

  Widget buildAppBar(BuildContext context) {
    return FlyAppBar(context, '成绩（需内网或VPN）');
  }

  Widget buildTopArea(BuildContext context) => ScoreProfile(
        jiaquan: scoreProvider.jiaquanTotal,
        jidian: scoreProvider.jidianTotal,
      );

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
