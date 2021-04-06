import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

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
  const FlyBottomSheetScaffold(this.context,
      {this.key,
      this.leftText = "取消",
      this.title = '标题',
      this.onDetermine,
      this.onCancel,
      this.rightText = "确定",
      @required this.child})
      : super(key: key);

  @override
  _FlyBottomSheetScaffoldState createState() => _FlyBottomSheetScaffoldState();
}

class _FlyBottomSheetScaffoldState extends State<FlyBottomSheetScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(deviceHeight * 0.8),
        padding: EdgeInsets.all(spaceCardPaddingRL),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(borderRadiusValue)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: widget.onCancel,
                      child: FlyText.mainTip40(
                        widget.leftText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: FlyText.title45(widget.title,
                            fontWeight: FontWeight.bold))),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onDetermine,
                      child: FlyText.main40(widget.rightText, color: colorMain),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: spaceCardMarginBigTB * 2,
            ),
            Expanded(child: widget.child)
          ],
        ));
  }
}
