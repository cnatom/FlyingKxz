import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/ui/Theme/theme.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/point_components/point_array.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/point_components/point_matrix.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:provider/provider.dart';

class PointMain extends StatefulWidget {
  PointMain({Key key}):super(key:key);
  @override
  PointMainState createState() => PointMainState();
}

class PointMainState extends State<PointMain> {
  ThemeProvider themeProvider;
  CourseProvider courseProvider;
  bool showRight = false;
  GlobalKey<PointMatrixState> pointAreaKey = new GlobalKey<PointMatrixState>();
  show(){
    showRight = !showRight;
    setState(() {
    });
    pointAreaKey.currentState.changeWeekOffset(courseProvider.curWeek);
  }
  initScroll(){
    pointAreaKey.currentState.changeWeekOffset(courseProvider.initialWeek);
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    courseProvider = Provider.of<CourseProvider>(context);

    return Container(
      height: double.infinity,
      child: Row(
        children: [
          AnimatedCrossFade(
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: Container(),
            secondChild: PointArray(colorFirst: themeProvider.colorMain,colorSecond: themeProvider.colorNavText.withOpacity(0.3),),
            duration: Duration(milliseconds: 200),
            crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
          ),
          AnimatedCrossFade(
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
            firstChild: PointMatrix(key:pointAreaKey),
            secondChild: Container(),
            duration: Duration(milliseconds: 200),
            crossFadeState: showRight?CrossFadeState.showFirst:CrossFadeState.showSecond,
          )
        ],
      ),
    );
  }
}