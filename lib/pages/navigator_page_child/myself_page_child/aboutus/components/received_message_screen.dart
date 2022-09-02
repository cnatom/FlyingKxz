
import 'dart:math' as math; // import this

import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/Theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../ui/config.dart';
import '../../../../../ui/container.dart';
import '../model/link_card.dart';
import 'custom_shape.dart';

class ReceivedMessageScreen extends StatelessWidget {
  final String message;
  AboutLinkModel linkModel;
  ReceivedMessageScreen({
    Key key,
    @required this.message,
    this.linkModel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: CustomPaint(
                painter: CustomShape(Theme.of(context).cardColor),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlyText.title50(message,maxLine: 10,),
                    linkModel!=null?Column(
                      children: [
                        SizedBox(height: spaceCardPaddingTB,),
                        _linkView(context,linkModel),
                      ],
                    ):Container()
                  ],
                ),
              ),
            ),
          ],
        ));

    return Padding(
      padding: EdgeInsets.only(right: 50.0, left: 18, top: spaceCardMarginTB, bottom: spaceCardMarginTB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }

  Widget _linkView(BuildContext context,AboutLinkModel linkModel){
    return InkWell(
      onTap: (){
        launchUrl(Uri.parse(linkModel.link),mode: LaunchMode.externalApplication);
      },
      child: FlyContainer(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, spaceCardPaddingTB),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlyText.mainTip40(linkModel.link,maxLine: 1,),
            Divider(height: 14,),
            FlyText.title50(linkModel.title,fontWeight: FontWeight.bold,maxLine: 3,),
            SizedBox(height: 8,),
            FlyText.main40(linkModel.subText,maxLine: 10,),
          ],
        ),
      ),
    );
  }
}