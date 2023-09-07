import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/course_date_picker.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:flying_kxz/ui/text.dart';
import '../../../../../ui/config.dart';
import '../../../../../ui/sheet.dart';
import '../../../../../ui/toast.dart';
import '../../../../../util/logger/log.dart';
import '../../utils/course_data.dart';
import '../add_components/course_add_view.dart';
import 'import_page.dart';

class ImportSelector extends StatefulWidget {
  CourseProvider courseProvider;
  ImportSelector({Key key,@required this.courseProvider}) : super(key: key);

  @override
  State<ImportSelector> createState() => _ImportSelectorState();
}

class _ImportSelectorState extends State<ImportSelector> {

  CourseProvider courseProvider;

  void importCourse({@required ImportCourseType type})async{
    bool ok = false;
    List<dynamic> list = await Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ImportPage(importType: type,)));
    ok = list!=null?true:false;
    courseProvider.handleCourseList(list);
    if(ok){
      showToast("🎉成功导入！");
    }
    Navigator.of(context).pop(["import",type,ok]);
  }

  void addCourse() async {
    List<CourseData> newCourseDataList;
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
    Navigator.of(context).pop();
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
    Navigator.of(context).pop(["date",true]);
  }

  @override
  Widget build(BuildContext context) {
    courseProvider = widget.courseProvider;
    return Wrap(
      runSpacing: spaceCardMarginTB,
      children: [
        FlyTitle("调整课表"),

        Divider(height: 5,color: Colors.transparent,),
        button("导入本科课表",iconData: Icons.cloud_download_outlined,onTap: ()=>importCourse(type: ImportCourseType.BK)),
        button("导入研究生课表",iconData: Icons.cloud_download_outlined,onTap: ()=>importCourse(type: ImportCourseType.YJS)),
        button("添加自定义课程",iconData: Icons.add,solid: false,onTap: ()=>addCourse()),
        Divider(height: 5,),
        button("修改课表日期",iconData: Icons.date_range,solid: false,onTap: ()=>selectDate(context)),
        Divider(height: 0,),
        FlyText.miniTip30("👍[桌面小组件]点击右上角分享按钮去看看吧\n👏[自动登录校园网]点击\"我的\"页面查看\n😉[回到本周]按钮是可以拖动的",maxLine: 100,),

      ],
    );
  }

  Widget button(String title,
      {GestureTapCallback onTap, Color color,IconData iconData,bool solid = true}) {
    if(color == null){
      color = colorMain;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40 * 3,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: solid?null:Border.all(color: color,width: 1.5),
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: solid?color:Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: solid?Colors.white:color),
            SizedBox(
              width: 5,
            ),
            FlyText.main40(title, color: solid?Colors.white:color,fontWeight: solid?FontWeight.bold:null,),
          ],
        ),
      ),
    );
  }
}
