import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/CumtSpider/cumt_format.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/text_editer.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/score_map.dart';
import 'package:provider/provider.dart';

class ScoreSetPage extends StatefulWidget {
  @override
  _ScoreSetPageState createState() => _ScoreSetPageState();
}

class _ScoreSetPageState extends State<ScoreSetPage> {
  ThemeProvider themeProvider;
  Map<String,dynamic> data;
  @override
  void initState() {
    super.initState();
    ScoreMap.init();
    data = ScoreMap.data;
  }
  set(String key)async{
    var temp = await FlyDialogDIYShow(context,content: ScoreSetView(k: key,data: data,));
    if(temp==null) return;
    setState(() {
      data = temp;
    });
    ScoreMap.saveFromMap(data);
  }
  add()async{
    var temp = await FlyDialogDIYShow(context,content: ScoreSetView(data: data,));
    if(temp==null) return;
    setState(() {
      data = temp;
    });
    ScoreMap.saveFromMap(data);
  }
  refresh(){
    ScoreMap.refresh();
    showToast('已恢复默认设置');
    data = ScoreMap.data;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, "特殊成绩设置",actions: [
        IconButton(icon: Icon(Icons.add,color: themeProvider.colorNavText,), onPressed: ()=>add()),
        IconButton(icon: Icon(Icons.refresh,color: themeProvider.colorNavText,), onPressed: ()=>refresh())
      ]),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [for(var key in data.keys)Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: FlyText.title45(key),),
                    Expanded(
                      child: _buildRow("总评", data[key]['zongping']),),
                    Expanded(
                      child: _buildRow("绩点", data[key]['jidian']),),
                    IconButton(icon: Icon(Icons.edit,color: themeProvider.colorMain,), onPressed: ()=>set(key),)
                  ],
                ),
              )],
            ),
            SizedBox(height: 200,),
          ],
        ),
      ),
    );
  }
  Widget _buildRow(String title,String content){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FlyText.mini30(title+'：'),
        FlyText.title45(content,color: themeProvider.colorMain,fontWeight: FontWeight.bold,)
      ],
    );
  }

}

class ScoreSetView extends StatefulWidget {
  final String k;
  final Map<String,dynamic> data;
  ScoreSetView({this.k,this.data,});
  @override
  _ScoreSetViewState createState() => _ScoreSetViewState();
}

class _ScoreSetViewState extends State<ScoreSetView> {
  ThemeProvider themeProvider;
  TextEditingController controller0 = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  Map<String,dynamic> data;
  ok(){
    String zongping = controller1.text;
    String jidian = controller2.text;
    if(check(zongping,100)&&check(jidian,5.0)){
      data[widget.k]["zongping"] = zongping;
      data[widget.k]["jidian"] = jidian;
      Navigator.of(context).pop(data);
    }
  }
  add(){
    String pingji = controller0.text??'';
    String zongping = controller1.text??'';
    String jidian = controller2.text??'';
    if(pingji.isEmpty){
      showToast('评级不能未空');
      return;
    }
    if(check(zongping,100)&&check(jidian,5.0)){
      data.addAll({
        pingji:{
          "zongping":zongping,
          "jidian":jidian
        }
      });
      Navigator.of(context).pop(data);
    }
  }
  delete(String k){
    data.remove(k);
    Navigator.of(context).pop(data);
  }
  bool check(String text,double max){
    if(CumtFormat.isNumeric(text)){
      double n = double.parse(text);
      if(n<0||n>max){
        showToast(text+' - 超出限定范围');
        return false;
      }
      return true;
    }{
      showToast(text+' - 格式不正确');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Wrap(
        runSpacing: 20,
        children: [
          Wrap(
            runSpacing: spaceCardMarginBigTB,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: fontSizeMini38/4,
                    height: fontSizeTitle45,
                    decoration: BoxDecoration(color: themeProvider.colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
                  ),
                  SizedBox(width: ScreenUtil().setSp(35),),
                  Text(
                    widget.k??"添加映射",
                    style: TextStyle(
                      fontSize: fontSizeTitle45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              widget.k==null?Column(
                children: [
                  SizedBox(height: spaceCardMarginBigTB,),
                  FlyInputBar(context, '评级(如"优秀")', controller0)
                ],
              ):Container(),
              Container(),
              FlyInputBar(context, "总评"+"(0~100)", controller1),
              FlyInputBar(context, "绩点"+"(0.0~5.0)", controller2),
              Container(),
              Container(),
              Row(
                mainAxisAlignment: widget.k!=null?MainAxisAlignment.spaceAround:MainAxisAlignment.center,
                children: [
                  widget.k!=null?IconButton(icon: Icon(Icons.delete_outline_rounded,color: Colors.red.withOpacity(0.8),size: 30,), onPressed: ()=>delete(widget.k)):Container(),
                  IconButton(icon: Icon(Icons.check,color: themeProvider.colorMain,size: 30,), onPressed: ()=>widget.k==null?add():ok()),
                ],
              )
              // Center(
              //   child: InkWell(
              //     onTap: ()=>ok(),
              //     child: Container(
              //       padding: EdgeInsets.fromLTRB(40, 12, 40, 12),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(100),
              //           color: themeProvider.colorMain
              //       ),
              //       child: FlyText.main40('确定',color: Colors.white,fontWeight: FontWeight.bold,),
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }
}