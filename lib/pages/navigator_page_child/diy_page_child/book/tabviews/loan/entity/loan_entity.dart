/// success : true
/// message : "操作成功"
/// errCode : 200
/// errorCode : null
/// data : {"searchResult":[{"recordId":907878,"loanId":18907165,"title":"Flutter实战指南","author":"李楠编著","publisher":"清华大学出版社","isbn":"978-7-302-55021-1","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02370460","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":1147815,"loanId":18907166,"title":"大数据分析","author":"尚硅谷IT教育编著","publisher":"电子工业出版社","isbn":"978-7-121-39600-7","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02381051","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":907877,"loanId":18907167,"title":"Android程序设计教程","author":"北京尚学堂科技有限公司组编","publisher":"西安电子科技大学出版社","isbn":"978-7-5606-5582-6","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02370772","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":907875,"loanId":18907168,"title":"零基础iOS从入门到精通","author":"零壹快学编著","publisher":"广东人民出版社","isbn":"978-7-218-13761-2","publishYear":"2019","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02375382","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":663475,"loanId":80619,"title":"Unreal Engine 4蓝图完全学习教程","author":"(日) 掌田津耶乃编著","publisher":"中国青年出版社","isbn":"978-7-5153-4550-5","publishYear":"2017","loanDate":"2019-11-01","normReturnDate":"2020-01-01","returnDate":"2020-01-03","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02302017","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":664956,"loanId":79787,"title":"Unreal Engine 4蓝图可视化编程","author":"(美) Brenden Sewell著","publisher":"人民邮电出版社","isbn":"978-7-115-45304-4","publishYear":"2017","loanDate":"2019-11-01","normReturnDate":"2020-01-31","returnDate":"2020-01-03","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02288030","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":579544,"loanId":72495,"title":"数据结构","author":"熊岳山编著","publisher":"清华大学出版社","isbn":"978-7-302-38818-0","publishYear":"2015","loanDate":"2019-11-09","normReturnDate":"2019-12-10","returnDate":"2019-12-15","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02089815","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":509068,"loanId":6603032,"title":"数据结构","author":"闫玉宝 ... [等] 编著","publisher":"清华大学出版社","isbn":"978-7-302-35290-7","publishYear":"2014","loanDate":"2019-10-09","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01915580","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":490658,"loanId":6580926,"title":"SQL注入攻击与防御","author":"(美) Justin Clarke著","publisher":"清华大学出版社","isbn":"978-7-302-34005-8","publishYear":"2013","loanDate":"2019-11-03","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01860597","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":415033,"loanId":6580925,"title":"Linux操作系统","author":"邵国金主编","publisher":"电子工业出版社","isbn":"978-7-121-17161-1","publishYear":"2012","loanDate":"2019-11-03","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01803447","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"}],"numFound":14}

class LoanEntity {
  LoanEntity({
    bool? success,
    String? message,
    int? errCode,
    dynamic errorCode,
    Data? data,}){
    _success = success;
    _message = message;
    _errCode = errCode;
    _errorCode = errorCode;
    _data = data;
  }

