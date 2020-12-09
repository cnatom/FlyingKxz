//背景图片
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

GlobalKey<BackImgViewState> backImgViewKey = new GlobalKey<BackImgViewState>();
class BackImgView extends StatefulWidget {
  @override
  BackImgViewState createState() => BackImgViewState();
}
class BackImgViewState extends State<BackImgView> {
  void refreshImg(){
    build(context);
  }
  @override
  Widget build(BuildContext context) {
    return fileBackImg==null?Positioned.fill(
      child: Image.asset("images/loginBackground.png",fit: BoxFit.fitHeight,),
    ):Positioned.fill(
      child: Image.file(fileBackImg,fit: BoxFit.fitHeight,),
    );
  }
}