import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_card/score_rate.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_container.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../ui/ui.dart';
import '../../../model/score_item.dart';

typedef void ScoreCardFilterChange(bool value);
typedef void ScoreCardRateChange(double rate);

class ScoreCard extends StatefulWidget {
  final ScoreItem scoreItem;
  final bool showFilterView;
  final ScoreCardFilterChange onFilterChange;
  final bool showRateView;
  final ScoreCardRateChange onRateChange;

  const ScoreCard(
      {Key key, @required this.scoreItem, this.showFilterView = false,this.showRateView = false,this.onRateChange,this.onFilterChange})
      : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  ThemeProvider themeProvider;
  Color colorCard;
  double zongpingDouble = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Color getCardColor(double score) {
    if (score >= 90) {
      return Colors.deepOrangeAccent;
    } else if (score >= 80) {
      return Colors.blue;
    } else if (score >= 60) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  void setFilter(bool value) {
    if(widget.onFilterChange!=null){
      widget.onFilterChange(value);
    }
  }

  void setRate(double rate){
    if(widget.onRateChange!=null){
      widget.onRateChange(rate);
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    colorCard = getCardColor(widget.scoreItem.zongpingDouble);
    return ScoreContainer(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
          spaceCardPaddingRL, spaceCardPaddingTB),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              progressIndicator(item: widget.scoreItem, color: colorCard),
              //进度圈右侧信息区域
              Expanded(
                flex: 3,
                child: buildInfoArea(),
              ),
              //筛选切换
              buildFilterNewView()
            ],
          ),
          FlyAnimatedCrossFade(
            showSecond: widget.showRateView,
            firstChild: Container(),
            secondChild: Column(
              children: [
                Divider(),
                ScoreRateView(
                  initRate: widget.scoreItem.rate,
                  onRateChange: setRate,
                )
              ],
            ),
          )
        ],
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
            Expanded(child: buildCourseName(widget.scoreItem.courseName)),
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
              child: buildXuefen(widget.scoreItem.xuefen.toString())
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
      FlyText.main35(text, fontWeight: FontWeight.bold,maxLine: 2,);

  Widget buildFilterNewView()=>FlyAnimatedCrossFade(
    showSecond: widget.showFilterView,
    firstChild: SizedBox(
      height: fontSizeMini38 * 3,
    ),
    secondChild: Container(
      padding: EdgeInsets.fromLTRB(fontSizeMini38, 0, 0, 0),
      height: fontSizeMini38 * 3,
      child: CupertinoSwitch(
          activeColor: themeProvider.colorMain.withAlpha(200),
          value: widget.scoreItem.includeWeighting,
          onChanged: setFilter),
    ),
  );

  //圆形进度指示器
  Widget progressIndicator(
      {@required ScoreItem item, Color color = Colors.grey}) {
    String text = item.zongping.toString();
    if(item.zongping is! num){
      // 如果是合格类的
      text = "${item.zongping}\n${item.zongpingDouble}";
    }else{
      text = "${item.zongping}";
    }

    Widget buildText(String value){
      return Container(
        padding: EdgeInsets.all(5),
        child: FlyText.main40(
          value.toString().trim(),
          maxLine: 2,
          textAlign: TextAlign.center,
          color: color,
          fontWeight: FontWeight.bold,
          autoscaling: true,
        ),
      );
    }
    return Container(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, spaceCardPaddingRL * 0.8, 0),
        child: CircularPercentIndicator(
          radius: fontSizeMain40 * 1.5,
          lineWidth: 2.5,
          animation: false,
          animationDuration: 800,
          percent: item.zongpingDouble / 100.0,
          center: buildText(text),
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
