
class BalanceHistoryEntity {
  BalanceHistoryEntity({
    this.issucceed,
    this.name,
    this.total,
    this.tranamt,
    this.tranamt1,
    this.tranamt2,
    this.parm1,
    this.parm2,
    this.trannum,
    this.rows,
    this.footer,});

  BalanceHistoryEntity.fromJson(dynamic json) {
    issucceed = json['issucceed'];
    name = json['name'];
    total = json['total'];
    tranamt = json['tranamt'];
    tranamt1 = json['tranamt1'];
    tranamt2 = json['tranamt2'];
    parm1 = json['parm1'];
    parm2 = json['parm2'];
    trannum = json['trannum'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows.add(Rows.fromJson(v));
      });
    }
    footer = json['footer'];
  }
  bool issucceed;
  dynamic name;
  int total;
  int tranamt;
  int tranamt1;
  int tranamt2;
  dynamic parm1;
  dynamic parm2;
  int trannum;
  List<Rows> rows;
  dynamic footer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['issucceed'] = issucceed;
    map['name'] = name;
    map['total'] = total;
    map['tranamt'] = tranamt;
    map['tranamt1'] = tranamt1;
    map['tranamt2'] = tranamt2;
    map['parm1'] = parm1;
    map['parm2'] = parm2;
    map['trannum'] = trannum;
    if (rows != null) {
      map['rows'] = rows.map((v) => v.toJson()).toList();
    }
    map['footer'] = footer;
    return map;
  }

}

class Rows {
  Rows({
    this.ro,
    this.occtime,
    this.effectdate,
    this.mercname,
    this.tranamt,
    this.tranname,
    this.trancode,
    this.cardbal,
    this.jdesc,
    this.jnum,
    this.maccount,
    this.f1,
    this.f2,
    this.f3,
    this.syscode,
    this.poscode,
    this.cmoney,
    this.zmoney,
    this.acctypename,});

  Rows.fromJson(dynamic json) {
    ro = json['RO'];
    occtime = json['OCCTIME'];
    effectdate = json['EFFECTDATE'];
    mercname = json['MERCNAME'];
    tranamt = double.parse(json['TRANAMT'].toString());
    tranname = json['TRANNAME'];
    trancode = json['TRANCODE'];
    cardbal = json['CARDBAL'].runtimeType==double?json['MACCOUNT']:0;
    jdesc = json['JDESC'];
    jnum = json['JNUM'];
    maccount = json['MACCOUNT'].runtimeType==int?json['MACCOUNT']:0;
    f1 = json['F1'];
    f2 = json['F2'];
    f3 = json['F3'];
    syscode = json['SYSCODE'];
    poscode = json['POSCODE'];
    cmoney = json['CMONEY'];
    zmoney = json['ZMONEY'];
    acctypename = json['ACCTYPENAME'];
  }
  int ro;
  String occtime;
  String effectdate;
  String mercname;
  double tranamt;
  String tranname;
  String trancode;
  double cardbal;
  String jdesc;
  int jnum;
  int maccount;
  String f1;
  String f2;
  String f3;
  int syscode;
  int poscode;
  double cmoney;
  double zmoney;
  String acctypename;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RO'] = ro;
    map['OCCTIME'] = occtime;
    map['EFFECTDATE'] = effectdate;
    map['MERCNAME'] = mercname;
    map['TRANAMT'] = tranamt;
    map['TRANNAME'] = tranname;
    map['TRANCODE'] = trancode;
    map['CARDBAL'] = cardbal;
    map['JDESC'] = jdesc;
    map['JNUM'] = jnum;
    map['MACCOUNT'] = maccount;
    map['F1'] = f1;
    map['F2'] = f2;
    map['F3'] = f3;
    map['SYSCODE'] = syscode;
    map['POSCODE'] = poscode;
    map['CMONEY'] = cmoney;
    map['ZMONEY'] = zmoney;
    map['ACCTYPENAME'] = acctypename;
    return map;
  }

}