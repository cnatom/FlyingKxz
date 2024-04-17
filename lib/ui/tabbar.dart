import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/text.dart';

class FlyTabBar extends StatelessWidget implements PreferredSizeWidget {
  const FlyTabBar({
    Key? key,
    required TabController tabController,required this.tabs,
  }) : _tabController = tabController, super(key: key);
  final List<Widget> tabs;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        labelColor: Theme.of(context).primaryColor,
        controller: _tabController,
        labelStyle: TextStyle(
            fontSize: fontSizeMini38, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeMini38,
          fontWeight: FontWeight.bold,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
                width: 2, color: Theme.of(context).primaryColor),
            insets: EdgeInsets.fromLTRB(
                fontSizeMain40 * 1.2, 0, fontSizeMain40 * 1.2, 0)),
        tabs: tabs);
  }

  @override
  Size get preferredSize => Size.fromHeight(46.0);
}