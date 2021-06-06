import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/bottom_sheet.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:provider/provider.dart';

class LessonWeekNumPicker extends StatefulWidget {
  @override
  _LessonWeekNumPickerState createState() => _LessonWeekNumPickerState();
}

class _LessonWeekNumPickerState extends State<LessonWeekNumPicker> {
  int weekNum = 1;
  int lessonNum = 1;
  int duration = 1;
  int step = 0;
  ThemeProvider themeProvider;
  PageController controller = PageController();
  void _switchStep() {
    if (step == 0) {
      this.controller.jumpToPage(1);
      setState(() {
        step = 1;
      });
    } else {
      this.controller.jumpToPage(0);
      setState(() {
        step = 0;
      });
    }
  }

  _submit() {
    Navigator.of(context).pop([weekNum, lessonNum, duration]);
  }

  _pop() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: ScreenUtil().setHeight(deviceHeight * 0.7),
      child: FlyBottomSheetScaffold(context,
          title: '周$weekNum  第$lessonNum' +
              (duration != 1 ? '-${lessonNum + duration - 1}' : '') +
              '节',
          leftText: step == 0 ? "取消" : "上一步",
          rightText: step == 0 ? "下一步" : "确定",
          onDetermine: () => step == 0 ? _switchStep() : _submit(),
          onCancel: () => step == 0 ? _pop() : _switchStep(),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              _buildFir(),
              _buildSec(),
            ],
          )),
    );
  }

  SingleChildScrollView _buildFir() {
    return SingleChildScrollView(
      child: _buildLocPicker(),
    );
  }

  Widget _buildSec() {
    return SingleChildScrollView(child: Center(child: _buildDurationPicker()));
  }

  Widget _buildLocPicker() {
    return Wrap(
      children: [
        //周1-周7
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            8,
            (i) {
              if (i == 0)
                return Expanded(
                  child: Center(
                    child: FlyText.miniTip30('节'),
                  ),
                  flex: 1,
                );
              return Expanded(
                  flex: 2,
                  child: Center(
                    child: FlyWidgetBuilder(
                      whenFirst: weekNum == i,
                      firstChild: FlyText.mini30(
                        '周$i',
                        color: themeProvider.colorMain,
                        fontWeight: FontWeight.bold,
                      ),
                      secondChild: FlyText.miniTip30(
                        '周$i',
                      ),
                    ),
                  ));
            },
          ),
        ),
        //节次 [][][][][][][]
        Wrap(
          children: List.generate(11, (lesson) {
            if (lesson == 0) return Container();
            return _buildRow(lesson);
          }),
        ),
      ],
    );
  }

  bool check({int lesson, int dur}) {
    if (lesson == null) lesson = lessonNum;
    if (dur == null) dur = duration;
    if (lesson + dur - 1 > 10) {
      showToast("节次超限啦(X_X)", gravity: 1);
      return false;
    }
    return true;
  }

  Widget _buildDurationPicker() {
    int lenth = 11 - lessonNum;
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: List.generate(lenth, (index) {
        int dur = index + 1;
        return ChoiceChip(
          labelPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          label: FlyText.main40((dur != 1
              ? '$lessonNum-${lessonNum + dur - 1}节'
              : "第$lessonNum节")),
          selected: duration == dur,
          onSelected: (v) {
            if (v) {
              if (check(dur: dur))
                setState(() {
                  duration = dur;
                });
            }
            debugPrint(weekNum.toString() + '  ' + lessonNum.toString());
          },
        );
      }).toList(),
    );
  }

  Widget _buildRow(int lesson) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(8, (week) {
          if (week == 0)
            return Expanded(
              child: Center(
                child: FlyWidgetBuilder(
                  whenFirst: lesson == lessonNum,
                  firstChild: FlyText.mini30(
                    '$lesson',
                    color: themeProvider.colorMain,
                    fontWeight: FontWeight.bold,
                  ),
                  secondChild: FlyText.miniTip30(
                    '$lesson',
                  ),
                ),
              ),
            );
          return Expanded(
            flex: 2,
            child: ChoiceChip(
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              label: Container(
                height: 30,
                width: 30,
              ),
              selected: weekNum == week && lessonNum == lesson,
              onSelected: (v) {
                if (v) {
                  if (check(lesson: lesson))
                    setState(() {
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
