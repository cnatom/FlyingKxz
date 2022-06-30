var a = {
  'lst_DataSource': [
    {
      "Course": {
        "FileStoreUrl": "http://121.248.108.57:9091",
        "ThumbnailPath":
            "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg",
        "CourseName": "马克思主义基本原理",
        "UserName": "罗肖泉",
        "CourseDate": "2021-06-03",
        "ShowTerm": "第二学期",
        "SchoolYear": "2020-2021"
      },
      "CourseDateList": [
        {
          "CourseID": "0F2EC78F-A038-4EE9-9069-52FC0C97D025",
          "CourseCode": "7ADD1D61-E403-4FFE-97E5-BA725617B713",
          "Date": "2021-06-03",
          "RoomId": "J2-A201",
          "FileStoreUrl": "http://121.248.108.57:9091",
          "ThumbnailPath":
              "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg"
        }
      ]
    }
  ]
};

class VideoInfo {
  List<Lst_DataSource> _lstDataSource;

  List<Lst_DataSource> get lstDataSource => _lstDataSource;

  VideoInfo({List<Lst_DataSource> lstDataSource}) {
    _lstDataSource = lstDataSource;
  }

  VideoInfo.fromJson(dynamic json) {
    if (json["lst_DataSource"] != null) {
      _lstDataSource = [];
      json["lst_DataSource"].forEach((v) {
        _lstDataSource.add(Lst_DataSource.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_lstDataSource != null) {
      map["lst_DataSource"] = _lstDataSource.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Course : {"FileStoreUrl":"http://121.248.108.57:9091","ThumbnailPath":"/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg","CourseName":"马克思主义基本原理","UserName":"罗肖泉","CourseDate":"2021-06-03","ShowTerm":"第二学期","SchoolYear":"2020-2021"}
/// CourseDateList : [{"CourseID":"0F2EC78F-A038-4EE9-9069-52FC0C97D025","CourseCode":"7ADD1D61-E403-4FFE-97E5-BA725617B713","Date":"2021-06-03","RoomId":"J2-A201","FileStoreUrl":"http://121.248.108.57:9091","ThumbnailPath":"/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg"}]

class Lst_DataSource {
  Course _course;
  List<CourseDateList> _courseDateList;

  Course get course => _course;
  List<CourseDateList> get courseDateList => _courseDateList;

  Lst_DataSource({Course course, List<CourseDateList> courseDateList}) {
    _course = course;
    _courseDateList = courseDateList;
  }

  Lst_DataSource.fromJson(dynamic json) {
    _course = json["Course"] != null ? Course.fromJson(json["Course"]) : null;
    if (json["CourseDateList"] != null) {
      _courseDateList = [];
      json["CourseDateList"].forEach((v) {
        _courseDateList.add(CourseDateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_course != null) {
      map["Course"] = _course.toJson();
    }
    if (_courseDateList != null) {
      map["CourseDateList"] = _courseDateList.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// CourseID : "0F2EC78F-A038-4EE9-9069-52FC0C97D025"
/// CourseCode : "7ADD1D61-E403-4FFE-97E5-BA725617B713"
/// Date : "2021-06-03"
/// RoomId : "J2-A201"
/// FileStoreUrl : "http://121.248.108.57:9091"
/// ThumbnailPath : "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg"

class CourseDateList {
  String _courseID;
  String _courseCode;
  String _date;
  String _roomId;
  String _fileStoreUrl;
  String _thumbnailPath;
  String get courseID => _courseID;
  String get courseCode => _courseCode;
  String get date => _date;
  String get roomId => _roomId;
  String get fileStoreUrl => _fileStoreUrl;
  String get thumbnailPath => _thumbnailPath;

  CourseDateList(
      {String courseID,
      String courseCode,
      String date,
      String roomId,
      String fileStoreUrl,
      String thumbnailPath}) {
    _courseID = courseID;
    _courseCode = courseCode;
    _date = date;
    _roomId = roomId;
    _fileStoreUrl = fileStoreUrl;
    _thumbnailPath = thumbnailPath;
  }

  CourseDateList.fromJson(dynamic json) {
    _courseID = json["CourseID"];
    _courseCode = json["CourseCode"];
    _date = json["Date"];
    _roomId = json["RoomId"];
    _fileStoreUrl = json["FileStoreUrl"];
    _thumbnailPath = json["ThumbnailPath"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CourseID"] = _courseID;
    map["CourseCode"] = _courseCode;
    map["Date"] = _date;
    map["RoomId"] = _roomId;
    map["FileStoreUrl"] = _fileStoreUrl;
    map["ThumbnailPath"] = _thumbnailPath;
    return map;
  }
}

/// FileStoreUrl : "http://121.248.108.57:9091"
/// ThumbnailPath : "/20210603/4ED9BFD1-2539-4D79-827A-F71D527FF68D_J2-A201/406054EC-0038-4632-A042-C9539D181002/406054EC-0038-4632-A042-C9539D181002-1.jpg"
/// CourseName : "马克思主义基本原理"
/// UserName : "罗肖泉"
/// CourseDate : "2021-06-03"
/// ShowTerm : "第二学期"
/// SchoolYear : "2020-2021"

class Course {
  String _fileStoreUrl;
  String _thumbnailPath;
  String _courseName;
  String _userName;
  String _courseDate;
  String _showTerm;
  String _schoolYear;
  String imageUrl;

  String get fileStoreUrl => _fileStoreUrl;
  String get thumbnailPath => _thumbnailPath;
  String get courseName => _courseName;
  String get userName => _userName;
  String get courseDate => _courseDate;
  String get showTerm => _showTerm;
  String get schoolYear => _schoolYear;

  Course(
      {String fileStoreUrl,
      String thumbnailPath,
      String courseName,
      String userName,
      String courseDate,
      String showTerm,
      String schoolYear}) {
    _fileStoreUrl = fileStoreUrl;
    _thumbnailPath = thumbnailPath;
    _courseName = courseName;
    _userName = userName;
    _courseDate = courseDate;
    _showTerm = showTerm;
    _schoolYear = schoolYear;
    imageUrl = _fileStoreUrl + _thumbnailPath;
  }

  Course.fromJson(dynamic json) {
    _fileStoreUrl = json["FileStoreUrl"];
    _thumbnailPath = json["ThumbnailPath"];
    _courseName = json["CourseName"];
    _userName = json["UserName"];
    _courseDate = json["CourseDate"];
    _showTerm = json["ShowTerm"];
    _schoolYear = json["SchoolYear"];
    imageUrl = _fileStoreUrl + _thumbnailPath;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["FileStoreUrl"] = _fileStoreUrl;
    map["ThumbnailPath"] = _thumbnailPath;
    map["CourseName"] = _courseName;
    map["UserName"] = _userName;
    map["CourseDate"] = _courseDate;
    map["ShowTerm"] = _showTerm;
    map["SchoolYear"] = _schoolYear;
    map["imageUrl"] = imageUrl;
    return map;
  }
}
