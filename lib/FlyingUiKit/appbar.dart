import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Text/text.dart';
import 'config.dart';
//白色背景AppBar(子页面AppBar)
Widget FlyAppBar(BuildContext context, String title,
    {PreferredSizeWidget bottom,List<Widget> actions}) =>
    AppBar(
      brightness: Theme.of(context).brightness,
      actions: actions,
      centerTitle: true,
      bottom: bottom,
      title: FlyText.title45(title,fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor,),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: fontSizeMain40,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => Navigator.pop(context),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );