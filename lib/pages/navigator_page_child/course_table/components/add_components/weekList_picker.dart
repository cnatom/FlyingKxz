import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';
import 'package:flying_kxz/ui/ui.dart';

class WeekListPicker extends StatefulWidget {
  @override
  _WeekListPickerState createState() => _WeekListPickerState();
}

class _WeekListPickerState extends State<WeekListPicker> {
  List<int> weekList = [];
  bool chooseAll = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTitle('选择周次'),
              FlyTextButton(chooseAll?"取消全选":"全部选择",onTap: (){
                setState(() {
                  chooseAll = !chooseAll;
                });
                if(chooseAll){
                  weekList.clear();
                  for(int i = 1;i<=22;i++){
                    weekList.add(i);
                  }
                }else{
                  weekList.clear();
                }
              })
            ],
          ),

          _buildWeekPicker(),
          Wrap(
            runSpacing: 20,
            children: [
              _buildPreview(),
              _buildButton(onTap:()=>_submit())
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPreview(){
    return Center(
      child: FlyText.miniTip30(CourseData.weekListToString(weekList),maxLine: 5,),
    );
  }
  Widget _buildWeekPicker(){
    return Wrap(
      spacing: 10,
      children: List.generate(22, (index) {
        int week = index+1;
        return ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          label: FlyText.mini30(week.toString()),
          selected: weekList.contains(week),
          onSelected: (v) {
            setState(() {
              if(v){
                weekList.add(week);
              }else{
                weekList.removeWhere((element) => element==week);
              }
              weekList.sort();
            });
          },
        );
      }).toList(),
    );
  }
  Widget _buildTitle(String title){
    return Center(child: FlyText.title50(title,fontWeight: FontWeight.bold,),);
  }
  _submit(){
    if(weekList.isEmpty){
      Navigator.of(context).pop();
    }else{
      Navigator.of(context).pop(weekList);
    }
  }
  Widget _buildButton({GestureTapCallback onTap}){
    return Center(
      child: FlyTextButton("确定",
        onTap: onTap,),
    );
  }

}