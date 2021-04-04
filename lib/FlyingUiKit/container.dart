import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyhub/animation/easy_falling_ball.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/pages/backImage_view.dart';
import 'package:provider/provider.dart';
import 'Theme/theme.dart';
import 'config.dart';

class FlyContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  final Key key;
  FlyContainer(
      {@required this.child, this.margin, this.padding, this.decoration, this.key});
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
      padding: widget.padding,
      decoration: widget.decoration??BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context)
              .cardColor
              .withOpacity(themeProvider.transCard),
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

Widget FlyIdCardContainer(
        {@required String title,
        @required String subTitle,
        @required String imageResource}) =>
    Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spaceCardMarginBigTB, 0, spaceCardMarginBigTB, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageResource,
                  height: ScreenUtil().setWidth(160),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(70),
                        color: colorMainText,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: spaceCardPaddingTB,
                  ),
                  FlyText.main40(subTitle, color: Colors.black38)
                ],
              ),
            )

          ],
        ),
      ),
    );



