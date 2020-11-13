import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/book_detail_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/book_get.dart';
import 'package:flying_kxz/NetRequest/exam_get.dart';

import 'book_detail_page.dart';

class BookData {
  BookData(
      {this.name,
      this.author,
      this.publisher,
      this.searchCode,
      this.image,
      this.available,
      this.eCount,
      this.pCount});
  String name;
  String author;
  String publisher;
  String searchCode;
  String image;
  bool available;
  int eCount;
  int pCount;
}
//跳转到当前页面
void toBookPage(BuildContext context) {

  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => BookPage()));
}


class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> with AutomaticKeepAliveClientMixin{
  int curPage = 0;//当前页
  int allPage = 0;//总页数
  int row = 10;//单页搜索结果数
  String curBookName;//当前搜索书籍名称
  bool loading;//加载动画
  bool miniLoading = false;//切换页面时的迷你动画
  FocusNode searchBarFocus = new FocusNode();

  getShowBookView(String book,{int page = 1})async{
    setState(() {loading = true;});
    if(await bookGet(book: book,row: row.toString(),page: page.toString())){
      allPage = ((Global.bookInfo.data.all??0)/row).ceil();
      curPage = page;
    }
    setState(() {loading = false;});
  }
  switchPage({@required int page})async{
    setState(() {
      loading = true;
    });
    await bookGet(book: curBookName,row: row.toString(),page: page.toString());
    setState(() {loading = false;});
  }
  Future<bool> getBookDetail({@required String url})async{
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(url,);
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    if (map['status']==200) {
      Global.bookDetailInfo = BookDetailInfo.fromJson(map);
      return true;
    }
    return false;
  }
  Widget bookCard(int curIndex,
      {@required String name,
        @required String author,
        @required String publisher,
        @required String searchCode,
        @required String image,
        @required bool available,
        @required String eCount,
        @required String pCount,
        @required String statusNow}) {
    int curIndexTemp = curIndex;
    //右上角 可借/不可借 卡片
    Widget tipCard(bool available) {
      String title = available ? "可借" : "不可借";
      Color color = available ? colorMain : Colors.grey;
      return Container(
        padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: color.withAlpha(20)),
        child: FlyTextMini35(title, color: color, fontWeight: FontWeight.bold),
      );
    }

