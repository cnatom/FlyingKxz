
import 'package:flutter/material.dart';

import '../../../../../ui/ui.dart';
import 'custom_shape.dart';

class SentMessageScreen extends StatelessWidget {
  final String message;
  const SentMessageScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(spaceCardPaddingRL),
                decoration: BoxDecoration(
                  color: Colors.cyan[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: FlyText.title45(message,color: Colors.white,maxLine: 10,),
              ),
            ),
            CustomPaint(painter: CustomShape(Colors.cyan[900]!)),
            // 头像
            Center(
              child: Container(
                width: fontSizeMini38 * 5,
                height: fontSizeMini38 * 5,
                child: ClipOval(
                  child: Image.network(
                    "http://q1.qlogo.cn/g?b=qq&nk=1004275481&s=640",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ));

    return Padding(
      padding: EdgeInsets.only(right: spaceCardMarginRL, left: spaceCardMarginRL, top: spaceCardMarginTB, bottom: spaceCardMarginTB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}