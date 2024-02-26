import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../../ui/ui.dart';
import '../model/score_provider.dart';

typedef FilterCallback = bool Function(bool value);

class ScoreProfile extends StatefulWidget {
  final double jiaquan;
  final double jidian;

  const ScoreProfile({Key key, this.jiaquan, this.jidian});

  @override
  State<ScoreProfile> createState() => _ScoreProfileState();
}

class _ScoreProfileState extends State<ScoreProfile> {
  ThemeProvider themeProvider;
  ScoreProvider scoreProvider;

  clickFilterChip() => scoreProvider.toggleShowConsole();

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    scoreProvider = Provider.of<ScoreProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: spaceCardPaddingTB * 2,
          horizontal: spaceCardPaddingRL * 1.5),
      decoration: BoxDecoration(
        color: themeProvider.colorMain,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: buildRowContent("加权", widget.jiaquan.toStringAsFixed(2)??'0.00',)),
          Expanded(child: buildRowContent("绩点", widget.jidian.toStringAsFixed(2)??'0.00',)),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: buildSwitchButton(),
          )),
        ],
      ),
    );
  }

  Widget buildSwitchButton() => InkWell(
    onTap: clickFilterChip,
    child: FlyAnimatedCrossFade(
      firstChild: buildButton(isClick: false),
      secondChild: buildButton(isClick: true),
      showSecond: scoreProvider.showConsole,
    ),
  );

  Widget buildButton({bool isClick = false}){
    Color backColor = isClick?Colors.white.withOpacity(0.9):Colors.white.withOpacity(0.2);
    Color iconColor = isClick?themeProvider.colorMain:Colors.white;
    IconData iconData = isClick?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down;
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: backColor),
      child: Icon(
        iconData,
        color: iconColor,
        size: 30,
      ),
    );
  }

  Widget buildRowContent(String title, String content) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlyText.mini30(
            "$title：",
            color: Colors.white,
          ),
          Text(
            content,
            key: Key(content),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(90)),
          )
        ],
      ),
    );
  }

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

  Widget filterChip({Key key, GestureTapCallback onTap}) {
    return InkWell(
      key: key,
      onTap: onTap,
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

  Widget selectAllChip({GestureTapCallback onTap, bool selectAll = false}) {
    return InkWell(
      onTap: onTap,
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
}
