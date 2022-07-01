import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/appbar.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportHelpPage extends StatefulWidget {
  @override
  _ImportHelpPageState createState() => _ImportHelpPageState();
}

class _ImportHelpPageState extends State<ImportHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, '《矿小姬的问答课堂-胎教版》'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL*2, 0, spaceCardPaddingRL*2, 0),
          child: Wrap(
            runSpacing: spaceCardMarginTB,
            children: [
              _buildText('你好呀～，我叫矿小姬，是矿小助用户的私人助理，你也可以叫我"小姬姬"(正经的那种。\nQQ：2893604242'),
              _buildImage('images/kxj.png'),
              Divider(),

              _buildTitle('Q1：我为什么一直在加载？'),
              _buildText('可能未连接"校内网"。您可以连接校内的Wifi，比如下面这两个:'),
              _buildImage('images/wifi.png'),
              _buildText('(连接之后记得进http://10.2.5.251网站登录，或者也可以用矿小助的"校园网登录"功能自动登录哦～）'),
              Divider(),

              _buildTitle('Q2：可是我不在学校怎么办呀？'),
              _buildText('那就用VPN吧！小姬姬已经给你准备好链接啦 ⬇️'),
              size(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton('苹果VPN',MdiIcons.apple ,'iOS VPN指引','http://nic.cumt.edu.cn/info/1201/2407.htm'),
                  _buildButton('安卓VPN',MdiIcons.android ,'安卓 VPN指引','http://nic.cumt.edu.cn/info/1201/2408.htm')

                ],
              ),
              SizedBox(height: 20,),
              Divider(),
              _buildTitle('Q3:怎么提取课表呀？'),
              _buildText('1、先在下面这个界面登录'),
              _buildImage('images/importHelp1_score.png'),
              _buildText('2、然后按照下图提取'),
              _buildImage('images/importHelp2_score.png'),
              Divider(),
              _buildTitle('Q4:为什么导出的成绩没有明细呀？'),
              _buildText('暂时无法将明细导出，可以去成绩页面点击"成绩明细"(在筛选的左边)在网页中点击查看'),
              Divider(),
              _buildTitle('Q5:我遇到了其他问题怎么办？'),
              _buildText('那就私聊小姬姬吧，写代码的小哥哥会一对一解答的～。\n当然，也可以加小姬姬的粉丝群哦，QQ群号：839372371'),
              Divider(),

              size(),
              size(),
              size(),
              size(),

            ],
          ),
        ),
      ),
    );
  }
  Widget size(){
    return Row(
      children: [
        SizedBox(height: spaceCardMarginTB,)
      ],
    );
  }
  Widget _buildButton(String title,IconData iconData,String urlTitle,String url){
    return InkWell(
      onTap: (){
        launch(url);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            Icon(iconData,size: fontSizeMain40*1.5),
            SizedBox(height: 5,),
            FlyText.main40(title)
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0.05,
                  color: Colors.black12.withAlpha(5)
              )
            ]
        ),
      ),
    );
  }
  Widget _buildTitle(String title){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.title50(title,fontWeight: FontWeight.bold,),
          ],
        ),
        SizedBox(height: spaceCardMarginTB,),
      ],
    );
  }
  Widget _buildText(String text){
    return FlyText.main40(text,maxLine: 100,);
  }
  Widget _buildImage(String resource){
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          boxShadow: [
            boxShadowMain
          ]
      ),

      child: Image.asset(resource),
    );
  }
}