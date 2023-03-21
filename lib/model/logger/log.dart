
import 'package:flying_kxz/model/logger/data.dart';

export 'data.dart';
class Logger {
  static void send({LoggerData data}) {
    print(data.toJson());
  }
  static void sendBase({LoggerBaseData data}) {
    print(data.toJson());
  }
}


