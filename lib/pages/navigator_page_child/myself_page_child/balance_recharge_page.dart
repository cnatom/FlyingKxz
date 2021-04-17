import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';

void toBalanceRechargePage(BuildContext context){
  Navigator.push(context, CupertinoPageRoute(builder: (context)=>BalanceRechargePage()));
}
class BalanceRechargePage extends StatefulWidget {
  @override
  _BalanceRechargePageState createState() => _BalanceRechargePageState();
}

class _BalanceRechargePageState extends State<BalanceRechargePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "校园卡充值"),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
