import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/appbar.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/loading.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
import 'package:flying_kxz/Model/news_detail_info.dart';
import 'package:url_launcher/url_launcher.dart';
//跳转到当前页面
void toNewsDetailPage(BuildContext context,String location,String link) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => NewsDetailPage(location,link)));
}
class NewsDetailPage extends StatefulWidget {
  final String location;
  final String link;
  NewsDetailPage(this.location, this.link);
  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  String title;
  NewsDetailInfo newsDetailInfo;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _getDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "",actions: [
        IconButton(icon: Icon(Icons.language_outlined,color: Theme.of(context).primaryColor,), onPressed: ()=>launch(widget.link))
      ]),
      body: loading?Center(
        child: loadingAnimationWave(colorMain),
      ):Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  //标题前竖线
                  Container(
                    color: colorMain,
                    width: ScreenUtil().setWidth(10),
                    height: ScreenUtil().setSp(140),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: FlyText.title50(newsDetailInfo.data.title,maxLine: 100,fontWeight: FontWeight.bold,),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: FlyText.mainTip35(newsDetailInfo.data.header.time+"  "+newsDetailInfo.data.header.author,),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                          childAnimationBuilder: (widget) => SlideAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: Duration(milliseconds: 100),
                            horizontalOffset: 50,
                            child: FadeInAnimation(
                              delay: Duration(milliseconds: 200),
                              duration: Duration(milliseconds: 500),
                              child: widget,
                            ),
                          ),
                          children: newsDetailInfo.data.content.map((e) => Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("　　"+e,style: TextStyle(fontSize: fontSizeTitle45,height: 2),),
                          )).toList()
                      ),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Wrap(
                  runSpacing: fontSizeMain40,
                  children: newsDetailInfo.data.about.map((item){
                    return Row(
                      children: [
                        Expanded(
                          child: FlyText.miniTip30(item,maxLine: 100,),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 200,)
            ],
          ),
        ),
      ),
    );
  }
  void _getDetail()async{
    setState(() {
      loading = true;
    });
    try{
      Dio dio = new Dio();
      Response res;
      res = await dio.get(widget.location);
      Map<String, dynamic> map = jsonDecode(res.toString());
      if(map['status']==200){
        newsDetailInfo = NewsDetailInfo.fromJson(map);
        setState(() {
          loading = false;
        });
      }else{
        showToast(map['msg']);
      }

    }catch(e){
      showToast( "网络连接异常");
      debugPrint(e.toString());
    }
  }

}