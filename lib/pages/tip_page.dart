import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/FlyingUiKit/webview.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//跳转到当前页面
void toTipPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => TipPage()));
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
    showToast(context, await Cumt.checkConnect());
    setState(() {
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, '',),
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
                    // FlyText.main40('为保证数据安全，矿小助部分功能需要使用"学校内网"进行访问。请选择以下任意方式连接内网:',maxLine: 100,)
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildButton('苹果VPN',MdiIcons.apple ,'iOS VPN指引','http://nic.cumt.edu.cn/info/1201/2407.htm'),
                        _buildButton('安卓VPN',MdiIcons.android ,'安卓 VPN指引','http://nic.cumt.edu.cn/info/1201/2408.htm')

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
        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>FlyWebView(title: urlTitle,initialUrl: url,)));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            Icon(iconData,size: fontSizeMain40*1.5,),
            SizedBox(height: 5,),
            FlyText.main40(title)
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
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
