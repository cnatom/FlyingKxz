import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/news_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoList extends StatefulWidget {
  final String url;
  final int page;

  const InfoList({Key key, this.url, this.page}) : super(key: key);
  @override
  _InfoListState createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  NewsInfo newsInfo = new NewsInfo();
  ThemeProvider themeProvider;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _getInfo(widget.page);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return loading==false?Wrap(
      runSpacing: spaceCardMarginTB,
      children: newsInfo.data.map((item){
        return _buildInfoCard(item.title,item.link,item.time);
      }).toList(),
    ):Center(
      child: loadingAnimationWave(themeProvider.colorNavText.withOpacity(0.6)),
    );
  }
  void _getInfo(int page)async{
    if(!loading){
      setState(() {
        loading = true;
      });
      try{
        Dio dio = new Dio();
        Response res;
        res = await dio.get(widget.url,queryParameters: {
          'page':page.toString()
        });
        debugPrint(res.toString());
        Map<String,dynamic> map = jsonDecode(res.toString());
        if(map['status']==200){
          newsInfo = NewsInfo.fromJson(map);
        }
        setState(() {
          loading = false;
        });
      }catch(e){
        debugPrint(e.toString());
      }
    }
  }
  void _toDetail(String link){
    if(link!=null){
      debugPrint(link);
      launch(link);
    }
  }
  Widget _buildInfoCard(String title,String link,String time) {
    return Column(
      children: [
        InkWell(
          onTap: ()=>_toDetail(link),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setSp(time!=null?230:170),
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
                spaceCardPaddingRL, spaceCardPaddingTB),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                color: Theme.of(context).cardColor.withOpacity(
                    themeProvider.simpleMode ? 1 : themeProvider.transCard),
                boxShadow: [boxShadowMain]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlyText.main40(
                  title,
                  fontWeight: FontWeight.w400,
                  color: themeProvider.colorNavText,
                  maxLine: 2,
                ),
                time!=null?FlyText.main35(
                  time,
                  color: themeProvider.colorNavText.withOpacity(0.5),
                ):Container()
              ],
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}
