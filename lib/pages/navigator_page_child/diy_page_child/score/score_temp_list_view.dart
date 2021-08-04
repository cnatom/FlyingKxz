
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/bottom_sheet.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/exam_data.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam/exam_page.dart';
import 'package:provider/provider.dart';

class ScoreTempListView extends StatefulWidget {
  List<Map<String, dynamic>> list;
  ScoreTempListView({this.list});
  @override
  _ScoreTempListViewState createState() => _ScoreTempListViewState();
}

class _ScoreTempListViewState extends State<ScoreTempListView> {
  List<Map<String, dynamic>> pre = [];
  List<Map<String, dynamic>> cur = [];
  ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    pre.addAll(widget.list);
    cur.addAll(widget.list);
  } //结束时间
  _clear(){
    setState(() {
      cur.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FlyBottomSheetScaffold(context,
          onCancel: ()=>_clear(),//返回先前的数据
          onDetermine: ()=>Navigator.pop(context,cur),//返回更改后的数据
          leftText: "清空",
          title: "成绩列表 ("+cur.length.toString()+')',
          child:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Wrap(
              runSpacing: spaceCardMarginBigTB,
              children: [for(int i = 0;i<cur.length;i++) _buildItem(cur[i],i)],
            ),
          )
      ),
    );
  }
  Widget _buildItem(Map<String,dynamic> item,int index){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, 0, spaceCardPaddingTB),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlyText.title45(item['courseName'],maxLine: 2,),
                    SizedBox(height: 3,),
                    FlyText.main35(item['type']+'  '+item['zongping'],color: item['type']=="正常考试"?Color(0xff8d8d93):Colors.red.withOpacity(0.9),)
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.delete_outline_rounded),onPressed: ()=>deleteElement(index),)
            ],
          ),
        ),
        Divider()
      ],
    );
  }
  deleteElement(int index){
    setState(() {
      cur.removeAt(index);
    });
  }

}
