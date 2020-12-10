//背景图片
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

GlobalKey<BackImgViewState> backImgViewKey = new GlobalKey<BackImgViewState>();
class BackImgView extends StatefulWidget {
  @override
  BackImgViewState createState() => BackImgViewState();
}
class BackImgViewState extends State<BackImgView> {
  @override
  Widget build(BuildContext context) {
    return backImgFileDiy==null?Positioned.fill(
      child: Image.asset("images/loginBackground.png",fit: BoxFit.fitHeight,filterQuality: FilterQuality.none,),
    ):Positioned.fill(
      child: Image.file(backImgFileDiy,fit: BoxFit.fitHeight,filterQuality: FilterQuality.none,),
    );
  }
}