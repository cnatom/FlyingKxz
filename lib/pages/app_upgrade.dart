import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void checkUpgrade(BuildContext context)async{
  if(Global.prefs.getBool(Global.prefsStr.igUpgrade)==false&&Platform.isAndroid){
    await upgradeApp(context,auto: true);//用户没有忽略过则检查更新
  }
  debugPrint("@@checkUpgrade");
}
Future<Null> upgradeApp(BuildContext context,{bool auto = false})async{
  Global.curVersion = (await PackageInfo.fromPlatform()).version;
  Response res;
  Dio dio = Dio();
  try{
    res = await dio.get(
        Global.apiUrl.appUpgradeUrl,
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
        if(auto==false) showToast(context, "当前为最新版本！");
      }
    }else{
      if(auto==false) showToast(context, '获取最新版本失败(X_X)');
    }
  }catch(e){
    if(auto==false)showToast(context, '获取最新版本失败(X_X)');
    debugPrint(e.toString());
  }
}

Future<void> updateAlert(BuildContext context, Map data) async {
  bool isForceUpdate = data['isForceUpdate']; // 从数据拿到是否强制更新字段
  showDialog( // 显示对话框
    context: context,
    barrierDismissible: false, // 点击空白区域不结束对话框
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
            children: <Widget>[
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FlyTextTitle45("发现最新版本！",fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: new Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    child: new Text('$info',
                        style: new TextStyle(color: Color(0xff7A7A7A)))),
              ),
              getLoadingWidget(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Center(child: FlyTextMain40("立即更新",color: colorMain,fontWeight: FontWeight.w600),),
                      onTap: () => upgradeHandle(),
                    ),
                  ),
                  widget.isForceUpdate?Container():Expanded(
                    child: InkWell(
                      child: Center(child: FlyTextMain40("忽略",color: Colors.black38,fontWeight: FontWeight.w600),),
                      onTap: ()async{
                        Global.prefs.setBool(Global.prefsStr.igUpgrade, true);
                        Navigator.of(context).pop();
                      },
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * Android更新处理
  * */
  void _androidUpdate() async {
    final apkPath = await FileUtil.getInstance().getSavePath("/Download/");
    try {
      await Dio().download(
        widget.updateUrl,
        apkPath + "test.apk",
        cancelToken: token,
        onReceiveProgress: (int count, int total) {
          if (mounted) {
            setState(() {
              _downloadProgress = ((count / total) * 100).toInt();
              if (_downloadProgress == 100) {
                if (mounted) {
                  setState(() {
                    uploadingFlag = UploadingFlag.uploaded;
                  });
                }
                debugPrint("读取的目录:$apkPath");
                try {
                  OpenFile.open(apkPath + "test.apk");
                } catch (e) {}
                Navigator.of(context).pop();
              }
            });
          }
        },
        options: Options(sendTimeout: 15 * 1000, receiveTimeout: 360 * 1000),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          uploadingFlag = UploadingFlag.uploadingFailed;
        });
      }
    }
  }

  /*
  * 进度显示的组件
  * */
  Widget getLoadingWidget() {
    if (_downloadProgress != 0 && uploadingFlag == UploadingFlag.uploading) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        width: double.infinity,
        height: 40,
        alignment: Alignment.center,
        child: LinearProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          backgroundColor: Colors.grey[300],
          value: _downloadProgress / 100,
        ),
      );
    }

    /*
    * 如果是在进行中并且进度为0则显示
    * */
    if (uploadingFlag == UploadingFlag.uploading && _downloadProgress == 0) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorMainText)),
            SizedBox(width: 5),
            Material(
              child: Text(
                '等待',
                style: TextStyle(color: colorMainText),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      );
    }

    /*
    * 如果下载失败则显示
    * */
    if (uploadingFlag == UploadingFlag.uploadingFailed) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.clear, color: Colors.redAccent),
            SizedBox(width: 5),
            Material(
              child: Text(
                '下载超时',
                style: TextStyle(color: colorMainText),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      );
    }
    return Container();
  }

  /*
  * IOS更新处理，直接打开AppStore链接
  * */
  void _iosUpdate() {
    launch(widget.updateUrl);
  }

  /*
  * 更新处理事件
  * */
  upgradeHandle() {
    if (uploadingFlag == UploadingFlag.uploading) return;
    uploadingFlag = UploadingFlag.uploading;
    // 必须保证当前状态安全，才能进行状态刷新
    if (mounted) setState(() {});
    // 进行平台判断
    if (Platform.isAndroid) {
      _androidUpdate();
    } else if (Platform.isIOS) {
      _iosUpdate();
    }
  }

  ///跳转本地浏览器
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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