import 'package:flutter/cupertino.dart';

class FlyScrollView extends StatefulWidget {
  const FlyScrollView({Key? key,required this.child,this.controller}) : super(key: key);

  final Widget child;
  final ScrollController? controller;

  @override
  State<FlyScrollView> createState() => _FlyScrollViewState();
}

class _FlyScrollViewState extends State<FlyScrollView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      physics: AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: widget.child,
    );
  }
}
