//关于我们
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/aboutus/about_detail.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/detail_info.dart';

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
            _buildHeader(),
            SizedBox(
              height: fontSizeMini38 * 4,
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
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
                        _buildUnit("项目组", "点击卡片查看详情", children: [
                          _buildButton(
                              title: "牟金腾",
                              subTitle: "19级大数据2班",
                              qqNumber: "1004275481",
                              onTap: ()=>toAboutDetailPage(context,"1004275481",DetailInfo.mjt())),
                          _buildButton(
                              title: "吕迎朝",
                              subTitle: "19级大数据2班",
                              qqNumber: "1662870160",
                              onTap: ()=>toAboutDetailPage(context,"1662870160",DetailInfo.lyz())),
                          _buildButton(
                              title: "管永富",
                              subTitle: "18级工作室站长",
                              qqNumber: "1337612820",
                              onTap: ()=>toAboutDetailPage(context,"1337612820",DetailInfo.gyf())),
                          _buildButton(
                              title: "王逸鸣",
                              subTitle: "19级计科2班",
                              qqNumber: "522942475",
                              onTap: ()=>toAboutDetailPage(context,"522942475",DetailInfo.wym())),
                          _buildButton(
                              title: "李家鑫",
                              subTitle: "19级会计2班",
                              qqNumber: "1156573954",
                              onTap: ()=>toAboutDetailPage(context,"1156573954",DetailInfo.ljx())),
                          _buildButton(
                              title: "罗纯颖",
                              subTitle: "19级信安3班",
                              qqNumber: "1651711016",
                              onTap: ()=>toAboutDetailPage(context,"1651711016",DetailInfo.lcy())),
                        ]),
                        _buildUnit('反馈群', "点击卡片可复制群号", children: [
                          _buildButton(
                              type: 1,
                              title: "交流1群",
                              subTitle: "发布、反馈中心",
                              qqNumber: "839372371"),
                          _buildButton(
                              type: 1,
                              title: "交流2群",
                              subTitle: "发布、反馈中心",
                              qqNumber: "957634136")
                        ]),
                        _buildUnit("其他", "点击卡片进入页面", children: [
                          _buildButton(
                              type: 1,
                              imageResource: 'images/jiaoliuqun.jpg',
                              title: "关于工作室",
                              subTitle: "长期招聘↗",
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://flyingstudio.feishu.cn/docs/doccnuWFYfcbHUZ65FmKB3iA6pf"));
                              }),
                          _buildButton(
                              imageResource: "images/github.png",
                              title: "矿小助源代码",
                              subTitle: "求一个Star～",
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://github.com/cnatom/FlyingKxz"));
                              })
                        ]),
                        Column(
                          children: [
                            SizedBox(
                              height: fontSizeMini38 * 2,
                            ),
                            FlyTitle('你的支持是我们用爱发电最大的动力！'),
                            Wrap(
                              children: [_buildImage('images/help.png')],
                            ),
                            SizedBox(
                              height: 300,
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          );
  }

  Column _buildHeader() {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                height: fontSizeMini38 * 3.5,
              ),
              SizedBox(
                height: fontSizeMini38 * 1.5,
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
                height: fontSizeMini38 * 0.8,
              ),
              Text(
                '— 科技改变生活，技术成就梦想 —',
                style: TextStyle(
                    color: colorLoginPageMain,
                    fontSize: fontSizeTip33,
                    letterSpacing: 3),
              )
            ],
          );
  }


  Widget _buildButton(
      {int type = 0,
        @required String title,
        String imageResource,
        @required subTitle,
        String qqNumber,
        GestureTapCallback onTap}) {
    return Container(
      width: ScreenUtil().setWidth(deviceWidth / 2) - spaceCardPaddingTB / 2,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingTB / 2, spaceCardPaddingTB,
          spaceCardPaddingTB / 2, 0),
      child: InkWell(
        onTap: onTap == null
            ? () {
          Clipboard.setData(ClipboardData(text: qqNumber));
          showToast("已复制QQ号至剪切板", duration: 1);
        }
            : onTap,
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
                  child: qqNumber != null
                      ? Image.network(
                    type == 0
                        ? "http://q1.qlogo.cn/g?b=qq&nk=$qqNumber&s=640"
                        : "http://p.qlogo.cn/gh/$qqNumber/$qqNumber/640/",
                    fit: BoxFit.cover,
                  )
                      : Image.asset(imageResource),
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
  Widget _buildUnit(String title, String subTitle,
      {@required List<Widget> children}) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.fromLTRB(spaceCardMarginRL, fontSizeMini38 * 2, spaceCardMarginRL, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlyTitle(title),
              FlyText.miniTip30(subTitle),
            ],
          ),
        ),
        Wrap(
          children: children,
        ),
      ],
    );
  }

  Widget _buildImage(String resource) {
    return Container(
      padding: EdgeInsets.fromLTRB(70, 30, 70, 0),
      decoration: BoxDecoration(boxShadow: [boxShadowMain]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset("images/help.png"),
      ),
    );
  }
}
