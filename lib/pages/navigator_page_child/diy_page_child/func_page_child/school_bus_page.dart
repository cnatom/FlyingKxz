import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

import 'package:photo_view/photo_view.dart';


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

class _SchoolBusPageState extends State<SchoolBusPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  final List<List> busTimeData1 = [
    [0,"文昌中心路始末站发车时间","南湖路线安排","南湖公教楼始末站发车时间"],
    [1,"7:10","南线","7:10、7:40"],
    [1,"7:30","北线","8:00"],
    [1,"7:50","北线","8:30"],
    [1,"8:10","北线","9:00"],
    [1,"8:30","北线","9:30"],
    [1,"8:50","北线","10:10"],
    [1,"9:20","南线","10:40"],
    [1,"9:40","北线","11:00"],
    [1,"10:00","北线","11:20"],
    [1,"10:40","北线","11:40"],
    [1,"11:10","南线","12:10"],
    [1,"11:40","南线","12:20"],
    [0,"下午班车",],
    [1,"12:50","南线","1:20"],
    [1,"1:10","南线","1:40"],
    [1,"1:40、2:00","北线","2:10"],
    [1,"2:10","北线","2:40"],
    [1,"2:40、3:00","北线","3:10、3:30"],
    [1,"3:20","南线","3:50"],
    [1,"3:50","北线","4:10"],
    [1,"4:10","北线","4:30"],
    [1,"4:20","北线","5:00"],
    [1,"4:30","北线","5:10"],
    [1,"4:50","北线","5:30"],
    [1,"5:00","南线","5:50"],
    [1,"5:40","南线","6:00、6:10"],
    [1,"6:00","南线","6:30"],
    [0,"晚上班车"],
    [1,"6:10","中心路始发","6:40"],
    [1,"以下时段由电教馆始发，人满后循环发车",],
    [1,"10:00","末班车","10:00"],
  ];
  final List<List> busTimeData2 = [
    [0,"文昌中心路始末站发车时间","南湖公教楼始末站发车时间"],
    [1,"7:10","7:50"],
    [1,"7:40","8:10"],
    [1,"8:00","8:30"],
    [1,"8:20","8:50"],
    [1,"8:40","9:10"],
    [1,"9:10","9:40"],
    [1,"9:30","10:10"],
    [1,"9:50","10:20"],
    [1,"10:10","10:40"],
    [1,"10:40","11:10"],
    [1,"11:10","11:40"],
    [1,"11:30","12:10"],
    [0,"下午班车"],
    [1,"1:00","1:30"],
    [1,"1:20","1:50"],
    [1,"1:40","2:10"],
    [1,"2:00","2:30"],
    [1,"2:20","2:50"],
    [1,"3:00","3:30"],
    [1,"3:20","3:50"],
    [1,"3:40","4:10"],
    [1,"4:00","4:50"],
    [1,"4:20","5:00"],
    [1,"4:40","5:20"],
    [1,"4:50","5:40"],
    [1,"5:20","6:00"],
    [1,"5:40","6:20"],
    [0,"晚上班车"],
    [1,"6:10","6:40"],
    [1,"注：以下时段由电教馆始发，人满后循环发车。"],
    [1,"10:00","10:00"]
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,);
  }


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "2020年班车时刻表",
          bottom: TabBar(
            labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              labelStyle: TextStyle(fontSize: fontSizeMini38,fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: fontSizeMini38,fontWeight: FontWeight.bold,),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor),
                  insets: EdgeInsets.fromLTRB(fontSizeMain40*1.2, 0, fontSizeMain40*1.2, 0)
              ),
              tabs: [
                Tab(
                  text: "工作日安排",
                ),
                Tab(
                  text: "休息日安排",
                ),

              ])),
      body: TabBarView(
        controller: _tabController,
        children: [
          BusTimeListView(busTimeData1),
          BusTimeListView(busTimeData2),
        ],
      ),
    );
  }
}
class BusTimeListView extends StatefulWidget {
  BusTimeListView(this.busTimeData);
  List<List> busTimeData;
  @override
  _BusTimeListViewState createState() => _BusTimeListViewState();
}

class _BusTimeListViewState extends State<BusTimeListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorMainText.withOpacity(0.2)))
          ),
          child: Row(
            children: [
              for(int j = 1;j<widget.busTimeData[0].length;j++) widget.busTimeData[0][0]==0?
              Expanded(
                child: FlyText.main40(widget.busTimeData[0][j],maxLine: 2,fontWeight: FontWeight.bold,textAlign: TextAlign.center),
              ):Expanded(
                child: FlyText.main40(widget.busTimeData[0][j],maxLine: 2,textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                for(int i = 1;i<widget.busTimeData.length;i++)
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: colorMainText.withOpacity(0.1)))
                    ),
                    child: Row(
                      children: [
                        for(int j = 1;j<widget.busTimeData[i].length;j++) widget.busTimeData[i][0]==0?
                        Expanded(
                          child: FlyText.main40(widget.busTimeData[i][j],maxLine: 2,fontWeight: FontWeight.bold,textAlign: TextAlign.center),
                        ):Expanded(
                          child: FlyText.main40(widget.busTimeData[i][j],maxLine: 2,textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 40,),
                FlyText.main40("团体用车联系电话：83885871、17851181688\n",color: Colors.black38,textAlign: TextAlign.left),
                FlyText.main40("更新时间：2020 年 9 月 19 日",color: Colors.black38),
                SizedBox(height: 60,),

              ],
            ),
          ),
        )
      ],
    );
  }
}