    Widget rowContent(String title, String content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlyTextTip30(title+'：', color: colorMainText.withAlpha(100)),
          FlyTextMain40(
            content,
            color: colorMain,
          )
        ],
      );
    }
    Widget rowContentDetail(String bookCode,String location,String current){
      return Container(
        padding: EdgeInsets.fromLTRB(0, spaceCardPaddingTB/1.5, 0, spaceCardPaddingTB/1.5),
        color:Colors.grey.withAlpha(5),
        child:Row(
          children: [
            Expanded(child: FlyTextMini35(location??"-",textAlign: TextAlign.center,maxLine: 3)),
            Expanded(child: FlyTextMini35(bookCode??'-',textAlign: TextAlign.center,maxLine: 3)),
            Expanded(child: FlyTextMini35(current??'-',textAlign: TextAlign.center,color: colorMain,maxLine: 3)),

          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/1.5,
          spaceCardPaddingRL, spaceCardPaddingTB/1.5),
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: ()=>toBookDetailPage(context,statusNow,name),
        child: Column(
          children: [
            Row(
              children: [
                //左侧书籍封面
                Container(
                  height: fontSizeMain40*8,
                  child: AspectRatio(
                    aspectRatio: 0.618,
                    child: BookImage(url: image,),
                  ),
                ),
                SizedBox(
                  width: spaceCardPaddingRL,
                ),
                //右侧信息区域
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //书名+作者 -> 是否可借
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: FlyTextTitle45(name, fontWeight: FontWeight.bold,),),
                              tipCard(available)
                            ],
                          ),
                          FlyTextMini35(author,
                              color: colorMainText.withAlpha(200)),
                        ],
                      ),
                      SizedBox(height: spaceCardPaddingTB,),
                      //出版社+搜索代码
                      FlyTextMini35(publisher,
                          color: colorMainText.withAlpha(100)),
                      FlyTextMini35("索书号："+searchCode,
                          color: colorMainText.withAlpha(100)),
                      Divider(height: spaceCardPaddingTB/1.5,),
                      //纸本馆藏
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: rowContent('电子馆藏', eCount.toString())),
                          Expanded(
                            child: rowContent('纸本馆藏', pCount.toString()),
                          ),
                          Row(
                            children: [
                              FlyTextTip30("详情",
                                  color: colorMainText.withAlpha(100)),
                              Icon(Icons.chevron_right,color: colorMainText.withAlpha(100))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
  Widget switchPageCard(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.white.withAlpha(200),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withAlpha(20),
                    blurRadius: 10
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onLongPress: (){
                  if(!miniLoading){
                    if(curPage==1) {
                      showToast(context, '已经到首页了(~_~)');
                      return;
                    }
                    curPage = 1;
                    switchPage(page: curPage);

                  }
                },
                onPressed: () {
                  if(!miniLoading){
                    if(curPage>1){
                      switchPage(page: --curPage);
                    }else{
                      showToast(context, '已经到首页了(~_~)');
                    }
                  }
                },
                child: FlyTextMini35("上一页"),
              ),
              Container(
                alignment: Alignment.center,
                width: fontSizeMini38*5,
                child: miniLoading==true?loadingAnimationIOS():FlyTextMain40(
                  "$curPage/$allPage",),
              ),
              FlatButton(
                onPressed: () {
                  if(!miniLoading){
                    if(curPage<allPage){
                      switchPage(page: ++curPage);
                    }else{
                      showToast(context, '已经到尾页了(O_O)');
                    }
                  }
                },
                child: FlyTextMini35("下一页",),
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget nullView(){
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(deviceHeight/3),),
          FlyTextMain40("(￣▽￣)~* 矿大书库，应有尽有", color: Colors.black38),
          FlyTextTip30("( 图书推荐功能正在开发中…… )")
        ],
      ),
    );
  }
  Widget loadingView(){
    return SingleChildScrollView(
      child: Column(
        children: [
          for(int i = 0;i<5;i++)loadingAnimationArticle()
        ],
      ),
    );
  }
  Widget infoView(){
    int curIndex = 0;
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                children: Global.bookInfo.data.bookList.map((item){
                  return bookCard(curIndex++,
                      name: item.name??"",
                      author: item.author??"",
                      publisher: item.publisher??"",
                      searchCode: item.searchCode??"",
                      available: item.status??false,
                      eCount: item.ecount.toString(),
                      pCount: item.pcount.toString(),
                      image:
                      item.image!=''?item.image:"",
                      statusNow: item.statusNow);
                }).toList(),
              ),
              FlyTextTip30(""),
              FlyTextTip30("长按“上一页”按钮可返回首页"),
              SizedBox(height: ScreenUtil().setHeight(deviceHeight/5),)
            ],
          ),
        ),
      ],
    );
  }
  Widget infoEmptyView(){
    return Center(
      child: FlyTextMain40("∑(っ°Д°;)っ 小助没有搜到这本书", color: Colors.black38),
    );
  }
  Widget curView(){
    Widget child = nullView();
    switch(loading) {
      case true:child = loadingView();break;
      case false:{
        child = Global.bookInfo.data==null?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPageBackground,
      appBar: AppBar(
          leadingWidth: 0,
          brightness: Brightness.light,
          leading: Container(),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: colorMainText,
                  size: fontSizeMain40,
                ),
                onPressed: () => Navigator.pop(context),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              Expanded(child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 242,243,247),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.search,
                        size: 22,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: searchBarFocus,
                        decoration: InputDecoration(
                          hintText: "输入书名",
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: fontSizeMini38,
                            color: Color(0xFF999999),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF333333),
                          height: 1.3,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (bookName){
                          if(bookName.isNotEmpty){
                            curBookName = bookName;
                            getShowBookView(curBookName);
                          }else{
                            showToast(context, '请输入书籍名称');
                          }

                        },
                      ),
                    ),
                  ],
                ),
              ),),

            ],
          )
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              curView(),
              Positioned(
                bottom: 20,
                child: Container(
                  height: fontSizeMini38*3,
                  width: ScreenUtil().setWidth(deviceWidth),
                  child: switchPageCard(),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;
}
class BookImage extends StatefulWidget {
  final String url;
  BookImage({this.url});
  @override
  _BookImageState createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> with AutomaticKeepAliveClientMixin{
  Widget child;
  void initFunc({@required String url})async{
    child = loadingAnimationIOS();
    Response res;
    Dio dio = Dio();
    //配置dio信息
    res = await dio.get(url,);
    //Json解码为Map
    Map<String,dynamic> map = jsonDecode(res.toString());
    debugPrint(res.toString());
    if (map['status']==200&&map['data']!='') {
      child = Image.network(
        map['data'],
        fit: BoxFit.fill,
      );
    }else{
      child = Image.asset("images/bookCover.jpg",fit: BoxFit.fill,);
    }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    initFunc(url: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return child;
  }

  @override
  bool get wantKeepAlive => true;
}
