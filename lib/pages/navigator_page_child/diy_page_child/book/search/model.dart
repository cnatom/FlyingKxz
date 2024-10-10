import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/util/util.dart';

import 'entity.dart';

class BookSearchModel {
  BookSearchEntity? entity;

  Future<BookSearchEntity?> bookGet(
      {required String book,
      required String page,
      required String row}) async {
    try {
      //配置dio信息
      var res = await Network.get(
        "https://user.kxz.atcumt.com/lib/book",
        params: {"book": book, "page": page, "row": row},
      );
      //Json解码为Map
      entity = BookSearchEntity.fromJson(res?.data as Map<String, dynamic>);
      Logger.log("Book", "查询", {"book":book,"page":page,"result":res?.data as Map<String, dynamic>});
      return entity;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
