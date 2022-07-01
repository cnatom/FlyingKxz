import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';

import 'Text/text.dart';

void showToast(String text,
    {String subTitle,int duration = 2, int gravity = 2}) {
  // Toast.show(text, context,
  //     backgroundRadius: 5, gravity: gravity, duration: duration);
  BotToast.showSimpleNotification(
    title: text,
    subTitle: subTitle,
    titleStyle: TextStyle(fontSize: fontSizeMain40),
    hideCloseButton: true,
    borderRadius: borderRadiusValue,
    duration: Duration(seconds: duration),
    enableSlideOff: false,
    align: const Alignment(0, -0.85)
  );
}

void showFlyDialog(BuildContext context, {@required Widget child}) {
  showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          backgroundColor: Colors.transparent,
          child: child,
        );
      },
      animationType: DialogTransitionType.rotate3D,
      duration: const Duration(milliseconds: 200));
}

class Toast {
  static final int LENGTH_SHORT = 1;
  static final int LENGTH_LONG = 2;
  static final int BOTTOM = 0;
  static final int CENTER = 1;
  static final int TOP = 2;

  static void show(String msg, BuildContext context,
      {int duration = 1,
      int gravity = 0,
      Color backgroundColor = const Color(0xAA000000),
      Color textColor = Colors.white,
      double backgroundRadius = 20,
      Border border}) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textColor, backgroundRadius, border);
  }
}

class ToastView {
  static final ToastView _singleton = new ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(
      String msg,
      BuildContext context,
      int duration,
      int gravity,
      Color background,
      Color textColor,
      double backgroundRadius,
      Border border) async {
    overlayState = Overlay.of(context);

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(backgroundRadius),
                    border: border,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Text(msg,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: fontSizeMain40, color: textColor)),
                )),
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await new Future.delayed(
        Duration(seconds: duration == null ? Toast.LENGTH_SHORT : duration));
    dismiss();
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: gravity == 2 ? 50 : null,
        bottom: gravity == 0 ? 50 : null,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ));
  }
}
