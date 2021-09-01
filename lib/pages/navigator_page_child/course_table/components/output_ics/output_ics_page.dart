import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/output_ics/ics_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_color.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class OutputIcsPage extends StatefulWidget {
  List<CourseData> courseList;
  OutputIcsPage(this.courseList);
  @override
  _OutputIcsPageState createState() => _OutputIcsPageState();
}

class _OutputIcsPageState extends State<OutputIcsPage> {
  ThemeProvider themeProvider;
  List<CourseData> list = [];

  @override
  void initState() {
    super.initState();
    list.addAll(widget.courseList);
  }
  del(int index){
    list.removeAt(index);
    setState(() {});
  }
  outCalendar()async{
    String data = await courseToIcs(list);
    if(data==''){
      FlyDialogDIYShow(context, content: Wrap(
        runSpacing: spaceCardPaddingTB,
        children: [
          FlyTitle('ICS生成失败'),
          FlyText.main40("请检查是否为矿小助开启了文件读写权限\n未设置开学时间也可能会导致失败\n如果依然失败，请进QQ群957634136反馈",maxLine: 100,),

        ],
      ));
      return;
    }
    FlyDialogDIYShow(context, content: Wrap(
      runSpacing: spaceCardPaddingTB,
      children: [
        FlyTitle('成功生成ICS'),
        FlyText.main40("已自动复制ICS链接至剪贴板\n请参照以下步骤导入（以ios为例）",maxLine: 3,),
        FlyText.main40('1.请粘贴到系统浏览器中打开',maxLine: 3,),
        Image.asset('images/ics_help0.png'),
        Divider(),
        FlyText.main40('2.然后直接导入系统日历即可',maxLine: 3,),
        Image.asset('images/ics_help1.png')

      ],
    ));
    Clipboard.setData(ClipboardData(text: "file://$data"));
  }
  outFile()async{
    String data = await courseToIcs(list);
    Share.shareFiles(['$data'],);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, '课表导出(${list.length})'),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                buildTop(),
                buildBody(),
                SizedBox(height: MediaQuery.of(context).size.height/4,)
              ],
            ),
          ),
          _bottomBar(),

        ],
      ),
    );
  }
  Widget _bottomBar(){
    Color textColor = Theme.of(context).brightness==Brightness.light?themeProvider.colorMain:Colors.white;
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: 0,
      child: FlyContainer(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: Theme.of(context)
                .cardColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0.05,
                  color: Colors.black12.withAlpha(20)
              )
            ]),
        margin: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).padding.bottom),
        padding: EdgeInsets.fromLTRB(10,10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: ()=>outFile(),
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: textColor.withOpacity(0.1),
                ),
                child: FlyText.title45('以文件分享',fontWeight: FontWeight.bold,color: textColor,),
              ),
            ),
            InkWell(
              onTap: ()=>outCalendar(),
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: themeProvider.colorMain,
                    boxShadow: [
                      boxShadowMain
                    ]
                ),
                child: FlyText.title45('导出至日历',fontWeight: FontWeight.bold,color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildTop(){
    return InkWell(
      child: FlyContainer(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
        margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: Theme.of(context).cardColor,
            boxShadow: [
              boxShadowMain
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlyText.title45("课表还可以这么玩?"),
            Icon(Icons.chevron_right,color: Theme.of(context).primaryColor.withOpacity(0.5),)
          ],
        ),
      ),
    );
  }
  Widget buildBody(){
    return Column(
      children: [for(int i = 0;i<list.length;i++)FlyContainer(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB*1.5, spaceCardPaddingRL, spaceCardPaddingTB),
        margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: Theme.of(context).cardColor,
            boxShadow: [
              boxShadowMain
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: fontSizeTitle45,
                        width: fontSizeTitle45 / 4.5,
                        decoration: BoxDecoration(
                            color: CourseColor.fromStr(list[i].title),
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                      SizedBox(
                        width: fontSizeTitle45 * 0.6,
                      ),
                      Column(
                        children: [
                          FlyText.title45(list[i].title),

                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
                    child: Column(
                      children: [
                        list[i].location!=''?rowKbContent('地点', list[i].location):Container(),
                        list[i].teacher!=''?rowKbContent('老师', list[i].teacher):Container(),
                        list[i].credit!=''?rowKbContent('学分', list[i].credit):Container(),
                        rowKbContent('周次', CourseData.weekListToString(list[i].weekList)),
                        rowKbContent('节次', '星期${list[i].weekNum}  第${list[i].lessonNum}小节  持续${list[i].durationNum}小节')
                      ],
                    ),
                  )

                  // rowKbContent('周次', CourseData.weekListToString(list[i].weekList)),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.delete_outline_rounded), onPressed: ()=>del(i))
          ],
        ),
      )],
    );
  }
  Widget rowKbContent(
      String title, String content) {
    return Column(
      children: [
        SizedBox(height: fontSizeMini38 / 2,),
        Container(),
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: <Widget>[
            FlyText.mainTip35(
              "$title     ",
            ),
            Expanded(
              child: FlyText.main35(content, maxLine: 3),
            )
          ],
        ),

      ],
    );
  }

}
