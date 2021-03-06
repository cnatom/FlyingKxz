//"我的"页面
import 'dart:io';
import 'dart:ui';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/FlyingUiKit/text_editer.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/balance_get.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:flying_kxz/NetRequest/feedback_post.dart';
import 'package:flying_kxz/NetRequest/power_get.dart';
import 'package:flying_kxz/NetRequest/rank_get.dart';
import 'package:flying_kxz/pages/app_upgrade.dart';
import 'package:flying_kxz/pages/backImage_view.dart';
import 'package:flying_kxz/pages/login_page.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/about_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/invite_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'myself_page_child/cumtLogin_view.dart';

class MyselfPage extends StatefulWidget {
  @override
  _MyselfPageState createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage>
    with AutomaticKeepAliveClientMixin {
  ThemeProvider themeProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _powerNumController = new TextEditingController();
  bool powerLoading = false;

  @override
  void initState() {
    super.initState();
    getPreviewInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        brightness: themeProvider.simpleMode?Brightness.light:Brightness.dark,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              //个人资料区域
              Wrap(
                runSpacing: spaceCardMarginBigTB * 3,
                children: <Widget>[
                  _buildInfoCard(context,
                      imageResource: 'images/avatar.png',
                      name: Prefs.name??'',
                      id: Prefs.username??'',
                      classs: Prefs.iClass??'',
                      college: Prefs.college??''),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Expanded(
                  //         flex: 1,
                  //         child: previewItem(
                  //           title:
                  //               "${Prefs.balance ?? '0.0'}",
                  //           subTitle: "校园卡余额 (元)",
                  //         )),
                  //     Container(
                  //       color: themeProvider.colorNavText.withOpacity(0.2),
                  //       height: fontSizeMini38 * 2,
                  //       width: 1,
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: previewItem(
                  //           title:
                  //               "${Prefs.power ?? '0.0'}",
                  //           subTitle: "宿舍电量 (度)"),
                  //     ),
                  //   ],
                  // ),
                  Container()
                ],
              ),
              //可滚动功能区
              Wrap(
                runSpacing: spaceCardMarginTB,
                children: [
                  _buttonList(children: <Widget>[
                    FlyFlexibleButton(
                      icon: Icons.language_outlined,
                      title: '校园网登录',
                      secondChild: CumtLoginView(),),
                    FlyFlexibleButton(
                      title: "个性化",
                      icon: LineariconsFree.shirt,
                      secondChild: _buildPersonalise(),
                    ),
                  ]),
                  _buttonList(children: <Widget>[

                    FlyFlexibleButton(
                      title: "校园卡余额",
                      icon: Icons.monetization_on_outlined,
                      previewStr: (Prefs.balance??"0.0")+"元",
                      secondChild: Padding(
                        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
                        child: _buildDiyButton("校园卡流水",
                            onTap: ()=> showToast(context, "开发中……请保持最新版本"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.arrow_right_sharp,
                                  size: sizeIconMain50,
                                  color: themeProvider.colorNavText.withOpacity(0.5),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                    FlyFlexibleButton(
                      title: "宿舍电量",
                      icon: Icons.flash_on,
                      previewStr: Prefs.power==null?"未绑定":"${Prefs.power}度",
                      secondChild: _buildPower(),
                    )
                  ]),

                  _buttonList(children: <Widget>[
                    _buildIconTitleButton(
                        icon: Icons.people_outline,
                        title: '关于我们',
                        onTap: () => toAboutPage(context)),
                    _buildIconTitleButton(
                        icon: Icons.feedback_outlined,
                        title: '反馈与建议',
                        onTap: () async {
                          String text = await FlyDialogInputShow(context,
                              hintText:
                              "感谢您提出宝贵的建议，这对我们非常重要！\n*｡٩(ˊᗜˋ*)و*｡\n\n(也可以留下您的联系方式，方便我们及时联络您)",
                              confirmText: "发送",
                              maxLines: 10);
                          if (text != null) {
                            await feedbackPost(context, text: text);
                          }
                        }),
                    _buildIconTitleButton(
                        icon: MdiIcons.heartOutline,
                        title: '邀请好友',
                        onTap: () {
                          FlyDialogDIYShow(context, content: InvitePage());
                        }),
                    Platform.isIOS
                        ? Container()
                        : _buildIconTitleButton(
                        icon: CommunityMaterialIcons.download_outline,
                        title: '检查更新',
                        onTap: () {
                          upgradeApp(context, auto: false);
                        }),

                  ]),
                  _buttonList(children: [
                    _buildIconTitleButton(icon: Icons.logout, title: "退出登录",onTap: ()=>willSignOut(context))
                  ])
                ],
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: fontSizeMini38,
                    ),
                    FlyText.miniTip30("矿小助-正式版 ${Global.curVersion} "),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPower(){
    void _handlePower()async{
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        powerLoading = true;
      });
      if(_powerNumController.text.isNotEmpty||Prefs.powerHome!=null){
        Prefs.powerNum = _powerNumController.text.toString();
        bool ok = await powerGet(context, token: Prefs.token, home: Prefs.powerHome, num: Prefs.powerNum);
        if(!ok) showToast(context, "获取失败，请再检查一下参数");
      }else{
        showToast(context, "请输入完整");
      }
      setState(() {
        powerLoading = false;
      });
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      child: Wrap(
        children: [
          _buildPreviewButton("宿舍楼",Prefs.powerHome??"未选择",onTap: ()=>_handlePowerPicker()),
          _buildInputButton("宿舍号", Prefs.powerNum??"未选择"),
          FlyWidgetBuilder(
            whenFirst: powerLoading,
            firstChild: _buildTitleCenterButton(context, "加载中……"),
            secondChild: _buildTitleCenterButton(context, "绑定",onTap: ()=>_handlePower(),
          ))
        ]
      ),
    );
  }
  void _handlePowerPicker()async{
    showPicker(context, _scaffoldKey,
        title: "选择宿舍楼",
        pickerDatas: PickerData.apartment,
        isArray: false,
        onConfirm: (Picker picker, List value) {
          String home = picker.getSelectedValues()[1].toString();
          Prefs.powerHome = home;
          setState(() {

          });
        });
  }
  Widget _buildPersonalise() {
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      child: Wrap(
        children: [
          _buildDiyButton("简约白", child: _buildSwitch(themeProvider.simpleMode, onChanged: (v){
            setState(() {
              themeProvider.simpleMode = !themeProvider.simpleMode;
            });
          })),
          _buildDiyButton("深邃黑", child: _buildSwitch(themeProvider.darkMode, onChanged: (v){
            setState(() {
              themeProvider.darkMode = !themeProvider.darkMode;
            });
          })),

          _buildDiyButton("更换背景",
              onTap: ()=> _changeBackgroundImage(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_right_sharp,
                    size: sizeIconMain50,
                    color: themeProvider.colorNavText.withOpacity(0.5),
                  )
                ],
              )
              ),
          _buildDiyButton("背景透明",
              child: _buildSliver(themeProvider.transBack, onChanged: (v) {
                themeProvider.transBack = v;
              })
          ),
          _buildDiyButton("背景模糊",
              child: _buildSliver(themeProvider.blurBack,max: 30.0, onChanged: (v) {
                themeProvider.blurBack = v;
              })
          ),
          _buildDiyButton("卡片透明",
              child: _buildSliver(themeProvider.transCard,min: 0.01,max:themeProvider.darkMode?0.8:0.2, onChanged: (v) {
                themeProvider.transCard = v;
              })
          ),

        ],
      ),
    );
  }
  Widget _buildInputButton(String title,String previewStr,{GestureTapCallback onTap}){
    return _buildDiyButton(title,
        child: _buildInputBar("输入寝室号(如B1052)", _powerNumController)
    );
  }
  Widget _buildInputBar(String hintText,TextEditingController controller){
    return TextFormField(
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: fontSizeMain40,color: themeProvider.colorNavText.withOpacity(0.8)),
      controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
      cursorColor: colorMain,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: fontSizeMain40,color: themeProvider.colorNavText.withOpacity(0.5)),
        border: InputBorder.none, //下划线
        hintText: hintText, //点击后显示的提示语
      ),
    );
  }
  Widget _buildPreviewButton(String title,String previewStr,{GestureTapCallback onTap}){
    return _buildDiyButton(title,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlyText.main35(previewStr,color: themeProvider.colorNavText.withOpacity(0.5),),
            SizedBox(width: fontSizeMini38,),
            Icon(
              Icons.arrow_right_sharp,
              size: sizeIconMain50,
              color: themeProvider.colorNavText.withOpacity(0.5),
            )
          ],
        )
    );
  }
  Widget _buildDiyButton(String title,{@required Widget child,GestureTapCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40*3.5,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FlyText.main35(title,color: themeProvider.colorNavText,),
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
  Widget _buildSwitch(bool value,{@required ValueChanged<bool> onChanged}){
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
      {double max = 1.0,double min = 0.0, @required ValueChanged<double> onChanged}) {
    return Slider(
      inactiveColor: Theme.of(context).unselectedWidgetColor,
      activeColor: themeProvider.colorMain,
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
    );
  }

  void getPreviewInfo() async {
    await powerGet(context,
        token: Prefs.token, num: Prefs.powerNum, home: Prefs.powerHome);
    await rankGet(username: Prefs.username);
    await balanceGet(
        newToken: Prefs.token);
    setState(() {});
  }

  void signOut() {
    Global.clearPrefsData();
    toLoginPage(context);
  }
  void _changeBackgroundImage() async {
    File tempImgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String imageFileName = tempImgFile.path.substring(
        tempImgFile.path.lastIndexOf('/') + 1, tempImgFile.path.length);
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/images');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    backImgFile = await tempImgFile.copy('${directory.path}/$imageFileName');
    Prefs.backImg = backImgFile.path;
    navigatorPageController.jumpToPage(0);
  }

  //确定退出
  Future<bool> willSignOut(context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: FlyText.main40('你确定要退出登录吗?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => signOut(),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: FlyContainer(
          child: Column(
        children: children,
      )),
    );
  }



  Widget _buildIconTitleButton(
          {@required IconData icon,
          @required String title,
          GestureTapCallback onTap}) =>
      InkWell(
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
                  Icon(
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
              FlyIconRightGreyArrow(color: themeProvider.colorNavText.withOpacity(0.5))
            ],
          ),
        ),
      );
