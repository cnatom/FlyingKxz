import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../ui/ui.dart';
class PowerCircularView extends StatelessWidget {
  const PowerCircularView({
    Key? key,
    required this.powerPercent,
    required this.themeProvider,
  }) : super(key: key);

  final double powerPercent;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width/6,
      lineWidth: 13.0,
      animation: true,
      percent: powerPercent,
      backgroundColor: Theme.of(context).disabledColor,
      center: Icon(EvaIcons.flash,size: MediaQuery.of(context).size.width/10,color: themeProvider.colorMain,),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: themeProvider.colorMain,
    );
  }
}
