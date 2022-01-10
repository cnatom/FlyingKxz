/// kbList : [{"cdmc":"博3-B102","date":"二○二一年五月二十三日","dateDigit":"2021年5月23日","dateDigitSeparator":"2021-5-23","day":"23","jc":"1-2节","jcor":"1-2","jcs":"1-2","jgh_id":"080101","jgpxzd":"1","jxb_id":"B58B450385DC0292E053C0A86D5D6A08","jxbmc":"数据库原理-0003","jxbsftkbj":"0","kch":"M08103","kch_id":"M08103","kclb":"A","kcmc":"数据库原理","kcxszc":"讲课:48,实验:0","kcxz":"学科","khfsmc":"考试","kkzt":"1","listnav":"false","localeKey":"zh_CN","month":"5","oldjc":"3","oldzc":"479","pageable":true,"pkbj":"1","rangeable":true,"rk":"5","rsdzjs":0,"skfsmc":"面授讲课","sxbj":"1","xf":"3","xkbz":"无","xm":"闫秋艳","xnm":"2020","xqdm":"0","xqh1":"2,","xqh_id":"2","xqj":"1","xqjmc":"星期一","xqm":"12","xqmc":"南湖校区","xsdm":"01","xslxbj":"★","year":"2021","zcd":"1-5周,7-9周","zcmc":"副教授","zhxs":"6","zxs":"48","zyfxmc":"无方向","zzrl":"65"}]

class CourseBean {
  List<KbList> _kbList;

  List<KbList> get kbList => _kbList;

  CourseBean({
      List<KbList> kbList}){
    _kbList = kbList;
}

