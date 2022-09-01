import 'package:flying_kxz/ui/toast.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

import 'package:flying_kxz/Model/video__data.dart';

/// 数据清洗模块
class CumtFormat{
  static String courseHtmlToDate(String html){
    try{
      String result;
      String year,term;
      var document = parser.parse(html);
      var table = document.body.querySelector('h6[class="pull-left"]');
      //提取学期
      RegExp expTerm = new RegExp(r".*学年第(.*)学期");
      if(expTerm.hasMatch(table.text)){
        term = expTerm.firstMatch(table.text).group(1);
      }
      //提取学年
      RegExp expYear = new RegExp(r"(.*)-");
      if(expYear.hasMatch(table.text)){
        year = expYear.firstMatch(table.text).group(1);
      }
      //判断开学时间
      if(term=='1'){
        result = '$year-09-07';
      }else{
        result = '${int.parse(year)+1}-03-01';
      }
      return result;
    }catch(e){
      return '';
    }
  }
  //课表HTML->List<CourseData>
  static List<dynamic> courseHtmlToList(String html){
    try{
      var result = [];

      String title;//语文
      String location;//博五
      String teacher;//张三
      String credit;//学分
      List<int> weekList = [];//几周有这些课
      int weekNum;//星期几
      int lessonNum;//第几节课
      int durationNum;//持续节次，默认为2小节
      List<int> duration = [];
      List<int> lesson = [];
      Map<String,String> map = new Map<String,String>();
      var document = parser.parse(html);
      var table = document.body.querySelector("#kbgrid_table_0");
      Element temp1;
      List<Element> temp2;
      for(int r = 1;r<=12;r++){
        for(int c = 1;c<=7;c++){
          temp1 = table.querySelector('td[id="$c-$r"]');
          if(temp1!=null&&temp1.text!=''){
            temp2 = temp1.children;
            try{
              for(var temp3 in temp2){
                title = temp3.querySelector(".title").text;
                location = temp3.querySelector('span[title="上课地点"]').nextElementSibling.text;
                teacher = temp3.querySelector('span[title="教师"]').nextElementSibling.text;
                credit = temp3.querySelector('span[title="学分"]').nextElementSibling.text;
                String lessonWeek = temp3.querySelector('span[title="节/周"]').nextElementSibling.text;
                duration = _getDuration(lessonWeek);
                lesson = _getLesson(lessonWeek);
                weekList = _getWeekList(lessonWeek);
                weekNum = c;
                print(lesson.toString());
                print(duration.toString());
                for(int i = 0;i<duration.length;i++){

                  durationNum = duration[i];
                  lessonNum = lesson[i];
                  if(duration.length>1){
                    var key = '$lessonNum-$durationNum';
                    if(map[key]==null){
                      map[key] = title;
                    }else if(map[key].contains(title)){
                      break;
                    }else{
                      map[key]+=' '+title;
                    }
                  }
                  // print({
                  //   "title":title,
                  //   "location":location,
                  //   "teacher":teacher,
                  //   "credit":credit,
                  //   "durationNum":durationNum,
                  //   "weekList":weekList,
                  //   "weekNum":weekNum,
                  //   "lessonNum":lessonNum,
                  // });
                  result.add({
                    "title":title,
                    "location":location,
                    "teacher":teacher,
                    "credit":credit,
                    "durationNum":durationNum,
                    "weekList":weekList,
                    "weekNum":weekNum,
                    "lessonNum":lessonNum,
                  });
                }

              }
            }catch(e){
              print(e);
            }
          }
        }
      }
      return result;
    }catch (e){
      print(e.toString());
      return null;
    }
    // try{
    //   var result = [];
    //
    //   String title;//语文
    //   String location;//博五
    //   String teacher;//张三
    //   String credit;//学分
    //   List<int> weekList;//几周有这些课
    //   int weekNum;//星期几
    //   int lessonNum;//第几节课
    //   int durationNum;//持续节次，默认为2小节
    //
    //   var document = parser.parse(html);
    //   var table = document.body.querySelector("#kbgrid_table_0");
    //   Element temp1;
    //   List<Element> temp2;
    //   for(int r = 1;r<=12;r++){
    //     for(int c = 1;c<=7;c++){
    //       temp1 = table.querySelector('td[id="$c-$r"]');
    //       if(temp1!=null&&temp1.text!=''){
    //         temp2 = temp1.children;
    //         for(var temp3 in temp2){
    //
    //           title = temp3.querySelector(".title").text;
    //           location = temp3.querySelector('span[title="上课地点"]').nextElementSibling.text;
    //           teacher = temp3.querySelector('span[title="教师"]').nextElementSibling.text;
    //           credit = temp3.querySelector('span[title="学分"]').nextElementSibling.text;
    //           String lessonWeek = temp3.querySelector('span[title="节/周"]').nextElementSibling.text;
    //           //durationNum = _getDuration(lessonWeek);
    //           weekList = _getWeekList(lessonWeek);
    //           weekNum = c;
    //           // lessonNum = _getLessonNum(lessonWeek);
    //           print({
    //             "title":title,
    //             "location":location,
    //             "teacher":teacher,
    //             "credit":credit,
    //             "durationNum":durationNum,
    //             "weekList":weekList,
    //             "weekNum":weekNum,
    //             "lessonNum":lessonNum,
    //           }.toString());
    //           result.add({
    //             "title":title,
    //             "location":location,
    //             "teacher":teacher,
    //             "credit":credit,
    //             "durationNum":durationNum,
    //             "weekList":weekList,
    //             "weekNum":weekNum,
    //             "lessonNum":lessonNum,
    //           });
    //         }
    //       }
    //     }
    //   }
    //   return result;
    // }catch(e){
    //   print(e.toString());
    //
    //   return null;
    // }
  }
  //(1-3节,5-6节)1-5周,7-9周 -> lessonNum:[1,5]
  static List<int> _getLesson(String s){
    // RegExp expWeek = new RegExp(r"[(](.*?)[)]");
    // RegExp expLesson = new RegExp(r"[(](.*?)-.*节[)]");
    // int lessonNum;
    // if(expLesson.hasMatch(s)){
    //   String durationStr = expLesson.firstMatch(s).group(1);
    //   lessonNum = int.parse(durationStr);
    // }
    // return lessonNum;

    RegExp expLesson = new RegExp(r"[(](.*)[)]");
    List<int> lessonNum = [];
    if(expLesson.hasMatch(s)){
      String durationStr = expLesson.firstMatch(s).group(1);
      //1-2节,7-8节
      var b = durationStr.split(',');
      for(var item in b){
        expLesson = new RegExp(r"(.*)[节]");
        if(expLesson.hasMatch(item)){
          item = expLesson.firstMatch(item).group(1);
          var d = item.split('-');
          lessonNum.add(int.parse(d[0]));
        }
      }
    }
    return lessonNum;
  }

