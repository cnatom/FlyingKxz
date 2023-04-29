import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/cumt/cumt.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/search/book_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/spider.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/loan_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/library/my_Library_page.dart';
import 'package:flying_kxz/ui/tabbar.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import '../../../../util/logger/log.dart';


toNewBookPage(BuildContext context) {
  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
    return NewBookPage();
  }));
  Logger.log('Book', '进入', {});
}

class NewBookPage extends StatefulWidget {
  const NewBookPage({Key key}) : super(key: key);

  @override
  State<NewBookPage> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "图书馆",
          titleWidget: buildSearchBar(context, onSubmitted: (value) {
            toBookSearchPage(context,bookName: value);
          }),
          bottom: FlyTabBar(tabController: tabController, tabs: [
            Tab(text: "当前借阅"),
            Tab(text: "借阅历史"),
          ]),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          LoanPage(loanType: LoanType.loanCur,),
          LoanPage(loanType: LoanType.loanHis,),
        ],
      ),
    );
  }

  Widget buildSearchBar(BuildContext context,
      {ValueChanged<String> onSubmitted}) {
    return Container(
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
              decoration: InputDecoration(
                hintText: "请输入要搜索的内容",
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
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
