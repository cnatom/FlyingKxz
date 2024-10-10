import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDatePicker{
  Future<String> show(BuildContext context) async {
    try{
      Locale myLocale = Localizations.localeOf(context);
      // 获取当前日期并计算出离当前日期最近的周一
      DateTime initialDate = _getNextMonday(DateTime.now());
      DateTime? date = await showDatePicker(
        helpText: "选择开学日期（第一周第一天的日期）",
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2010,1,1),
        lastDate: DateTime(2100),
        locale: myLocale,
        // 限制只能选择周一
        selectableDayPredicate: (DateTime day) {
          return day.weekday == DateTime.monday; // 只允许选择周一
        },
      );
      if(date==null){
        return '';
      }
      String y = _fourDigits(date.year);
      String m = _twoDigits(date.month);
      String d = _twoDigits(date.day);
      return '$y-$m-$d';
    }catch(e){
      print(e.toString());
      return '';
    }
  }
  // 返回下一个周一的日期
  DateTime _getNextMonday(DateTime currentDate) {
    int daysToAdd = (DateTime.monday - currentDate.weekday) % 7;
    if (daysToAdd == 0) {
      return currentDate; // 如果今天是周一，直接返回
    } else {
      return currentDate.add(Duration(days: daysToAdd));
    }
  }
  String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }
  String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }
}