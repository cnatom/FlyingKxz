import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:package_info/package_info.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

void checkUpgrade(BuildContext context, {bool auto = true}) async {
  if (UniversalPlatform.isIOS) {
    return;
  }
  Global.curVersion = (await PackageInfo.fromPlatform()).version;
  Response res;
  Dio dio = Dio();
  try {
    res = await dio.get(ApiUrl.appUpgradeUrl,
        queryParameters: {'version': Global.curVersion.toString()});
    Map<String, dynamic> map = jsonDecode(res.toString());
    print(map.toString());
    if (map['status'] == 200) {
      if (map['check'] == true) {
        if(auto==true && Prefs.prefs.getString("ignore_version_url")==map['apkUrl']){
          return;
        }else{
          updateAlert(context, {
            'isForceUpdate': false, //是否强制更新
            'content': map['description'], //版本描述
            'url': map['apkUrl'], // 安装包的链接
          });
        }
      } else {
        if (auto == false) showToast("当前为最新版本！");
      }
    } else {
      if (auto == false) showToast('获取最新版本失败(X_X)');
    }
  } catch (e) {
    if (auto == false) showToast('获取最新版本失败(X_X)');
    debugPrint(e.toString());
  }
}

Future<void> updateAlert(BuildContext context, Map data) async {
  bool isForceUpdate = data['isForceUpdate']; // 从数据拿到是否强制更新字段
  showDialog(
    // 显示对话框
    context: context,
    builder: (_) =>
        new UpgradeDialog(data, isForceUpdate, updateUrl: data['url']),
  );
}

class UpgradeDialog extends StatefulWidget {
  final Map data; // 数据
  final bool isForceUpdate; // 是否强制更新
  final String updateUrl; // 更新的url（安装包下载地址）

  UpgradeDialog(this.data, this.isForceUpdate, {this.updateUrl});

  @override
  _UpgradeDialogState createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  String prefsIgnore = "ignore_version_url";

  @override
  Widget build(BuildContext context) {
    String info = widget.data['content']; // 更新内容

    return new Center(
      child: new Material(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: new Container(
          width: MediaQuery.of(context).size.width * 0.8, // 宽度是整宽的百分之80
          padding: EdgeInsets.fromLTRB(
              0, spaceCardPaddingTB * 2, 0, spaceCardPaddingTB * 2),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadiusValue)), // 圆角
          ),
          child: Wrap(
            runSpacing: spaceCardMarginBigTB,
            children: <Widget>[
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FlyText.title45("发现最新版本！", fontWeight: FontWeight.bold),
              ),
              Container(
                height: ScreenUtil().setHeight(deviceHeight / 2),
                width: double.infinity,
                child: new SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      child: new Text('$info',
                          style: new TextStyle(color: Color(0xff7A7A7A)))),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: _buildButton("取消", prime: false, onTap: () {
                    Navigator.of(context).pop();
                  })),
                  Expanded(
                      child:
                          _buildButton("忽略该版本", prime: false, onTap: () async {
                    if (await _willIgnore(context)) {
                      Prefs.prefs.setString(prefsIgnore, widget.updateUrl);
                      Navigator.of(context).pop();
                    }
                  })),
                  Expanded(
                    child: _buildButton("立即更新", onTap: () {
                      launchUrl(Uri.parse(widget.updateUrl),
                          mode: LaunchMode.externalApplication);
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _willIgnore(context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: FlyText.main40(
              '如果有发布新的版本，依然会提醒您。\n您也可以前往"我的"页面手动更新。\n\n确定要忽略本次版本更新吗?\n',
              maxLine: 100,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: FlyText.main40('确定', color: colorMain),
              ),
              TextButton(
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

  Widget _buildButton(String title,
      {bool prime = true, GestureTapCallback onTap}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: FlyText.main40(title,
            color: prime ? colorMain : Colors.black38,
            fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
