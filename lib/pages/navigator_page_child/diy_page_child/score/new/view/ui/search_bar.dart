import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ScoreContainer(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.search,
              size: 22,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
          Expanded(
            child: TextField(
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
            ),
          )
        ],
      ),
    );
  }
}