  LoanEntity.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _errCode = json['errCode'];
    _errorCode = json['errorCode'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  int? _errCode;
  dynamic _errorCode;
  Data? _data;
  LoanEntity copyWith({  bool? success,
    String? message,
    int? errCode,
    dynamic errorCode,
    Data? data,
  }) => LoanEntity(  success: success ?? _success,
    message: message ?? _message,
    errCode: errCode ?? _errCode,
    errorCode: errorCode ?? _errorCode,
    data: data ?? _data,
  );
  bool? get success => _success;
  String? get message => _message;
  int? get errCode => _errCode;
  dynamic get errorCode => _errorCode;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['errCode'] = _errCode;
    map['errorCode'] = _errorCode;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// searchResult : [{"recordId":907878,"loanId":18907165,"title":"Flutter实战指南","author":"李楠编著","publisher":"清华大学出版社","isbn":"978-7-302-55021-1","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02370460","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":1147815,"loanId":18907166,"title":"大数据分析","author":"尚硅谷IT教育编著","publisher":"电子工业出版社","isbn":"978-7-121-39600-7","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02381051","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":907877,"loanId":18907167,"title":"Android程序设计教程","author":"北京尚学堂科技有限公司组编","publisher":"西安电子科技大学出版社","isbn":"978-7-5606-5582-6","publishYear":"2020","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02370772","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":907875,"loanId":18907168,"title":"零基础iOS从入门到精通","author":"零壹快学编著","publisher":"广东人民出版社","isbn":"978-7-218-13761-2","publishYear":"2019","loanDate":"2021-04-08","normReturnDate":"2021-05-08","returnDate":"2021-05-08","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02375382","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":663475,"loanId":80619,"title":"Unreal Engine 4蓝图完全学习教程","author":"(日) 掌田津耶乃编著","publisher":"中国青年出版社","isbn":"978-7-5153-4550-5","publishYear":"2017","loanDate":"2019-11-01","normReturnDate":"2020-01-01","returnDate":"2020-01-03","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02302017","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":664956,"loanId":79787,"title":"Unreal Engine 4蓝图可视化编程","author":"(美) Brenden Sewell著","publisher":"人民邮电出版社","isbn":"978-7-115-45304-4","publishYear":"2017","loanDate":"2019-11-01","normReturnDate":"2020-01-31","returnDate":"2020-01-03","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02288030","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"},{"recordId":579544,"loanId":72495,"title":"数据结构","author":"熊岳山编著","publisher":"清华大学出版社","isbn":"978-7-302-38818-0","publishYear":"2015","loanDate":"2019-11-09","normReturnDate":"2019-12-10","returnDate":"2019-12-15","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C02089815","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":509068,"loanId":6603032,"title":"数据结构","author":"闫玉宝 ... [等] 编著","publisher":"清华大学出版社","isbn":"978-7-302-35290-7","publishYear":"2014","loanDate":"2019-10-09","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01915580","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":490658,"loanId":6580926,"title":"SQL注入攻击与防御","author":"(美) Justin Clarke著","publisher":"清华大学出版社","isbn":"978-7-302-34005-8","publishYear":"2013","loanDate":"2019-11-03","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01860597","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖借阅大厅"},{"recordId":415033,"loanId":6580925,"title":"Linux操作系统","author":"邵国金主编","publisher":"电子工业出版社","isbn":"978-7-121-17161-1","publishYear":"2012","loanDate":"2019-11-03","normReturnDate":"2019-11-09","returnDate":"2019-11-09","locationName":"南湖自然科学图书阅览室","phyLibName":"中国矿业大学","loanType":null,"docAbstract":null,"barcode":"C01803447","docCode":"1","campusId":null,"campusName":null,"curLibName":"中国矿业大学","curLocationName":"南湖自然科学图书阅览室"}]
/// numFound : 14

class Data {
  Data({
    List<SearchResult>? searchResult,
    int? numFound,}){
    _searchResult = searchResult;
    _numFound = numFound;
  }

  Data.fromJson(dynamic json) {
    if (json['searchResult'] != null) {
      _searchResult = [];
      json['searchResult'].forEach((v) {
        _searchResult?.add(SearchResult.fromJson(v));
      });
    }
    _numFound = json['numFound'];
  }
  List<SearchResult>? _searchResult;
  int? _numFound;
  Data? copyWith({  List<SearchResult>? searchResult,
    int? numFound,
  }) => Data(  searchResult: searchResult ?? _searchResult,
    numFound: numFound ?? _numFound,
  );
  List<SearchResult?>? get searchResult => _searchResult;
  int? get numFound => _numFound;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_searchResult != null) {
      map['searchResult'] = _searchResult?.map((v) => v.toJson()).toList();
    }
    map['numFound'] = _numFound;
    return map;
  }

}

/// recordId : 907878
/// loanId : 18907165
/// title : "Flutter实战指南"
/// author : "李楠编著"
/// publisher : "清华大学出版社"
/// isbn : "978-7-302-55021-1"
/// publishYear : "2020"
/// loanDate : "2021-04-08"
/// normReturnDate : "2021-05-08"
/// returnDate : "2021-05-08"
/// locationName : "南湖自然科学图书阅览室"
/// phyLibName : "中国矿业大学"
/// loanType : null
/// docAbstract : null
/// barcode : "C02370460"
/// docCode : "1"
/// campusId : null
/// campusName : null
/// curLibName : "中国矿业大学"
/// curLocationName : "南湖自然科学图书阅览室"

class SearchResult {
  SearchResult({
    int? recordId,
    int? loanId,
    String? title,
    String? author,
    String? publisher,
    String? isbn,
    String? publishYear,
    String? loanDate,
    String? normReturnDate,
    String? returnDate,
    String? locationName,
    String? phyLibName,
    dynamic loanType,
    dynamic docAbstract,
    String? barcode,
    String? docCode,
    dynamic campusId,
    dynamic campusName,
    String? curLibName,
    String? curLocationName,}){
    _recordId = recordId;
    _loanId = loanId;
    _title = title;
    _author = author;
    _publisher = publisher;
    _isbn = isbn;
    _publishYear = publishYear;
    _loanDate = loanDate;
    _normReturnDate = normReturnDate;
    _returnDate = returnDate;
    _locationName = locationName;
    _phyLibName = phyLibName;
    _loanType = loanType;
    _docAbstract = docAbstract;
    _barcode = barcode;
    _docCode = docCode;
    _campusId = campusId;
    _campusName = campusName;
    _curLibName = curLibName;
    _curLocationName = curLocationName;
  }

