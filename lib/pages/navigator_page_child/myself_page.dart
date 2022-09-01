//"我的"页面
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/cumt/cumt.dart';
import 'package:flying_kxz/pages/app_upgrade.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/components/preview.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/utils/provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/invite_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/components/preview.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/Theme/theme.dart';
import 'package:flying_kxz/ui/config.dart';
import 'package:flying_kxz/ui/container.dart';
import 'package:flying_kxz/ui/dialog.dart';
import 'package:flying_kxz/ui/loading.dart';
import 'package:flying_kxz/ui/webview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

import 'myself_page_child/aboutus/about_page.dart';
import 'myself_page_child/cumt_login/cumtLogin_view.dart';

class MyselfPage extends StatefulWidget {
  @override
  _MyselfPageState createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage>
    with AutomaticKeepAliveClientMixin {
  ThemeProvider themeProvider;
  Cumt cumt; // 用于网络请求

  @override
  void initState() {
    super.initState();
    cumt = Cumt.getInstance();
    _initBalanceAndPowerProvider();
    sendInfo('我的', '初始化我的页面');
  }

  // 退出登录
  void _signOut() async {
    sendInfo('退出登录', '退出了登录');
    await Global.clearPrefsData();
    backImgFile = null;
    await cumt.clearCookie();
    cumt.init();
    toLoginPage(context);
  }

  // 初始化校园卡余额与宿舍电量
  Future<bool> _initBalanceAndPowerProvider()async{
    bool ok = true;
    await Future.wait([cumt.login(Prefs.username??"", Prefs.password??"")]).then((value)async{
      ok &= await Provider.of<BalanceProvider>(context,listen: false).getBalance();
      ok &= await Provider.of<PowerProvider>(context,listen: false).getPreview();
      ok &= await Provider.of<BalanceProvider>(context,listen: false).getBalanceHistory();
    });
    return ok;
  }


  Future<void> _feedback() async {
    String text = await FlyDialogInputShow(context,
        hintText:
            "感谢您提出宝贵的建议，这对我们非常重要！\n*｡٩(ˊᗜˋ*)و*｡\n\n(也可以留下您的联系方式，方便我们及时联络您)",
        confirmText: "发送",
        maxLines: 10);
    if (text != null) {
      await cumt.dio.post("https://user.kxz.atcumt.com/admin/version_new", data: {'data': text,});
      sendInfo('反馈与建议', '发送了反馈:$text');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return _myselfScaffold(children: [
      SizedBox(
        height: kToolbarHeight,
      ),
      _header(), // 个人资料区域
      Wrap(
        runSpacing: spaceCardMarginTB,
        children: [
          // NoticeCard(),
          _preview(), // 校园卡、宿舍电量
          _container1(), // 校园网登录、、
          _container2(), // 关于我们、、
          _container3() // 退出登录、、
        ],
      ),
      SizedBox(
        height: 10,
      ),
      _privacyTextButton()
    ]);
  }

  Widget _myselfScaffold({@required List<Widget> children}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          leading: Container(),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: themeProvider.simpleMode ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  spaceCardMarginRL, 0, spaceCardMarginRL, 0),
              child: Column(
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Wrap(
      runSpacing: spaceCardMarginBigTB * 2,
      children: <Widget>[
        _buildInfoCard(context,
            imageResource: 'images/avatar.png',
            name: Prefs.name ?? '',
            id: Prefs.username ?? '',
            classs: Prefs.className ?? '',
            college: Prefs.college ?? ''),
        Container(),
        Container()
      ],
    );
  }

  Widget _preview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BalancePreviewView(),
        ),
        SizedBox(
          width: spaceCardMarginRL,
        ),
        Expanded(
          child: PowerPreviewView(),
        ),
      ],
    );
  }

  Widget _myselfIconTitleButton(
      {@required IconData icon,
      @required String title,
      GestureTapCallback onTap,
      bool loading = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
            spaceCardPaddingRL, fontSizeMain40 * 1.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                loading
                    ? loadingAnimationIOS()
                    : Icon(
                        icon,
                        size: sizeIconMain50,
                        color: themeProvider.colorNavText,
                      ),
                SizedBox(
                  width: spaceCardPaddingTB * 3,
                ),
                FlyText.main40(
                  title,
                  color: themeProvider.colorNavText,
                )
              ],
            ),
            FlyIconRightGreyArrow(
                color: themeProvider.colorNavText.withOpacity(0.5))
          ],
        ),
      ),
    );
  }

  Widget _privacyTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => FlyWebView(
                      title: "隐私政策",
                      initialUrl: "https://kxz.atcumt.com/privacy.html",
                    )));
      },
      child: FlyText.main35(
        "隐私政策",
        color: themeProvider.colorNavText.withOpacity(0.5),
      ),
    );
  }

  Widget _container1() {
    return _buttonList(children: <Widget>[
      FlyFlexibleButton(
        icon: Icons.language_outlined,
        title: '校园网登录',
        secondChild: CumtLoginView(),
      ),
      FlyFlexibleButton(
        title: "个性化",
        icon: LineariconsFree.shirt,
        secondChild: _buildPersonalise(),
      ),
    ]);
  }

  Widget _container2() {
    return _buttonList(children: <Widget>[
      // 关于我们
      _myselfIconTitleButton(
          icon: Icons.people_outline,
          title: '关于我们',
          onTap: () => toAboutPage(context)),
      //反馈与建议
      _myselfIconTitleButton(
          icon: Icons.feedback_outlined,
          title: '反馈与建议',
          onTap: () => _feedback()),
      //分享App
      _myselfIconTitleButton(
          icon: Icons.share_outlined,
          title: '分享App',
          onTap: () => FlyDialogDIYShow(context, content: InvitePage())),
      UniversalPlatform.isIOS
          ? Container()
          : _myselfIconTitleButton(
              icon: CommunityMaterialIcons.download_outline,
              title: '检查更新',
              onTap: () => checkUpgrade(context, auto: false)),
    ]);
  }

  Widget _container3() {
    return _buttonList(children: [
      _myselfIconTitleButton(
          icon: Icons.logout, title: "退出登录", onTap: () => _willSignOut(context))
    ]);
  }

  Widget _buildPersonalise() {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      child: Wrap(
        children: [
          _buildDiyButton("简约白",
              child: _buildSwitch(themeProvider.simpleMode, onChanged: (v) {
                setState(() {
                  themeProvider.simpleMode = !themeProvider.simpleMode;
                });
              })),
          _buildDiyButton("深邃黑",
              child: _buildSwitch(themeProvider.darkMode, onChanged: (v) {
                setState(() {
                  themeProvider.darkMode = !themeProvider.darkMode;
                });
              })),
          !UniversalPlatform.isWindows
              ? Wrap(
                  children: [
                    _buildDiyButton("更换背景",
                        onTap: () => _changeBackgroundImage(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_right_sharp,
                              size: sizeIconMain50,
                              color:
                                  themeProvider.colorNavText.withOpacity(0.5),
                            )
                          ],
                        )),
                    _buildDiyButton("背景透明",
                        child: _buildSliver(themeProvider.transBack,
                            onChanged: (v) {
                          themeProvider.transBack = v;
                        })),
                    _buildDiyButton("背景模糊",
                        child: _buildSliver(themeProvider.blurBack, max: 30.0,
                            onChanged: (v) {
                          themeProvider.blurBack = v;
                        })),
                    _buildDiyButton("卡片透明",
                        child: _buildSliver(themeProvider.transCard,
                            min: 0.01,
                            max: themeProvider.darkMode
                                ? 0.8
                                : themeProvider.simpleMode
                                    ? 1.0
                                    : 0.2, onChanged: (v) {
                          themeProvider.transCard = v;
                        })),
                    _buildDiyButton("主题颜色", child: _buildColorSelector()),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    List<Color> themeColors = [
      Color.fromARGB(255, 0, 196, 169),
      Color.fromARGB(255, 0, 186, 253),
      Color.fromARGB(255, 255, 64, 58),
      Color.fromARGB(255, 255, 116, 152),
      Color.fromARGB(255, 0, 109, 252),
      Color.fromARGB(255, 255, 206, 38),
      Color.fromARGB(255, 48, 54, 56),
      Color.fromARGB(255, 200, 200, 200),
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, 0, 0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 10,
          children: themeColors.map((item) {
            return _buildColorCir(item);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColorCir(Color color) {
    return InkWell(
      onTap: () => themeProvider.colorMain = color,
      child: Container(
        height: fontSizeMain40 * 2,
        width: fontSizeMain40 * 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: color),
      ),
    );
  }

  Widget _buildDiyButton(String title,
      {@required Widget child, GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40 * 3.5,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FlyText.main35(
                title,
                color: themeProvider.colorNavText,
              ),
            ),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, {@required ValueChanged<bool> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Switch(
          activeColor: themeProvider.colorMain,
          value: value,
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildSliver(double value,
      {double max = 1.0,
      double min = 0.0,
      @required ValueChanged<double> onChanged}) {
    return Slider(
      inactiveColor: Theme.of(context).unselectedWidgetColor,
      activeColor: themeProvider.colorMain,
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
    );
  }

  void _changeBackgroundImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File tempImgFile = File(pickedFile.path);
    String imageFileName = tempImgFile.path.substring(
        tempImgFile.path.lastIndexOf('/') + 1, tempImgFile.path.length);
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/images');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    backImgFile = await tempImgFile.copy('${directory.path}/$imageFileName');
    backImg = new Image.file(
      backImgFile,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
    await precacheImage(new FileImage(backImgFile), context);
    Prefs.backImg = backImgFile.path;
    navigatorPageController.jumpToPage(0);
  }

  //确定退出
  Future<bool> _willSignOut(context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: FlyText.main40(
              '你确定要退出登录吗?\n\n'
              '这会清除所有本地缓存\n\n（包括自定义背景、自定义课表、自定义倒计时、校园网登录账户信息、宿舍电量绑定信息……）',
              maxLine: 100,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => _signOut(),
                child: FlyText.main40('确定', color: colorMain),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: FlyText.mainTip40(
                  '取消',
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buttonList({List<Widget> children = const <Widget>[]}) {
    return FlyContainer(
        child: Column(
      children: children,
    ));
  }

//个人资料卡
  Widget _buildInfoCard(BuildContext context,
      {String imageResource = "",
      String name = "",
      String id = "",
      String classs = "",
      String college = ""}) {
    String title = "早上好";
    Map subText = {
      0: "☺️ 该睡觉了哦～。",
      1: "🌙 偷偷努力，我们都会成为别人的梦想。",
      2: "🌙 偷偷努力，我们都会成为别人的梦想。",
      3: "😪 小助快要熬不动了～",
      4: "😴 呼噜噜噜噜噜～",
      5: "️🥰 早起的鸟儿有虫吃。",
      6: "😉 ‍一日之计在于晨。",
      7: "🏃 没有醒不来的早晨，只有不敢追的梦。",
      8: "🌦 越是憧憬，就越要风雨兼程。",
      9: "⛅️ 要开心，你迟早是别人的宝藏。",
      10: "🌟 这吹不出褶的平静日子，也在闪光。",
      11: "🌈 前路漫漫亦灿灿。",
      12: "🥳 下课啦，去吃饭吧～",
      13: "☀️ 玻璃晴朗，橘子辉煌。",
      14: "☘️ 信手拈来的从容，都是厚积薄发的沉淀。",
      15: "☘️ 信手拈来的从容，都是厚积薄发的沉淀。",
      16: "☺️ 保持热爱，奔赴山河。",
      17: "☺️ 保持热爱，奔赴山河。",
      18: "🤗 晚饭时间到～",
      19: "💫 别慌，月亮也在大海某处迷茫。",
      20: "⭐️ 错过落日余晖，请记得还有漫天星辰。",
      21: "✨ 星光不问赶路人，时光不负有心人。",
      22: "✨ 星光不问赶路人，时光不负有心人。",
      23: "🌙 还有星月可寄望，还有宇宙浪漫不止。",
    };
    int hour = DateTime.now().hour;
    String sentence = subText[hour];
    if (hour < 5) title = "夜深了";
    if (hour >= 19) {
      title = "晚上好";
    } else if (hour >= 18) {
      title = "傍晚了";
    } else if (hour >= 14) {
      title = "下午好";
    } else if (hour >= 11) {
      title = "中午好";
    } else if (hour >= 8) {
      title = "上午好";
    }

    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: spaceCardMarginRL * 2,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "$title，" + name,
                    style: TextStyle(
                        color: themeProvider.colorNavText,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(60)),
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.fromLTRB(
                  //           fontSizeMini38 / 2, 0, fontSizeMini38 / 2, 0),
                  //       decoration: BoxDecoration(
                  //           color: colorMain.withAlpha(200),
                  //           borderRadius: BorderRadius.circular(2)),
                  //       child: (Prefs.rank!=null&&int.parse(Prefs.rank)<=2000)?Row(
                  //         children: [
                  //           FlyText.mini30("内测会员",
                  //               color: Colors.white,
                  //               textAlign: TextAlign.center),
                  //           FlyText.mini30(
                  //               " No.${Prefs.rank}",
                  //               color: Colors.white)
                  //         ],
                  //       ):Container(),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: FlyText.main40(
                      sentence,
                      color: themeProvider.colorNavText.withOpacity(0.5),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FlyFlexibleButton extends StatefulWidget {
  final Widget secondChild;
  final String title;
  final IconData icon;
  final String previewStr;
  final GestureTapCallback onTap;

  const FlyFlexibleButton(
      {Key key,
      this.secondChild,
      this.title,
      this.icon,
      this.previewStr,
      this.onTap})
      : super(key: key);

  @override
  _FlyFlexibleButtonState createState() => _FlyFlexibleButtonState();
}

class _FlyFlexibleButtonState extends State<FlyFlexibleButton> {
  bool showSecond = false;
  double opacity = 0;
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    if (opacity > 0) opacity = themeProvider.transCard;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor.withOpacity(opacity)),
      child: Column(
        children: [
          _button(),
          AnimatedCrossFade(
            alignment: Alignment.topCenter,
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: Container(),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(
                  spaceCardMarginRL, 0, spaceCardMarginRL, spaceCardMarginTB),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    color: Theme.of(context).cardColor.withOpacity(opacity)),
                child: Column(
                  children: [
                    themeProvider.simpleMode
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                                spaceCardMarginRL, 0, spaceCardMarginRL, 0),
                            child: Divider(
                              height: 0,
                            ),
                          )
                        : Container(),
                    widget.secondChild ?? Container()
                  ],
                ),
              ),
            ),
            duration: Duration(milliseconds: 200),
            crossFadeState: showSecond
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          )
        ],
      ),
    );
  }

  Widget _button() => InkWell(
        onTap: widget.onTap ??
            () {
              setState(() {
                showSecond = !showSecond;
                if (showSecond) {
                  opacity = themeProvider.transCard;
                } else {
                  opacity = 0;
                }
              });
            },
        child: Padding(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
              spaceCardPaddingRL, fontSizeMain40 * 1.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.icon,
                      size: sizeIconMain50,
                      color: themeProvider.colorNavText,
                    ),
                    SizedBox(
                      width: spaceCardPaddingTB * 3,
                    ),
                    FlyText.main40(
                      widget.title,
                      color: themeProvider.colorNavText,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.previewStr != null
                              ? FlyText.main35(
                                  widget.previewStr,
                                  color: themeProvider.colorNavText
                                      .withOpacity(0.5),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      width: fontSizeMini38,
                    )
                  ],
                ),
              ),
              Icon(
                showSecond
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: sizeIconMain50,
                color: themeProvider.colorNavText.withOpacity(0.5),
              )
            ],
          ),
        ),
      );
}
