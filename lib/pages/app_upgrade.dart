import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

void checkUpgrade(BuildContext context,{bool auto = true})async{
  return;
  if(UniversalPlatform.isIOS){
    return;
  }
  Global.curVersion = (await PackageInfo.fromPlatform()).version;

  Response res;
  Dio dio = Dio();
  try{
    res = await dio.get(
        ApiUrl.appUpgradeUrl,
        queryParameters: {'version':Global.curVersion.toString()}
    );
    debugPrint(res.toString());
    Map<String,dynamic> map = jsonDecode(res.toString());
    if(map['status']==200){
      if(map['check']==true){
        updateAlert(context,{
          'isForceUpdate': false,//是否强制更新
          'content': map['description'],//版本描述
          'url': map['apkUrl'],// 安装包的链接
        });
      }else{
        if(auto==false) showToast("当前为最新版本！");
      }
    }else{
      if(auto==false) showToast( '获取最新版本失败(X_X)');
    }
  }catch(e){
    if(auto==false)showToast('获取最新版本失败(X_X)');
    debugPrint(e.toString());
  }
}

Future<void> updateAlert(BuildContext context, Map data) async {
  bool isForceUpdate = data['isForceUpdate']; // 从数据拿到是否强制更新字段
  showDialog( // 显示对话框
    context: context,
    builder: (_) => new UpgradeDialog(data, isForceUpdate, updateUrl: data['url']),
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
  int _downloadProgress = 0; // 进度初始化为0

  CancelToken token;
  UploadingFlag uploadingFlag = UploadingFlag.idle;

  @override
  void initState() {
    super.initState();
    token = new CancelToken(); // token初始化
  }

  @override
  Widget build(BuildContext context) {
    String info = widget.data['content']; // 更新内容

    return new Center(
      // 剧中组件
      child: new Material(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: new Container(
          width: MediaQuery.of(context).size.width * 0.8, // 宽度是整宽的百分之80
          padding: EdgeInsets.fromLTRB(0, spaceCardPaddingTB*2, 0, spaceCardPaddingTB*2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)), // 圆角
          ),
          child: Wrap(
            runSpacing: spaceCardMarginBigTB,
            children: <Widget>[
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FlyText.title45("发现最新版本！",fontWeight: FontWeight.bold),
              ),
              Container(
                height: ScreenUtil().setHeight(deviceHeight/2),
                width: double.infinity,
                child: new SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                      child: new Text('$info',
                          style: new TextStyle(color: Color(0xff7A7A7A)))),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Center(child: FlyText.main40("取消",color: Colors.black38,fontWeight: FontWeight.w600),),
                      onTap: ()async{
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Center(child: FlyText.main40("立即更新",color: colorMain,fontWeight: FontWeight.w600),),
                      onTap: () => launch(widget.updateUrl),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    if (!token.isCancelled) token?.cancel();
    super.dispose();
    debugPrint("升级销毁");
  }
}

enum UploadingFlag { uploading, idle, uploaded, uploadingFailed }

// 文件工具类
class FileUtil {
  static FileUtil _instance;

  static FileUtil getInstance() {
    if (_instance == null) {
      _instance = FileUtil._internal();
    }
    return _instance;
  }

  FileUtil._internal();

  /*
  * 保存路径
  * */
  Future<String> getSavePath(String endPath) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    String path = tempDir.path + endPath;
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return path;
  }
}