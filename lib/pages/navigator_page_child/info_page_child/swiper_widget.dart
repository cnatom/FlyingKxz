import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/loading.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/net_request/swiper_get.dart';
import 'package:provider/provider.dart';

class SwiperWidget extends StatefulWidget {
  @override
  _SwiperWidgetState createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  ThemeProvider themeProvider;
  void getSwiper()async{
    await swiperGet();
    setState(() {
      var swiperImgList = Global.swiperInfo.data
          .map((item) => NetworkImage(item.imageUrl))
          .toList();
      for (var img in swiperImgList) {
        precacheImage(img, context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSwiper();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: (ScreenUtil().setWidth(deviceWidth)-spaceCardMarginTB*2)*0.4114,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: Theme.of(context)
                .cardColor
                .withOpacity(themeProvider.simpleMode?1:themeProvider.transCard),
            borderRadius: BorderRadius.circular(10),
            child: Global.swiperInfo.data!=null?Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  Global.swiperInfo.data[index].imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ):Center(
              child: loadingAnimationIOS(),
            ),
          );
        },
        itemCount: 5,

        scale: 0.8,
        autoplay: true,
      ),
    );
  }
}
