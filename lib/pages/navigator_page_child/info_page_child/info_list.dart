import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/Model/news_info.dart';
import 'package:flying_kxz/pages/navigator_page_child/info_page_child/news_detail.dart';
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
        return _buildInfoCard(item.title,item.time,item.location,item.link);
      }).toList(),
    ):Container();
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
  void _toDetail(String location,String link){
    if(location!=null){
      toNewsDetailPage(context, location,link);
    }else{
      launch(link);
    }
  }
  Widget _buildInfoCard(String title,String time,String location,String link) {
    return Column(
      children: [
        InkWell(
          onTap: ()=>_toDetail(location,link),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setSp(time!=null?230:200),
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
                FlyText.title45(
                  title+(location==null?"  ↗  ":""),
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
