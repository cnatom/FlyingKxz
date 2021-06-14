//关于我们
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

//跳转到当前页面
void toAboutPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => AboutPage()));
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final double leading = 0.9;
  final double textLineHeight = 1.5;

  /// 文本间距
  final double fontSize = fontSizeMini38;

  Widget funcButton({int type = 0,
      @required String imageResource,
      @required String title,
      @required subTitle,
      String qqNumber,
    GestureTapCallback onTap}) {
    return Container(
      width: ScreenUtil().setWidth(deviceWidth / 2) - spaceCardPaddingTB / 2,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingTB / 2, spaceCardPaddingTB,
          spaceCardPaddingTB / 2, 0),
      child: InkWell(
        onTap: onTap==null?() {
          Clipboard.setData(ClipboardData(text: qqNumber));
          showToast("已复制QQ号至剪切板", duration: 1);
        }:onTap,
        child: Container(
          padding: EdgeInsets.all(spaceCardMarginRL),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              color: Theme.of(context).cardColor),
          child: Row(
            children: [
              Container(
                width: fontSizeMini38 * 2.5,
                height: fontSizeMini38 * 2.5,
                child: ClipOval(
                  child: qqNumber!=null?Image.network(
                    type == 0
                        ? "http://q1.qlogo.cn/g?b=qq&nk=$qqNumber&s=640"
                        : "http://p.qlogo.cn/gh/$qqNumber/$qqNumber/640/",
                    fit: BoxFit.cover,
                  ):Image.asset("images/avatar.png"),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(deviceWidth / 40),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlyText.main35(title,
                      fontWeight: FontWeight.bold, maxLine: 1),
                  FlyText.miniTip30(subTitle, maxLine: 1)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            size: fontSizeMain40,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: fontSizeMini38 * 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  height: fontSizeMini38 * 3.5,
                ),
                SizedBox(
                  height: fontSizeMini38*1.5,
                ),
                Text(
                  '翔工作室',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorLoginPageMain,
                      fontSize: fontSizeMain40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: fontSizeMini38*0.8,
                ),
                Text(
                  '— 科技改变生活，技术成就梦想 —',
                  style: TextStyle(
                      color: colorLoginPageMain,
                      fontSize: fontSizeTip33,
                      letterSpacing: 3),
                )
              ],
            ),
            SizedBox(
              height: fontSizeMini38 * 4,
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: fontSizeMini38 * 2,
                  ),
                  AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                          childAnimationBuilder: (widget) => SlideAnimation(
                                duration: Duration(milliseconds: 500),
                                delay: Duration(milliseconds: 50),
                                horizontalOffset: 50,
                                child: FadeInAnimation(
                                  delay: Duration(milliseconds: 100),
                                  duration: Duration(milliseconds: 500),
                                  child: widget,
                                ),
                              ),
                          children: [

                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, spaceCardMarginRL, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlyTitle('开发者'),
                                      FlyText.miniTip30("点击卡片可复制成员QQ号码"),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  children: [
                                    funcButton(
                                        imageResource: 'images/mujinteng.jpg',
                                        title: "牟金腾",
                                        subTitle: "19级大数据2班",
                                        qqNumber: "1004275481"),
                                    funcButton(
                                        imageResource: 'images/lvyingzhao.jpg',
                                        title: "吕迎朝",
                                        subTitle: "19级大数据2班",
                                        qqNumber: "1662870160")
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: fontSizeMini38 * 2,
                                ),
                                FlyTitle('鸣谢'),
                                Wrap(
                                  children: [
                                    funcButton(
                                        imageResource: 'images/wangzhaojun.jpg',
                                        title: "王昭君",
                                        subTitle: "17级电信2班",
                                        qqNumber: "821589498"),
                                    funcButton(
                                        imageResource: 'images/liuhao.jpg',
                                        title: "刘浩",
                                        subTitle: "18级大数据2班",
                                        qqNumber: "1322740325"),
                                    funcButton(
                                        imageResource: 'images/guanyongfu.jpg',
                                        title: "管永富",
                                        subTitle: "18级能动2班",
                                        qqNumber: "1337612820"),
                                    funcButton(
                                        imageResource: 'images/zhouwenhong.jpg',
                                        title: "周文洪",
                                        subTitle: "17级计科5班",
                                        qqNumber: "1600577405"),
                                    funcButton(
                                        imageResource: 'images/xingyuan.jpg',
                                        title: "邢远",
                                        subTitle: "前翔工作室成员",
                                        qqNumber: "1285085637"),
                                    funcButton(
                                        imageResource: 'images/weirongqing.jpg',
                                        title: "韦荣庆",
                                        subTitle: "17级物理5班",
                                        qqNumber: "972054808"),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: fontSizeMini38 * 2,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, spaceCardMarginRL, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlyTitle('QQ群'),
                                      FlyText.miniTip30("点击卡片可复制QQ群号码"),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  children: [
                                    SizedBox(
                                      width: spaceCardMarginRL / 2,
                                    ),
                                    funcButton(
                                      type: 1,
                                        imageResource: 'images/jiaoliuqun.jpg',
                                        title: "App交流1群",
                                        subTitle: "发布、反馈中心",
                                        qqNumber: "839372371"),
                                    funcButton(
                                      type: 1,
                                        imageResource: 'images/duiwai.jpg',
                                        title: "App交流2群",
                                        subTitle: "发布、反馈中心",
                                        qqNumber: "957634136"),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: fontSizeMini38 * 2,
                                ),
                                FlyTitle('关于工作室'),
                                Row(
                                  children: [
                                    SizedBox(width: spaceCardPaddingTB / 2,),
                                    funcButton(
                                        type: 1,
                                        imageResource: 'images/jiaoliuqun.jpg',
                                        title: "长期招聘↗",
                                        subTitle: "点我了解更多",
                                        onTap: (){
                                          if(UniversalPlatform.isWindows){
                                            launch("https://mp.weixin.qq.com/s?__biz=MzIyNjAxNDkwMA==&mid=502587667&idx=1&sn=940336553beac7fb1e5d53fb3a0d0584");
                                          }else{
                                            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AboutFlyingWebView()));
                                          }
                                        }
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: fontSizeMini38 * 10,
                                ),

                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class AboutFlyingWebView extends StatefulWidget {
  @override
  _AboutFlyingWebViewState createState() => _AboutFlyingWebViewState();
}

class _AboutFlyingWebViewState extends State<AboutFlyingWebView> {
  double progress = 0;
  WebViewController webViewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FlyAppBar(context, "Flying Studio",
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(3.0),
        child: LinearProgressIndicator(
          backgroundColor: Colors.white70.withOpacity(0),
          value: progress>0.99?0:progress,
          valueColor: new AlwaysStoppedAnimation<Color>(colorMain),
        ),
      ),),
      body: WebView(

        initialUrl: "http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fjwxt.cumt.edu.cn%2Fsso%2Fjziotlogin",
          // initialUrl: "https://mp.weixin.qq.com/s?__biz=MzIyNjAxNDkwMA==&mid=502587667&idx=1&sn=940336553beac7fb1e5d53fb3a0d0584",
          javascriptMode: JavascriptMode.unrestricted,
        onProgress: (value){
            setState(() {
              progress = value/100.0;
            });
        },
        onWebViewCreated: (controller)async{
            webViewController = controller;
        },
        onPageStarted: (start){
            start.toString();
        },
        onPageFinished: (finish)async{
        },
      ),
    );
  }
}
