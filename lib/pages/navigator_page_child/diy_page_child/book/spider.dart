import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/entity/loan_entity.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/entity/renew_entity.dart';
import 'package:flying_kxz/util/logger/log.dart';

import '../../../../cumt/cumt.dart';

enum LoanType { loanHis, loanCur }

// 图书馆爬虫
class BookSpider {
  static Cumt _cumt = Cumt.getInstance();
  static String _jwtOpacAuth;
  static Map<LoanType, String> _urlMap = {
    LoanType.loanCur: "https://findcumt.libsp.com/find/loanInfo/loanList",
    LoanType.loanHis: "https://findcumt.libsp.com/find/loanInfo/loanHistoryList"
  };

  // 获取必要的请求字段
  static Future<String> _getJwtOpacAuth() async {
    if (_jwtOpacAuth == null) {
      try {
        await Cumt.getInstance().loginDefault();
        var res1 = await _cumt.dio.get(
            "https://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2F121.248.104.188%3A8080%2FCASSSO%2Flogin.jsp",
            options: Options(followRedirects: false));
        var res2 = await _cumt.dio.get(res1.headers.value("Location"),
            options: Options(followRedirects: false));
        var res3 = await _cumt.dio.get(res2.headers.value("Location"),
            options: Options(followRedirects: false));
        _jwtOpacAuth = res3.headers.value("Location").split("/")[5];
        return _jwtOpacAuth;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return _jwtOpacAuth;
    }
  }

  // 获取历史借阅
  static Future<LoanEntity> getLoan(LoanType loanType) async {
    try {
      String jwtOpacAuth = await _getJwtOpacAuth();
      if (jwtOpacAuth != null) {
        var res = await _cumt.dio.post(_urlMap[loanType],
            data: {
              "page": 1,
              "rows": 50,
              "searchType": 1,
              "searchContent": ""
            },
            options: Options(headers: {"jwtOpacAuth": jwtOpacAuth}));
        LoanEntity loanEntity =
            LoanEntity.fromJson(res.data as Map<String, dynamic>);
        Logger.log("Book", loanType==LoanType.loanCur?"当前借阅":"历史借阅", {"info":loanEntity.data.searchResult});
        return loanEntity;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
  
  static Future<RenewEntity> reNew({@required List loanIds})async{
    try{
      var res = await _cumt.dio.post("https://findcumt.libsp.com/find/lendbook/reNew",data: {"loanIds":loanIds},
          options: Options(headers: {"jwtOpacAuth": _jwtOpacAuth}));
      RenewEntity entity = RenewEntity.fromJson(res.data as Map<String, dynamic>);
      Logger.log("Book", "一键续借", {"info":res.data as Map<String, dynamic>});
      return entity;
    }catch(e){
      print(e);
      return null;
    }
  }
  // 图书封面url
  static Future<String> getBookCoverUrl(
      {@required String isbn,
      @required String title,
      @required int recordID}) async {
    try {
      var res = await _cumt.dio.get(
          "https://findcumt.libsp.com/find/book/getDuxiuImageUrl",
          queryParameters: {
            "isbn": isbn,
            "title": title,
            "recordId": recordID
          });
      var url = (res.data as Map<String, dynamic>)["data"];
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }
  static dispose(){
    _jwtOpacAuth = null;
  }
}
