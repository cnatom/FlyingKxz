import 'package:flutter/material.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/loading.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
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
      if (scrollController.position.pixels ==scrollController.position.maxScrollExtent && scrollController.position.pixels > 10&&!loadingMore) {
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
                        ? Container()
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
                    loadingAnimationWave(
                        themeProvider.colorNavText.withOpacity(0.6)),
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
    showToast("刷新成功");
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

  Future<void> _loadingMoreInfo() async {
    loadingMore = true;
    setState(() {

    });
    await _getInfo(++curPage);
    loadingMore = false;
    setState(() {

    });
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
