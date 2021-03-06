import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/news_info.dart';
import 'package:flying_kxz/NetRequest/swiper_get.dart';
import 'package:flying_kxz/pages/navigator_page_child/info_page_child/info_list.dart';
import 'package:flying_kxz/pages/navigator_page_child/info_page_child/swiper_widget.dart';
import 'package:provider/provider.dart';

class InfoView extends StatefulWidget {
  final String url;
  final bool showSwiper;
  const InfoView({Key key, this.url, this.showSwiper = false})
      : super(key: key);
  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ThemeProvider themeProvider;
  ScrollController scrollController = new ScrollController();
  bool loadingMore = false; //上拉加载更多
  bool loading = false; //刷新或者初始化
  List<InfoList> infoList = new List<InfoList>();
  int curPage = 1;
  @override
  void initState() {
    super.initState();
    _getInfo(curPage);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && scrollController.position.pixels > 10&&!loadingMore) {
        _loadingMoreInfo();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Scrollbar(
          child: RefreshIndicator(
            color: colorMain,
            onRefresh: () => _refresh(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
                child: Column(
                  children: [
                    loading
                        ? loadingAnimationWave(
                            themeProvider.colorNavText.withOpacity(0.6))
                        : Wrap(
                            runSpacing: spaceCardMarginTB,
                            children: [
                              widget.showSwiper ? SwiperWidget() : Container(),
                              Wrap(
                                runSpacing: spaceCardMarginTB,
                                children: infoList,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _refresh() async {
    infoList.clear();
    await _getInfo(curPage = 1);
  }

  Future<void> _getInfo(int page) async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      await infoList.add(new InfoList(
        url: widget.url,
        page: page,
      ));
      setState(() {
        loading = false;
      });
    }
  }

  void _loadingMoreInfo() async {
    if (loadingMore == false) {
      debugPrint("上拉加载");
      loadingMore = true;
      await _getInfo(++curPage);
      loadingMore = false;
    }
  }

  Widget _buildInfoCard(String title, String link, String time) {
    return Column(
      children: [
        InkWell(
          onTap: () => debugPrint(link),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setSp(230),
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB,
                spaceCardPaddingRL, spaceCardPaddingTB),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                color: Theme.of(context).cardColor.withOpacity(
                    themeProvider.simpleMode ? 1 : themeProvider.transCard),
                boxShadow: [boxShadowMain]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: FlyText.main40(
                    title,
                    fontWeight: FontWeight.w400,
                    color: themeProvider.colorNavText,
                    maxLine: 2,
                  ),
                ),
                Expanded(
                  child: FlyText.main35(
                    time,
                    color: themeProvider.colorNavText.withOpacity(0.5),
                  ),
                )
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
