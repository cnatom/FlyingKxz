

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/output_ics/ics_data.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_color.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import 'output_ics_help_page.dart';

class OutputIcsPage extends StatefulWidget {
  List<CourseData> courseList;
  OutputIcsPage(this.courseList);
  @override
  _OutputIcsPageState createState() => _OutputIcsPageState();
}

class _OutputIcsPageState extends State<OutputIcsPage> {
  ThemeProvider themeProvider;
  List<CourseData> list = [];
  bool outLoading = false;
  @override
  void initState() {
    super.initState();
    list.addAll(widget.courseList);
    list.sort((a, b) => a.title.compareTo(b.title));
  }
  //删除临时课程
  del(int index){
    list.removeAt(index);
    setState(() {});
  }
  //同步日历
  sync()async{
    showToast('正在同步……');
    if(list.isEmpty){
      showToast('同步失败，列表为空');
      return;
    }
    try{
      String dataPath = await courseToIcs(list);
      Map<String ,dynamic> map = Map();
      map["myfile"] = await MultipartFile.fromFile(dataPath,filename: "${Prefs.username}.ics");
      var res = await Dio().post('https://user.kxz.atcumt.com/ics/upload',data: FormData.fromMap(map),options: Options(sendTimeout: 3000,receiveTimeout: 3000,));
      if(res.statusCode==200){
        showToast('同步成功！');
        Prefs.courseIcsDate = DateTime.now().toString();
        setState(() {});
        return;
      }else{
        showToast('同步失败${res.statusCode}');
        return;
      }
    }on DioError catch(e){
      showToast('同步失败，请检查网络连接！');
      return;
    }
  }
  //导出日历
  outCalendar()async{
    setState(() {
      outLoading = true;
    });
    if(list.isEmpty){
      showToast('导出失败，列表为空');
      setState(() {outLoading = false;});
      return;
    }
    showToast('正在导出……');
    String dataPath = await courseToIcs(list);
    if(dataPath==''){
      FlyDialogDIYShow(context, content: Wrap(
        runSpacing: spaceCardPaddingTB,
        children: [
          FlyTitle('ICS生成失败'),
          FlyText.main40("请检查是否为矿小助开启了文件读写权限\n未设置开学时间也可能会导致失败\n如果依然失败，请进QQ群957634136反馈",maxLine: 100,),

        ],
      ));
      setState(() {outLoading = false;});
      return;
    }
    if(Prefs.username==null){
      showToast('未检测到登录态，请重新登录');
      setState(() {outLoading = false;});
      return;
    }
    Map<String ,dynamic> map = Map();
    map["myfile"] = await MultipartFile.fromFile(dataPath,filename: "${Prefs.username}.ics");
    try{
      var res = await Dio().post('https://user.kxz.atcumt.com/ics/upload',data: FormData.fromMap(map),options: Options(sendTimeout: 3000,receiveTimeout: 3000,));
      if(res.statusCode==200){
        Prefs.courseIcsUrl = 'https://user.kxz.atcumt.com/ics/download/${Prefs.username}.ics';
        Prefs.courseIcsDate = DateTime.now().toString();
        setState(() {});
        FlyDialogDIYShow(context, content: Wrap(
          runSpacing: spaceCardPaddingTB,
          children: [
            FlyTitle('成功生成订阅!'),
            Container(),
            FlyText.main40('5秒后自动跳转至浏览器……',maxLine: 3,),
            UniversalPlatform.isAndroid?FlyText.main40('请用"系统日历"打开下载的文件',maxLine: 3,):
            Container(),
            FlyText.miniTip30('您课表文件的订阅网址：',maxLine: 3,),
            FlyTextButton(Prefs.courseIcsUrl,onTap: (){
              Clipboard.setData(ClipboardData(text: Prefs.courseIcsUrl));
              showToast('已复制链接');
            },maxLine: 10,),

            UniversalPlatform.isAndroid?
            FlyText.main40('（日历事项时间冲突可能会导致无法导入，清理一下日历里面的事项就好了）',maxLine: 3,):
            FlyText.miniTip30('小技巧：使用日历软件(如滴答清单)的url订阅功能，可以实现日历与服务器同步更新哦～(具体步骤请点击"课表还能这么玩？"）',maxLine: 3,),
          ],
        ));
        Logger.log("OutputIcs", "导出至日历,成功",{});
        Future.delayed(Duration(seconds: 5),(){
          launchUrl(Uri.parse(Prefs.courseIcsUrl));
        });
      }else{
        showToast('导出失败${res.toString()}');
        Logger.log("OutputIcs", "导出至日历,失败",{});
        return;
      }
    }on DioError catch(e){
      showToast('导出失败,请检查网络连接！');
      setState(() {
        outLoading = false;
      });
      return;
    }
  }
  outFile()async{
    if(list.isEmpty){
      showToast('分享失败，列表为空');
      return;
    }
    showToast('正在生成课表文件……');
    String data = await courseToIcs(list);
    if(data!=''){
      showToast('成功生成课表文件，分享出去吧～');
      Share.shareFiles(['$data'],);
      Logger.log("OutputIcs", "以文件分享,成功",{});
    }else{
      showToast('文件生成失败');
      Logger.log("OutputIcs", "以文件分享,失败",{});
    }
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, '课表导出(${list.length})',
      actions: [
        Prefs.courseIcsUrl!=null
            ? IconButton(icon: Icon(MdiIcons.cloudSyncOutline,color: Theme.of(context).primaryColor,), onPressed: ()=>sync())
            : Container(),
      ]),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                buildHelp(),
                Prefs.courseIcsUrl!=null?_buildTop():Container(),
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
  Widget _buildTop(){
    return _container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlyText.miniTip30('当前课表订阅网址(点击复制链接)',maxLine: 3,),
          FlyTextButton(Prefs.courseIcsUrl,onTap: (){
            Clipboard.setData(ClipboardData(text: Prefs.courseIcsUrl));
            showToast('已复制链接');
          },maxLine: 10,),
          FlyText.miniTip30('更新时间:${Prefs.courseIcsDate}\n点击右上角按钮，刷新服务器课表数据',maxLine: 3,),
        ],
      )
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
  Widget buildHelp(){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>IcsHelpPage()));
      },
      child: _container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlyText.title45("课表还能这么玩?"),
            Icon(Icons.chevron_right,color: Theme.of(context).primaryColor.withOpacity(0.5),)
          ],
        )
      ),
    );
  }
  Widget _container({Widget child}){
    return FlyContainer(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor,
          boxShadow: [
            boxShadowMain
          ]),
      child: child,
    );
  }
  Widget buildBody(){
    return Column(
      children: [for(int i = 0;i<list.length;i++)_container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: spaceCardPaddingTB*0.5,),
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
                      Expanded(child: FlyText.title45(list[i].title,),)
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
        )
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