//个人资料卡
  Widget _buildInfoCard(BuildContext context,
          {String imageResource = "",
          String name = "",
          String id = "",
          String classs = "",
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
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlyText.title45(name,
                    color: themeProvider.colorNavText, fontWeight: FontWeight.bold),
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
  Widget previewItem({@required String title, @required String subTitle}) =>
      Container(
        alignment: Alignment.center,
        child: Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: <Widget>[
            FlyText.main40(
              title,
              fontWeight: FontWeight.bold,
              color: themeProvider.colorNavText,
            ),
            FlyText.mini30(
              subTitle,
              color: themeProvider.colorNavText.withOpacity(0.5),
            ),
          ],
        ),
      );
  Widget _buildTitleCenterButton(BuildContext context, String title,
      {GestureTapCallback onTap,}) {
    return InkWell(
      onTap: onTap,
      child: FlyContainer(
        margin: EdgeInsets.fromLTRB(
            0, spaceCardPaddingTB , 0, spaceCardPaddingTB ),
        padding: EdgeInsets.fromLTRB(
            0, spaceCardPaddingTB , 0, spaceCardPaddingTB ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlyText.main35(
              title,
              color: themeProvider.colorNavText,
            )
          ],
        ),
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
  const FlyFlexibleButton({Key key, this.secondChild, this.title, this.icon, this.previewStr})
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
    if(opacity>0)opacity = themeProvider.transCard;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Theme.of(context).cardColor.withOpacity(opacity)
      ),
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
              padding:
              EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, spaceCardMarginTB),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    color: Theme.of(context).cardColor.withOpacity(opacity)),
                child: Column(
                  children: [
                    themeProvider.simpleMode?Padding(
                      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
                      child: Divider(height: 0,),
                    ):Container(),
                    widget.secondChild
                  ],
                ),
              ),
            ),
            duration: Duration(milliseconds: 200),
            crossFadeState:
            showSecond ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          )
        ],
      ),
    );
  }

  Widget _button() => InkWell(
        onTap: () {
          setState(() {
            showSecond = !showSecond;
            if(showSecond){
              opacity = themeProvider.transCard;
            }else{
              opacity = 0;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
              spaceCardPaddingRL, fontSizeMain40 * 1.3),
          child:Row(
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
                          widget.previewStr!=null?FlyText.main35(widget.previewStr,color: themeProvider.colorNavText.withOpacity(0.5),):Container()
                        ],
                      ),
                    ),
                    SizedBox(width: fontSizeMini38,)
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
