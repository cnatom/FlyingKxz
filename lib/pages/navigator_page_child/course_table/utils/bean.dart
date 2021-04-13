/// kbList : [{"cd_id":"sgw0000538","cdmc":"博4-C206","cxbj":"1","date":"二○二一年四月十三日","dateDigit":"2021年4月13日","dateDigitSeparator":"2021-4-13","day":"13","jc":"1-2节","jcor":"1-2","jcs":"1-2","jgh_id":"050059","jgpxzd":"1","jxb_id":"A63764864E7601EAE053C0A86D5D77B4","jxbmc":"微机原理与应用B-0004","jxbsftkbj":"0","kch_id":"M04213","kclb":"A","kcmc":"微机原理与应用B","kcxszc":"讲课:40","kcxz":"必修","khfsmc":"考试","kkzt":"1","listnav":"false","localeKey":"zh_CN","month":"4","oldjc":"3","oldzc":"494","pageable":true,"pkbj":"1","queryModel":{"currentPage":1,"currentResult":0,"entityOrField":false,"limit":15,"offset":0,"pageNo":0,"pageSize":15,"showCount":10,"totalCount":0,"totalPage":0,"totalResult":0},"rangeable":true,"rk":"4","rsdzjs":0,"skfsmc":"面授讲课","sxbj":"1","totalResult":"0","userModel":{"monitor":false,"roleCount":0,"roleKeys":"","roleValues":"","status":0,"usable":false},"xf":"2.5","xkbz":"无","xm":"陈兴新","xnm":"2020","xqdm":"0","xqh1":"2,","xqh_id":"2","xqj":"1","xqjmc":"星期一","xqm":"3","xqmc":"南湖校区","xsdm":"01","xslxbj":"★","year":"2021","zcd":"2-4周,6-9周","zcmc":"讲师","zhxs":"6","zxs":"40","zyfxmc":"无方向","zzrl":"71"},null]
/// zckbsfxssj : "1"
/// sfxsd : "1"
/// xnxqsfkz : "false"

class CourseBean {
  List<KbList> kbList;
  String zckbsfxssj;
  String sfxsd;
  String xnxqsfkz;

  CourseBean({
    this.kbList,
    this.zckbsfxssj,
    this.sfxsd,
    this.xnxqsfkz});

  CourseBean.fromJson(dynamic json) {
    if (json["kbList"] != null) {
      kbList = [];
      json["kbList"].forEach((v) {
        kbList.add(KbList.fromJson(v));
      });
    }
    zckbsfxssj = json["zckbsfxssj"];
    sfxsd = json["sfxsd"];
    xnxqsfkz = json["xnxqsfkz"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (kbList != null) {
      map["kbList"] = kbList.map((v) => v.toJson()).toList();
    }
    map["zckbsfxssj"] = zckbsfxssj;
    map["sfxsd"] = sfxsd;
    map["xnxqsfkz"] = xnxqsfkz;
    return map;
  }

}

/// cd_id : "sgw0000538"
/// cdmc : "博4-C206"
/// cxbj : "1"
/// date : "二○二一年四月十三日"
/// dateDigit : "2021年4月13日"
/// dateDigitSeparator : "2021-4-13"
/// day : "13"
/// jc : "1-2节"
/// jcor : "1-2"
/// jcs : "1-2"
/// jgh_id : "050059"
/// jgpxzd : "1"
/// jxb_id : "A63764864E7601EAE053C0A86D5D77B4"
/// jxbmc : "微机原理与应用B-0004"
/// jxbsftkbj : "0"
/// kch_id : "M04213"
/// kclb : "A"
/// kcmc : "微机原理与应用B"
/// kcxszc : "讲课:40"
/// kcxz : "必修"
/// khfsmc : "考试"
/// kkzt : "1"
/// listnav : "false"
/// localeKey : "zh_CN"
/// month : "4"
/// oldjc : "3"
/// oldzc : "494"
/// pageable : true
/// pkbj : "1"
/// queryModel : {"currentPage":1,"currentResult":0,"entityOrField":false,"limit":15,"offset":0,"pageNo":0,"pageSize":15,"showCount":10,"totalCount":0,"totalPage":0,"totalResult":0}
/// rangeable : true
/// rk : "4"
/// rsdzjs : 0
/// skfsmc : "面授讲课"
/// sxbj : "1"
/// totalResult : "0"
/// userModel : {"monitor":false,"roleCount":0,"roleKeys":"","roleValues":"","status":0,"usable":false}
/// xf : "2.5"
/// xkbz : "无"
/// xm : "陈兴新"
/// xnm : "2020"
/// xqdm : "0"
/// xqh1 : "2,"
/// xqh_id : "2"
/// xqj : "1"
/// xqjmc : "星期一"
/// xqm : "3"
/// xqmc : "南湖校区"
/// xsdm : "01"
/// xslxbj : "★"
/// year : "2021"
/// zcd : "2-4周,6-9周"
/// zcmc : "讲师"
/// zhxs : "6"
/// zxs : "40"
/// zyfxmc : "无方向"
/// zzrl : "71"

class KbList {
  String cdId;
  String cdmc;
  String cxbj;
  String date;
  String dateDigit;
  String dateDigitSeparator;
  String day;
  String jc;
  String jcor;
  String jcs;
  String jghId;
  String jgpxzd;
  String jxbId;
  String jxbmc;
  String jxbsftkbj;
  String kchId;
  String kclb;
  String kcmc;
  String kcxszc;
  String kcxz;
  String khfsmc;
  String kkzt;
  String listnav;
  String localeKey;
  String month;
  String oldjc;
  String oldzc;
  bool pageable;
  String pkbj;
  QueryModel queryModel;
  bool rangeable;
  String rk;
  int rsdzjs;
  String skfsmc;
  String sxbj;
  String totalResult;
  UserModel userModel;
  String xf;
  String xkbz;
  String xm;
  String xnm;
  String xqdm;
  String xqh1;
  String xqhId;
  String xqj;
  String xqjmc;
  String xqm;
  String xqmc;
  String xsdm;
  String xslxbj;
  String year;
  String zcd;
  String zcmc;
  String zhxs;
  String zxs;
  String zyfxmc;
  String zzrl;

