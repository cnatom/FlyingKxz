import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:ical/serializer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/course_data.dart';

Future<String> courseToIcs(List<CourseData> list)async{
  var data = new CalendarData.create(list);
  if(data.ics==null) return '';
  Directory documentsDir = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDir.path+'/course.ics';
  File file = new File(documentsPath);
  if(file.existsSync()){
    file.deleteSync();
  }
  file.createSync();
  await file.writeAsString(data.ics);
  if(file.existsSync()) {
    return documentsPath;
  }
  return '';
}

class CalendarData{
  var _startTime = [[-1,-1],[8,0], [8,55], [10,15], [11,10], [14,0], [14,55], [16,15], [17,10], [19,0], [19,55]];
  var _endTime = [[-1,-1],[8,50], [9,45], [11,5], [12,0], [14,50], [15,45], [17,5], [18,0], [19,50], [20,45],];
  ICalendar data;
  String ics;
  CalendarData.create(List<CourseData> list){
    if(Prefs.admissionDate==null){
      showToast('未定义开学时间');
      return;
    }
    DateTime start = DateTime.parse(Prefs.admissionDate).toUtc();
    this.data = new ICalendar();
    for(int i = 0;i<list.length;i++){
      CourseData cur = list[i];
      for(int week in cur.weekList){
        DateTime startDate = start;
        startDate = startDate.add(Duration(
          days: (week-1)*7+cur.weekNum-1,
          hours: _startTime[cur.lessonNum][0],
          minutes: _startTime[cur.lessonNum][1]
        ),);
        DateTime endDate = DateTime.utc(startDate.year,startDate.month,startDate.day).subtract(Duration(hours: 8));
        endDate = endDate.add(Duration(
          hours: _endTime[cur.lessonNum+cur.durationNum-1][0],
          minutes: _endTime[cur.lessonNum+cur.durationNum-1][1]
        ));
        IEvent event = new IEvent(
          summary: cur.title,
          location: cur.location,
          description: '${cur.teacher} ${cur.credit}学分',
          start: startDate,
          end: endDate,
          url: 'https://kxz.atcumt.com/',
        );
        this.data.addElement(event);
      }
    }
    this.ics = this.data.serialize();
  }
}