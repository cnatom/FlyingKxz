import 'package:flutter/material.dart';

import 'text.dart';

//白色背景AppBar(子页面AppBar)
AppBar FlyAppBar(BuildContext context, String title,
        {PreferredSizeWidget? bottom,
        List<Widget>? actions,
        Widget? titleWidget}) =>
    AppBar(
      systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      actions: actions,
      centerTitle: true,
      bottom: bottom,
      title: titleWidget ??
          FlyText.title45(
            title,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
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
