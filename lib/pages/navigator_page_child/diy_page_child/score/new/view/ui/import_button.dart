import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../ui/ui.dart';

class ScoreImportButton extends StatelessWidget {
  ScoreImportButton({
    Key key,
    @required this.context,
    @required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final GestureTapCallback onTap;
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: buildContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,color: Colors.white,size: fontSizeTitle45*1.5,
            ),
            SizedBox(width: 15,),
            FlyText.title45("导入成绩",fontWeight: FontWeight.bold,color: Colors.white,),
          ],
        ),
      ),
    );
  }

  Widget buildContainer({Widget child}) {
    return Container(
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL*3, spaceCardMarginTB, spaceCardMarginRL*3, MediaQuery.of(context).padding.bottom),
      padding: EdgeInsets.symmetric(vertical: spaceCardPaddingTB*1.5),
      decoration: BoxDecoration(
          color: themeProvider.colorMain,
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: child,
    );
  }
}