  KbList({
    this.cdId,
    this.cdmc,
    this.cxbj,
    this.date,
    this.dateDigit,
    this.dateDigitSeparator,
    this.day,
    this.jc,
    this.jcor,
    this.jcs,
    this.jghId,
    this.jgpxzd,
    this.jxbId,
    this.jxbmc,
    this.jxbsftkbj,
    this.kchId,
    this.kclb,
    this.kcmc,
    this.kcxszc,
    this.kcxz,
    this.khfsmc,
    this.kkzt,
    this.listnav,
    this.localeKey,
    this.month,
    this.oldjc,
    this.oldzc,
    this.pageable,
    this.pkbj,
    this.queryModel,
    this.rangeable,
    this.rk,
    this.rsdzjs,
    this.skfsmc,
    this.sxbj,
    this.totalResult,
    this.userModel,
    this.xf,
    this.xkbz,
    this.xm,
    this.xnm,
    this.xqdm,
    this.xqh1,
    this.xqhId,
    this.xqj,
    this.xqjmc,
    this.xqm,
    this.xqmc,
    this.xsdm,
    this.xslxbj,
    this.year,
    this.zcd,
    this.zcmc,
    this.zhxs,
    this.zxs,
    this.zyfxmc,
    this.zzrl});

  KbList.fromJson(dynamic json) {
    cdId = json["cd_id"];
    cdmc = json["cdmc"];
    cxbj = json["cxbj"];
    date = json["date"];
    dateDigit = json["dateDigit"];
    dateDigitSeparator = json["dateDigitSeparator"];
    day = json["day"];
    jc = json["jc"];
    jcor = json["jcor"];
    jcs = json["jcs"];
    jghId = json["jgh_id"];
    jgpxzd = json["jgpxzd"];
    jxbId = json["jxb_id"];
    jxbmc = json["jxbmc"];
    jxbsftkbj = json["jxbsftkbj"];
    kchId = json["kch_id"];
    kclb = json["kclb"];
    kcmc = json["kcmc"];
    kcxszc = json["kcxszc"];
    kcxz = json["kcxz"];
    khfsmc = json["khfsmc"];
    kkzt = json["kkzt"];
    listnav = json["listnav"];
    localeKey = json["localeKey"];
    month = json["month"];
    oldjc = json["oldjc"];
    oldzc = json["oldzc"];
    pageable = json["pageable"];
    pkbj = json["pkbj"];
    queryModel = json["queryModel"] != null ? QueryModel.fromJson(json["queryModel"]) : null;
    rangeable = json["rangeable"];
    rk = json["rk"];
    rsdzjs = json["rsdzjs"];
    skfsmc = json["skfsmc"];
    sxbj = json["sxbj"];
    totalResult = json["totalResult"];
    userModel = json["userModel"] != null ? UserModel.fromJson(json["userModel"]) : null;
    xf = json["xf"];
    xkbz = json["xkbz"];
    xm = json["xm"];
    xnm = json["xnm"];
    xqdm = json["xqdm"];
    xqh1 = json["xqh1"];
    xqhId = json["xqh_id"];
    xqj = json["xqj"];
    xqjmc = json["xqjmc"];
    xqm = json["xqm"];
    xqmc = json["xqmc"];
    xsdm = json["xsdm"];
    xslxbj = json["xslxbj"];
    year = json["year"];
    zcd = json["zcd"];
    zcmc = json["zcmc"];
    zhxs = json["zhxs"];
    zxs = json["zxs"];
    zyfxmc = json["zyfxmc"];
    zzrl = json["zzrl"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cd_id"] = cdId;
    map["cdmc"] = cdmc;
    map["cxbj"] = cxbj;
    map["date"] = date;
    map["dateDigit"] = dateDigit;
    map["dateDigitSeparator"] = dateDigitSeparator;
    map["day"] = day;
    map["jc"] = jc;
    map["jcor"] = jcor;
    map["jcs"] = jcs;
    map["jgh_id"] = jghId;
    map["jgpxzd"] = jgpxzd;
    map["jxb_id"] = jxbId;
    map["jxbmc"] = jxbmc;
    map["jxbsftkbj"] = jxbsftkbj;
    map["kch_id"] = kchId;
    map["kclb"] = kclb;
    map["kcmc"] = kcmc;
    map["kcxszc"] = kcxszc;
    map["kcxz"] = kcxz;
    map["khfsmc"] = khfsmc;
    map["kkzt"] = kkzt;
    map["listnav"] = listnav;
    map["localeKey"] = localeKey;
    map["month"] = month;
    map["oldjc"] = oldjc;
    map["oldzc"] = oldzc;
    map["pageable"] = pageable;
    map["pkbj"] = pkbj;
    if (queryModel != null) {
      map["queryModel"] = queryModel.toJson();
    }
    map["rangeable"] = rangeable;
    map["rk"] = rk;
    map["rsdzjs"] = rsdzjs;
    map["skfsmc"] = skfsmc;
    map["sxbj"] = sxbj;
    map["totalResult"] = totalResult;
    if (userModel != null) {
      map["userModel"] = userModel.toJson();
    }
    map["xf"] = xf;
    map["xkbz"] = xkbz;
    map["xm"] = xm;
    map["xnm"] = xnm;
    map["xqdm"] = xqdm;
    map["xqh1"] = xqh1;
    map["xqh_id"] = xqhId;
    map["xqj"] = xqj;
    map["xqjmc"] = xqjmc;
    map["xqm"] = xqm;
    map["xqmc"] = xqmc;
    map["xsdm"] = xsdm;
    map["xslxbj"] = xslxbj;
    map["year"] = year;
    map["zcd"] = zcd;
    map["zcmc"] = zcmc;
    map["zhxs"] = zhxs;
    map["zxs"] = zxs;
    map["zyfxmc"] = zyfxmc;
    map["zzrl"] = zzrl;
    return map;
  }

}

/// monitor : false
/// roleCount : 0
/// roleKeys : ""
/// roleValues : ""
/// status : 0
/// usable : false

class UserModel {
  bool monitor;
  int roleCount;
  String roleKeys;
  String roleValues;
  int status;
  bool usable;

