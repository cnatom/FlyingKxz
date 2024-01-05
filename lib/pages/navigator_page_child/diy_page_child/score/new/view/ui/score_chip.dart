import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../ui/ui.dart';

typedef ScoreChipTapCallback = void Function(bool value);



class ScoreChip extends StatefulWidget {
  final String title;
  final bool clicked;
  final ScoreChipTapCallback onTap;
  const ScoreChip({Key key, @required this.title, this.clicked = false,this.onTap}) : super(key: key);

  @override
  State<ScoreChip> createState() => _ScoreChipState();
}

class _ScoreChipState extends State<ScoreChip> {
  ThemeProvider themeProvider;
  bool _isSelect;

  onTap(){
    setState(() {
      _isSelect = !_isSelect;
    });
    widget.onTap(_isSelect);
  }

  @override
  void initState() {
    super.initState();
    _isSelect = widget.clicked;
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    Color titleColor = _isSelect ? Colors.white : themeProvider.colorMain;
    Color backgroundColor = _isSelect ? themeProvider.colorMain : themeProvider.colorMain.withOpacity(0.10);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: spaceCardPaddingTB, horizontal: spaceCardPaddingRL),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100)),
        child: FlyText.main40(
          widget.title,
          color: titleColor,
        ),
      ),
    );
    ;
  }
}
