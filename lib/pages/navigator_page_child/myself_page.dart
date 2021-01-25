//"我的"页面
import 'dart:io';
import 'dart:ui';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme_switch_button.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
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
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/activeStep_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/invite_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'myself_page_child/cumtLogin_view.dart';


class MyselfPage extends StatefulWidget {
  @override
  _MyselfPageState createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage> with AutomaticKeepAliveClientMixin{

  void getPreviewInfo()async{
    await powerGet(context,token: Global.prefs.getString(Global.prefsStr.token));
    await rankGet(username: Global.prefs.getString(Global.prefsStr.username));
    await balanceGet(newToken: Global.prefs.getString(Global.prefsStr.newToken));
    setState(() {

    });

  }
  void signOut(){
    Global.clearPrefsData();
    toLoginPage(context);
  }

  void _changeBackgroundImage()async{
    File tempImgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String imageFileName = tempImgFile.path.substring(tempImgFile.path.lastIndexOf('/')+1,tempImgFile.path.length);
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory directory = new Directory('${tempDir.path}/images');
    if (!directory.existsSync()) {
      directory.createSync();
    }
    backImgFile = await tempImgFile.copy('${directory.path}/$imageFileName');
    Global.prefs.setString(Global.prefsStr.backImg, backImgFile.path);
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
            child: FlyText.main40('确定',color: colorMain),),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: FlyText.mainTip40('取消',),
          ),
        ],
      ),
    ) ??
        false;
  }
  Widget buttonListCard({List<Widget> children = const <Widget>[]}){
    return Container(
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor.withOpacity(transparentValue)
      ),
      child: Column(
        children: children,
      ),
    );
  }


  Widget previewItem({@required String title,@required String subTitle})=>Container(
    alignment: Alignment.center,
    child: Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: <Widget>[
        FlyText.main40(title,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor,),
        FlyText.mini30(subTitle,color: Theme.of(context).accentColor,),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    getPreviewInfo();

  }


  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // ChangeThemeButton()
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            //个人资料区域
              Wrap(
              runSpacing: spaceCardMarginBigTB*3,
              children: <Widget>[
                FlyMyselfCard(context,
                    imageResource: 'images/avatar.png',
                    name: Global.prefs.getString(Global.prefsStr.name),
                    id: Global.prefs.getString(Global.prefsStr.username),
                    classs: Global.prefs.getString(Global.prefsStr.iClass),
                    college: Global.prefs.getString(Global.prefsStr.college)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: previewItem(title: "${Global.prefs.getString(Global.prefsStr.balance)??'0.0'}",subTitle: "校园卡余额 (元)",)
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.2),
                      height: fontSizeMini38*2,
                      width: 1,
                    ),
                    Expanded(
                      flex: 1,
                      child: previewItem(title: "${Global.prefs.getString(Global.prefsStr.power)??'0.0'}",subTitle: "宿舍电量 (度)"),
                    ),
                  ],
                ),
                Container()
              ],
            ),
            //可滚动功能区
            Wrap(
              runSpacing: spaceCardMarginTB,
              children: [
                buttonListCard(
                    children: <Widget>[
                      FlyRowMyselfItemButton(
                          icon: Icons.language_outlined,
                          title: '校园网登录',
                          onTap: () {
                            FlyDialogDIYShow(context,content: CumtLoginView());
                          }
                      ),
                      FlyRowMyselfItemButton(
                          icon: LineariconsFree.shirt,
                          title: '更换背景',
                          onTap: ()=>_changeBackgroundImage()
                      ),
                    ]
                ),
                buttonListCard(
                    children: <Widget>[
                      FlyRowMyselfItemButton(
                          icon:  Icons.people_outline,
                          title: '关于我们',
                          onTap: () => toAboutPage(context)
                      ),
                      FlyRowMyselfItemButton(
                          icon: Icons.feedback_outlined,
                          title: '反馈与建议',
                          onTap: () async{
                            String text = await FlyDialogInputShow(context,hintText: "感谢您提出宝贵的建议，这对我们非常重要！\n*｡٩(ˊᗜˋ*)و*｡\n\n(也可以留下您的联系方式，方便我们及时联络您)",confirmText: "发送",maxLines: 10);
                            if(text!=null){
                              await feedbackPost(context, text: text);
                            }
                          }
                      ),
                      FlyRowMyselfItemButton(
                          icon: MdiIcons.heartOutline,
                          title: '邀请好友',
                          onTap: () {
                            FlyDialogDIYShow(context,content: InvitePage());
                          }
                      ),
                      Platform.isIOS?Container():FlyRowMyselfItemButton(
                          icon: CommunityMaterialIcons.download_outline,
                          title: '检查更新',
                          onTap: () {
                            Global.prefs.setBool('igUpgrade', false);
                            upgradeApp(context,auto: false);
                          }
                      )
                    ]
                ),
                FlyCenterMyselfItemButton(context,'永久激活  "校园卡余额"  功能',onTap: ()=>toActiveStepPage(context),),
                FlyCenterMyselfItemButton(context,'退出登录',onTap: ()=>willSignOut(context)),
              ],
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: fontSizeMini38,),
                  FlyText.miniTip30("矿小助-正式版 ${Global.curVersion} "),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
