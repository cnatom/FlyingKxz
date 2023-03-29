import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/account.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/login.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:provider/provider.dart';

class CumtLoginStateText extends StatefulWidget {
  final String defaultText;

  CumtLoginStateText({@required this.defaultText});

  @override
  _CumtLoginStateTextState createState() => _CumtLoginStateTextState();
}

class _CumtLoginStateTextState extends State<CumtLoginStateText>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  String result = "";
  String oldResult = "";
  ThemeProvider themeProvider;
  CumtLoginAccount account = CumtLoginAccount();
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    autoLogin();
  }

  void refreshText(String newText) {
    oldResult = result;
    result = newText;
    _controller.reset();
    _controller.forward();
  }

  void autoLogin() async {
    if (account.isEmpty) {
      result = widget.defaultText;
      _controller.forward();
      return;
    }
    refreshText("正在登录校园网...");
    var res = await CumtLogin.autoLogin(account: account);
    await Future.delayed(Duration(seconds: 1));
    refreshText(res);
    await Future.delayed(Duration(seconds: 1));
    refreshText(widget.defaultText);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
  }

  /// 生命周期回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 在resumed的时候自动登录校园网
    if (state == AppLifecycleState.resumed) {
      autoLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0.0, -_animation.value*10),
              child: Opacity(
                opacity: 1-_animation.value,
                child: FlyText.title45(oldResult,
                fontWeight: FontWeight.w600,
                color: themeProvider.colorNavText),
              ),
            ),
            Transform.translate(
              offset: Offset(0.0, (1-_animation.value)*10),
              child: Opacity(
                opacity: _animation.value,
                child: FlyText.title45(result,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.colorNavText),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
