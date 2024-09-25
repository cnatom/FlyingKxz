import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:flying_kxz/ui/webview_inapp.dart';

import '../../../../Model/prefs.dart';
import '../../../../util/logger/log.dart';

void toPowerChargePage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => PowerChargePage()));
  Logger.log("PowerCharge", "进入", {});
}

class PowerChargePage extends StatefulWidget {
  const PowerChargePage({Key? key}) : super(key: key);

  @override
  State<PowerChargePage> createState() => _PowerChargePageState();
}

class _PowerChargePageState extends State<PowerChargePage> {
  late InAppWebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return FlyWebViewInApp(
      url:
          "https://authserver.cumt.edu.cn/authserver/login?service=https%3A%2F%2Fyktm.cumt.edu.cn%2Fberserker-auth%2Fcas%2Flogin%2Fwisedu%3FtargetUrl%3Dhttps%3A%2F%2Fyktm.cumt.edu.cn%2Fplat%2F%3Fname%3DloginTransit",
      title: "电费充值",
      autoLogin: true,
      onWebViewCreated: (controller) {
        this._controller = controller;
      },
      onLoadStop: (controller, url) async {
        if (url.rawValue.contains("https://yktm.cumt.edu.cn/plat")) {
          showToast("正在跳转到电费充值界面");
          Future.delayed(Duration(seconds: 1), () async {
            var ok = await _controller.evaluateJavascript(source: '''
    (function() {
      var element = document.evaluate("//div[contains(text(), '缴电费')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
      if (element) {
        element.click();
        return true;
      } else {
        return false;
      }
    })();
  ''');
            if (ok == true) {
              showToast('🎉跳转成功！正在填充房间号……');
            } else {
              showToast('跳转失败，请在页面上点击“缴电费”');
            }
          });
        }
        if(url.rawValue.contains("https://yktm.cumt.edu.cn/web/common/checkEle.html")){
          if (Prefs.powerRoomid != null) {
            Future.delayed(Duration(seconds: 2),()async{
              var result = await _controller.evaluateJavascript(
                  source: '''
    (function() {
      var element = document.getElementById('inputroomid');
      if (element) {
        element.value = '${Prefs.powerRoomid}';
        return true;
      } else {
        return false;
      }
    })();
  '''
              );

              if (result == true) {
                // 执行成功后的回调
                showToast('🎉房间号已成功填充，感谢支持～');
              } else {
                // 执行失败的回调
                showToast('填充失败，请检查房间号输入框是否存在');
              }
            });
          }
        }
      },
    );
  }
}
