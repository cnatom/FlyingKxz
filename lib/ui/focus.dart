import 'package:flutter/cupertino.dart';

class FlyUnfocus extends StatelessWidget {
  final Widget child;
  final BuildContext parContext;
  const FlyUnfocus(this.parContext,{Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(parContext);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
