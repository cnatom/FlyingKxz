import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumtLogin_view.dart';
import 'package:provider/provider.dart';

import 'FlyingUiKit/container.dart';
import 'FlyingUiKit/custome_router.dart';
import 'Model/prefs.dart';
import 'newCumtLogin_view.dart';

//跳转到当前页面
void toTestPage(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      CustomRoute(TestPage(), milliseconds: 500), (route) => route == null);
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: FlyNavBackground(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(spaceCardMarginRL),
              child: Wrap(
                runSpacing: spaceCardMarginBigTB,
                children: [
                  SizedBox(
                    height: ScreenUtil.statusBarHeight * 2,
                    width: double.infinity,
                  ),
                  _buildInfoCard(context,
                      imageResource: 'images/avatar.png',
                      name: "牟金腾",
                      college: "计算机科学与技术学院"),
                  Container(),
                  Container(),
                  _buildIconsArea(),
                  NewCumtLoginView(),
                  _buildUnitCard(0xe610, "校园卡余额", "0.84 元",
                      child: Wrap(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: fontSizeMini38/3,),
                                  FlyText.mini30("校园卡流水")
                                ],
                              ),
                              FlyIconRightGreyArrow(
                                  color:
                                  themeProvider.colorNavText.withOpacity(0.5))
                            ],
                          )
                        ],
                      )),
                  _buildUnitCard(
                    0xe611,
                    "宿舍电量",
                    "66 度",
                  ),
                  _buildUnitCard(
                      0xe61b,
                      "考试倒计时",
                      "暂无考试",
                      child: ExamPage()
                  ),
                  TextButton(onPressed: ()=>themeProvider.simpleMode=!themeProvider.simpleMode, child: Text('调整')),

                  TextButton(
                      onPressed: () => themeProvider.colorMain =
                      themeProvider.colorMain != Colors.pink
                          ? Colors.pink
                          : colorMain,
                      child: Text('切换主题'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  FlyContainer _buildUnitCard(int codePoint, String title, String previewText,
      {Widget child}) {
    return FlyContainer(
      key: ValueKey(codePoint),
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB * 1.4,
          spaceCardPaddingRL, spaceCardPaddingTB * 1.2),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                IconData(codePoint, fontFamily: "CY"),
                color: themeProvider.colorMain,
                size: fontSizeMain40 * 1.7,
              ),
              SizedBox(
                width: fontSizeMain40 / 2,
              ),
              FlyText.mini30(title,fontWeight: FontWeight.w600,color: themeProvider.colorNavText.withOpacity(0.7),),
              FlyText.main40(
                "    \\    ",
                color: themeProvider.colorNavText.withOpacity(0.3),
              ),
              FlyText.mini30(
                previewText,
                color: themeProvider.colorNavText.withOpacity(0.6),
              )
            ],
          ),
          Divider(height: spaceCardPaddingTB*1.8,),
          Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL/4, 0, spaceCardPaddingRL/4, spaceCardPaddingTB),
            child: child ?? Container(),
          )
        ],
      ),
    );
  }
  Widget _buildInfoCard(BuildContext context,
      {String imageResource = "",
        String name = "",
        String college = ""}) =>
      Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageResource,
                  height: ScreenUtil().setWidth(120),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlyText.title45(name,
                    color: themeProvider.colorNavText, fontWeight: FontWeight.w600),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: FlyText.mini30(
                    college,
                    color: themeProvider.colorNavText,
                  ),
                ),
              ],
            )
          ],
        ),
      );
  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
          {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: fontSizeMain40, color: themeProvider.colorNavText),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: fontSizeMain40,
                color: themeProvider.colorNavText.withOpacity(0.5)),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
  FlyContainer _buildIconsArea() {
    return FlyContainer(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB * 1.4,
          spaceCardPaddingRL, spaceCardPaddingTB * 1.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconButton(
            "图书馆",
            0xe61a,
          ),
          _buildIconButton(
            "成绩",
            0xe613,
          ),
          _buildIconButton(
            "校车",
            0xe616,
          ),
          _buildIconButton(
            "校历",
            0xe615,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String title, int codePoint,
      {GestureTapCallback onTap, Color color}) {
    if (color == null) color = themeProvider.colorMain;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                color: color.withOpacity(0.15)),
            padding: EdgeInsets.all(spaceCardPaddingRL / 4),
            child: Icon(
              IconData(codePoint, fontFamily: "CY"),
              color: color,
              size: fontSizeMain40 * 2.3,
            ),
          ),
          SizedBox(
            height: fontSizeMain40 / 3,
          ),
          FlyText.mini30(
            title,
            color: themeProvider.colorNavText,
          )
        ],
      ),
    );
  }
}
class FlyUnitCard extends StatefulWidget {
  final int codePoint;
  final String title;
  final String previewText;
  final Widget child;
  FlyUnitCard(this.codePoint, this.title, this.previewText,
      {this.child});
  @override
  _FlyUnitCardState createState() => _FlyUnitCardState();
}

class _FlyUnitCardState extends State<FlyUnitCard> {
  ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return FlyContainer(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB * 1.4,
          spaceCardPaddingRL, spaceCardPaddingTB * 1.2),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                IconData(widget.codePoint, fontFamily: "CY"),
                color: themeProvider.colorMain,
                size: fontSizeMain40 * 1.7,
              ),
              SizedBox(
                width: fontSizeMain40 / 2,
              ),
              FlyText.mini30(widget.title,fontWeight: FontWeight.w600,color: themeProvider.colorNavText.withOpacity(0.7),),
              FlyText.main40(
                "    \\    ",
                color: themeProvider.colorNavText.withOpacity(0.3),
              ),
              FlyText.mini30(
                widget.previewText,
                color: themeProvider.colorNavText.withOpacity(0.6),
              )
            ],
          ),
          Divider(height: spaceCardPaddingTB*1.8,),
          Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL/4, 0, spaceCardPaddingRL/4, spaceCardPaddingTB),
            child: widget.child ?? Container(),
          )
        ],
      ),
    );
  }
}
