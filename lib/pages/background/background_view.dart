//背景图片
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/pages/background/background_provider.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

class BackgroundView extends StatefulWidget {
  @override
  State<BackgroundView> createState() => _BackgroundViewState();
}

class _BackgroundViewState extends State<BackgroundView> {
  @override
  Widget build(BuildContext context) {
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    return Positioned.fill(
        child: backgroundProvider.getBackgroundPath == "images/background.png"
            ? Image.asset(backgroundProvider.getBackgroundPath,fit: BoxFit.cover,gaplessPlayback: true,)
            : Image.file(File(backgroundProvider.getBackgroundPath),fit: BoxFit.cover,gaplessPlayback: true,));
  }
}
