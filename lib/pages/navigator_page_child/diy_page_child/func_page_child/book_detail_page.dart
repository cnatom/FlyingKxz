import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/Model/book_detail_info.dart';
import 'package:flying_kxz/Model/global.dart';
//跳转到当前页面
void toBookDetailPage(BuildContext context,String url,String bookName) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => BookDetailPage(url: url,bookName: bookName,)));
}
class BookDetailPage extends StatefulWidget {
  final String url;
  final String bookName;
  BookDetailPage({@required this.url,@required this.bookName});
  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>{
  bool loading = true;
  void getBookDetail({@required String url})async{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(url,);
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    if (map['status']==200) {
      Global.bookDetailInfo = BookDetailInfo.fromJson(map);
      setState(() {
        loading = false;
      });
    }
    setState(() {

    });
  }
  Widget rowContentDetail(String bookCode,String location,String current){
    return Container(
      padding: EdgeInsets.fromLTRB(0, spaceCardPaddingTB/1.5, 0, spaceCardPaddingTB/1.5),
      color:Colors.grey.withAlpha(5),
      child:Row(
        children: [
          Expanded(child: Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
            child: FlyTextTip30(location??"-",textAlign: TextAlign.center,color: colorMainText,maxLine: 3),
          )),
          Expanded(child: FlyTextMini35(bookCode??'-',textAlign: TextAlign.center,maxLine: 3)),
          Expanded(child: FlyTextMini35(current??'-',textAlign: TextAlign.center,color: colorMain,maxLine: 3)),

        ],
      ),
    );
  }
  //顶部
  Widget headerWidget(){
    return Container(
      padding: EdgeInsets.fromLTRB(0, spaceCardPaddingTB/2, 0, spaceCardPaddingTB/2),
      color:Colors.grey.withAlpha(15),
      child:Row(
        children: [
          Expanded(child: FlyTextMini35('馆藏地',textAlign: TextAlign.center,color: Colors.grey)),
          Expanded(child: FlyTextMini35('条码号',textAlign: TextAlign.center,color: Colors.grey)),
          Expanded(child: FlyTextMini35('属性',textAlign: TextAlign.center,color: Colors.grey)),
        ],
      ),
    );
  }
  //内容
  Widget infoListWidget(){
    return Column(
      children: Global.bookDetailInfo.data.map((item){
        return rowContentDetail(item.bookcode, item.location, item.current);
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getBookDetail(url: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyWhiteAppBar(context, widget.bookName),
      body: Column(
        children: [
          headerWidget(),
          loading==false?infoListWidget():loadingAnimationArticle()
        ],
      ),
    );
  }

}


