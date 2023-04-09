import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/spider.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/entity/loan_entity.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/entity/renew_entity.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/loan_model.dart';
import 'package:flying_kxz/ui/container.dart';
import 'package:flying_kxz/ui/loading.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/ui.dart';

class LoanPage extends StatefulWidget {
  final LoanType loanType;

  const LoanPage({Key key, this.loanType}) : super(key: key);

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage>
    with AutomaticKeepAliveClientMixin {
  LoanModel loanModel = LoanModel();
  var futureBuilderFunc;
  ThemeProvider themeProvider;
  initState() {
    super.initState();
    futureBuilderFunc = loanModel.getData(context, widget.loanType);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder<MapEntry<List<String>, LoanEntity>>(
        future: futureBuilderFunc,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<List<String>, LoanEntity>> snapshot) {
          if (snapshot.hasData) {
            var searchResult = loanModel.loanEntity.data.searchResult;
            var coverUrls = loanModel.coverUrls;
            if (searchResult.isEmpty) {
              return Center(
                child: widget.loanType==LoanType.loanCur?Text("当前没有借阅"):Text("借阅历史为空"),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: spaceCardMarginTB / 2,
                    horizontal: spaceCardMarginRL),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var item = searchResult[index];
                                var coverUrl = coverUrls[index];
                                return buildBookCard(
                                    title: item.title,
                                    author: item.author,
                                    barcode: item.barcode,
                                    loanDate: item.loanDate,
                                    coverUrl: coverUrl,
                                    normReturnDate: item.normReturnDate);
                              },
                              itemCount: searchResult.length,
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.loanType == LoanType.loanCur
                        ? RenewButton(onTap: ()=>renew(),)
                        : Container(),
                  ],
                ),
              );
            }
          }else if(snapshot.hasError){
            return Center(child: FlyText.main40("网络请求失败(X_X)"),);
        } else{
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  Future<void> renew()async{
    RenewDialogInfo dialogInfo = await loanModel.renewAll();
    FlyDialogDIYShow(context, content: Wrap(
      children: [
        Row(
          children: [
            Container(
              width: fontSizeMini38/4,
              height: fontSizeTitle45,
              decoration: BoxDecoration(color: themeProvider.colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
            ),
            SizedBox(width: ScreenUtil().setSp(35),),
            FlyText.title45(dialogInfo.title,fontWeight: FontWeight.bold,)
          ],
        ),

        ...dialogInfo.resultList.map((e) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FlyText.main40(e)
            ],
          ),
        )).toList()
      ],
    ),);
    await loanModel.getData(context, widget.loanType);
    setState(() {});
  }
  Widget buildBookCard(
      {@required String title,
      @required String author,
      @required String barcode,
      @required String normReturnDate,
      @required String loanDate,
      @required String coverUrl}) {
    return FlyContainer(
      backgroundColor: Theme.of(context).cardColor,
      margin: EdgeInsets.symmetric(vertical: spaceCardMarginTB / 2),
      padding: EdgeInsets.symmetric(
          vertical: spaceCardPaddingTB, horizontal: spaceCardPaddingRL),
      child: SizedBox(
        height: fontSizeMain40 * 9,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 0.618,
              child: coverUrl != null
                  ? Image.network(coverUrl)
                  : Image.asset("images/bookCover.jpg"),
            ),
            SizedBox(
              width: spaceCardPaddingRL,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlyText.title45(
                  "${title}",
                  fontWeight: FontWeight.bold,
                  maxLine: 1,
                ),
                FlyText.main40(
                  "${author}",
                  maxLine: 1,
                ),
                FlyText.main40(
                  "条码号：${barcode}",
                  maxLine: 1,
                ),
                FlyText.main40(
                  "借阅日期：${loanDate}",
                  maxLine: 1,
                ),
                widget.loanType == LoanType.loanCur
                    ? FlyText.main40(
                        "应还日期：${normReturnDate}",
                        maxLine: 1,
                      )
                    : Container(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RenewButton extends StatefulWidget {
  final GestureTapCallback onTap;
  const RenewButton({Key key, this.onTap}) : super(key: key);

  @override
  State<RenewButton> createState() => _RenewButtonState();
}

class _RenewButtonState extends State<RenewButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      child: InkWell(
        onTap: () async{
          if(loading==true){
            return;
          }
          setState(() {
            loading = true;
          });
          await widget.onTap();
          setState(() {
            loading = false;
          });
        },
        child: FlyContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeProvider.colorMain, width: 1)),
          padding: EdgeInsets.symmetric(vertical: spaceCardMarginTB),
          backgroundColor: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlyText.title45(
                loading?"续借中......":"一键续借",
                color: themeProvider.colorMain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

