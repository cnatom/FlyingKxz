import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDatePicker{
  Future<String> show(BuildContext context) async {
    try{
      Locale myLocale = Localizations.localeOf(context);
      DateTime? date = await showDatePicker(
        helpText: "选择开学日期（第一周第一天的日期）",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010,1,1),
        lastDate: DateTime(2100),
        locale: myLocale,
      );
      if(date==null){
        return '';
      }
      String y = _fourDigits(date.year);
      String m = _twoDigits(date.month);
      String d = _twoDigits(date.day);
      return '$y-$m-$d';
    }catch(e){
      return '';
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