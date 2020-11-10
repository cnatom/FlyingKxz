/// status : 200
/// msg : "抓取成功"
/// data : {"all":1601,"bookList":[{"bookId":413400,"name":"三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-229-03093-3","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/3","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-229-03093-3&title=三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=413400","status":true},{"bookId":373428,"name":"三体.Ⅹ,观想之宙.中国科幻基石丛书","author":"宝树著","publisher":"重庆出版社","isbn":"978-7-229-03981-3","pcount":3,"ecount":1,"searchCode":"I247.5/B-764/5","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-229-03981-3&title=三体.Ⅹ,观想之宙.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=373428","status":true},{"bookId":619579,"name":"三体.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-5366-9293-0","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/1","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5366-9293-0&title=三体.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=619579","status":true},{"bookId":619578,"name":"三体.II,黑暗森林.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-5366-9396-8","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/2","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5366-9396-8&title=三体.II,黑暗森林.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=619578","status":false},{"bookId":138688,"name":"三体问题","author":"汪家訸编著","publisher":"科学出版社","isbn":"","pcount":4,"ecount":0,"searchCode":"O933.3/W419","image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体问题","statusNow":"https://api.kxz.atcumt.com/lib/status?id=138688","status":true},{"bookId":1009960,"name":"三体摭韵 1","author":"（清）朱昆田撰","publisher":"台湾商务印书馆","isbn":"","pcount":0,"ecount":1,"searchCode":null,"image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体摭韵 1","statusNow":"https://api.kxz.atcumt.com/lib/status?id=1009960","status":false},{"bookId":968675,"name":"三体摭韵  4","author":"（清）朱昆田撰","publisher":"台湾商务印书馆","isbn":"","pcount":0,"ecount":1,"searchCode":null,"image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体摭韵  4","statusNow":"https://api.kxz.atcumt.com/lib/status?id=968675","status":false},{"bookId":491065,"name":"三维应力环境下节理岩体真三轴试验研究","author":"刘海宁著","publisher":"中国水利水电出版社","isbn":"978-7-5170-0744-9","pcount":3,"ecount":1,"searchCode":"P583/L-385","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5170-0744-9&title=三维应力环境下节理岩体真三轴试验研究","statusNow":"https://api.kxz.atcumt.com/lib/status?id=491065","status":true},{"bookId":581606,"name":"《三体》中的物理学","author":"李淼著","publisher":"四川科学技术出版社","isbn":"978-7-5364-8068-1","pcount":4,"ecount":1,"searchCode":"O4-49/L-519","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5364-8068-1&title=《三体》中的物理学","statusNow":"https://api.kxz.atcumt.com/lib/status?id=581606","status":true},{"bookId":734411,"name":"《三体》中的物理学","author":"李淼著","publisher":"湖南科学技术出版社","isbn":"978-7-5710-0148-3","pcount":1,"ecount":0,"searchCode":"O4-49/L-519.2","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5710-0148-3&title=《三体》中的物理学","statusNow":"https://api.kxz.atcumt.com/lib/status?id=734411","status":false}]}

class BookInfo {
  int status;
  String msg;
  Data data;

  BookInfo({
      this.status, 
      this.msg, 
      this.data});

  BookInfo.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }

}

