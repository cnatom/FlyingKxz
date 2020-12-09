//填充图标:https://www.iconfont.cn/collections/detail?spm=a313x.7781069.1998910419.d9df05512&cid=20081

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/swiper_get.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/func_page_child/school_bus_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/func_page_child/school_calendar_page.dart';

import 'func_page_child/book_page.dart';
class FuncPage extends StatefulWidget {
  @override
  _FuncPageState createState() => _FuncPageState();
}

class _FuncPageState extends State<FuncPage> {
  List<String> swiperImage = [
    'images/swiper1.jpg',
    'images/swiper2.jpg',
    'images/swiper3.jpg',
    'images/swiper4.jpg',
  ];
  //加载轮播图、新闻数据
  Future<Null> initFunc() async {
//    await swiperGet();
//    var swiperImgList = Global.swiperInfo.data
//        .map((item) => NetworkImage(item.image))
//        .toList();
//    for (var img in swiperImgList) {
//      precacheImage(img, context);
//    }
//    setState(() {});
  }
  Widget swiperWidget(){
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              swiperImage[index],
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
      itemCount: 4,
      viewportFraction: 0.9,
      scale: 0.8,
      autoplay: true,
    )
    ;
  }
  Widget funcButton({@required String imageResource,@required String title,@required subTitle,GestureTapCallback onTap,Color color = Colors.grey}){
    return Container(
      width: ScreenUtil().setWidth(deviceWidth/2)-spaceCardMarginRL/2,
      padding: EdgeInsets.fromLTRB(0,0, spaceCardPaddingTB, spaceCardPaddingTB),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(spaceCardMarginRL),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue),
              color: Colors.white.withOpacity(transparentValue),
          ),
          child: Row(
            children: [
              Container(
                width: fontSizeMini38*2.5,
                height: fontSizeMini38*2.5,
                padding: EdgeInsets.all(fontSizeMini38/2),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(200)
                ),
                child: Image.asset(
                  imageResource,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(deviceWidth/40),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlyTextMini35(title,fontWeight: FontWeight.bold),
                  FlyTextTip30(subTitle)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Wrap(
                runSpacing: spaceCardMarginBigTB,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, 0, 0),
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            funcButton(imageResource: 'images/tushuguan.png',title: '图书馆',color:colorFuncButton[0],subTitle: '馆藏查询、图书推荐',onTap: ()=>toBookPage(context)),
                            funcButton(imageResource: 'images/xiaoche.png',title: '校车',color:colorFuncButton[3],subTitle: '通勤班车时间表',onTap: ()=>toSchoolBusPage(context)),
                            funcButton(imageResource: 'images/xiaoli.png',title: '校历',color:colorFuncButton[2],subTitle: '本学年校历',onTap: ()=>toSchoolCalendarPage(context)),
                            funcButton(imageResource: 'images/kongjiaoshi.png',title: '空教室',subTitle: '快速查找空教室'),
                            funcButton(imageResource: 'images/tongxunlu.png',title: '通讯录',subTitle: '矿大黄页、联系你我'),
                            funcButton(imageResource: 'images/ditu.png',title: '校园地图',subTitle: '拯救路痴的你'),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(),
                  ExamPage(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
