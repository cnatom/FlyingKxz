import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/bottom_sheet.dart';
import 'package:flying_kxz/ui/config.dart';
import 'package:flying_kxz/ui/dialog.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/add_components/weekList_picker.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';

import 'lessonWeekNum_picker.dart';

class CourseAddView extends StatefulWidget {
  @override
  _CourseAddViewState createState() => _CourseAddViewState();
}

class _CourseAddViewState extends State<CourseAddView> {
  //构建页面所需数据
  var titleController = new TextEditingController();
  var locationController = new TextEditingController();
  var teacherController = new TextEditingController();
  var remarkController = new TextEditingController();
  List<String> lessonStrList = ["未选择"];
  List<String> weekStrList = ["未选择"];
  //需要返回的数据
  String title;
  String location;
  String teacher;

  List<CourseData> courseDataList = [new CourseData()];
  int durationNum;
  @override
  Widget build(BuildContext context) {
    return FlyBottomSheetScaffold(context,
        title: "添加课程",
        onDetermine: ()=>_onDetermine(),
        onCancel: ()=>Navigator.of(context).pop(),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: spaceCardMarginBigTB*2,
            children: <Widget>[
              inputBar('课程', titleController),
              inputBar('地点(选填)', locationController),
              inputBar('老师(选填)', teacherController),
              inputBar('备注(选填)', remarkController,maxLines: 3),
              Wrap(
                children: List.generate(lessonStrList.length, (index){
                  return  _buildPickers(index);
                },growable: true),
              ),
              Divider(),
              _buildAddSubButtons()
            ],
          ),
        )
    );
  }
  Widget _buildAddSubButtons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        courseDataList.length>1?IconButton(icon: Icon(Icons.remove,), onPressed: ()=>_subDate()):Container(),
        IconButton(icon: Icon(Icons.add), onPressed: ()=>_addDate()),
      ],
    );
  }
  _addDate(){
    courseDataList.add(new CourseData());
    lessonStrList.add('未选择');
    weekStrList.add('未选择');
    setState(() {

    });
  }
  _subDate(){
    courseDataList.removeLast();
    lessonStrList.removeLast();
    weekStrList.removeLast();
    setState(() {
    });
  }
  Widget _buildPickers(int index){
    return Wrap(
      runSpacing: spaceCardMarginBigTB*2,
      children: [
        Divider(height: 0,),
        Center(child: FlyText.miniTip30('No.${index+1}'),),
        _buildChooseButton("周数",weekStrList[index]??"未选择", ()=>_weekPick(index)),
        _buildChooseButton("节次", lessonStrList[index]??"未选择", ()=>_lessonPick(index)),
      ],
    );
  }
  _weekPick(int index)async{
    List<int> weekList;
    weekList = await FlyDialogDIYShow(context, content: WeekListPicker());
    if(weekList==null)return;
    courseDataList[index].weekList = weekList;
    weekStrList[index] = CourseData.weekListToString(weekList);
    setState(() {

    });
  }
  _lessonPick(int index)async{
    List result = [];
    int weekNum;
    int lessonNum;
    int durationNum;
    result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor.withOpacity(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      builder: (BuildContext context) {
        return LessonWeekNumPicker();
      },
    );
    if(result==null) return;
    weekNum = result[0];
    lessonNum = result[1];
    durationNum = result[2];
    setState(() {
      lessonStrList[index] = '周$weekNum  第$lessonNum'+(durationNum!=1?'-${lessonNum+durationNum-1}':'')+'节';
    });
    courseDataList[index].weekNum = weekNum;
    courseDataList[index].lessonNum = lessonNum;
    courseDataList[index].durationNum = durationNum;
  }

  Widget _buildChooseButton(String title,String subTitle,GestureTapCallback onTap){
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spaceCardMarginRL),
        child: Row(
          children: [
            Expanded(
              child: FlyText.title45(title),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FlyText.main40(subTitle,maxLine: 2,),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right_rounded,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  bool _checkCompleteness(){
    for(int i = 0;i<lessonStrList.length;i++){
      if(lessonStrList[i]=="未选择"||weekStrList[i]=="未选择"){
        showToast("请填写完整哦");
        return false;
      }
    }
    if(titleController.text.isEmpty){
      showToast( "请填写完整哦");
      return false;
    }
    return true;
  }
  _onDetermine(){
    FocusScope.of(context).requestFocus(FocusNode());
    //确定回调
    if(_checkCompleteness()){
      for(var courseData in courseDataList){
        courseData.title = titleController.text;
        courseData.location = locationController.text;
        courseData.teacher = teacherController.text;
        courseData.remark = remarkController.text;
      }
      Navigator.of(context).pop(courseDataList);
    }
  }

  Widget inputBar(String hintText,TextEditingController controller,
      {FormFieldSetter<String> onSaved,bool autofocus = false,int maxLines = 1}){
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: TextFormField(
        cursorColor: colorMain,
        autofocus: autofocus,
        maxLines: maxLines,
        style: TextStyle(fontSize: fontSizeTitle45,),
        controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: fontSizeTitle45,),
          border: InputBorder.none, //下划线
          hintText: hintText, //点击后显示的提示语
        ),
        onSaved: onSaved,
      ),
    );
  }
}