/// all : 1601
/// bookList : [{"bookId":413400,"name":"三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-229-03093-3","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/3","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-229-03093-3&title=三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=413400","status":true},{"bookId":373428,"name":"三体.Ⅹ,观想之宙.中国科幻基石丛书","author":"宝树著","publisher":"重庆出版社","isbn":"978-7-229-03981-3","pcount":3,"ecount":1,"searchCode":"I247.5/B-764/5","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-229-03981-3&title=三体.Ⅹ,观想之宙.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=373428","status":true},{"bookId":619579,"name":"三体.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-5366-9293-0","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/1","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5366-9293-0&title=三体.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=619579","status":true},{"bookId":619578,"name":"三体.II,黑暗森林.中国科幻基石丛书","author":"刘慈欣著","publisher":"重庆出版社","isbn":"978-7-5366-9396-8","pcount":3,"ecount":1,"searchCode":"I247.55/L-236.2/2","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5366-9396-8&title=三体.II,黑暗森林.中国科幻基石丛书","statusNow":"https://api.kxz.atcumt.com/lib/status?id=619578","status":false},{"bookId":138688,"name":"三体问题","author":"汪家訸编著","publisher":"科学出版社","isbn":"","pcount":4,"ecount":0,"searchCode":"O933.3/W419","image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体问题","statusNow":"https://api.kxz.atcumt.com/lib/status?id=138688","status":true},{"bookId":1009960,"name":"三体摭韵 1","author":"（清）朱昆田撰","publisher":"台湾商务印书馆","isbn":"","pcount":0,"ecount":1,"searchCode":null,"image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体摭韵 1","statusNow":"https://api.kxz.atcumt.com/lib/status?id=1009960","status":false},{"bookId":968675,"name":"三体摭韵  4","author":"（清）朱昆田撰","publisher":"台湾商务印书馆","isbn":"","pcount":0,"ecount":1,"searchCode":null,"image":"https://api.kxz.atcumt.com/lib/image?isbn=&title=三体摭韵  4","statusNow":"https://api.kxz.atcumt.com/lib/status?id=968675","status":false},{"bookId":491065,"name":"三维应力环境下节理岩体真三轴试验研究","author":"刘海宁著","publisher":"中国水利水电出版社","isbn":"978-7-5170-0744-9","pcount":3,"ecount":1,"searchCode":"P583/L-385","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5170-0744-9&title=三维应力环境下节理岩体真三轴试验研究","statusNow":"https://api.kxz.atcumt.com/lib/status?id=491065","status":true},{"bookId":581606,"name":"《三体》中的物理学","author":"李淼著","publisher":"四川科学技术出版社","isbn":"978-7-5364-8068-1","pcount":4,"ecount":1,"searchCode":"O4-49/L-519","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5364-8068-1&title=《三体》中的物理学","statusNow":"https://api.kxz.atcumt.com/lib/status?id=581606","status":true},{"bookId":734411,"name":"《三体》中的物理学","author":"李淼著","publisher":"湖南科学技术出版社","isbn":"978-7-5710-0148-3","pcount":1,"ecount":0,"searchCode":"O4-49/L-519.2","image":"https://api.kxz.atcumt.com/lib/image?isbn=978-7-5710-0148-3&title=《三体》中的物理学","statusNow":"https://api.kxz.atcumt.com/lib/status?id=734411","status":false}]

class Data {
  int all;
  List<BookList> bookList;

  Data({
      this.all, 
      this.bookList});

  Data.fromJson(dynamic json) {
    all = json["all"];
    if (json["bookList"] != null) {
      bookList = [];
      json["bookList"].forEach((v) {
        bookList.add(BookList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["all"] = all;
    if (bookList != null) {
      map["bookList"] = bookList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// bookId : 413400
/// name : "三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书"
/// author : "刘慈欣著"
/// publisher : "重庆出版社"
/// isbn : "978-7-229-03093-3"
/// pcount : 3
/// ecount : 1
/// searchCode : "I247.55/L-236.2/3"
/// image : "https://api.kxz.atcumt.com/lib/image?isbn=978-7-229-03093-3&title=三体.Ⅲ.Ⅲ,死神永生,Dead end.中国科幻基石丛书"
/// statusNow : "https://api.kxz.atcumt.com/lib/status?id=413400"
/// status : true

class BookList {
  int bookId;
  String name;
  String author;
  String publisher;
  String isbn;
  int pcount;
  int ecount;
  String searchCode;
  String image;
  String statusNow;
  bool status;

  BookList({
      this.bookId, 
      this.name, 
      this.author, 
      this.publisher, 
      this.isbn, 
      this.pcount, 
      this.ecount, 
      this.searchCode, 
      this.image, 
      this.statusNow, 
      this.status});

  BookList.fromJson(dynamic json) {
    bookId = json["bookId"];
    name = json["name"];
    author = json["author"];
    publisher = json["publisher"];
    isbn = json["isbn"];
    pcount = json["pcount"];
    ecount = json["ecount"];
    searchCode = json["searchCode"];
    image = json["image"];
    statusNow = json["statusNow"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["bookId"] = bookId;
    map["name"] = name;
    map["author"] = author;
    map["publisher"] = publisher;
    map["isbn"] = isbn;
    map["pcount"] = pcount;
    map["ecount"] = ecount;
    map["searchCode"] = searchCode;
    map["image"] = image;
    map["statusNow"] = statusNow;
    map["status"] = status;
    return map;
  }

}