import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:provider/provider.dart';
class BackCurWeekButton extends StatefulWidget {
  final GestureTapCallback onTap;
  final bool show;
  const BackCurWeekButton({
    Key key,
    @required this.themeProvider, this.onTap, this.show,
  }) : super(key: key);

  final ThemeProvider themeProvider;

  @override
  _BackCurWeekButtonState createState() => _BackCurWeekButtonState();
}

class _BackCurWeekButtonState extends State<BackCurWeekButton> {
  double _dy;
  String prefsStr = "BackToCurWeek";
  ThemeProvider themeProvider;
  _initHisLoc(){
    _dy = Prefs.prefs.getDouble(prefsStr);
    if(_dy==null){
      _dy = ScreenUtil.bottomBarHeight+ScreenUtil().setHeight(deviceHeight/2);
      Prefs.prefs.setDouble(prefsStr, _dy);
    }
  }
  @override
  void initState() {
    super.initState();
    _initHisLoc();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),
      tween: Tween(end: widget.show?0.0:1.0),
      curve: Curves.easeOutQuint,
      builder: (BuildContext context, Object value, Widget child) {
        return Positioned(
          right: double.parse(value.toString())*(-50.0),
          top: _dy-ScreenUtil.statusBarHeight-kToolbarHeight,
          child: Opacity(
            opacity: 1.0-value,
            child: Draggable(
                axis: Axis.vertical,
                feedback: _buildBackButton(context,drag: true),
                child: _buildBackButton(context),
                childWhenDragging: Container(),
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  if(_dy > offset.dy-10 && _dy < offset.dy+10){
                    widget.onTap();
                    return;
                  }
                  setState(() {
                    _dy = offset.dy;
                    if(_dy<120){
                      _dy = 120;
                    }else if(_dy>MediaQuery.of(context).size.height-100){
                      _dy = MediaQuery.of(context).size.height-100;
                    }

                  });
                  Prefs.prefs.setDouble(prefsStr, _dy);

                }
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context,{bool drag = false}) {
    double backTrans = widget.themeProvider.transCard+(drag?0.1:0);
    if(backTrans>1.0||backTrans<0.0){
      backTrans = 0.2;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(themeProvider.simpleMode?backTrans*0.5:backTrans),
          border: Border.all(color: widget.themeProvider.colorNavText.withOpacity(0.5)),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(100),)
      ),
      child: FlyText.mini30("回到本周",color: widget.themeProvider.colorNavText,),
    );
  }
}



