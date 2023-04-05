//各种按钮
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:provider/provider.dart';

import 'config.dart';

class FlyTextButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onTap;
  final Color color;
  final int maxLine;

  const FlyTextButton(this.title,
      {Key key, this.onTap, this.color, this.maxLine})
      : super(key: key);

  @override
  _FlyTextButtonState createState() => _FlyTextButtonState();
}

class _FlyTextButtonState extends State<FlyTextButton> {
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      child: Container(
          child: FlyText.main40(
        widget.title,
        color: widget.color ?? themeProvider.colorMain,
        fontWeight: FontWeight.bold,
        maxLine: widget.maxLine,
      )),
      onTap: widget.onTap,
    );
  }
}
