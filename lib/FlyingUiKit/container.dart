import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyhub/animation/easy_falling_ball.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:provider/provider.dart';
import 'config.dart';

//常用圆角容器
//Widget FlyCirContainer(
//        {@required Widget child,
//        Color color = Colors.white}) =>
//    Container(
//      margin: EdgeInsets.fromLTRB(spaceCardMarginTB, 0, spaceRow, 0),
//      padding: EdgeInsets.all(spaceRow),
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(borderRadiusValue), color: color),
//      child: child,
//    );
class FlyFilterContainer extends StatefulWidget {
  final Widget child;

  const FlyFilterContainer({Key key, @required this.child}) : super(key: key);

  @override
  _FlyFilterContainerState createState() => _FlyFilterContainerState();
}

class _FlyFilterContainerState extends State<FlyFilterContainer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            //背景过滤器
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: themeProvider.blurBack,sigmaY: themeProvider.blurBack,),
              child: Opacity(
                opacity: themeProvider.transBack,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
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



