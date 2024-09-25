import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flying_kxz/ui/toast.dart';

import '../Model/prefs.dart';
import 'dialog.dart';

class FlyWebView extends StatefulWidget {
  final String url;
  final bool? autoLogin;
  final void Function(InAppWebViewController controller, int progress)?
      onProgressChanged;
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStart;
  final void Function(InAppWebViewController controller, WebUri? url)?
      onLoadStop;
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final void Function(bool loading)? onLoading;

  const FlyWebView({
    Key? key,
    required this.url,
    this.onProgressChanged,
    this.onLoadStart,
    this.onLoadStop,
    this.onWebViewCreated,
    this.onLoading,
    this.autoLogin = false
  }) : super(key: key);

  @override
  State<FlyWebView> createState() => _FlyWebViewState();
}

class _FlyWebViewState extends State<FlyWebView> {

  late InAppWebViewController controller;
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      onWebViewCreated: (InAppWebViewController controller) {
        if (widget.onWebViewCreated != null) {
          widget.onWebViewCreated!(controller);
        }
        this.controller = controller;
      },
      shouldOverrideUrlLoading: (InAppWebViewController controller,
          NavigationAction navigationAction) async {
        return null;
      },
      onLoadStart: (InAppWebViewController controller, WebUri? url) {
        if (widget.onLoadStart != null) {
          widget.onLoadStart!(controller, url);
        }
        onLoading(true);
      },
      onLoadStop: (controller, url) async {
        onLoading(false);
        // 教务系统自动登录
        if(widget.autoLogin==true){
          loginJw(url?.rawValue);
        }
        if (url
            .toString()
            .contains("http://yjsxt.cumt.edu.cn/Gstudent/Default.aspx")) {
          String courseSwitchJS =
              "document.getElementById('MenuFrame').contentDocument.querySelector('#tree1_4_a').click();";
          showToast("正在自动跳转到课表页面......请耐心等待，若我自动消失后还没出现课表页，可按下方[导入步骤]手动跳转",
              duration: 15);
          await _controller.zoomBy(zoomFactor: 2, animated: true);
          await _controller.scrollTo(x: 0, y: 0, animated: true);
          await _controller.evaluateJavascript(source: courseSwitchJS);
        }
      },
      onProgressChanged: widget.onProgressChanged,
    );
  }

  void loginRh(String? url)async{
    if(url==null) return;
    if (url.contains("https://authserver.cumt.edu.cn/authserver/login")) {
      showToast("正在自动填充账号密码并登录……");
      await evaluateJs('document.getElementById("username").value = "${Prefs.username}";');
      await evaluateJs('document.getElementById("password").value = "${Prefs.password}";');
      await evaluateJs('document.getElementById("login_submit").click();');
    }
  }

  void loginJw(String? url)async{
    if (url==null) return;
    if (url.contains("http://jwxt.cumt.edu.cn/jwglxt/xtgl/login_slogin.html")) {
      await evaluateJs('document.getElementById("yhm").value = "${Prefs.username}";');
    }
    if (url.contains("http://jwxt.cumt.edu.cn/jwglxt/kbcx/xskbcx")) {
      if (Prefs.passwordJw == null) {
        bool? confirm = await showDialogConfirm(context,
            title: "是否记住当前密码，下次自动填充此密码？", onConfirm: () {});
        if (confirm == true) {}
      }
    }
  }

  Future<void> evaluateJs(String source)async{
    await controller.evaluateJavascript(source:source);
  }

  void onLoading(bool loading){
    if (widget.onLoading != null) {
      widget.onLoading!(loading);
    }
  }
}
