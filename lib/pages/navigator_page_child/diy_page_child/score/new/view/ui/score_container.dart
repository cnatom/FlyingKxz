import 'package:flutter/material.dart';
import '../../../../../../../ui/ui.dart';

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({Key key,this.child,this.padding,this.color});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return FlyContainer(
      key: key,
      padding: padding,
      decoration: BoxDecoration(
          color: color??Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          boxShadow: [boxShadowMain]),
      child: child,
    );
  }
}
