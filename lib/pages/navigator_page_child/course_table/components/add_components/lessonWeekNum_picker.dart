import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';

class LessonWeekNumPicker extends StatefulWidget {
  @override
  _LessonWeekNumPickerState createState() => _LessonWeekNumPickerState();
}

class _LessonWeekNumPickerState extends State<LessonWeekNumPicker> {
  int weekNum=1;
  int lessonNum=1;
  int duration = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 20,
        children: [
          _buildTitle('选择小节'),
          _buildLocPicker(),
          Divider(),
          _buildTitle('持续几小节？'),
          _buildDurationPicker(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPreview(),
              _buildButton(),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildTitle(String title){
    return Center(child: FlyText.title50(title,fontWeight: FontWeight.bold,),);
  }
  Widget _buildPreview(){
    return FlyText.miniTip30('周$weekNum  第$lessonNum'+(duration!=1?'-${lessonNum+duration-1}':'')+'节');
  }
  Widget _buildLocPicker(){
    return Wrap(
      children: [
        //周1-周7
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(8, (i){
            if(i==0)return Expanded(child: Center(child: FlyText.miniTip30('节'),),flex: 1,);
            return Expanded(flex: 2,child: Center(child: FlyWidgetBuilder(
              whenFirst: weekNum==i,
              firstChild: FlyText.mini30('周$i',color: colorMain,fontWeight: FontWeight.bold,),
              secondChild: FlyText.miniTip30('周$i',),
            ),
            ));
          },),
        ),
        //节次 [][][][][][][]
        Wrap(
          children: List.generate(11, (lesson){
            if(lesson == 0) return Container();
            return _buildRow(lesson);
          }),
        ),
      ],
    );
  }
  _submit(){
    Navigator.of(context).pop([weekNum,lessonNum,duration]);
  }
  Widget _buildButton(){
    return Center(
      child:  InkWell(
        child: FlyText.main40('确定',color: colorMain,fontWeight: FontWeight.bold,),
        onTap: ()=>_submit(),
      ),
    );
  }
  bool check({int lesson,int dur}){
    if(lesson==null)lesson = lessonNum;
    if(dur==null)dur = duration;
    if(lesson+dur-1>10){
      showToast(context, "节次超限啦(X_X)",gravity: 1);
      return false;
    }
    return true;
  }
  Widget _buildDurationPicker(){

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          int dur = index+1;
          return ChoiceChip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            label: FlyText.mini30(dur.toString()),
            selected: duration==dur,
            onSelected: (v) {
              if(v){
                if(check(dur: dur)) setState(() {
                  duration = dur;
                });
              }
              debugPrint(weekNum.toString()+'  '+lessonNum.toString());
            },
          );
        }).toList(),
      ),
    );
  }
  Widget _buildRow(int lesson){
    return  Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(8, (week) {
          if(week==0)return Expanded(
            child: Center(child: FlyWidgetBuilder(
              whenFirst: lesson==lessonNum,
              firstChild: FlyText.mini30('$lesson',color: colorMain,fontWeight: FontWeight.bold,),
              secondChild: FlyText.miniTip30('$lesson',),
            ),),
          );
          return Expanded(
            flex: 2,
            child: ChoiceChip(
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              label: Container(height: 30,width: 30,),
              selected: weekNum==week&&lessonNum==lesson,
              onSelected: (v) {
                if(v){
                  if(check(lesson: lesson))setState(() {
                    weekNum = week;
                    lessonNum = lesson;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

}