import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:provider/provider.dart';

import 'Text/text.dart';
import 'config.dart';

class FlyBottomSheetScaffold extends StatefulWidget {
  final BuildContext context;
  final Key key;
  final String leftText;
  final String rightText;
  final String title;
  final VoidCallback onDetermine;
  final Widget child;
  final VoidCallback onCancel;
  final Color backgroundColor;
  const FlyBottomSheetScaffold(this.context,
      {this.key,
      this.leftText = "取消",
      this.title = '标题',
      this.onDetermine,
      this.onCancel,
      this.rightText = "确定",
        this.backgroundColor,
      @required this.child})
      : super(key: key);

  @override
  _FlyBottomSheetScaffoldState createState() => _FlyBottomSheetScaffoldState();
}

class _FlyBottomSheetScaffoldState extends State<FlyBottomSheetScaffold> {
  ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        height: ScreenUtil().setHeight(deviceHeight * 0.8),
        padding: EdgeInsets.all(spaceCardPaddingRL),
        decoration: BoxDecoration(
            color: widget.backgroundColor??Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(borderRadiusValue)),
        child: Column(
          children: <Widget>[
            SizedBox(height: spaceCardPaddingTB,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: spaceCardMarginRL,),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: FlyTextButton(
                      widget.leftText,
                      onTap: widget.onCancel,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                    child: Center(
                        child: FlyText.title45(widget.title,
                            fontWeight: FontWeight.bold))),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: FlyTextButton(
                      widget.rightText,
                      onTap: widget.onDetermine,
                    ),
                  ),
                ),
                SizedBox(width: spaceCardMarginRL,)
              ],
            ),
            SizedBox(
              height: spaceCardMarginBigTB * 2,
            ),

            Expanded(child: widget.child),
          ],
        ));
  }
}
