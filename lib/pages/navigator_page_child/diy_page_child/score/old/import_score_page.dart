import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flying_kxz/cumt/cumt.dart';
import 'package:flying_kxz/cumt/cumt_format.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/old/score_temp_list_view.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import 'import_help_page.dart';


class ImportScorePage extends StatefulWidget {
  @override
  _ImportScorePageState createState() => _ImportScorePageState();
}

class _ImportScorePageState extends State<ImportScorePage> {
  late InAppWebViewController _controller;
  late ThemeProvider themeProvider;
  double progress = 0.0;
  bool loadingWeb = true;
  bool loading = false;

  List<Map<String,dynamic>>? result = [];


  @override
  void initState() {
    super.initState();
    init();
  }
  init()async{
    if(!await Cumt.checkConnect()){
      toTipPage();
    }
  }

  _showDetail()async{
    if(result==null||result!.isEmpty){
      showToast('列表为空');
      return;
    }
    var temp = await showFlyModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      builder: (BuildContext context) {
        return ScoreTempListView(list:result!);
      },
    );
    if(temp==null) return;
    result = temp;
    setState(() {

    });
  }
  _add()async{
    var html = await _controller.getHtml();
    if(html==null) return;
    var res = CumtFormat.parseScoreAll(html);
    if(res==null) return;
    result?.addAll(res);
    setState(() {

    });
  }
  _ok(){
    if(result==null||result!.isEmpty){
      showToast('列表为空');
      return;
    }
    result?.sort((a, b) => a['courseName'].compareTo(b['courseName']));
    Navigator.of(context).pop(result);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context,loadingWeb?"从教务获取成绩(加载中……)":"矿大教务",
          actions: [
            IconButton(icon: Icon(Boxicons.bx_help_circle,color: Theme.of(context).primaryColor,), onPressed: (){
              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ImportHelpPage()));
            })
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white70.withOpacity(0),
              value: progress>0.99?0:progress,
              valueColor: new AlwaysStoppedAnimation<Color>(colorMain),
            ),
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                    useHybridComposition: true
                )
            ),
            initialUrlRequest: URLRequest(url: Uri.parse("http://jwxt.cumt.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html?gnmkdm=N305005&layout=default")),
            onWebViewCreated: (controller){
              _controller = controller;
            },
            onLoadStart: (controller,url){

              setState(() {
                loadingWeb = true;
              });
            },
            onLoadStop: (controller,url){
              setState(() {
                loadingWeb = false;
              });
            },
            onProgressChanged: (controller,process){
              setState(() {
                progress = process/100.0;
              });
            },
          ),
          _bottomBar(),
          Positioned(
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: FlyText.main40('矿小姬Tip：登录后，逐一提取每页成绩，最后点对勾即可',color: Colors.white,maxLine: 10,),
                )
              ],
            ),
          )
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
                .cardColor
                .withOpacity(0.9),
            boxShadow: [
              boxShadowMain
            ]),
        margin: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).padding.bottom),
        padding: EdgeInsets.fromLTRB(10,10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: ()=>_showDetail(),
              child: badges.Badge(
                badgeContent: Text(result!.length.toString(),style: TextStyle(color: Colors.white),),
                child: Icon(Icons.list,size: 35,color: textColor,),
              ),
            ),
            Center(
              child: InkWell(
                onTap: ()=>_add(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: textColor.withOpacity(0.1),
                      boxShadow: [
                        boxShadowMain
                      ]
                  ),
                  child: FlyText.title45('提取本页成绩',fontWeight: FontWeight.bold,color: textColor,),
                ),
              ),
            ),
            InkWell(
              onTap: ()=>_ok(),
              child: Icon(Icons.check,size: 30,color: textColor,),
            ),
          ],
        ),
      ),
    );
  }
}



