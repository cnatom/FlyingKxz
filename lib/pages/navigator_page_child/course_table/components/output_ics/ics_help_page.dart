import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:url_launcher/url_launcher.dart';

class IcsHelpPage extends StatefulWidget {
  @override
  _IcsHelpPageState createState() => _IcsHelpPageState();
}

class _IcsHelpPageState extends State<IcsHelpPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, '导出课表的妙用'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL*2, 0, spaceCardPaddingRL*2, 0),
          child: Wrap(
            runSpacing: spaceCardMarginTB,
            children: [
              Container(),

              _buildTitle('1⃣ ️桌面小组件'),
              _buildText('一次导出，各种日历软件皆可同步，还可以使用小组件哦～'),
              _buildImage('images/icsHelp1.png'),
              _buildImage('images/icsHelp2.png'),
              Divider(),

              _buildTitle('2⃣️ 在电脑上看课表'),
              _buildText('将课表文件分享到电脑上，直接打开文件即可导入至电脑日历中！（Windows11的桌面小组件也可以用）'),
              size(),
              SizedBox(height: 20,),
              Divider(),
              _buildTitle('3⃣️ 订阅日历实现同步'),
              _buildText('手机、平板、电脑，三种设备都可以利用订阅功能，实现与矿小助服务器的课表文件同步！只需要取消订阅即可将日历的课表全部清空！\n\n推荐使用滴答清单哦（部分日历软件不支持url订阅）'),
              _buildImage('images/icsHelp3.png'),
              _buildImage('images/icsHelp4.png'),
              _buildImage('images/icsHelp5.png'),
              _buildImage('images/icsHelp6.png'),

              Divider(),
              _buildTitle('❓我遇到了其他问题怎么办？'),
              _buildText('那就加群咨询吧，写代码的小哥哥会一对一解答的～。QQ群号：839372371'),
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            boxShadowMain
          ]
      ),

      child: Image.asset(resource),
    );
  }

  @override
  void initState() {
    super.initState();
    sendInfo("课表导出", "初始化帮助页");
  }
}