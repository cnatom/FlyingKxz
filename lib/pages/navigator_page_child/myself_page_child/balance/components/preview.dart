
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/components/preview_view.dart';
import 'package:provider/provider.dart';

import '../balance_page.dart';
import '../utils/provider.dart';

class BalancePreviewView extends StatefulWidget {
  const BalancePreviewView({Key key}) : super(key: key);

  @override
  State<BalancePreviewView> createState() => _BalancePreviewViewState();
}

class _BalancePreviewViewState extends State<BalancePreviewView> {

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    return PreviewView(
        "校园卡",
        "余额  " + balanceProvider.balance + "元",
        Icons.monetization_on_outlined,
        onTap: () =>toBalancePage(context));
  }
}
