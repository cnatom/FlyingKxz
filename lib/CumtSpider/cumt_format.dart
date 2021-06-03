/// 数据清洗模块
class CumtFormat{
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
  static Map<String,dynamic> parseExam(Map<String,dynamic> data){
    var exam_list = [];
    for(var single_data in data['items']){
      print('@@');
      print(single_data.toString());
      var item = {
        "local": single_data['cdbh'],
        "time": single_data['kssj'],
        "course": single_data['kcmc'],
        "type": single_data['ksmc'],
        "year": int.parse(single_data['kssj'].substring(0,4)),
        "month": int.parse(single_data['kssj'].substring(5,7)),
        "day": int.parse(single_data['kssj'].substring(8,10))
      };
      exam_list.add(item);
    }
    var result = {
      'data':exam_list
    };
    return result;
  }
  //成绩（包括补考无明细）
  static Map<String,dynamic> parseScoreAll(Map<String,dynamic> data){
    var grades_list = data['items'];
    var l1 = [];
    for(var a in grades_list){
      var d1 = {
        "courseName": a['kcmc'],
        "xuefen": a['xf'],
        "jidian": a['jd'],
        "zongping": a['bfzcj'],
        "type": a['ksxz'],
      };
      l1.add(d1);
    }
    return {
      'data':l1
    };
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
        if(_isNumeric(foda['zongping'])){
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
  static bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}