import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/ui.dart';
import '../model/score_item.dart';

class ScoreCard extends StatefulWidget {
  final ScoreItem scoreItem;
  final bool showFilterView;

  const ScoreCard(
      {Key key, @required this.scoreItem, this.showFilterView = true})
      : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  ThemeProvider themeProvider;
  ScoreItem scoreItem;
  Color colorCard;
  double zongpingDouble = 0.0;

  @override
  void initState() {
    super.initState();
    scoreItem = widget.scoreItem;
    colorCard = getCardColor(scoreItem);
  }

  // 辅助函数，根据总评分数决定卡片颜色
  Color getCardColor(ScoreItem scoreItem) {
    if (scoreItem.zongping is num) {
      double zongpingInt = double.parse(scoreItem.zongping.toString());
      if (zongpingInt >= 90) {
        return Colors.deepOrangeAccent;
      } else if (zongpingInt >= 80) {
        return Colors.blue;
      } else if (zongpingInt >= 60) {
        return Colors.green;
      } else {
        return Colors.grey;
      }
    } else {
      return Colors.deepOrangeAccent; // 默认颜色，如果无法解析成数字
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
          spaceCardPaddingRL, spaceCardPaddingTB),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor,
          boxShadow: [boxShadowMain]),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            progressIndicator(value: scoreItem.zongping, color: colorCard),
            //进度圈右侧信息区域
            Expanded(
              flex: 3,
              child: buildInfoArea(),
            ),
            //筛选切换
            buildFilterView()
          ],
        ),
      ),
    );
  }

  Widget buildInfoArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        //课程名   总评:100
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildCourseName(widget.scoreItem.courseName),
            buildExamType(widget.scoreItem.type)
          ],
        ),
        Divider(
          height: fontSizeMini38 / 1.5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: buildXuefen(widget.scoreItem.xuefen.toString()),
            ),
            Expanded(
              child: buildJidian(widget.scoreItem.jidian.toString()),
            ),
          ],
        )
      ],
    );
  }

  Widget buildJidian(String text) => _rowContent('绩点', text, colorCard);

  Widget buildXuefen(String text) => _rowContent('学分', text, colorCard);

  Widget buildExamType(String type) => FlyText.mini30(
        type,
        color: type == '正常考试' ? colorMain : Colors.red,
      );

  Widget buildCourseName(String text) =>
      FlyText.main35(text, fontWeight: FontWeight.bold);

  Widget buildFilterView() => AnimatedCrossFade(
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
          value: widget.scoreItem.includeWeighting,
          onChanged: (v) {

            // setState(() {
            //   if (isNumeric(zongping)) {
            //     scoreFilter[curIndex] = !scoreFilter[curIndex];
            //     _calcuTotalScore();
            //   } else {
            //     if (ScoreMap.data[zongping] == null) {
            //       showToast(
            //           '特殊成绩"$zongping"的绩点和总评未定义\n请点击右上角小齿轮添加定义',
            //           duration: 5);
            //     } else {
            //       scoreFilter[curIndex] = !scoreFilter[curIndex];
            //       _calcuTotalScore();
            //     }
            //   }
            // });
          }),
    ),
    duration: Duration(milliseconds: 200),
    crossFadeState: widget.showFilterView
        ? CrossFadeState.showSecond
        : CrossFadeState.showFirst,
  );

  //圆形进度指示器
  Widget progressIndicator(
      {@required dynamic value, Color color = Colors.grey}) {
    double valueDouble = double.tryParse(value.toString()) ?? 100.0;
    return Container(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL * 0.8, 0),
        child: CircularPercentIndicator(
          radius: fontSizeMain40 * 1.5,
          lineWidth: 3.0,
          animation: false,
          animationDuration: 800,
          percent: valueDouble / 100.0,
          center: FlyText.main40(
            // 删除前后的空格
            value.toString().trim(),
            maxLine: 1,
            color: color,
            fontWeight: FontWeight.bold,
            autoscaling: true,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: Theme.of(context).disabledColor,
        ),
      ),
    );
  }

  //水平内容
  Widget _rowContent(String title, String content, Color color) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      FlyText.miniTip30(
        "$title：",
      ),
      FlyText.main35(content, color: color)
    ],
  );

  //垂直内容
  Widget _columnContent(String title, String content, Color color) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      FlyText.miniTip30(title),
      SizedBox(
        height: ScreenUtil().setWidth(10),
      ),
      Text(
        content,
        style: TextStyle(fontSize: fontSizeMini38, color: color),
      )
    ],
  );
}
