
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

import 'package:flying_kxz/Model/global.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'diy_page_child/exam_page.dart';
import 'diy_page_child/func_page_child/book_page.dart';
import 'diy_page_child/func_page_child/school_bus_page.dart';
import 'diy_page_child/func_page_child/school_calendar_page.dart';
import 'diy_page_child/score_page.dart';
class DiyPage extends StatefulWidget {
  @override
  _DiyPageState createState() => _DiyPageState();
}

class _DiyPageState extends State<DiyPage> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {

  Widget funcButton({@required String imageResource,@required String title,@required subTitle,GestureTapCallback onTap,Color color = Colors.grey}){
    return Container(
      width: ScreenUtil().setWidth(deviceWidth/2)-spaceCardMarginRL/2,
      padding: EdgeInsets.fromLTRB(0,0, spaceCardPaddingTB, spaceCardPaddingTB),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardPaddingTB,0, spaceCardPaddingTB),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: Theme.of(context).cardColor,
            boxShadow: [
              boxShadowMain
            ]
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
                  FlyText.main35(title,fontWeight: FontWeight.bold),
                  FlyText.miniTip30(subTitle)
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: FlyText.title45('发现',color:Theme.of(context).accentColor,fontWeight: FontWeight.w600,),
      ),
        body: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(ScreenUtil.statusBarHeight)/2,),
            Expanded(
              child: Column(
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
                                    funcButton(imageResource: 'images/chengji.png',title: '成绩',color:colorFuncButton[5],subTitle: '查看学分绩点',onTap: ()=>toScorePage(context)),
                                    funcButton(imageResource: 'images/xiaoche.png',title: '校车',color:colorFuncButton[1],subTitle: '通勤班车时间表',onTap: ()=>toSchoolBusPage(context)),
                                    funcButton(imageResource: 'images/xiaoli.png',title: '校历',color:colorFuncButton[2],subTitle: '本学年校历',onTap: ()=>toSchoolCalendarPage(context)),

                                    // funcButton(imageResource: 'images/tongxunlu.png',title: '通讯录',subTitle: '矿大黄页、联系你我'),
                                    // funcButton(imageResource: 'images/ditu.png',title: '校园地图',subTitle: '拯救路痴的你'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ExamPage(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

