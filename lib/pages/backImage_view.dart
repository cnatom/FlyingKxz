//背景图片
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

class BackImgView extends StatefulWidget {
  @override
  BackImgViewState createState() => BackImgViewState();
}
class BackImgViewState extends State<BackImgView> {

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: backImg);
  }
}