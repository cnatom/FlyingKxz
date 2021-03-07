//关于我们

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
import 'package:flying_kxz/pages/backImage_view.dart';

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
      @required String qqNumber}) {
    return Container(
      width: ScreenUtil().setWidth(deviceWidth / 2) - spaceCardPaddingTB / 2,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingTB / 2, spaceCardPaddingTB,
          spaceCardPaddingTB / 2, 0),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: qqNumber));
          showToast(context, "已复制QQ号至剪切板", duration: 1);
        },
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
                  child: Image.network(
                    type == 0
                        ? "http://q1.qlogo.cn/g?b=qq&nk=$qqNumber&s=640"
                        : "http://p.qlogo.cn/gh/$qqNumber/$qqNumber/640/",
                    fit: BoxFit.cover,
                  ),
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
                  height: fontSizeMini38 * 4,
                ),
                SizedBox(
                  height: fontSizeMini38,
                ),
                Text(
                  '翔工作室出品',
                  style: TextStyle(
                      color: colorLoginPageMain,
                      fontSize: fontSizeMain40,
                      fontWeight: FontWeight.bold,
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
                                        title: "校园App交流群",
                                        subTitle: "发布、反馈中心",
                                        qqNumber: "839372371"),
                                    funcButton(
                                      type: 1,
                                        imageResource: 'images/duiwai.jpg',
                                        title: "对外交流群",
                                        subTitle: "加群了解翔工作室",
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
                                FlyTitle('关于翔工作室'),
                                Container(
                                  margin: EdgeInsets.all(spaceCardMarginRL),
                                  padding: EdgeInsets.all(spaceCardMarginRL),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          borderRadiusValue),
                                      color: Theme.of(context).cardColor),
                                  child: Transform.translate(
                                    offset: Offset(0, fontSize * leading / 2),
                                    child: Text(
                                      "        这里是一个合作探索的团队，我们渴望新知，不断挑战自我."
                                      "我们以翔工作室为舞台，致力于为师生打造精彩的校园产品和网络生活。"
                                      "我们相信，没有完美的个人，但有完美的团队。\n",
                                      strutStyle: StrutStyle(
                                          forceStrutHeight: true,
                                          height: textLineHeight,
                                          leading: leading),
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        //backgroundColor: Colors.greenAccent),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: fontSizeMini38 * 2,
                                ),
                              ],
                            )
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
