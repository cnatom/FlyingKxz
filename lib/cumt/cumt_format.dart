import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/import_page.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;


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

  static List<dynamic> _htmlToListBK(String html){
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
                try{
                  title = temp3.querySelector('span[class="title"]').text;
                }catch(e){
                  title = temp3.querySelector('u[class="title showJxbtkjl"]').text;
                }
                try{
                  location = temp3.querySelector('span[title="上课地点"]').parent.text;
                }catch(e){
                  location = '';
                }
                try{
                  teacher = temp3.querySelector('span[title="教师 "]').parent.text;
                }catch(e){
                  try{
                    teacher = temp3.querySelector('span[title="教师"]').parent.text;
                  }
                  catch(e){
                    teacher = '';
                  }
                }
                try{
                  credit = temp3.querySelector('span[title="学分"]').parent.text;
                }catch(e){
                  credit = '';
                }
                String lessonWeek = temp3.querySelector('span[title="节/周"]').parent.text;
                lessonWeek = lessonWeek.replaceAll("？", "");
                duration = _getDuration(lessonWeek);
                lesson = _getLesson(lessonWeek);
                weekList = _getWeekList(lessonWeek);
                weekNum = c;
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
              print(e.toString());
            }
          }
        }
      }
      return result;
    }catch (e){
      print(e.toString());
      return null;
    }
  }
  int countMultipleNewlines(String text) {
    List<String> lines = text.split('\n');
    int count = 0;

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isEmpty) {
        count++;
      }
    }

    return count;
  }
  static List<dynamic> _htmlToListYJS(String html){
    try{
      var result = [];
      String title;//语文
      String location;//博五
      String teacher;//张三
      List<int> weekList = [];//几周有这些课
      int weekNum;//星期几
      int lessonNum;//第几节课
      int durationNum;//持续节次，默认为2小节
      List<int> duration = [];
      List<int> lesson = [];
      Map<String,String> map = new Map<String,String>();
      var document = parser.parse(html);
      var table = document.body.querySelector("table[class='Grid_Line']").querySelector("tbody");
      var tableLineList = table.children.toList();
      tableLineList = tableLineList.where((element) => element.text!='\n').skip(1).toList();

      var lessonWeekMatrix = List<List<int>>.generate(13, (_) => List<int>.generate(8, (_) => 0));

      bool canAdd(int lessonNu, int weekNu) {
        return lessonWeekMatrix[lessonNu][weekNu] == lessonNu || lessonWeekMatrix[lessonNu][weekNu] == 0;
      }

      void fillMatrix(int lessonNumStart, int lessonNumEnd, int weekNu, int num) {
        for (var i = lessonNumStart; i <= lessonNumEnd; i++) {
          lessonWeekMatrix[i][weekNu] = num;
        }
      }

      int calcIncreaseWeek(int lessonNu, int weekNu) {
        int increaseWeekNu = 0;
        for (int i = 1; i <= weekNu; i++) {
          if (lessonWeekMatrix[lessonNu][i] != lessonNu && lessonWeekMatrix[lessonNu][i] != 0) {
            increaseWeekNu += 1;
          }
        }
        return increaseWeekNu;
      }

      lessonNum = 1;
      for (var tableLine in tableLineList){
        if(tableLine.text == '\n'){
          continue;
        }
        var tableCells = tableLine.children.toList();
        tableCells = tableCells.where((element) => element.text!='\n').toList();
        tableCells = tableCells.where((element) => element.attributes['style']==null).toList();
        weekNum = 1;
        for(var cell in tableCells){
          if(cell.text.trim().isNotEmpty){
            var cel = cell.text.split('；');
            for (var ce in cel){
              title = RegExp(r'(.*?)\s*｛').firstMatch(ce).group(1).trim();
              durationNum = int.parse(cell.attributes['rowspan']);
              var ce_temp = RegExp(r'｛(.*?)｝').firstMatch(ce).group(1).trim();
              for(var c in ce_temp.split(']、')){
                c = c+']';
                weekList = _convertWeeksToList(RegExp(r'(.*?)\[').firstMatch(c).group(1).trim());
                try {
                  teacher = RegExp(r'教师:(.*?)(?=,|])').firstMatch(c).group(1).trim();
                } catch (e) {
                  teacher = null;
                }
                try{
                  location = RegExp(r'地点:(.*?)\]').firstMatch(ce).group(1).trim();
                }catch(e){
                  location = null;
                }
                // 判断是否跨行
                int newWeekNum = weekNum;
                newWeekNum += calcIncreaseWeek(lessonNum, weekNum);
                fillMatrix(lessonNum, lessonNum + durationNum - 1, newWeekNum, lessonNum);
                // if (canAdd(lessonNum, weekNum)) {
                //   fillMatrix(lessonNum, lessonNum + durationNum - 1, weekNum, lessonNum);
                // } else {
                //   for (var weekNumTemp = weekNum + 1; weekNumTemp <= 7; weekNumTemp++) {
                //     if (canAdd(lessonNum, weekNumTemp)) {
                //       fillMatrix(lessonNum, lessonNum + durationNum - 1, weekNumTemp, lessonNum);
                //       weekNum = weekNumTemp;
                //       break;
                //     }
                //   }
                // }
                result.add({
                  "title":title,
                  "location":location,
                  "teacher":teacher,
                  "durationNum":durationNum,
                  "weekList":weekList,
                  "weekNum":newWeekNum,
                  "lessonNum":lessonNum,
                });
              }
            }

          }
          weekNum++;
        }
        lessonNum++;
      }
      return result;
    }catch (e){
      print(e.toString());
      return null;
    }
  }
  //课表HTML->List<CourseData>
  static List<dynamic> courseHtmlToList(String html,ImportCourseType type){
    switch(type){
      case ImportCourseType.BK: {
        return _htmlToListBK(html);
      }
      case ImportCourseType.YJS:
        return _htmlToListYJS(html);
    }
    return null;
  }

  // "10-13周"->[10, 11, 12, 13] "2-5、7-10周"->[2, 3, 4, 5, 7, 8, 9, 10] "4-6双周"->[4,6]
  static List<int> _convertWeeksToList(String weeksString) {
    List<int> weeksList = [];
    List<String> weekRanges = weeksString.split('、');
    // 遍历周数区间
    for (String range in weekRanges) {
      // 检查是否存在连续周数的区间
      if (range.contains('-')) {
        // 将区间分割为起始周和结束周
        List<String> rangeParts = range.split('-');
        int startWeek = int.parse(rangeParts[0]);
        int endWeek;
        try{
          endWeek = int.parse(rangeParts[1].replaceAll("周",""));
          // 将连续周数添加到列表中
          for (int i = startWeek; i <= endWeek; i++) {
            weeksList.add(i);
          }
        }catch(e){
          // 检查是否为双周或单周
          bool isEven = true;
          if (rangeParts[1].contains('双')) {
            endWeek = int.parse(rangeParts[1].replaceAll("双周",""));
            isEven = true;
          } else if (rangeParts[1].contains('单')) {
            endWeek = int.parse(rangeParts[1].replaceAll("单周",""));
            isEven = false;
          }
          // 将连续周数添加到列表中
          for (int i = startWeek; i <= endWeek; i++) {
            if (isEven && i % 2 == 0) {
              weeksList.add(i);
            } else if (!isEven && i % 2 == 1) {
              weeksList.add(i);
            }
          }
        }
      } else {
        // 处理单个周数
        int week = int.parse(range.replaceAll('周', ''));
        weeksList.add(week);
      }
    }

    return weeksList;
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
        week = week.replaceAll("(单)", "").replaceAll("周", "");
        List temp = week.split('-');
        int i = int.parse(temp[0]).isOdd
            ? int.parse(temp[0])
            : int.parse(temp[0]) + 1;
        int j = int.parse(temp[1]);
        for (; i <= j; i += 2) weekList.add(i);
      } else if (week.contains("双")) {
        week = week.replaceAll("(双)", "").replaceAll("周", "");
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
  static List<Map<String,dynamic>>? parseScoreAll(String html){
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