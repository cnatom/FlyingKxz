
import 'package:flutter/material.dart';

class BusModel extends ChangeNotifier{
  bool showRest = false; // 是否显示休息日时间表
  List<List<String>> listRest = []; // 休息日时间表
  List<List<String>> listWork = []; // 工作日时间表
  List<List<String>> finalList = []; // 最终展示的时间表

  //南湖 北线 工作日
  final List<String> nNorthWork = [
    "7:50","8:00","8:10","8:20","8:30","8:50","9:40","10:00","10:40","11:00","11:20",
    "14:10","14:40","15:00","15:25","16:05","16:30","17:00","17:10","17:30",
    "22:00"
  ];
  //南湖 南线 工作日
  final List<String> nSouthWork = [
    "7:20","7:30","9:15","9:25","11:40","12:10","12:20",
    "13:10","13:15","13:40","15:50","17:40","17:50",
    "18:10","18:15","18:30","18:40","21:00","21:20","21:40","22:00"
  ];
  //文昌 北线 工作日
  final List<String> wNorthWork = [
    "7:30","7:40","7:50","8:10","8:20","8:30","8:50","9:40","10:00","10:40","11:00","11:20",
    "13:40","14:00","14:10","14:40","15:00","15:50","16:05","16:20","16:30","16:50",
    "22:00"
  ];
  //文昌 南线 工作日
  final List<String> wSouthWork = [
    "7:00","7:10","7:20","9:15","9:25","11:40","12:10","12:20",
    "13:00","13:10","13:20","13:30","15:25","17:10","17:30","17:45","18:00",
    "18:15","21:00","21:20","21:40","22:00",
  ];
  //南湖 休息日
  final List<String> nRest = [
    "7:25","7:30","7:50","8:00","8:20","8:40","9:10","9:20","9:40","10:00","10:40","11:10","12:15",
    "13:10","13:50","14:10","14:30","14:50","15:25","15:50","16:00","16:40","16:50","17:00","17:10","17:40",
    "18:10","18:15","18:40","21:00","21:20","21:40","22:00",
  ];
  //文昌 休息日
  final List<String> wRest = [
    "7:10","7:15","7:50","8:00","8:20","8:40","9:10","9:20","9:40","10:00","10:40","11:10","12:15",
    "13:10","13:20","13:30","13:40","14:00","14:20","15:00","15:25","15:40","16:00","16:20","16:40","16:50","17:10","17:40",
    "18:10","21:00","21:20","21:40","22:00"
  ];


  BusModel(){
    listRest..add(nRest)..add(nRest)..add(wRest)..add(wRest);
    listWork..add(nNorthWork)..add(nSouthWork)..add(wNorthWork)..add(wSouthWork);
    if(DateTime.now().weekday>=6){
      finalList = listRest;
      showRest = true;
    }else{
      finalList = listWork;
      showRest = false;
    }
  }
  switchRest(){
    showRest = !showRest;
    if(showRest){
      finalList = listRest;
    }else{
      finalList = listWork;
    }
    notifyListeners();
  }

}