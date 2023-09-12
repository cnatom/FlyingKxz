import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cumt/cumt.dart';
import 'navigator_page.dart';

//跳转到当前页面
void toTipPage() {
  FlyNavigatorPageState.navigatorKey.currentState.push(CupertinoPageRoute(builder: (BuildContext context)=>TipPage()));
}
class TipPage extends StatefulWidget {
  @override
  _TipPageState createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  bool loading = false;

  _fun()async{
    setState(() {
      loading = true;
    });
    showToast((await Cumt.checkConnect())?'🎉已连接内网':'未连接内网QAQ');
    setState(() {
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, '连接失败，可能未连接校内网',),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(spaceCardPaddingRL/2),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            children: [
              Center(
                child: Image.asset('images/404.png'),
              ),
              // FlyText.title50('请使用"学校内网"登录',fontWeight: FontWeight.bold,),
              Padding(
                padding: EdgeInsets.all(spaceCardPaddingRL/2),
                child: FlyText.main40('为保证数据安全，矿小助部分功能需要使用"学校内网"进行访问。请选择以下任意方式连接内网:',maxLine: 100,),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(spaceCardPaddingRL/2),
                child: Wrap(
                  runSpacing: 10,
                  children: [
                    // FlyTitle('连接学校的Wi-Fi'),
                    _buildTitle('连接校内Wi-Fi（推荐）'),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(spaceCardPaddingRL/2),
                        child: Image.asset('images/wifi.png'),
                      ),
                    ),
                    Center(
                      child: FlyText.miniTip30('连接后记得去网站："http://10.2.5.251"登录，或者使用矿小助的"校园网自动登录"功能登录',maxLine: 100,),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(spaceCardPaddingRL/2),
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    _buildTitle('使用矿大VPN'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton('矿大VPN',MdiIcons.network ,'VPN指引','https://www.cumt.edu.cn/a8/b4/c19686a567476/page.htm'),
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              InkWell(
                onTap: ()=>_fun(),
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                      color: colorMain,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        boxShadowMain
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlyText.title50(!loading?'检测内网环境':'检测中……',color: Colors.white,fontWeight: FontWeight.bold,)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 30,
          height: fontSizeMini38/6,
          decoration: BoxDecoration(color: colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
        ),
        SizedBox(width: spaceCardPaddingRL,),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSizeTitle45,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: spaceCardPaddingRL,),
        Container(
          width: 30,
          height: fontSizeMini38/6,
          decoration: BoxDecoration(color: colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
        ),
      ],
    );
  }
}
