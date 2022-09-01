import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/backImage_view.dart';
import 'package:flying_kxz/ui/loading.dart';
import 'package:provider/provider.dart';

import 'Theme/theme.dart';
import 'config.dart';

class FlyContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  final double width;
  final Key key;
  final Color backgroundColor;
  final double transValue;
  FlyContainer(
      {@required this.child, this.margin, this.padding, this.decoration, this.key, this.width, this.transValue,this.backgroundColor});
  @override
  _FlyContainerState createState() => _FlyContainerState();
}

class _FlyContainerState extends State<FlyContainer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      key: widget.key,
      margin: widget.margin,
      width: widget.width,
      padding: widget.padding,
      decoration: widget.decoration??BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: widget.backgroundColor??Theme.of(context)
              .cardColor
              .withOpacity(widget.transValue??themeProvider.transCard),
          boxShadow: [
            boxShadowMain
          ]),
      child: widget.child,
    );
  }
}

class FlyNavBackground extends StatefulWidget {
  final Widget child;

  const FlyNavBackground({Key key, @required this.child}) : super(key: key);

  @override
  _FlyNavBackgroundState createState() => _FlyNavBackgroundState();
}

class _FlyNavBackgroundState extends State<FlyNavBackground> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        BackImgView(),
        Positioned.fill(
          child: FlyWidgetBuilder(
            whenFirst: themeProvider.simpleMode,
            firstChild: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: themeProvider.blurBack,sigmaY: themeProvider.blurBack),
                child: Container(color: Colors.white.withOpacity(themeProvider.transBack),)),
            secondChild: ClipRect(
              //背景过滤器
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: themeProvider.blurBack,sigmaY: themeProvider.blurBack),
                child: Container(
                  color: Colors.black.withOpacity(themeProvider.transBack),
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}




