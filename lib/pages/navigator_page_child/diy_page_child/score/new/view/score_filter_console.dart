import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/model/score_provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/score_set_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/utils/score_sort.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_chip.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_container.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:provider/provider.dart';
import '../../../../../../ui/ui.dart';
import 'ui/score_help_dialog.dart';



class ScoreFilterConsole extends StatefulWidget {
  ScoreFilterConsole({Key key});

  @override
  State<ScoreFilterConsole> createState() => _ScoreFilterConsoleState();
}

class _ScoreFilterConsoleState extends State<ScoreFilterConsole> {
  ThemeProvider themeProvider;
  ScoreProvider scoreProvider;

  void _showHelp() => FlyDialogDIYShow(context, content: ScoreHelpDialog());
  void _toSetPage() => toScoreSetNewPage(context);

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    scoreProvider = Provider.of<ScoreProvider>(context);
    return Wrap(
      runSpacing: spaceCardMarginTB,
      children: [
        buildFilterArea(),
        buildChooseAllArea(),
        buildButtonArea()
      ],
    );
  }

  Widget buildButtonArea() => Row(
    children: [
      Expanded(child: buildConsoleSingleButton(
          title: "特殊成绩设置",
          iconData: Icons.settings,
          onTap: _toSetPage
      )),
      SizedBox(width: spaceCardMarginRL,),
      Expanded(child: buildConsoleSingleButton(
          title: "帮助",
          iconData: Icons.help_outline,
          onTap: _showHelp
      )),
    ],
  );

  Widget buildChooseAllArea() => buildConsole(
      children: [
        buildConsoleRow(title: "筛选",children: [
          CupertinoSwitch(
            value: scoreProvider.showFilterView,
            onChanged: (value) {
              scoreProvider.toggleShowFilterView(value:value);
            },
            activeColor: themeProvider.colorMain,
          )
        ]),
        FlyAnimatedCrossFade(
          showSecond: scoreProvider.showFilterView,
          firstChild: Container(),
          secondChild: Column(
            children: [
              Divider(),
              buildConsoleRow(title: "全选",children: [
                CupertinoSwitch(
                  value: scoreProvider.chooseAll,
                  onChanged: (value) {
                    scoreProvider.toggleAllFilter(value);
                  },
                  activeColor: themeProvider.colorMain,
                )
              ])
            ],
          )
        )
      ]
  );


  Widget buildFilterArea() => buildConsole(
      children: [
        buildConsoleRow(title: "排序",children: [
          ScoreChip(title: "顺序",clicked: !scoreProvider.isOrder, onTap: (value){
            scoreProvider.isOrder = false;
          },),
          ScoreChip(title: "逆序",clicked: scoreProvider.isOrder,onTap: (value){
            scoreProvider.isOrder = true;
          },),
        ]),
        Divider(),
        buildConsoleRow(title: "方式",children: [
          ScoreChip(title: "名称",clicked: scoreProvider.sortWay == ScoreSortWay.name,onTap: (value){
            scoreProvider.sortWay = ScoreSortWay.name;
          },),
          ScoreChip(title: "成绩",clicked: scoreProvider.sortWay == ScoreSortWay.score,onTap: (value){
            scoreProvider.sortWay = ScoreSortWay.score;
          },),
          ScoreChip(title: "学分",clicked: scoreProvider.sortWay == ScoreSortWay.credit,onTap: (value){
            scoreProvider.sortWay = ScoreSortWay.credit;
          },),
        ]),
      ]
  );

  Widget buildConsoleSingleButton({String title,IconData iconData,GestureTapCallback onTap}) {
    Color color = Theme.of(context).primaryColor.withOpacity(0.5);
    return InkWell(
            onTap: onTap,
            child: buildConsole(
              padding: EdgeInsets.symmetric(vertical: spaceCardPaddingTB*1.5),
                children:[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData,color: color,),
                      SizedBox(width: 5,),
                      FlyText.main40(title,color: color,),
                    ],
                  )
                ]
            ),
          );
  }

  Widget buildConsole({List<Widget> children,EdgeInsetsGeometry padding}) => ScoreContainer(
      padding: padding??EdgeInsets.symmetric(vertical: spaceCardPaddingTB,horizontal: spaceCardPaddingRL*1.5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: children,
            ),
          )
        ],
      )
  );

  Widget buildConsoleRow({@required String title, List<Widget> children}) {
    Color leadingTextColor = Theme.of(context).primaryColor.withOpacity(0.5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FlyText.main40(
              title,
              color: leadingTextColor,
            )
          ],
        ),
        Wrap(
          spacing: spaceCardMarginRL,
          children: children,
        )
      ],
    );
  }
}
