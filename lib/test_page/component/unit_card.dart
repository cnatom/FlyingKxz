import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:provider/provider.dart';

class FlyUnitCard extends StatefulWidget {
  final int codePoint;
  final String title;
  final String previewText;
  final Widget child;
  final bool loading;
  FlyUnitCard(this.codePoint, this.title, this.previewText,
      {this.child,this.loading = false});
  @override
  _FlyUnitCardState createState() => _FlyUnitCardState();
}

class _FlyUnitCardState extends State<FlyUnitCard> {
  ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return FlyContainer(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB * 1.4,
          spaceCardPaddingRL, spaceCardPaddingTB * 1.2),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                IconData(widget.codePoint, fontFamily: "CY"),
                color: themeProvider.colorMain,
                size: fontSizeMain40 * 1.7,
              ),
              SizedBox(
                width: fontSizeMain40 / 2,
              ),
              FlyText.mini30(widget.title,fontWeight: FontWeight.w600,color: themeProvider.colorNavText.withOpacity(0.8),),
              FlyText.main40(
                "    \\    ",
                color: themeProvider.colorNavText.withOpacity(0.3),
              ),
              FlyText.mini30(
                widget.previewText,
                color: themeProvider.colorNavText.withOpacity(0.6),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.loading?loadingAnimationIOS():Container(),
                  ],
                ),
              )

            ],
          ),
          Divider(height: spaceCardPaddingTB*1.8,),
          Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL/4, 0, spaceCardPaddingRL/4, spaceCardPaddingTB),
            child: widget.child ?? Container(),
          )
        ],
      ),
    );
  }
}
