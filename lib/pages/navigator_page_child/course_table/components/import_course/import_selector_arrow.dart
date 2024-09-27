
import 'package:flutter/material.dart';

class ImportSelectorArrow extends CustomPainter {
  final Color bgColor;

  ImportSelectorArrow(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = bgColor;
    // 定义三角形的三个顶点
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, -6);
    path.close(); // 闭合路径，形成三角形

    // 绘制三角形
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}