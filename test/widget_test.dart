import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

import 'package:flutter_test/flutter_test.dart';

Future<String> getImagePro(String isbn,String title)async{
  try{
    var url = 'https://findcumt.libsp.com/find/book/getDuxiuImageUrl';
    var params = {
      "isbn": isbn,
      "title": title
    };
    Response r = await Dio().get(url, queryParameters: params);
    Map<String,dynamic> map = jsonDecode(r.data);
    return map['data'];
  }on Exception catch(e){
    print(e);
    return "null";
  }
}

Future<Map<String,dynamic>> getBook(String keyword,String page,String row)async{
  Dio dio = Dio();
  String url = "https://findcumt.libsp.com/find/unify/search";
  var s_json = {
    "searchFieldContent": keyword,
    "rows": row,
    "page": page,
    "searchField": "keyWord"
  };
  var book_headers = {
    "groupCode": "200069",
    "Referer": "https://findcumt.libsp.com/"
  };
  Response r = await dio.post(url,data: s_json,options: Options(headers: book_headers));
  var data = r.data;
  var book_list = [];
  for(var single in data['data']['searchResult']){
    bool onshelf = false;
    if (single['onShelfCountI'] != null) {
      onshelf = true;
    }
    if (single['groupECount'] == null) {
      single['groupECount'] = 0;
    }
    if (single['groupPhysicalCount'] == null) {
      single['groupPhysicalCount'] = 0;
    }
    if (single['isbn'] == null) {
      single['isbn'] = '';
    }

    var a = {
      "bookId": single['recordId'],
      "name": single['title'],
      "author": single['author'],
      "publisher": single['publisher'],
      "isbn": single['isbn'],
      "pcount": single['groupPhysicalCount'],
      "ecount": single['groupECount'],
      "searchCode": single['callNoOne'],
      // http://127.0.0.1:5000/lib/image?isbn=7-222-02563-4&title=平凡的世界
      // https://api.kxz.atcumt.com/lib'
      "image": getImagePro(single['isbn'], single['title']),
      "statusNow": 'https://user.kxz.atcumt.com/lib/status?id=' +
          single['recordId'].toString(),
      "status": onshelf
    };
    book_list.add(a);
  }
  var l1 = {
    "all": data['data']['numFound'],
    "bookList": book_list
  };
  return l1;
}

void main() {
  test("logger", () async {

    var res = await getBook("三体", "1", "20");
    print(res);
  });
}
