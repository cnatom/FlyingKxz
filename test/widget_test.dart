

import 'package:flutter_test/flutter_test.dart';

List<int> convertWeeksToList(String weeksString) {
  List<int> weeksList = [];

  // 将字符串按逗号分割为多个周数区间
  List<String> weekRanges = weeksString.split('、');

  // 遍历周数区间
  for (String range in weekRanges) {
    // 检查是否存在连续周数的区间
    if (range.contains('-')) {
      // 将区间分割为起始周和结束周
      List<String> rangeParts = range.split('-');
      int startWeek = int.parse(rangeParts[0]);
      int endWeek = int.parse(rangeParts[1].replaceAll("周",""));

      // 将连续周数添加到列表中
      for (int i = startWeek; i <= endWeek; i++) {
        weeksList.add(i);
      }
    } else {
      // 处理单个周数
      int week = int.parse(range.replaceAll('周', ''));
      weeksList.add(week);
    }
  }

  return weeksList;
}


void main() {
  test("logger", () async {
    String weeksString1 = "10-13周";
    String weeksString2 = "2-5、7-10周";

    List<int> weeksList1 = convertWeeksToList(weeksString1);
    List<int> weeksList2 = convertWeeksToList(weeksString2);

    print(weeksList1); // 输出: [10, 11, 12, 13]
    print(weeksList2); // 输出: [2, 3, 4, 5, 7, 8, 9, 10]

  });
}
