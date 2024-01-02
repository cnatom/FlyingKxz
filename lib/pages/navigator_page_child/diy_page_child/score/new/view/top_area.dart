import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/ui.dart';

class ScoreProfile extends StatefulWidget {
  final bool showFilter;
  final String jiaquan;
  final String jidian;
  const ScoreProfile({Key key,this.showFilter = false, this.jiaquan, this.jidian});
  @override
  State<ScoreProfile> createState() => _ScoreProfileState();
}

class _ScoreProfileState extends State<ScoreProfile> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                    Text(widget.jiaquan??"00.00",
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
                    Text(widget.jidian??"0.00",
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
                  if(widget.showFilter) return selectAllChip();
                  return expandChip();
                }),
                filterChip()
              ],
            ),
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
