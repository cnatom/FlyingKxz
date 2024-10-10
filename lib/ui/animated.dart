import 'package:flutter/cupertino.dart';

class FlyAnimatedCrossFade extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool showSecond;
  final Alignment? alignment;
  final Duration? duration;
  const FlyAnimatedCrossFade({Key? key, this.duration,required this.firstChild, required this.secondChild, this.showSecond = false,this.alignment = Alignment.topCenter});

  @override
  State<FlyAnimatedCrossFade> createState() => _FlyAnimatedCrossFadeState();
}

class _FlyAnimatedCrossFadeState extends State<FlyAnimatedCrossFade> {
  @override
  Widget build(BuildContext context) {
    return  AnimatedCrossFade(
      alignment: widget.alignment??Alignment.topCenter,
      firstCurve: Curves.easeInOut,
      secondCurve: Curves.easeInOut,
      sizeCurve: Curves.easeInOut,
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      duration: widget.duration??Duration(milliseconds: 250),
      crossFadeState: widget.showSecond
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
