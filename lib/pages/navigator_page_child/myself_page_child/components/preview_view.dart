
import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import '../../../../ui/text.dart';
import '../../../../ui/container.dart';

class PreviewView extends StatelessWidget {
  GestureTapCallback? onTap;
  IconData iconData;
  String title;
  String subText;
  PreviewView(this.title,this.subText,this.iconData,{Key? key,this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child:FlyContainer(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL,spaceCardPaddingTB*1.5,spaceCardPaddingRL,spaceCardPaddingTB*1.5),
        child: Row(
          children: [
            Icon(
              iconData,
              size: sizeIconMain50,
              color: themeProvider.colorNavText,
            ),
            SizedBox(
              width: spaceCardPaddingTB * 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlyText.main40(
                  title,
                  color: themeProvider.colorNavText,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: spaceCardPaddingTB/2,),
                FlyText.main35(subText,
                  color: themeProvider.colorNavText.withOpacity(0.5),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
