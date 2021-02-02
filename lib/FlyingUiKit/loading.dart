import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/tool/Util.dart';
import 'package:flutter_easyhub/tool/config.dart';

import 'Text/text.dart';
import 'config.dart';

class FlyWidgetBuilder extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool whenFirst;
  const FlyWidgetBuilder({Key key, @required this.firstChild, @required this.whenFirst, @required this.secondChild}) : super(key: key);
  @override
  _FlyWidgetBuilderState createState() => _FlyWidgetBuilderState();
}

class _FlyWidgetBuilderState extends State<FlyWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.whenFirst==true?widget.firstChild:widget.secondChild;
  }
}


Widget loadingAnimationWave=Tool.getIndicatorWidget(
    EasyHubIndicatorType.beatingRects,
    circleValueColor:
    AlwaysStoppedAnimation(colorMain));

Widget loadingAnimationWave1=Tool.getIndicatorWidget(
    EasyHubIndicatorType.foldingRect,
    circleValueColor:
    AlwaysStoppedAnimation(colorMain));

Widget loadingAnimationTwoCircles({Color color = Colors.greenAccent})=>Tool.getIndicatorWidget(
    EasyHubIndicatorType.rotatingTwoCircles,
    circleValueColor:
    AlwaysStoppedAnimation(color));

Widget loadingAnimationIOS()=>CupertinoActivityIndicator();

Widget loadingAnimationArticle(BuildContext context)=>Container(
    padding: EdgeInsets.all(5),
    child: Card(
      elevation: 0,
      child: Stack(
        children: <Widget>[
          FLSkeleton(
            shape: BoxShape.rectangle,
            margin: EdgeInsets.only(top: 10, left: 10),
            width: fontSizeMini38*4,
            height: fontSizeMini38*6,
            color: Theme.of(context).cardColor,
          ),
          FLSkeleton(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            margin: EdgeInsets.only(left: 80, top: 10, right: 10),
            height: fontSizeMini38*1.2,
            color: Theme.of(context).cardColor,
          ),
          FLSkeleton(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            margin: EdgeInsets.only(left: 80, top: 40),
            width: 300,
            height: fontSizeMini38*1.2,
            color: Theme.of(context).cardColor,
          ),
          FLSkeleton(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            margin: EdgeInsets.only(left: 80, top: 70, bottom: 10),
            width: 100,
            height: fontSizeMini38*1.2,
            color: Theme.of(context).cardColor,
          ),
        ],
      ),
    )
);

Widget loadingPage(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: ()=>Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios,color: colorMain,size: 18,),
      ),
    ),
    body: Center(child: loadingAnimationIOS(),),
  );
}