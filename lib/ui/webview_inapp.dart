import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flying_kxz/ui/toast.dart';

import '../Model/prefs.dart';
import 'appbar.dart';
import 'config.dart';
import 'dialog.dart';

class FlyWebViewAction {
  IconData iconData;
  VoidCallback? onPressed;

  FlyWebViewAction({required this.iconData, this.onPressed});
}

class FlyWebViewInApp extends StatefulWidget {
  final String initialUrl;
  final String title;
  final bool? autoLogin;
  final List<FlyWebViewAction>? actions;
  final List<Widget> stackChildren;
  final void Function(InAppWebViewController controller, WebUri url)?
      onLoadStart;
  final void Function(InAppWebViewController controller, WebUri url)?
      onLoadStop;
  final void Function(InAppWebViewController controller)? onWebViewCreated;

  const FlyWebViewInApp({
    Key? key,
    required this.initialUrl,
    required this.title,
    this.stackChildren = const <Widget>[],
    this.onLoadStart,
    this.onLoadStop,
    this.onWebViewCreated,
    this.actions,
    this.autoLogin = false,
  }) : super(key: key);

  @override
  State<FlyWebViewInApp> createState() => _FlyWebViewState();
}

class _FlyWebViewState extends State<FlyWebViewInApp> {
  late InAppWebViewController controller;
  bool loadingWeb = false;
  double progress = 0;
  String? usernameJw;
  String? passwordJw;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, loadingWeb ? "加载中……" : widget.title,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  await InAppWebViewController.clearAllCache();
                  await _deleteAllCookies();
                  await controller.loadUrl(
                      urlRequest: URLRequest(url: WebUri(widget.initialUrl)));
                }),
            if (widget.actions != null)
              for (var action in widget.actions!)
                IconButton(
                  icon: Icon(
                    action.iconData,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: action.onPressed,
                )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white70.withOpacity(0),
              value: progress > 0.99 ? 0 : progress,
              valueColor: new AlwaysStoppedAnimation<Color>(colorMain),
            ),
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            onWebViewCreated: (InAppWebViewController controller) {
              if (widget.onWebViewCreated != null) {
                widget.onWebViewCreated!(controller);
              }
              this.controller = controller;
            },
            onLoadStart: (InAppWebViewController controller, WebUri? url) {
              if (url == null) return;
              if (widget.onLoadStart != null) {
                widget.onLoadStart!(controller, url);
              }
              setState(() {
                loadingWeb = true;
              });
            },
            onLoadStop: (controller, url) async {
              if (url == null) return;
              setState(() {
                loadingWeb = false;
              });
              // 教务系统自动登录
              if (widget.autoLogin == true) {
                loginJw(url.rawValue);
                loginRh(url.rawValue);
              }
              // 记住密码

              if (widget.onLoadStop != null) {
                widget.onLoadStop!(controller, url);
              }
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          ...widget.stackChildren
        ],
      ),
    );
  }

  void loginRh(String? url) async {
    if (url == null) return;
    if (url.contains("https://authserver.cumt.edu.cn/authserver/login")) {
      showToast("正在自动填充账号密码并登录……");
      await evaluateJs(
          'document.getElementById("username").value = "${Prefs.username}";');
      await evaluateJs(
          'document.getElementById("password").value = "${Prefs.password}";');
      await evaluateJs('document.getElementById("login_submit").click();');
    }
  }
  // 添加登录事件监听
  Future<void> addRememberListener() async {
    await evaluateJs("""
            document.getElementById("dl").addEventListener('click', function(event) {
              var username = document.getElementById("yhm").value;
              var password = document.getElementById("mm").value;
              window.flutter_inappwebview.callHandler('inputValueHandler', username, password);
            });
              """);
    controller.addJavaScriptHandler(
      handlerName: 'inputValueHandler',
      callback: (args) async {
        if (args.length != 2) return;
        String username = args[0];
        String password = args[1];
        if (username == "" || password == "") return;
        this.usernameJw = username;
        this.passwordJw = password;
      },
    );
  }

  // 询问是否要记住账号密码
  Future<void> rememberAccount() async {
    if (usernameJw != null && passwordJw != null) {
      if (Prefs.passwordJw != passwordJw || Prefs.usernameJw != usernameJw){
        bool? confirm = await showDialogConfirm(context, title: "是否记住账号密码，下次登录时自动填充？",
            onConfirm: () {
              Prefs.usernameJw = usernameJw;
              Prefs.passwordJw = passwordJw;
            });
        if(confirm==true){
          showToast("🎉已记住此账号！");
        }
      }
    }
  }

  // 教务系统账号密码自动填充
  void loginJw(String? url) async {
    if (url == null) return;
    if (url.contains("http://jwxt.cumt.edu.cn/jwglxt/xtgl/login_slogin.html")) {
      await evaluateJs('document.getElementById("yhm").value = "${Prefs.usernameJw??Prefs.username}";');
      if(Prefs.passwordJw!=null){
        await evaluateJs('document.getElementById("mm").value = "${Prefs.passwordJw}";');
      }
      await addRememberListener();
    }
    if (url.contains("http://jwxt.cumt.edu.cn/jwglxt") && !url.contains("jwglxt/xtgl")) {
      await rememberAccount();
    }
  }

  // 删除所有Cookie
  Future<void> _deleteAllCookies() async {
    CookieManager cookieManager = CookieManager.instance();
    bool result = await cookieManager.deleteAllCookies();
    if (result) {
      print("所有Cookie已成功删除");
    } else {
      print("删除Cookie时出现问题");
    }
  }

  // 执行js
  Future<void> evaluateJs(String source) async {
    await controller.evaluateJavascript(source: source);
  }
}
