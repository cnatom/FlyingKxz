import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/course_date_picker.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:provider/provider.dart';
import '../../../../../ui/config.dart';
import '../../../../../ui/sheet.dart';
import '../../../../../ui/toast.dart';
import '../../../../../util/logger/log.dart';
import '../../utils/course_data.dart';
import '../add_components/course_add_view.dart';
import 'import_page.dart';
import 'import_selector_arrow.dart';

class ImportSelectorNew extends StatefulWidget {
  final CourseProvider courseProvider;
  final void Function(Object? object) onImport;
  ImportSelectorNew({Key? key,required this.courseProvider,required this.onImport}) : super(key: key);

  @override
  State<ImportSelectorNew> createState() => _ImportSelectorNewState();
}

class _ImportSelectorNewState extends State<ImportSelectorNew> {
  late ThemeProvider themeProvider;
  late CourseProvider courseProvider;

  void importCourse({required ImportCourseType type})async{
    bool ok = false;
    List<dynamic>? list = await Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ImportPage(importType: type,)));
    ok = list!=null&&list.isNotEmpty?true:false;
    if(ok){
      courseProvider.handleCourseList(list);
    }
    widget.onImport(["import",type,ok]);
  }

  void addCourse() async {
    List<CourseData>? newCourseDataList;
    newCourseDataList = await showFlyModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue)),
      builder: (BuildContext context) {
        return CourseAddView();
      },
    );
    if (newCourseDataList == null) return;
    for (var newCourseData in newCourseDataList) {
      courseProvider.add(newCourseData);
    }
    showToast("🎉添加成功！");
    Logger.log("Course", "添加,成功",
        {'info': newCourseDataList.map((e) => e.toJson()).toList()});
  }


  void selectDate(BuildContext context)async{
    CourseDatePicker picker = CourseDatePicker();
    var dateTime = await picker.show(context);
    if(dateTime==''){
      showToast('日期选择失败');
      Navigator.of(context).pop(["date",false]);
      return;
    }
    courseProvider.setAdmissionDateTime(dateTime);
    showToast("🎉日期选择成功！");
    widget.onImport(["date",true]);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    courseProvider = widget.courseProvider;
    return CustomPaint(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadiusValue),
            bottomRight: Radius.circular(borderRadiusValue),
            bottomLeft: Radius.circular(borderRadiusValue),
          ),
        ),
        child: Wrap(
          runSpacing: spaceCardMarginTB,
          children: [
            button("导入本科课表",iconData: Icons.cloud_download_outlined,onTap: ()=>importCourse(type: ImportCourseType.BK)),
            button("导入研究生课表",iconData: Icons.cloud_download_outlined,onTap: ()=>importCourse(type: ImportCourseType.YJS)),
            button("添加自定义课程",iconData: Icons.add,solid: false,onTap: ()=>addCourse()),
            Divider(height: 5,),
            button("修改课表日期",iconData: Icons.date_range,solid: false,onTap: ()=>selectDate(context)),

          ],
        ),
      ),
      painter: ImportSelectorArrow(Theme.of(context).cardColor),
    );
  }

  Widget button(String title,
      {GestureTapCallback? onTap,IconData? iconData,bool solid = true}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: solid?null:Border.all(color: themeProvider.colorMain,width: 1.5),
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: solid?themeProvider.colorMain:Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, color: solid?Colors.white:themeProvider.colorMain),
            SizedBox(
              width: 5,
            ),
            FlyText.main40(title, color: solid?Colors.white:themeProvider.colorMain,fontWeight: solid?FontWeight.bold:null,),
          ],
        ),
      ),
    );
  }
}
