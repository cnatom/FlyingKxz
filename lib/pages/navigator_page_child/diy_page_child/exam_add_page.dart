
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flying_kxz/FlyingUiKit/bottom_sheet.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/exam_info.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/exam_page.dart';

class ExamAddView extends StatefulWidget {
  @override
  _ExamAddViewState createState() => _ExamAddViewState();
}

class _ExamAddViewState extends State<ExamAddView> {
  TextEditingController courseController = new TextEditingController();
  TextEditingController localController = new TextEditingController();
  DateTime date;//日期
  DateTime startTime;//开始时间
  DateTime endTime;//结束时间

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FlyBottomSheetScaffold(context,
          onCancel: ()=>Navigator.pop(context,false),
          title: "添加倒计时",
          onDetermine: ()=>determineFunc(),
          child:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Wrap(
              runSpacing: spaceCardMarginBigTB*2,
              children: [
                inputBar('事项', courseController),
                inputBar('地点', localController),
                InkWell(
                  onTap: ()=>_showDataPicker(),
                  child: Padding(
                    padding: EdgeInsets.all(spaceCardMarginRL),
                    child: Row(
                      children: [
                        FlyText.title45('日期'),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              date==null?FlyText.mainTip40('未选择',):
                              FlyText.main40("${date.year}-${date.month}-${date.day}")
                              ,
                              Icon(Icons.keyboard_arrow_right_rounded,)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(height: 0,),
                Center(
                  child: FlyText.miniTip30('Tip：点击倒计时卡片可以将其删除（从教务系统提取的除外）'),
                ),
              ],
            ),
          )
      ),
    );
  }
  Widget inputBar(String hintText,TextEditingController controller,
      {FormFieldSetter<String> onSaved,bool autofocus = false}){
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
      decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: TextFormField(
        autofocus: autofocus,
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
  _showDataPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
        lastDate: DateTime(2100),
        locale: myLocale);
    setState(() {

    });
  }
  determineFunc(){
    if(courseController.text.isEmpty||localController.text.isEmpty||date==null){
      showToast('请填写完整~');
      return;
    }
    var newCountDownInfo = ExamUnit(
        courseName: courseController.text,
        location: localController.text,
        dateTime: "${date.year}-${date.month}-${date.day}",
        year: date.year,
        month: date.month,
        day: date.day,
        diy: true
    );
    Global.examList.add(newCountDownInfo);
    Prefs.examData = ExamUnit.examJsonEncode(Global.examList);
    Navigator.pop(context);
  }

}
