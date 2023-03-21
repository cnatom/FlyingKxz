

import 'package:flutter_test/flutter_test.dart';

import 'package:flying_kxz/model/logger/log.dart';

void main() {
  test("logger", () {
    Logger.send(
        data: LoggerData(
            username: '学号',
            action: '获取成绩,大一,第一学期',
            data: {'语文': '98.0', "数学": '99.0', "英语": '100.0'},
            page: 'CoursePage',
            time: '请求时间'));
  });
  Logger.sendBase(
      data: LoggerBaseData(
          name: '姓名',
          system: '系统',
          version: '版本',
          phone: '电话号'));
}
