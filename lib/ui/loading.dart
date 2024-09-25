import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'config.dart';

class FlyWidgetBuilder extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool whenFirst;
  const FlyWidgetBuilder({Key? key, required this.firstChild, required this.whenFirst, required this.secondChild}) : super(key: key);
  @override
  _FlyWidgetBuilderState createState() => _FlyWidgetBuilderState();
}

class _FlyWidgetBuilderState extends State<FlyWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.whenFirst==true?widget.firstChild:widget.secondChild;
  }
}


// Widget loadingAnimationWave(Color color)=>Tool.getIndicatorWidget(
//     EasyHubIndicatorType.beatingRects,
//     circleValueColor:
//     AlwaysStoppedAnimation(color));
//
// Widget loadingAnimationWave1=Tool.getIndicatorWidget(
//     EasyHubIndicatorType.foldingRect,
//     circleValueColor:
//     AlwaysStoppedAnimation(colorMain));

Widget loadingAnimationTwoCircles({Color color = Colors.greenAccent})=>LoadingAnimationWidget.fourRotatingDots(color: color, size: 200);

Widget loadingAnimationIOS()=>CupertinoActivityIndicator();


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