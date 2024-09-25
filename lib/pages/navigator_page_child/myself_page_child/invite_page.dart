import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  Widget button(String title,
      {GestureTapCallback? onTap, String? imageAsset, Color? color,IconData? iconData}) {
    Widget leadingIcon = Icon(Icons.ac_unit, color: Colors.white);
    if(imageAsset!=null){
      leadingIcon = Image.asset(
        imageAsset,
        height: fontSizeMain40 * 1.2,
      );
    }
    if(iconData!=null){
      leadingIcon = Icon(iconData, color: Colors.white);
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40 * 3,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon,
            SizedBox(
              width: 5,
            ),
            FlyText.main35(title, color: Colors.white),
          ],
        ),
      ),
    );
  }

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
                      width: fontSizeMini38 / 4,
                      height: fontSizeTitle45,
                      decoration: BoxDecoration(
                          color: colorMain,
                          borderRadius:
                              BorderRadius.circular(borderRadiusValue)),
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(35),
                    ),
                    Text(
                      "联系我们",
                      style: TextStyle(
                        fontSize: fontSizeTitle45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                FlyText.miniTip30("点击卡片复制"),
              ],
            ),
            Container(), Container(),
            //分享矿小助官网
            button("矿小助官网", imageAsset: "images/logoWhite.png",color: colorMain, onTap: () {
              Clipboard.setData(ClipboardData(text: "http://kxz.atcumt.com/"));
              showToast("已复制到粘贴板，快分享给好友吧~");
              Logger.log("Invite", "分享", {"type": "官网"});
            }),
            //分享群号
            button("QQ群号",color: Colors.blue,iconData: MdiIcons.qqchat,onTap: (){
              Clipboard.setData(ClipboardData(text: "957634136"));
              showToast("已复制到粘贴板，快分享给好友吧~");
              Logger.log("Invite", "分享", {"type": "QQ群"});
            }),
            Container()
          ],
        ),
      ],
    );
  }
}
