import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/search/model.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import '../detail/detail_page.dart';

class BookSearchData {
  BookSearchData(
      {this.name,
        this.author,
        this.publisher,
        this.searchCode,
        this.image,
        this.available,
        this.eCount,
        this.pCount});
  String? name;
  String? author;
  String? publisher;
  String? searchCode;
  String? image;
  bool? available;
  int? eCount;
  int? pCount;
}
//跳转到当前页面
void toBookSearchPage(BuildContext context, {required String bookName}) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => BookSearchPage(bookName: bookName,)));
}


class BookSearchPage extends StatefulWidget {
  final String? bookName;

  const BookSearchPage({Key? key,required this.bookName}) : super(key: key);
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> with AutomaticKeepAliveClientMixin{
  int curPage = 0;//当前页
  int allPage = 0;//总页数
  int row = 20;//单页搜索结果数
  late String curBookName;//当前搜索书籍名称
  bool? loading;//加载动画
  bool miniLoading = false;//切换页面时的迷你动画
  FocusNode searchBarFocus = new FocusNode();
  late ThemeProvider themeProvider;
  BookSearchModel model = BookSearchModel();
  initState() {
    super.initState();
    if(widget.bookName != null){
      curBookName = widget.bookName!;
      getShowBookView(widget.bookName!);
    }
  }
  getShowBookView(String book,{int page = 1})async{
    setState(() {loading = true;});
    if(await model.bookGet(book: book,row: row.toString(),page: page.toString()) != null){
      allPage = ((model.entity?.data?.all??0)/row).ceil();
      curPage = page;
    }
    setState(() {loading = false;});
  }
  switchPage({required int page})async{
    setState(() {
      loading = true;
    });
    await model.bookGet(book: curBookName, page: page.toString(),row: row.toString());
    setState(() {loading = false;});
  }
  Widget bookCard(int curIndex,
      {required String name,
        required String author,
        required String publisher,
        required String searchCode,
        required String image,
        required bool available,
        required String eCount,
        required String pCount,
        required String statusNow}) {
    int? curIndexTemp = curIndex;
    //右上角 可借/不可借 卡片
    Widget tipCard(bool available) {
      String title = available ? "可借" : "不可借";
      Color color = available ? colorMain : Colors.grey;
      return Container(
        padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: color.withAlpha(20)),
        child: FlyText.main35(title, color: color, fontWeight: FontWeight.bold),
      );
    }

    Widget rowContent(String title, String content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlyText.miniTip30(title+'：', ),
          FlyText.main40(
            content,
            color: colorMain,
          )
        ],
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/1.5,
          spaceCardPaddingRL, spaceCardPaddingTB/1.5),
      margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadowMain
        ],
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: Theme.of(context).cardColor,
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
                    child: FlyWidgetBuilder(
                      whenFirst: image!='null',
                      firstChild: Image.network(image!,fit: BoxFit.fill,),
                      secondChild: Image.asset("images/bookCover.jpg",fit: BoxFit.fill,),
                    ),
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
                              Expanded(child: FlyText.title45(name, fontWeight: FontWeight.bold,),),
                              tipCard(available!)
                            ],
                          ),
                          FlyText.mainTip35(author,),
                        ],
                      ),
                      SizedBox(height: spaceCardPaddingTB,),
                      //出版社+搜索代码
                      FlyText.mainTip35(publisher,),
                      FlyText.mainTip35("索书号："+searchCode),
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
                              FlyText.miniTip30("详情",),
                              Icon(Icons.chevron_right,)
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
          padding: EdgeInsets.symmetric(horizontal: spaceCardPaddingRL,vertical: spaceCardPaddingTB),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Theme.of(context).cardColor,
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
              InkWell(
                onLongPress: (){
                  if(!miniLoading){
                    if(curPage==1) {
                      showToast('已经到首页了(~_~)');
                      return;
                    }
                    curPage = 1;
                    switchPage(page: curPage);

                  }
                },
                onTap: () {
                  if(!miniLoading){
                    if(curPage>1){
                      switchPage(page: --curPage);
                    }else{
                      showToast('已经到首页了(~_~)');
                    }
                  }
                },
                child: FlyText.title45("上一页",color: themeProvider.colorMain,),
              ),
              Container(
                alignment: Alignment.center,
                width: fontSizeMini38*9,
                child: miniLoading==true?loadingAnimationIOS():FlyText.title45(
                  "$curPage/$allPage",),
              ),
              InkWell(
                onTap: () {
                  if(!miniLoading){
                    if(curPage<allPage){
                      switchPage(page: ++curPage);
                    }else{
                      showToast('已经到尾页了(O_O)');
                    }
                  }
                },
                child: FlyText.title45("下一页",color: themeProvider.colorMain,),
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
          FlyText.mainTip40("(￣▽￣)~* 矿大书库，应有尽有",),
          FlyText.miniTip30("( 图书推荐功能正在开发中…… )")
        ],
      ),
    );
  }
  Widget loadingView(){
    return Center(
      child: loadingAnimationIOS(),
    );
  }
  Widget infoView(){
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemCount: model.entity?.data?.bookList?.length,itemBuilder: (context,index){
                var item = model.entity?.data?.bookList?[index];
                return bookCard(index,
                    name: item?.name??"",
                    author: item?.author??"",
                    publisher: item?.publisher??"",
                    searchCode: item?.searchCode??"",
                    available: item?.status??false,
                    eCount: item!.ecount.toString(),
                    pCount: item.pcount.toString(),
                    image:
                    item.image!=''?item.image!:"",
                    statusNow: item.statusNow!);
              }),
              FlyText.mini30(""),
              FlyText.mini30("长按“上一页”按钮可返回首页"),
              SizedBox(height: ScreenUtil().setHeight(deviceHeight/5),)
            ],
          ),
        ),
      ],
    );
  }
  Widget infoEmptyView(){
    return Center(
      child: FlyText.main40("∑(っ°Д°;)っ 小助没有搜到这本书",),
    );
  }
  Widget curView(){
    Widget child = nullView();
    switch(loading) {
      case true:child = loadingView();break;
      case false:{
        child = model.entity==null?infoEmptyView():infoView();
        break;
      }
    }
    return child;
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // 状态栏背景色
            statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
          ),
          leadingWidth: 0,
          leading: Container(),
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: fontSizeMain40,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              Expanded(child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: searchBarFocus,
                        decoration: InputDecoration(
                          hintText: "输入书名",
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(
                            fontSize: fontSizeMini38,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.3,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (bookName){
                          if(bookName.isNotEmpty){
                            curBookName = bookName;
                            getShowBookView(curBookName);
                          }else{
                            showToast('请输入书籍名称');
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
