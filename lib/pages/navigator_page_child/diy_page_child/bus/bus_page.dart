import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/bus/bus_img_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import '../../../../ui/tabbar.dart';
import '../../../../util/logger/log.dart';
import 'bus_model.dart';

//跳转到当前页面
void toSchoolBusPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolBusPage()));
  Logger.log('SchoolBus', '进入', {});
}

class SchoolBusPage extends StatefulWidget {
  @override
  _SchoolBusPageState createState() => _SchoolBusPageState();
}

class _SchoolBusPageState extends State<SchoolBusPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final String dialogContentNorth = "【北线停靠站】\n\n"
      "「文昌校区」：\n中心区、网络大讲堂（原电教馆)站；\n\n"
      "「南湖校区」：\n行健楼站、化工学院站、\n环测学院招呼站、资源学院站、\n建筑与设计学院招呼站、计算机学院站、\n图书馆站、“青春广场”（原松苑餐厅)站\n\n"
      "「特别说明」：20:00后由网络大讲堂（原电教馆）始发，满员后循环发车。";
  final String dialogContentSouth = "【南线停靠站】\n\n"
      "「文昌校区」：\n中心区、网络大讲堂（原电教馆)站；\n\n"
      "「南湖校区」：行健楼站、博学四楼站、\n博学五楼站、 “青春广场”（原松苑餐厅)站。\n\n"
      "「特别说明」：20:00后由网络大讲堂（原电教馆）始发，满员后循环发车。";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusModel(),
      child: Builder(builder: (context) {
        final _model = Provider.of<BusModel>(context);
        return Scaffold(
          appBar: FlyAppBar(
            context,
            "班车时刻" + (_model.showRest ? "（休息日）" : "（工作日）"),
            actions: [
              IconButton(
                  icon: Icon(
                    Entypo.switch_icon,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _model.switchRest();
                  }),
              IconButton(
                  icon: Icon(
                    Icons.image_search_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    toBusImagePage(context);
                  })
            ],
          ),
          body: Column(
            children: [
              FlyTabBar(
                tabController: _tabController,
                tabs: [
                  Tab(
                    text: "南湖公教楼",
                  ),
                  Tab(
                    text: "文昌中心路",
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: buildRouteTitle(
                            title: "北 线", dialogContent: dialogContentNorth)),
                    Expanded(
                        child: buildRouteTitle(
                            title: "南 线", dialogContent: dialogContentSouth)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    BusTimeListView(_model.finalList[0], _model.finalList[1]),
                    BusTimeListView(_model.finalList[2], _model.finalList[3])
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: FlyText.mainTip40("生效日期：2023.2.16 - 2023.7.10")),
              SizedBox(height: ScreenUtil.bottomBarHeight,)
            ],
          ),
        );
      }),
    );
  }

  Widget buildRouteTitle({@required String title, String dialogContent}) {
    return InkWell(
      onTap: () {
        if (dialogContent != null) {
          FlyDialogDIYShow(context,
              content: FlyText.main40(
                dialogContent,
                maxLine: 100,
              ));
        }
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chevron_right,
              color: Colors.transparent,
            ),
            FlyText.main40(
              title,
              fontWeight: FontWeight.bold,
            ),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}

class BusTimeListView extends StatefulWidget {
  BusTimeListView(this.north, this.south);

  final List<String> north;
  final List<String> south;

  @override
  _BusTimeListViewState createState() => _BusTimeListViewState();
}

class _BusTimeListViewState extends State<BusTimeListView> {
  ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    this.themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                Expanded(
                  child: _buildColumn(widget.north),
                ),
                VerticalDivider(
                  width: 0,
                ),
                Expanded(
                  child: _buildColumn(widget.south),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(List<String> timeList) {
    bool temp = false;
    //检查是否即将到该时间点
    bool checkTime(String timeStr) {
      DateTime now = DateTime.now();
      List timeSpl = timeStr.split(":");
      DateTime dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(timeSpl[0]),
          int.parse(timeSpl[1]),
          now.second,
          now.millisecond,
          now.microsecond);
      if (now.isAfter(dateTime.add(Duration(hours: -1))) &&
          now.isBefore(dateTime)) {
        return true;
      } else
        return false;
    }

    return Column(
      children: timeList.map((item) {
        temp = !temp;
        bool comingSoon = false;
        if (checkTime(item)) comingSoon = true;
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB / 2,
              spaceCardMarginRL, spaceCardMarginTB / 2),
          decoration: BoxDecoration(
              color: comingSoon
                  ? themeProvider.colorMain.withOpacity(0.7)
                  : temp
                      ? themeProvider.colorMain.withOpacity(0.05)
                      : themeProvider.colorMain.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadiusValue)),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: FlyText.main40(
            comingSoon ? "${item.toString()} 即将到达" : item.toString(),
            color: comingSoon
                ? Colors.white
                : Theme.of(context).primaryColor.withOpacity(0.9),
            fontWeight: comingSoon ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
