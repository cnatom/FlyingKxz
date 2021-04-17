import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';

import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

//跳转到当前页面
void toSchoolBusPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => SchoolBusPage()));
}
//跳转到当前页面
//void toLoginPage(BuildContext context) async {
//  Navigator.of(context).pushAndRemoveUntil(
//      CustomRoute(LoginPage(), milliseconds: 1000), (route) => route == null);
//}

class SchoolBusPage extends StatefulWidget {
  @override
  _SchoolBusPageState createState() => _SchoolBusPageState();
}

class _SchoolBusPageState extends State<SchoolBusPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showRest = false;
  List<List> listRest = [];
  List<List> listWork = [];
  List<List> finalList = [];
  //南湖 北线 工作日
  final List<String> nNorthWork = [
    "7:40","7:50","8:10","8:20","8:30","8:50","9:40","10:00","10:40","11:00","11:20",
    "14:10","14:40","15:00","15:20","15:25","16:00","16:05","16:30","17:00","17:10","17:30",
    "22:00"
  ];
  //南湖 南线 工作日
  final List<String> nSouthWork = [
    "7:10","7:15","9:20","9:25","11:40","12:10","12:20",
    "13:10","13:15","13:40","15:50","17:50",
    "18:10","18:15","18:30","18:40","21:00","21:20","21:40","22:00"
  ];
  //文昌 北线 工作日
  final List<String> wNorthWork = [
    "7:40","7:50","8:10","8:20","8:30","8:50","9:40","10:00","10:40","11:00","11:20",
    "14:00","14:10","14:40","15:00","15:50","16:00","16:05","16:20","16:30","16:50",
    "22:00"
  ];
  //文昌 南线 工作日
  final List<String> wSouthWork = [
    "7:10","7:15","9:20","9:25","11:40","12:10","12:20",
    "13:10","13:15","13:40","15:20","15:25","17:10","17:30","17:50","18:00",
    "18:10","18:15","21:00","21:20","21:40","22:00",
  ];
  //南湖 休息日
  final List<String> nRest = [
    "7:10","7:15","7:50","8:00","8:20","8:40","9:10","9:20","9:40","10:00","10:40","11:10","12:15",
    "13:10","13:50","14:10","14:30","14:50","15:25","15:50","16:00","16:40","16:50","17:00","17:10","17:40",
    "18:10","18:15","18:40","21:00","21:20","21:40","22:00",
  ];
  //文昌 休息日
  final List<String> wRest = [
    "7:10","7:15","7:50","8:00","8:20","8:40","9:10","9:20","9:40","10:00","10:40","11:10","12:15",
    "13:10","13:20","13:30","13:40","14:00","14:20","15:00","15:25","15:40","16:00","16:20","16:40","16:50","17:10","17:40",
    "18:10","18:15","21:00","21:20","21:40","22:00"
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    listRest..add(nRest)..add(nRest)..add(wRest)..add(wRest);
    listWork..add(nNorthWork)..add(nSouthWork)..add(wNorthWork)..add(wSouthWork);
    if(DateTime.now().weekday>=6){
      finalList = listRest;
      showRest = true;
    }else{
      finalList = listWork;
      showRest = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(showRest){
      finalList = listRest;
    }else{
      finalList = listWork;
    }
    return Scaffold(
      appBar: FlyAppBar(context, "班车时刻"+(showRest?"（休息日）":"（工作日）"),
          actions: [
            IconButton(icon: Icon(Entypo.switch_icon,color: Theme.of(context).primaryColor,), onPressed: (){
              setState(() {
                showRest = !showRest;
              });
            })
          ],
          bottom: TabBar(
              labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              labelStyle: TextStyle(
                  fontSize: fontSizeMini38, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                fontSize: fontSizeMini38,
                fontWeight: FontWeight.bold,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColor),
                  insets: EdgeInsets.fromLTRB(
                      fontSizeMain40 * 1.2, 0, fontSizeMain40 * 1.2, 0)),
              tabs: [
                Tab(
                  text: "南湖公教楼",
                ),
                Tab(
                  text: "文昌中心路",
                ),
              ])),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BusTimeListView(finalList[0], finalList[1]),
                BusTimeListView(finalList[2], finalList[3])
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil.bottomBarHeight,
          )
        ],
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildColumn("北 线", widget.north),
          ),
          VerticalDivider(
            width: 0,
          ),
          Expanded(
            child: _buildColumn("南 线", widget.south),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<String> timeList) {
    bool temp = false;
    //检查是否即将到该时间点
    bool checkTime(String timeStr) {
      DateTime now = DateTime.now();
      debugPrint(now.weekday.toString());
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
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB / 2,
              spaceCardMarginRL, spaceCardMarginTB / 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadiusValue)),
          child: FlyText.title50(
            title,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: timeList.map((item) {
                temp = !temp;
                bool comingSoon = false;
                if (checkTime(item)) comingSoon = true;
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      spaceCardMarginRL,
                      spaceCardMarginTB / 2,
                      spaceCardMarginRL,
                      spaceCardMarginTB / 2),
                  decoration: BoxDecoration(
                      color: comingSoon
                          ? themeProvider.colorMain.withOpacity(0.8)
                          : temp
                              ? themeProvider.colorMain.withOpacity(0.1)
                              : themeProvider.colorMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadiusValue)),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: FlyText.title50(
                    comingSoon ? "将达 ${item.toString()}" : item.toString(),
                    color: comingSoon
                        ? Colors.white
                        : Colors.black.withOpacity(0.8),
                    fontWeight:
                        comingSoon ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
