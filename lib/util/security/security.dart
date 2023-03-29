
import 'dart:convert';
class SecurityUtil{

  static String base64Encode(String text) {
    var bytes = utf8.encode(text); // 将字符串编码为UTF-8格式的字节数组
    var base64Str = base64.encode(bytes); // 对字节数组进行Base64编码
    return base64Str;
  }
}