  CourseBean.fromJson(dynamic json) {
    if (json["kbList"] != null) {
      _kbList = [];
      json["kbList"].forEach((v) {
        _kbList.add(KbList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_kbList != null) {
      map["kbList"] = _kbList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// cdmc : "博3-B102"
/// date : "二○二一年五月二十三日"
/// dateDigit : "2021年5月23日"
/// dateDigitSeparator : "2021-5-23"
/// day : "23"
/// jc : "1-2节"
/// jcor : "1-2"
/// jcs : "1-2"
/// jgh_id : "080101"
/// jgpxzd : "1"
/// jxb_id : "B58B450385DC0292E053C0A86D5D6A08"
/// jxbmc : "数据库原理-0003"
/// jxbsftkbj : "0"
/// kch : "M08103"
/// kch_id : "M08103"
/// kclb : "A"
/// kcmc : "数据库原理"
/// kcxszc : "讲课:48,实验:0"
/// kcxz : "学科"
/// khfsmc : "考试"
/// kkzt : "1"
/// listnav : "false"
/// localeKey : "zh_CN"
/// month : "5"
/// oldjc : "3"
/// oldzc : "479"
/// pageable : true
/// pkbj : "1"
/// rangeable : true
/// rk : "5"
/// rsdzjs : 0
/// skfsmc : "面授讲课"
/// sxbj : "1"
/// xf : "3"
/// xkbz : "无"
/// xm : "闫秋艳"
/// xnm : "2020"
/// xqdm : "0"
/// xqh1 : "2,"
/// xqh_id : "2"
/// xqj : "1"
/// xqjmc : "星期一"
/// xqm : "12"
/// xqmc : "南湖校区"
/// xsdm : "01"
/// xslxbj : "★"
/// year : "2021"
/// zcd : "1-5周,7-9周"
/// zcmc : "副教授"
/// zhxs : "6"
/// zxs : "48"
/// zyfxmc : "无方向"
/// zzrl : "65"

class KbList {
  String _cdmc;
  String _date;
  String _dateDigit;
  String _dateDigitSeparator;
  String _day;
  String _jc;
  String _jcor;
  String _jcs;
  String _jghId;
  String _jgpxzd;
  String _jxbId;
  String _jxbmc;
  String _jxbsftkbj;
  String _kch;
  String _kchId;
  String _kclb;
  String _kcmc;
  String _kcxszc;
  String _kcxz;
  String _khfsmc;
  String _kkzt;
  String _listnav;
  String _localeKey;
  String _month;
  String _oldjc;
  String _oldzc;
  bool _pageable;
  String _pkbj;
  bool _rangeable;
  String _rk;
  int _rsdzjs;
  String _skfsmc;
  String _sxbj;
  String _xf;
  String _xkbz;
  String _xm;
  String _xnm;
  String _xqdm;
  String _xqh1;
  String _xqhId;
  String _xqj;
  String _xqjmc;
  String _xqm;
  String _xqmc;
  String _xsdm;
  String _xslxbj;
  String _year;
  String _zcd;
  String _zcmc;
  String _zhxs;
  String _zxs;
  String _zyfxmc;
  String _zzrl;

  String get cdmc => _cdmc;
  String get date => _date;
  String get dateDigit => _dateDigit;
  String get dateDigitSeparator => _dateDigitSeparator;
  String get day => _day;
  String get jc => _jc;
  String get jcor => _jcor;
  String get jcs => _jcs;
  String get jghId => _jghId;
  String get jgpxzd => _jgpxzd;
  String get jxbId => _jxbId;
  String get jxbmc => _jxbmc;
  String get jxbsftkbj => _jxbsftkbj;
  String get kch => _kch;
  String get kchId => _kchId;
  String get kclb => _kclb;
  String get kcmc => _kcmc;
  String get kcxszc => _kcxszc;
  String get kcxz => _kcxz;
  String get khfsmc => _khfsmc;
  String get kkzt => _kkzt;
  String get listnav => _listnav;
  String get localeKey => _localeKey;
  String get month => _month;
  String get oldjc => _oldjc;
  String get oldzc => _oldzc;
  bool get pageable => _pageable;
  String get pkbj => _pkbj;
  bool get rangeable => _rangeable;
  String get rk => _rk;
  int get rsdzjs => _rsdzjs;
  String get skfsmc => _skfsmc;
  String get sxbj => _sxbj;
  String get xf => _xf;
  String get xkbz => _xkbz;
  String get xm => _xm;
  String get xnm => _xnm;
  String get xqdm => _xqdm;
  String get xqh1 => _xqh1;
  String get xqhId => _xqhId;
  String get xqj => _xqj;
  String get xqjmc => _xqjmc;
  String get xqm => _xqm;
  String get xqmc => _xqmc;
  String get xsdm => _xsdm;
  String get xslxbj => _xslxbj;
  String get year => _year;
  String get zcd => _zcd;
  String get zcmc => _zcmc;
  String get zhxs => _zhxs;
  String get zxs => _zxs;
  String get zyfxmc => _zyfxmc;
  String get zzrl => _zzrl;

  KbList({
      String cdmc, 
      String date, 
      String dateDigit, 
      String dateDigitSeparator, 
      String day, 
      String jc, 
      String jcor, 
      String jcs, 
      String jghId, 
      String jgpxzd, 
      String jxbId, 
      String jxbmc, 
      String jxbsftkbj, 
      String kch, 
      String kchId, 
      String kclb, 
      String kcmc, 
      String kcxszc, 
      String kcxz, 
      String khfsmc, 
      String kkzt, 
      String listnav, 
      String localeKey, 
      String month, 
      String oldjc, 
      String oldzc, 
      bool pageable, 
      String pkbj, 
      bool rangeable, 
      String rk, 
      int rsdzjs, 
      String skfsmc, 
      String sxbj, 
      String xf, 
      String xkbz, 
      String xm, 
      String xnm, 
      String xqdm, 
      String xqh1, 
      String xqhId, 
      String xqj, 
      String xqjmc, 
      String xqm, 
      String xqmc, 
      String xsdm, 
      String xslxbj, 
      String year, 
      String zcd, 
      String zcmc, 
      String zhxs, 
      String zxs, 
      String zyfxmc, 
      String zzrl}){
    _cdmc = cdmc;
    _date = date;
    _dateDigit = dateDigit;
    _dateDigitSeparator = dateDigitSeparator;
    _day = day;
    _jc = jc;
    _jcor = jcor;
    _jcs = jcs;
    _jghId = jghId;
    _jgpxzd = jgpxzd;
    _jxbId = jxbId;
    _jxbmc = jxbmc;
    _jxbsftkbj = jxbsftkbj;
    _kch = kch;
    _kchId = kchId;
    _kclb = kclb;
    _kcmc = kcmc;
    _kcxszc = kcxszc;
    _kcxz = kcxz;
    _khfsmc = khfsmc;
    _kkzt = kkzt;
    _listnav = listnav;
    _localeKey = localeKey;
    _month = month;
    _oldjc = oldjc;
    _oldzc = oldzc;
    _pageable = pageable;
    _pkbj = pkbj;
    _rangeable = rangeable;
    _rk = rk;
    _rsdzjs = rsdzjs;
    _skfsmc = skfsmc;
    _sxbj = sxbj;
    _xf = xf;
    _xkbz = xkbz;
    _xm = xm;
    _xnm = xnm;
    _xqdm = xqdm;
    _xqh1 = xqh1;
    _xqhId = xqhId;
    _xqj = xqj;
    _xqjmc = xqjmc;
    _xqm = xqm;
    _xqmc = xqmc;
    _xsdm = xsdm;
    _xslxbj = xslxbj;
    _year = year;
    _zcd = zcd;
    _zcmc = zcmc;
    _zhxs = zhxs;
    _zxs = zxs;
    _zyfxmc = zyfxmc;
    _zzrl = zzrl;
}

  KbList.fromJson(dynamic json) {
    _cdmc = json["cdmc"];
    _date = json["date"];
    _dateDigit = json["dateDigit"];
    _dateDigitSeparator = json["dateDigitSeparator"];
    _day = json["day"];
    _jc = json["jc"];
    _jcor = json["jcor"];
    _jcs = json["jcs"];
    _jghId = json["jgh_id"];
    _jgpxzd = json["jgpxzd"];
    _jxbId = json["jxb_id"];
    _jxbmc = json["jxbmc"];
    _jxbsftkbj = json["jxbsftkbj"];
    _kch = json["kch"];
    _kchId = json["kch_id"];
    _kclb = json["kclb"];
    _kcmc = json["kcmc"];
    _kcxszc = json["kcxszc"];
    _kcxz = json["kcxz"];
    _khfsmc = json["khfsmc"];
    _kkzt = json["kkzt"];
    _listnav = json["listnav"];
    _localeKey = json["localeKey"];
    _month = json["month"];
    _oldjc = json["oldjc"];
    _oldzc = json["oldzc"];
    _pageable = json["pageable"];
    _pkbj = json["pkbj"];
    _rangeable = json["rangeable"];
    _rk = json["rk"];
    _rsdzjs = json["rsdzjs"];
    _skfsmc = json["skfsmc"];
    _sxbj = json["sxbj"];
    _xf = json["xf"];
    _xkbz = json["xkbz"];
    _xm = json["xm"];
    _xnm = json["xnm"];
    _xqdm = json["xqdm"];
    _xqh1 = json["xqh1"];
    _xqhId = json["xqh_id"];
    _xqj = json["xqj"];
    _xqjmc = json["xqjmc"];
    _xqm = json["xqm"];
    _xqmc = json["xqmc"];
    _xsdm = json["xsdm"];
    _xslxbj = json["xslxbj"];
    _year = json["year"];
    _zcd = json["zcd"];
    _zcmc = json["zcmc"];
    _zhxs = json["zhxs"];
    _zxs = json["zxs"];
    _zyfxmc = json["zyfxmc"];
    _zzrl = json["zzrl"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cdmc"] = _cdmc;
    map["date"] = _date;
    map["dateDigit"] = _dateDigit;
    map["dateDigitSeparator"] = _dateDigitSeparator;
    map["day"] = _day;
    map["jc"] = _jc;
    map["jcor"] = _jcor;
    map["jcs"] = _jcs;
    map["jgh_id"] = _jghId;
    map["jgpxzd"] = _jgpxzd;
    map["jxb_id"] = _jxbId;
    map["jxbmc"] = _jxbmc;
    map["jxbsftkbj"] = _jxbsftkbj;
    map["kch"] = _kch;
    map["kch_id"] = _kchId;
    map["kclb"] = _kclb;
    map["kcmc"] = _kcmc;
    map["kcxszc"] = _kcxszc;
    map["kcxz"] = _kcxz;
    map["khfsmc"] = _khfsmc;
    map["kkzt"] = _kkzt;
    map["listnav"] = _listnav;
    map["localeKey"] = _localeKey;
    map["month"] = _month;
    map["oldjc"] = _oldjc;
    map["oldzc"] = _oldzc;
    map["pageable"] = _pageable;
    map["pkbj"] = _pkbj;
    map["rangeable"] = _rangeable;
    map["rk"] = _rk;
    map["rsdzjs"] = _rsdzjs;
    map["skfsmc"] = _skfsmc;
    map["sxbj"] = _sxbj;
    map["xf"] = _xf;
    map["xkbz"] = _xkbz;
    map["xm"] = _xm;
    map["xnm"] = _xnm;
    map["xqdm"] = _xqdm;
    map["xqh1"] = _xqh1;
    map["xqh_id"] = _xqhId;
    map["xqj"] = _xqj;
    map["xqjmc"] = _xqjmc;
    map["xqm"] = _xqm;
    map["xqmc"] = _xqmc;
    map["xsdm"] = _xsdm;
    map["xslxbj"] = _xslxbj;
    map["year"] = _year;
    map["zcd"] = _zcd;
    map["zcmc"] = _zcmc;
    map["zhxs"] = _zhxs;
    map["zxs"] = _zxs;
    map["zyfxmc"] = _zyfxmc;
    map["zzrl"] = _zzrl;
    return map;
  }

}