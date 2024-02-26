import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/animated.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';

import 'score_container.dart';

class ScoreSearchBar extends StatefulWidget {
  const ScoreSearchBar({Key key,this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  State<ScoreSearchBar> createState() => _ScoreSearchBarState();
}

class _ScoreSearchBarState extends State<ScoreSearchBar> {

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ScoreContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildIcon(Icons.search),
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: themeProvider.colorMain,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: fontSizeTitle45,color: themeProvider.colorMain),
              decoration: InputDecoration(
                hintText: "课程名称",
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(
                  fontSize: fontSizeTitle45,
                ),
              ),
              onChanged: widget.onChanged,
              onSubmitted: widget.onChanged,
            ),
          ),
          FlyAnimatedCrossFade(
            showSecond: _controller.text.isNotEmpty,
            firstChild: SizedBox(width: 40,height: 40),
            secondChild: InkWell(
                onTap: (){
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                  widget.onChanged('');
                },
                child: buildIcon(Icons.close)
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIcon(IconData iconData){
    return SizedBox(
      width: 40,
      height: 40,
      child: Icon(
        iconData,
        size: 22,
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
    );
  }
}
