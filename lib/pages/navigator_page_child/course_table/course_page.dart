//主页
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

import 'components/course_table.dart';
import 'components/point_area.dart';


class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}
class _CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin {
  CourseProvider courseProvider;
  bool showRight = false;
  @override
  void initState() {
    super.initState();
  }
  EdgeInsets padding()=>EdgeInsets.fromLTRB(
      0,0, spaceCardMarginRL/2, spaceCardMarginRL/2);
  BoxDecoration containerDecoration()=>BoxDecoration(
    color: Theme.of(context).cardColor.withOpacity(transparentValue*0.65),
    borderRadius: BorderRadius.circular(borderRadiusValue)
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: CourseProvider())],
      builder: (context,_){
        courseProvider = Provider.of<CourseProvider>(context);
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            title: FlyText.title45('第${CourseProvider.curWeek}周',
                fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
            leading: _buildHttpButton(),
            actions: [
              FlyWidgetBuilder(
                  whenFirst: CourseProvider.curWeek!=CourseProvider.initialWeek,
                  firstChild: _buildRefreshButton(),
                  secondChild: Container()),
              _buildAddButton(),
              _buildShowLeftButton(),
              // IconButton(icon: Icon(Icons.build), onPressed: ()=>courseProvider.test(),color: Colors.white,),
            ],
          ),
          body: Container(
            padding: padding(),
            decoration: containerDecoration(),
            child: Row(
              children: [
                Expanded(child: CourseTable()),
                AnimatedCrossFade(
                  firstCurve: Curves.easeOutCubic,
                  secondCurve: Curves.easeOutCubic,
                  sizeCurve: Curves.easeOutCubic,
                  firstChild: PointArea(),
                  secondChild: Container(),
                  duration: Duration(milliseconds: 200),
                  crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHttpButton(){
    return IconButton(
      icon: Icon(Icons.cloud_download_outlined),
      onPressed: ()=>courseProvider.get(Prefs.token, Prefs.schoolYear, Prefs.schoolTerm),color: Colors.white,);
  }
  Widget _buildRefreshButton(){
    return IconButton(
      icon: Icon(
        EvilIcons.refresh,
        color: Theme.of(context).accentColor,
      ),
      onPressed: (){
      courseProvider.changeWeek(CourseProvider.initialWeek);
      pageController.jumpToPage(CourseProvider.initialWeek-1,);
    },
    );
  }
  Widget _buildAddButton(){
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Theme.of(context).accentColor,
      ),
      onPressed: ()=>courseProvider.changeWeek(CourseProvider.initialWeek),
    );
  }
  Widget _buildShowLeftButton(){
    return  IconButton(
      icon: Icon(
        Boxicons.bx_menu_alt_right,
        color: Theme.of(context).accentColor,
      ),
      onPressed: () {
        setState(() {
          showRight = !showRight;
        });
      },
    );
  }
  @override
  bool get wantKeepAlive => true;
}
