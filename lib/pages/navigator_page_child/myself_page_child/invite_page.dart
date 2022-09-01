

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/buttons.dart';
import 'package:flying_kxz/ui/config.dart';

import 'package:flying_kxz/ui/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
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
                      "分享App",
                      style: TextStyle(
                        fontSize: fontSizeTitle45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FlyText.miniTip30("点击分享"),

              ],
            ),
            Container(),Container(),
            //分享矿小助官网
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: "http://kxz.atcumt.com/"));
                showToast("已复制到粘贴板，快分享给好友吧~");
                sendInfo('分享App', '分享了矿小助官网');
              },
              child: Container(
                height: fontSizeMain40*3,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  color: colorMain
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/logoWhite.png",height: fontSizeMain40*1.2,),
                    SizedBox(width: 5,),
                    FlyText.main35("矿小助官网",color: Colors.white),
                  ],
                ),
              ),
            ),
            //分享群号
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: "957634136"));
                showToast( "已复制到粘贴板，快分享给好友吧~");
                sendInfo('分享App', '分享了QQ群号');
              },
              child: Container(
                height: fontSizeMain40*3,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    color: Colors.blue
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(MdiIcons.qqchat,color: Colors.white),
                    FlyText.main35("QQ群号",color: Colors.white),
                  ],
                ),
              ),
            ),
            Container()
          ],
        ),
      ],
    );
  }
}
