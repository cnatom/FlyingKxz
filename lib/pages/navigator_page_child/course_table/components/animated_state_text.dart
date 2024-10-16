import 'package:flutter/material.dart';

enum AnimatedStateTextDirection {
  up,
  down,
}
class AnimatedStateText extends StatefulWidget {
  final String text; // 传入的文字
  final AnimatedStateTextDirection direction; // 传入的方向
  final Color? textColor;
  const AnimatedStateText({
    required this.text,
    required this.direction,
    this.textColor
  });

  @override
  AnimatedStateTextState createState() => AnimatedStateTextState();
}

class AnimatedStateTextState extends State<AnimatedStateText>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late String oldText; // 记录上一次的文字
  late AnimationController _controller; // 控制动画
  late Animation<double> _animation; // 动画值

  @override
  void initState() {
    super.initState();
    oldText = widget.text; // 初始化时旧文字为传入的文字
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // 使用传入的动画曲线
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedStateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      // 文字变化时触发动画
      _controller.reset(); // 重置动画
      _controller.forward(); // 开始动画
      oldText = oldWidget.text; // 将旧文字更新为之前的文字
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // 销毁动画控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            // 显示旧文字的动画
            Transform.translate(
              offset: Offset(0.0, (-_animation.value * 10) * (widget.direction == AnimatedStateTextDirection.up ? 1 : -1)),
              child: Opacity(
                opacity: 1 - _animation.value, // 透明度变化
                child: Text(
                  oldText,
                  style: TextStyle(color: widget.textColor),
                ),
              ),
            ),
            // 显示新文字的动画
            Transform.translate(
              offset: Offset(0.0, (1 - _animation.value) * 10 * (widget.direction == AnimatedStateTextDirection.up ? 1 : -1)),
              child: Opacity(
                opacity: _animation.value, // 透明度变化
                child: Text(
                  widget.text,
                  style: TextStyle(color: widget.textColor),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}