

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        Wrap(
          runSpacing: spaceCardMarginBigTB,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: fontSizeMini38/4,
                      height: fontSizeTitle45,
                      decoration: BoxDecoration(color: colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
                    ),
                    SizedBox(width: ScreenUtil().setSp(35),),
                    Text(
                      "邀请好友",
                      style: TextStyle(
                        color: colorMainText,
                        fontSize: fontSizeTitle45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FlyTextTip30("点击复制下载链接"),

              ],
            ),
            Container(),Container(),
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: "https://cumt-kxz-1300931999.cos.ap-nanjing.myqcloud.com/CUMT-KXZ/FlyingKXZ.apk"));
                showToast(context,"已复制安卓版本下载链接\n快分享给好友吧～！",);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  color: colorMain
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.android,color: Colors.white,),
                    FlyTextMini35("安卓版",color: Colors.white),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: "https://testflight.apple.com/join/hVUvhb9I"));
                showToast(context,"已复制iOS版本下载链接\n感谢您的支持！QAQ",);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    color: Colors.blueGrey
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(MdiIcons.apple,color: Colors.white,),
                    FlyTextMini35("IOS版",color: Colors.white),
                  ],
                ),
              ),
            ),
            Container(),
            FlyTextTip30("IOS版本需要用Safari浏览器打开链接，\n安卓版随便找个浏览器就可以～")
          ],
        ),
      ],
    );
  }
}
