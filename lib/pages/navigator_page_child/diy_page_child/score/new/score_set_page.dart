import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/cumt/cumt_format.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/model/score_new_map.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

toScoreSetNewPage(BuildContext context) {
  Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => ScoreSetNewPage()));
}

class ScoreSetNewPage extends StatefulWidget {
  @override
  _ScoreSetNewPageState createState() => _ScoreSetNewPageState();
}

class _ScoreSetNewPageState extends State<ScoreSetNewPage> {
  late ThemeProvider themeProvider;
  late Map<String,dynamic> data;


  @override
  void initState() {
    super.initState();
    data = ScoreNewMap.data;
  }

  set(String key)async{
    var temp = await FlyDialogDIYShow(context,content: ScoreSetView(k: key,data: data,));
    if(temp==null) return;
    setState(() {
      data = temp;
    });
    ScoreNewMap.saveFromMap(data);
  }

  add()async{
    var temp = await FlyDialogDIYShow(context,content: ScoreSetView(data: data,));
    if(temp==null) return;
    setState(() {
      data = temp;
    });
    ScoreNewMap.saveFromMap(data);
  }

  refresh(){
    ScoreNewMap.refresh();
    showToast('已恢复默认设置');
    data = ScoreNewMap.data;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, "特殊成绩设置",actions: [
        IconButton(icon: Icon(Icons.add,color: Theme.of(context).primaryColor,), onPressed: ()=>add()),
        IconButton(icon: Icon(Icons.refresh,color: Theme.of(context).primaryColor,), onPressed: ()=>refresh())
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
                      child: _buildRow("总评", data[key]['zongping'].toString()),),
                    Expanded(
                      child: _buildRow("绩点", data[key]['jidian'].toString()),),
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
  final String? k;
  final Map<String,dynamic> data;
  ScoreSetView({this.k,required this.data,});
  @override
  _ScoreSetViewState createState() => _ScoreSetViewState();
}

class _ScoreSetViewState extends State<ScoreSetView> {
  late ThemeProvider themeProvider;
  TextEditingController controller0 = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  late Map<String,dynamic> data;
  ok(){
    String zongping = controller1.text;
    String jidian = controller2.text;
    if(check(zongping,100)&&check(jidian,5.0)){
      data[widget.k]["zongping"] = double.parse(zongping);
      data[widget.k]["jidian"] = double.parse(jidian);
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
                  inputBar(context, '评级(如"优秀")', controller0)
                ],
              ):Container(),
              Container(),
              inputBar(context, "总评"+"(0~100)", controller1),
              inputBar(context, "绩点"+"(0.0~5.0)", controller2),
              Container(),
              Container(),
              Row(
                mainAxisAlignment: widget.k!=null?MainAxisAlignment.spaceAround:MainAxisAlignment.center,
                children: [
                  widget.k!=null?IconButton(icon: Icon(Icons.delete_outline_rounded,color: Colors.red.withOpacity(0.8),size: 30,), onPressed: ()=>delete(widget.k!)):Container(),
                  IconButton(icon: Icon(Icons.check,color: themeProvider.colorMain,size: 30,), onPressed: ()=>widget.k==null?add():ok()),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget inputBar(BuildContext context,String hintText, TextEditingController controller,
      {FormFieldSetter<String>? onSaved,EdgeInsetsGeometry? padding,bool obscureText = false,TextAlign textAlign = TextAlign.center}) =>
      Container(
        padding: padding,
        decoration: BoxDecoration(
            color: Theme.of(context).disabledColor,
            borderRadius: BorderRadius.circular(100)
        ),
        child: TextFormField(
          textAlign: textAlign,
          style: TextStyle(fontSize: fontSizeMain40),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          cursorColor: colorMain,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: fontSizeMain40),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
}