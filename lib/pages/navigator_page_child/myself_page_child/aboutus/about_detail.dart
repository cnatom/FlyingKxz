import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/appbar.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/aboutus/model/detail_info.dart';

//跳转到当前页面
void toAboutDetailPage(BuildContext context,String qqNumber,DetailInfo info) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => AboutDetail(qqNumber: qqNumber,
                detailInfo: info,
              )));
}

class AboutDetail extends StatelessWidget {
  DetailInfo detailInfo;
  String qqNumber;
  AboutDetail({@required this.detailInfo,@required this.qqNumber, Key key}) : super(key: key);
  EdgeInsets margin = EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB,
      spaceCardMarginRL, spaceCardMarginTB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, ""),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: [
              buildAvatar(),
              buildChatList(),
              SizedBox(height: 200,)
            ],
          ),
        ),
      ),
    );
  }

  // 头像部分
  Container buildAvatar() {
    return Container(
              padding: EdgeInsets.all(spaceCardMarginRL*2),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: fontSizeMain40*5,
                    height: fontSizeMain40*5,
                    child: ClipOval(
                      child: Image.network("http://q1.qlogo.cn/g?b=qq&nk=$qqNumber&s=640",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            );
  }

  //聊天气泡
  Column buildChatList() {
    return Column(
              children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget) => SlideAnimation(
                      duration: Duration(milliseconds: 500),
                      delay: Duration(milliseconds: 1000),
                      horizontalOffset: 50,
                      child: FadeInAnimation(
                        delay: Duration(milliseconds: 1000),
                        duration: Duration(milliseconds: 1000),
                        child: widget,
                      )),
                  children: detailInfo.info),
            );
  }
}
