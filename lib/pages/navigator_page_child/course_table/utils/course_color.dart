import 'dart:ui';

class CourseColor{
  static Map<String,Color> c = {};
  static int _curIndex = 0;
  static final List<Color> _colorLessonCard = [
    Color.fromARGB(255, 102,204,153),
    Color(0xFF6699FF),
    Color.fromARGB(255, 255,153,153),
    Color.fromARGB(255, 166,145,248),
    Color.fromARGB(255, 62,188,202),
    Color.fromARGB(255, 255,153,102),
    Color(0xFF4ecccc),
    Color(0xFFff9bcb)
  ];
  CourseColor(String str){
    if(!c.containsKey(str)){
      c[str] = _colorLessonCard[_curIndex++];
      _curIndex%=(_colorLessonCard.length-1);
    }
  }
  //CourseColor.fromStr("English")返回English的色彩
  static Color fromStr(String? str){
    if(str==null) return c[0]!;
    return c[str]!;
  }
}