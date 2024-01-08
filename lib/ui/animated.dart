import 'package:flutter/cupertino.dart';

class FlyAnimatedCrossFade extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool showSecond;
  final Alignment alignment;
  const FlyAnimatedCrossFade({Key key, this.firstChild, this.secondChild, this.showSecond = false,this.alignment = Alignment.topCenter});

  @override
  State<FlyAnimatedCrossFade> createState() => _FlyAnimatedCrossFadeState();
}

class _FlyAnimatedCrossFadeState extends State<FlyAnimatedCrossFade> {
  @override
  Widget build(BuildContext context) {
    return  AnimatedCrossFade(
      alignment: widget.alignment,
      firstCurve: Curves.easeOutCubic,
      secondCurve: Curves.easeOutCubic,
      sizeCurve: Curves.easeOutCubic,
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      duration: Duration(milliseconds: 300),
      crossFadeState: widget.showSecond
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
