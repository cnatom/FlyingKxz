import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/components/preview_view.dart';
import 'package:provider/provider.dart';

import '../../../../../Model/prefs.dart';
import '../../../../navigator_page.dart';
import '../balance_page.dart';
import '../utils/provider.dart';

class BalancePreviewView extends StatefulWidget {
  const BalancePreviewView({Key key}) : super(key: key);

  @override
  State<BalancePreviewView> createState() => _BalancePreviewViewState();
}

class _BalancePreviewViewState extends State<BalancePreviewView> {
  @override
  void initState() {
      super.initState();
      Provider.of<BalanceProvider>(context,listen: false).getBalance();

  }

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    return PreviewView(
        "校园卡",
        "余额  " + (balanceProvider.balance ?? "0.0") + "元",
        Icons.monetization_on_outlined,
        onTap: () =>toBalancePage(context));
  }
}
