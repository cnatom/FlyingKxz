import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../cumt/cumt.dart';
import 'appbar.dart';
import 'config.dart';

class FlyWebView extends StatefulWidget {
  final String title;
  final String initialUrl;
  final bool check;//是否检测内网连接
  const FlyWebView({Key key, this.title, this.initialUrl, this.check = false}) : super(key: key);
  @override
  _FlyWebViewState createState() => _FlyWebViewState();
}

class _FlyWebViewState extends State<FlyWebView> {
  double progress = 0;
  @override
  void initState() {
    super.initState();
    if(widget.check){
      check();
    }
  }
  check()async{
    if(!await Cumt.checkConnect()){
      toTipPage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, widget.title??'http://ccatom.blog.csdn.net/',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white70.withOpacity(0),
            value: progress>0.99?0:progress,
            valueColor: new AlwaysStoppedAnimation<Color>(colorMain),
          ),
        ),),
      body: WebView(
        initialUrl: widget.initialUrl??"",
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (value){
          setState(() {
            progress = value/100.0;
          });
        },
        onPageStarted: (start){
          start.toString();
        },
        onPageFinished: (finish){
          debugPrint(finish.toString());
        },
      ),
    );
  }
}
