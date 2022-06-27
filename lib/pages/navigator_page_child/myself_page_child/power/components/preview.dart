import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:provider/provider.dart';

import '../../components/preview_view.dart';
import '../power_page.dart';

class PowerPreviewView extends StatefulWidget {
  const PowerPreviewView({Key key}) : super(key: key);

  @override
  State<PowerPreviewView> createState() => _PowerPreviewViewState();
}

class _PowerPreviewViewState extends State<PowerPreviewView> {
  @override
  Widget build(BuildContext context) {
    final powerProvider = Provider.of<PowerProvider>(context);
    return PreviewView(
        "宿舍电量",
        powerProvider.power == null ? "点击绑定宿舍" : "剩余  ${powerProvider.power}度",
        Icons.power_outlined, onTap: () => toPowerPage(context));
  }


}
