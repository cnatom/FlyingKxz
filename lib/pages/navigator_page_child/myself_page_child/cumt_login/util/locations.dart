
import 'methods.dart';

enum CumtLoginLocation {
  nh, // 南湖
  wc // 文昌
}

extension CumtLoginLocationExtension on CumtLoginLocation {

  String loginUrl(
      String username, String password, CumtLoginMethod loginMethod) {
    String head =
        "http://10.2.5.251:801/eportal/?c=Portal&a=login&login_method=1&user_account=$username${loginMethod.code}&user_password=$password";
    switch (this) {
      case CumtLoginLocation.nh:
        return head;
      case CumtLoginLocation.wc:
        return "$head&wlan_ac_name=BRAS";
    }
  }

  String get logoutUrl {
    String head =
        "http://10.2.5.251:801/eportal/?c=Portal&a=logout&login_method=1";
    switch (this) {
      case CumtLoginLocation.nh:
        return head;
      case CumtLoginLocation.wc:
        return "$head&wlan_ac_name=BRAS";
    }
  }

  String get name {
    switch (this) {
      case CumtLoginLocation.nh:
        return '南湖';
      case CumtLoginLocation.wc:
        return '文昌';
    }
  }
  /// 获取所有name
  static List<String> get nameList {
    return CumtLoginLocation.values.map((e) => e.name).toList(growable: false);
  }

  /// 从name获取枚举
  static CumtLoginLocation fromName(String name) {
    return CumtLoginLocation.values
        .firstWhere((element) => element.name == name);
  }
}
