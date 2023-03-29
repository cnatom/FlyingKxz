import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/spider.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/loan/entity/loan_entity.dart';

import 'entity/renew_entity.dart';
class LoanModel {
  LoanEntity loanEntity;
  List<String> coverUrls = [];

  // 一键续约
  Future<RenewDialogInfo> renewAll() async {
    if (loanEntity == null) return RenewDialogInfo(title: "请先获取借阅数据");
    List<int> loanIds = loanEntity.data.searchResult.map((item) => item.loanId).toList();
    RenewEntity entity = await BookSpider.reNew(loanIds: loanIds);
    if(entity!=null){
      return RenewDialogInfo(title: "成功续借${entity.data.success}本，失败${entity.data.fail}本", resultList: entity.data.result.keys.map((key){
        return "$key\n${entity.data.result[key]}";
      }).toList());
    }else{
      return RenewDialogInfo(title: "续借失败");
    }
  }

  // 获取借阅数据
  Future<MapEntry<List<String>, LoanEntity>> getData(
      BuildContext context, LoanType loanType) async {
    try{
      // 获取借阅数据
      loanEntity = await BookSpider.getLoan(loanType);
      // 并发获取封面
      var futures = loanEntity.data.searchResult.map((item) =>
          BookSpider.getBookCoverUrl(
              isbn: item.isbn, title: item.title, recordID: item.recordId));
      var results = await Future.wait(futures);
      for (var url in results) {
        if (url != null) {
          precacheImage(NetworkImage(url), context);
          coverUrls.add(url);
        } else {
          coverUrls.add(null);
        }
      }
      return MapEntry(coverUrls, loanEntity);
    }catch(e){
      print(e);
      throw Exception(e);
    }
  }
}