//跳转到当前页面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../../../ui/ui.dart';
import '../../../../util/logger/log.dart';

void toCumtLoginHelpPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => CumtLoginHelpPage()));
  Logger.log('CumtLoginHelp', '进入', {});
}

class CumtLoginHelpPage extends StatefulWidget {
  @override
  _CumtLoginHelpPageState createState() => _CumtLoginHelpPageState();
}

class _CumtLoginHelpPageState extends State<CumtLoginHelpPage> {
  Widget helpItem(
    String imageResource,
    String text,
  ) =>
      Wrap(
        children: [
          FlyText.title45(
            text,
            maxLine: 100,
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(deviceWidth * 0.1)),
            child: Container(
              decoration: BoxDecoration(boxShadow: [boxShadowMain]),
              child: Center(
                child: Image.asset(
                  imageResource,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      );

  Widget buildText(
      {@required String title,
      List<String> textList,
      List<String> littleTextList}) {
    return Wrap(
      runSpacing: 10,
      children: [
        FlyTitle(title),
        Wrap(
          runSpacing: 5,
          children: textList
              .map((e) => FlyText.title45(
                    "        $e",
                    maxLine: 100,
                  ))
              .toList(),
        ),
        littleTextList != null
            ? Wrap(
                runSpacing: 5,
                children: littleTextList
                    .map(
                      (e) => FlyText.main40(
                        "        $e",
                        maxLine: 100,
                        color: Color(0xff8d8d93),
                      ),
                    )
                    .toList(),
              )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "用！ 前！ 必！ 看！ 求求了！QAQ"),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.all(spaceCardMarginRL),
              child: Wrap(
                runSpacing: 20,
                children: [
                  buildText(title: '矿小助校园网登录本质', textList: [
                    '相当于在校园网登录网站http://10.2.5.251/上登录，矿小助只是帮你自动填写账号密码，然后自动登录。',
                  ]),
                  buildText(title: '如何开启自动登录', textList: [
                    '用矿小助成功登录一次校园网，即可开启。',
                  ]),
                  buildText(title: '自动登录的时机', textList: [
                    'App从后台调出或者初始化的时候',
                  ]),
                  UniversalPlatform.isAndroid
                      ? buildText(title: '系统弹出认证页面？', textList: [
                          '直接回到主页，打开矿小助即可自动登录',
                        ], littleTextList: [
                          '如果觉得总是弹出认证页面很烦，可以在CUMT_STU的Wi-Fi设置中关闭"自动认证"功能。如果没有这个选项，那就算了叭。'
                        ])
                      : buildText(title: '系统弹出认证页面？', textList: [
                          '可以在CUMT_STU的Wi-Fi设置中关闭"自动登录"功能。',
                        ]),
                  UniversalPlatform.isAndroid
                      ? buildText(title: '同时开启WI-FI与流量时无法自动登录？', textList: [
                          '关闭流量，只开启WI-FI，再用矿小助登录。',
                          '或者关闭“智能助手”或"双通道网络加速"功能（或类似的功能）。',
                        ], littleTextList: [
                          "当您同时打开Wi-Fi和流量时，Android系统的双通道网络加速可能会通过流量发送网络请求而不是通过Wi-Fi。导致矿小助的流量不走WI-FI。",
                          "请注意，不同型号的手机上，该功能的名称可能会有所不同。如果您无法找到此功能，请去网上搜索一下。",
                        ])
                      : Container(),
                ],
              ))),
    );
  }
}