  //(1-3节)1-5周,7-9周 -> durationNum:[3]   (1-2节,7-8节)9周 ->  durationNum:[2,2]
  static List<int> _getDuration(String s){
    RegExp expLesson = new RegExp(r"[(](.*)[)]");
    List<int> durationNum = [];
    if(expLesson.hasMatch(s)){
      String durationStr = expLesson.firstMatch(s).group(1);
      //1-2节,7-8节
      var b = durationStr.split(',');
      for(var item in b){
        expLesson = new RegExp(r"(.*)[节]");
        if(expLesson.hasMatch(item)){
          item = expLesson.firstMatch(item).group(1);
          var d = item.split('-');
          if(d.length==1){
            durationNum.add(1);
          }else{
            durationNum.add(int.parse(d[1])-int.parse(d[0])+1);
          }
        }
      }
    }
    return durationNum;
  }
  // 1-3节 -> durationNum:3
  static int _getDurationNum(String s){
    RegExp expLesson = new RegExp(r"[(](.*?)节[)]");
    int durationNum;
    if(expLesson.hasMatch(s)){
      String durationStr = expLesson.firstMatch(s).group(1);
      var d = durationStr.split('-');
      if(d.length==1){
        durationNum = 1;
      }else{
        durationNum = int.parse(d[1])-int.parse(d[0])+1;
      }
    }
    return durationNum;
  }
//用于周次转换
//"5周"->[5]    "5-12周(单)"->[5, 7, 9, 11]   "13-18周(双)"->[14, 16, 18]   "11-14周"->[11, 12, 13, 14]
  static List<int> _getWeekList(String s) {
    RegExp expWeek = new RegExp(r"[)](.*)");
    String week = expWeek.firstMatch(s).group(1);
    List<int> weekList = [];
    var list = week.split(',');
    for(var week in list){
      if (week.contains("单")) {
        week = week.replaceAll("周(单)", "");
        List temp = week.split('-');
        int i = int.parse(temp[0]).isOdd
            ? int.parse(temp[0])
            : int.parse(temp[0]) + 1;
        int j = int.parse(temp[1]);
        for (; i <= j; i += 2) weekList.add(i);
      } else if (week.contains("双")) {
        week = week.replaceAll("周(双)", "");
        List temp = week.split('-');
        int i = int.parse(temp[0]).isEven
            ? int.parse(temp[0])
            : int.parse(temp[0]) + 1;
        int j = int.parse(temp[1]);
        for (; i <= j; i += 2) weekList.add(i);
      } else {
        week = week.replaceAll("周", "");
        List temp = week.split('-');
        if (temp.length != 1) {
          int i = int.parse(temp[0]);
          int j = int.parse(temp[1]);
          for (; i <= j; i++) weekList.add(i);
        } else {
          weekList.add(int.parse(temp[0]));
        }
      }
    }
    return weekList;
  }
  //校园卡流水
  static Map<String,dynamic> parseBalanceHis(Map<String,dynamic> data){
    var l1 = [];
    for(var a in data['data']){
      l1.add({
        "cardNumber": a['XGH'],
        "Type": a['JYLX'],
        "Location": a['ZDMC'],
        "name": a['SHMC'],
        "costMoney": a['JYE'],
        "balance": a['YE'],
        "time": a['JYSJ']
      });
    }
    return {
      'data':l1
    };
  }
  //考试
  static List<Map<String,dynamic>> parseExam(String html){
    List<Map<String,dynamic>> result = [];
    String courseName;
    String location;
    String dateTime;
    var document = parser.parse(html);
    var table = document.body.querySelector(r'tbody');
    for(int i = 1;i<table.children.length;i++){
      var cur = table.children[i];
      courseName = cur.querySelector('td[aria-describedby="tabGrid_kcmc"]').innerHtml;
      location = cur.querySelector('td[aria-describedby="tabGrid_cdmc"]').innerHtml;
      dateTime = cur.querySelector('td[aria-describedby="tabGrid_kssj"]').innerHtml;
      result.add({
        'courseName':courseName,
        'location':location,
        'dateTime':dateTime
      });
    }
    return result;
  }
  //成绩（包括补考无明细）
  static List<Map<String,dynamic>> parseScoreAll(String html){
    List<Map<String,dynamic>> result = [];

    String courseName;//语文
    String xuefen;//学分
    String jidian;//绩点
    String zongping;//总评
    String type;//正常考试

    var document = parser.parse(html);
    var table = document.body.querySelector("tbody");
    if(table.children==null) return null;
    for(int i = 1;i<table.children.length;i++){
      var cur = table.children[i];
      courseName = cur.querySelector(r'td[aria-describedby="tabGrid_kcmc"]').innerHtml;
      xuefen = cur.querySelector(r'td[aria-describedby="tabGrid_xf"]').innerHtml;
      jidian = cur.querySelector(r'td[aria-describedby="tabGrid_jd"]').innerHtml;
      zongping = cur.querySelector(r'td[aria-describedby="tabGrid_cj"]').innerHtml;
      type = cur.querySelector(r'td[aria-describedby="tabGrid_ksxz"]').innerHtml;

      result.add({
        "courseName": courseName,
        "xuefen": xuefen,
        "jidian": jidian,
        "zongping": zongping,
        "type": type,
      });
    }
    return result;
  }
  //成绩（有明细无补考）
  static Map<String,dynamic> parseScore(Map<String,dynamic> data){
    List bklt = [];
    var kd = {"xmcj":"0"};
    //用flag做标记
    var ps = false; // 平时成绩
    var qm = false; // 期末
    var sy = false; // 实验
    var qz = false; // 期中
    var pscj = {};
    var qzcj = {};
    var sycj = {};
    var qmcj = {};
    var zpcj = {};
    for(var single_data in data['items']){
      Map<String,dynamic> foda = {
        "courseName": single_data['kcmc'],
        "xuefen": single_data['xf'],
        "jidian": "5.0",
        "zongping": '100',
        "scoreDetail": []
      };
      if(single_data['xmblmc'].toString().contains('平时')){
        ps = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        pscj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('期中')){
        qz = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        qzcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('实验')){
        sy = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        sycj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc'].toString().contains('期末')){
        qm = true;
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        qmcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
      }
      if(single_data['xmblmc']=='总评'){
        if(single_data['xmcj']==null){
          kd.addAll(single_data);
        }
        foda['zongping'] = single_data['xmcj'];
        if(isNumeric(foda['zongping'])){
          var zongping = double.parse(foda['zongping']);
          if(zongping>=95&&zongping<=100) foda['jidian'] = '5.0';
          if(zongping>=90&&zongping<=94) foda['jidian'] = '4.5';
          if(zongping>=85&&zongping<=89) foda['jidian'] = '4.0';
          if(zongping>=82&&zongping<=84) foda['jidian'] = '3.5';
          if(zongping>=79&&zongping<=81) foda['jidian'] = '3.0';
          if(zongping>=75&&zongping<=77) foda['jidian'] = '2.8';
          if(zongping>=72&&zongping<=74) foda['jidian'] = '2.5';
          if(zongping>=68&&zongping<=71) foda['jidian'] = '2.5';
          if(zongping>=65&&zongping<=67) foda['jidian'] = '1.5';
          if(zongping>=60&&zongping<=64) foda['jidian'] = '1.0';
          if(zongping>=0&&zongping<60) foda['jidian'] = '0.0';
        }else{
          if (foda['zongping'] == '免修') foda['zongping'] = '100';
          if (foda['zongping'] == '优秀'){
            foda['zongping'] = '90';
            foda['jidian'] = "4.5";
          }
          if (foda['zongping'] == '良好'){
            foda['zongping'] = '85';
            foda['jidian'] = "3.5";
          }
          if (foda['zongping'] == '中等'){
            foda['zongping'] = '75';
            foda['jidian'] = "2.5";
          }
          if (foda['zongping'] == '合格'||foda['zongping'] == '及格'){
            foda['zongping'] = '65';
            foda['jidian'] = "1.0";
          }
          if (foda['zongping'] == '不及格'){
            foda['zongping'] = '0';
            foda['jidian'] = "0.0";
          }
          if (foda['zongping'] == '未评价'){
            foda['zongping'] = '0';
            foda['jidain'] = "0.0";
          }
        }
        zpcj = {'name': single_data['xmblmc'], 'score': single_data['xmcj']};
        if (ps){
          foda['scoreDetail'].add(pscj);
          ps = false;
        }
        if (qz){
          foda['scoreDetail'].add(qzcj);
          qz = false;
        }
        if (sy){
          foda['scoreDetail'].add(sycj);
          sy = false;
        }
        if (qm){
          foda['scoreDetail'].add(qmcj);
          qm = false;
        }
        foda['scoreDetail'].add(zpcj);
        ps = false;
        qz = false;
        sy = false;
        qm = false;
        bklt.add(foda);
      }
    }
    return {
      'data':bklt
    };
  }
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}