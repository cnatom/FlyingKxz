enum CumtLoginMethod {
  cumt, // 校园网
  telecom, // 电信
  unicom, // 联通
  cmcc // 移动
}

extension CumtLoginMethodExtension on CumtLoginMethod {

  String get code {
    switch (this) {
      case CumtLoginMethod.cumt:
        return '';
      case CumtLoginMethod.telecom:
        return '%40telecom';
      case CumtLoginMethod.unicom:
        return '%40unicom';
      case CumtLoginMethod.cmcc:
        return '%40cmcc';
    }
  }

  String get name {
    switch (this) {
      case CumtLoginMethod.cumt:
        return '校园网';
      case CumtLoginMethod.telecom:
        return '电信';
      case CumtLoginMethod.unicom:
        return '联通';
      case CumtLoginMethod.cmcc:
        return '移动';
    }
  }

  /// 获取所有枚举的name
  static List<String> get nameList {
    return CumtLoginMethod.values.map((e) => e.name).toList(growable: false);
  }

  /// 根据name获取枚举
  static CumtLoginMethod fromName(String name) {
    return CumtLoginMethod.values.firstWhere((element) => element.name == name);
  }
}
