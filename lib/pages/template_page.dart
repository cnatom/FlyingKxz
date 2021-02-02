

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/exam_get.dart';

class TemplatePage extends StatefulWidget {
  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  bool loading;
  getShowExamView()async{
    setState(() {loading = true;});
    await examPost(context, token:Global.prefs.getString(Global.prefsStr.token), year: '2019', term: '1');
    setState(() {loading = false;});
  }

  Widget nullView(){
    return Center(
      child: Text("NullView"),
    );
  }
  Widget loadingView(){
    return Center(
      child: loadingAnimationIOS(),
    );
  }
  Widget infoView(){
    return Center(
      child: Text("infoView"),
    );
  }
  Widget infoEmptyView(){
    return Center(
      child: Text("infoEmptyView"),
    );
  }
  Widget curView(){
    Widget child = nullView();
    switch(loading) {
      case true:child = loadingView();break;
      case false:{
        child = Global.examInfo.data.isEmpty?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Container(),
      ),
    );
  }
}
