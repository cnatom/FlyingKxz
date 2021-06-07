import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/Model/score_info.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/CumtSpider/cumt_format.dart';
import 'package:html/parser.dart';


Future<bool> scoreGet(BuildContext context,InquiryType type,{@required String term, @required String year,}) async {
  try{
    if(Prefs.visitor){
      //游客模式
      String visitorUrl = ApiUrl.scoreUrl;
      if(type==InquiryType.ScoreAll) visitorUrl = ApiUrl.scoreAllUrl;
      var res = (await Dio().post(visitorUrl)).toString();
      debugPrint(res);
      Map<String, dynamic> map = jsonDecode(res.toString());
      Global.scoreInfo = ScoreInfo.fromJson(map);
      return true;
    }else{
      //非游客模式
      var res = await cumt.inquiryJw(type, year, term);
      if(res!=''){
        Map<String, dynamic> map = jsonDecode(res.toString());
        if(type == InquiryType.ScoreAll) map = CumtFormat.parseScoreAll(map);
        if(type == InquiryType.Score) map = CumtFormat.parseScore(map);
        Global.scoreInfo = ScoreInfo.fromJson(map);
        return true;
      }
      return false;
    }
  }catch(e){
    debugPrint(e.toString());
    showToast('获取失败QAQ');
    return false;
  }
}


