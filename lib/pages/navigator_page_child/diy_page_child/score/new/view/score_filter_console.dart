import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_chip.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_container.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/ui.dart';
enum SortType { ascending, descending }
enum SortWay { name, score, credit }


class ScoreFilterConsole extends StatefulWidget {
  ScoreFilterConsole({Key key});

  @override
  State<ScoreFilterConsole> createState() => _ScoreFilterConsoleState();
}

class _ScoreFilterConsoleState extends State<ScoreFilterConsole> {
  ThemeProvider themeProvider;
  SortType sortType = SortType.ascending;
  SortWay sortWay = SortWay.name;
  bool clickButton = false;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Wrap(
      runSpacing: spaceCardMarginTB,
      children: [
        buildConsole(
          children: [
            buildConsoleRow(title: "排序",children: [
              ScoreChip(title: "顺序",clicked: clickButton, onTap: (value){
                clickButton = value;
              },),
              ScoreChip(title: "逆序",onTap: (value){},),
            ]),
            Divider(),
            buildConsoleRow(title: "方式",children: [
              ScoreChip(title: "名称",onTap: (value){},),
              ScoreChip(title: "成绩",onTap: (value){},),
              ScoreChip(title: "学分",onTap: (value){},),
            ]),
          ]
        ),
        buildConsole(
            children: [
              buildConsoleRow(title: "排序",children: [
                Container(
                  child: CupertinoSwitch(
                    value: clickButton,
                    onChanged: (value) {
                      clickButton = value;

                    },
                    activeColor: themeProvider.colorMain,
                  ),
                )
              ]),
            ]
        ),

      ],
    );
  }

  Widget buildConsole({List<Widget> children}) {
    return ScoreContainer(
        padding: EdgeInsets.symmetric(vertical: spaceCardPaddingTB,horizontal: spaceCardPaddingRL*1.5),
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
  }

  Widget buildConsoleRow({@required String title, List<Widget> children}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FlyText.main40(
              title,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
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
