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

  onTap()=> widget.onTap(widget.clicked);

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    Color titleColor = widget.clicked ? Colors.white : themeProvider.colorMain;
    Color backgroundColor = widget.clicked ? themeProvider.colorMain : themeProvider.colorMain.withOpacity(0.10);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: InkWell(
        key: Key(widget.clicked.toString()),
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
      ),
    );
    ;
  }
}