  UserModel({
    this.monitor,
    this.roleCount,
    this.roleKeys,
    this.roleValues,
    this.status,
    this.usable});

  UserModel.fromJson(dynamic json) {
    monitor = json["monitor"];
    roleCount = json["roleCount"];
    roleKeys = json["roleKeys"];
    roleValues = json["roleValues"];
    status = json["status"];
    usable = json["usable"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["monitor"] = monitor;
    map["roleCount"] = roleCount;
    map["roleKeys"] = roleKeys;
    map["roleValues"] = roleValues;
    map["status"] = status;
    map["usable"] = usable;
    return map;
  }

}

/// currentPage : 1
/// currentResult : 0
/// entityOrField : false
/// limit : 15
/// offset : 0
/// pageNo : 0
/// pageSize : 15
/// showCount : 10
/// totalCount : 0
/// totalPage : 0
/// totalResult : 0

class QueryModel {
  int currentPage;
  int currentResult;
  bool entityOrField;
  int limit;
  int offset;
  int pageNo;
  int pageSize;
  int showCount;
  int totalCount;
  int totalPage;
  int totalResult;

  QueryModel({
    this.currentPage,
    this.currentResult,
    this.entityOrField,
    this.limit,
    this.offset,
    this.pageNo,
    this.pageSize,
    this.showCount,
    this.totalCount,
    this.totalPage,
    this.totalResult});

  QueryModel.fromJson(dynamic json) {
    currentPage = json["currentPage"];
    currentResult = json["currentResult"];
    entityOrField = json["entityOrField"];
    limit = json["limit"];
    offset = json["offset"];
    pageNo = json["pageNo"];
    pageSize = json["pageSize"];
    showCount = json["showCount"];
    totalCount = json["totalCount"];
    totalPage = json["totalPage"];
    totalResult = json["totalResult"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["currentPage"] = currentPage;
    map["currentResult"] = currentResult;
    map["entityOrField"] = entityOrField;
    map["limit"] = limit;
    map["offset"] = offset;
    map["pageNo"] = pageNo;
    map["pageSize"] = pageSize;
    map["showCount"] = showCount;
    map["totalCount"] = totalCount;
    map["totalPage"] = totalPage;
    map["totalResult"] = totalResult;
    return map;
  }

}