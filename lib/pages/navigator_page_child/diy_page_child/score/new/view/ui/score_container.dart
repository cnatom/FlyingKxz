import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../ui/ui.dart';

class ScoreContainer extends StatelessWidget {
  const ScoreContainer({Key key,this.child,this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return FlyContainer(
      padding: padding,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          boxShadow: [boxShadowMain]),
      child: child,
    );
  }
}
