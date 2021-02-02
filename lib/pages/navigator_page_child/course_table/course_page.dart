//主页
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: new CourseProvider())],
      builder: (context,_){
        courseProvider = Provider.of<CourseProvider>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(courseProvider.getCurWeek.toString(),style: TextStyle(color: Colors.white),),
          ),
          body: Row(
            children: [
              Expanded(child: CourseTable()),
              PointArea()
            ],
          ),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    CourseProvider().init();
  }
  @override
  bool get wantKeepAlive => true;
}
