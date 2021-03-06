import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/swiper_get.dart';
import 'package:flying_kxz/pages/navigator_page_child/info_page_child/info_view.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>  with SingleTickerProviderStateMixin{
  ThemeProvider themeProvider;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,);

  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        brightness: themeProvider.simpleMode?Brightness.light:Brightness.dark,
        title:  _buildTabBar(),
      ),
      body: _buildBody(),
    );
  }
  Widget _buildBody(){
    int index = -1;
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: ApiUrl.newsUrlList.map((item){
              index++;
              if(index==0) return InfoView(url: item,showSwiper: true,);
              return InfoView(url: item,);
            }).toList(),
          ),
        )
      ],
    );
  }
  Widget _buildTabBar(){
    return TabBar(
      isScrollable: true,
        labelColor: themeProvider.colorNavText,
        controller: _tabController,
        labelStyle: TextStyle(fontSize: fontSizeMain40,fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: fontSizeMini38,),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3,color: themeProvider.colorNavText.withOpacity(0.6)),
          insets: EdgeInsets.fromLTRB(0, 10, 0, 0)
        ),
        tabs: [
          Tab(
            text: '视点新闻',
          ),
          Tab(
            text: '信息公告',
          ),
          Tab(
            text: '学术聚焦',
          ),
          Tab(
            text: '人文课堂',
          ),
        ]);
  }
}
