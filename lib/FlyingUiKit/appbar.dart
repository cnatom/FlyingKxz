import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config.dart';
//白色背景AppBar(子页面AppBar)
Widget FlyWhiteAppBar(BuildContext context, String title,
    {PreferredSizeWidget bottom,List<Widget> actions}) =>
    AppBar(
      actions: actions,
      centerTitle: true,
      bottom: bottom,
      elevation: 0,
      brightness: Brightness.light,
      title: Text(
        title,
        style: TextStyle(
            color: colorMainText,
            fontWeight: FontWeight.bold,
            fontSize: fontSizeMain40),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: colorMainText,
          size: fontSizeMain40,
        ),
        onPressed: () => Navigator.pop(context),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      backgroundColor: colorPageBackground,
    );