  SearchResult.fromJson(dynamic json) {
    _recordId = json['recordId'];
    _loanId = json['loanId'];
    _title = json['title'];
    _author = json['author'];
    _publisher = json['publisher'];
    _isbn = json['isbn'];
    _publishYear = json['publishYear'];
    _loanDate = json['loanDate'];
    _normReturnDate = json['normReturnDate'];
    _returnDate = json['returnDate'];
    _locationName = json['locationName'];
    _phyLibName = json['phyLibName'];
    _loanType = json['loanType'];
    _docAbstract = json['docAbstract'];
    _barcode = json['barcode'];
    _docCode = json['docCode'];
    _campusId = json['campusId'];
    _campusName = json['campusName'];
    _curLibName = json['curLibName'];
    _curLocationName = json['curLocationName'];
  }
  int? _recordId;
  int? _loanId;
  String? _title;
  String? _author;
  String? _publisher;
  String? _isbn;
  String? _publishYear;
  String? _loanDate;
  String? _normReturnDate;
  String? _returnDate;
  String? _locationName;
  String? _phyLibName;
  dynamic _loanType;
  dynamic _docAbstract;
  String? _barcode;
  String? _docCode;
  dynamic _campusId;
  dynamic _campusName;
  String? _curLibName;
  String? _curLocationName;
  SearchResult copyWith({  int? recordId,
    int? loanId,
    String? title,
    String? author,
    String? publisher,
    String? isbn,
    String? publishYear,
    String? loanDate,
    String? normReturnDate,
    String? returnDate,
    String? locationName,
    String? phyLibName,
    dynamic loanType,
    dynamic docAbstract,
    String? barcode,
    String? docCode,
    dynamic campusId,
    dynamic campusName,
    String? curLibName,
    String? curLocationName,
  }) => SearchResult(  recordId: recordId ?? _recordId,
    loanId: loanId ?? _loanId,
    title: title ?? _title,
    author: author ?? _author,
    publisher: publisher ?? _publisher,
    isbn: isbn ?? _isbn,
    publishYear: publishYear ?? _publishYear,
    loanDate: loanDate ?? _loanDate,
    normReturnDate: normReturnDate ?? _normReturnDate,
    returnDate: returnDate ?? _returnDate,
    locationName: locationName ?? _locationName,
    phyLibName: phyLibName ?? _phyLibName,
    loanType: loanType ?? _loanType,
    docAbstract: docAbstract ?? _docAbstract,
    barcode: barcode ?? _barcode,
    docCode: docCode ?? _docCode,
    campusId: campusId ?? _campusId,
    campusName: campusName ?? _campusName,
    curLibName: curLibName ?? _curLibName,
    curLocationName: curLocationName ?? _curLocationName,
  );
  int? get recordId => _recordId;
  int? get loanId => _loanId;
  String? get title => _title;
  String? get author => _author;
  String? get publisher => _publisher;
  String? get isbn => _isbn;
  String? get publishYear => _publishYear;
  String? get loanDate => _loanDate;
  String? get normReturnDate => _normReturnDate;
  String? get returnDate => _returnDate;
  String? get locationName => _locationName;
  String? get phyLibName => _phyLibName;
  dynamic get loanType => _loanType;
  dynamic get docAbstract => _docAbstract;
  String? get barcode => _barcode;
  String? get docCode => _docCode;
  dynamic get campusId => _campusId;
  dynamic get campusName => _campusName;
  String? get curLibName => _curLibName;
  String? get curLocationName => _curLocationName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recordId'] = _recordId;
    map['loanId'] = _loanId;
    map['title'] = _title;
    map['author'] = _author;
    map['publisher'] = _publisher;
    map['isbn'] = _isbn;
    map['publishYear'] = _publishYear;
    map['loanDate'] = _loanDate;
    map['normReturnDate'] = _normReturnDate;
    map['returnDate'] = _returnDate;
    map['locationName'] = _locationName;
    map['phyLibName'] = _phyLibName;
    map['loanType'] = _loanType;
    map['docAbstract'] = _docAbstract;
    map['barcode'] = _barcode;
    map['docCode'] = _docCode;
    map['campusId'] = _campusId;
    map['campusName'] = _campusName;
    map['curLibName'] = _curLibName;
    map['curLocationName'] = _curLocationName;
    return map;
  }

}