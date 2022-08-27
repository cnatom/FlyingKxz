import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/appbar.dart';
import 'package:flying_kxz/flying_ui_kit/container.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/aboutus/model/detail_info.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/aboutus/model/link_card.dart';
import '../../../../flying_ui_kit/config.dart';
import 'components/received_message_screen.dart';
import 'components/send_messsage_screen.dart';

//跳转到当前页面
void toAboutDetailPage(BuildContext context, DetailInfo info) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => AboutDetail(
                detailInfo: info,
              )));
}

class AboutDetail extends StatelessWidget {
  DetailInfo detailInfo;

  AboutDetail({@required this.detailInfo, Key key}) : super(key: key);
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
              Column(
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
              ),
              SizedBox(height: 200,)
            ],
          ),
        ),
      ),
    );
  }
}
