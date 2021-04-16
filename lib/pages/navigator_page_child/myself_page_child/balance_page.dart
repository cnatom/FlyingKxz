import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:provider/provider.dart';
//跳转到当前页面
void toBalancePage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => BalancePage()));
}
class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, "校园卡"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardMarginTB, spaceCardPaddingRL, spaceCardMarginTB),
            child: Column(
              children: [
                _buildHeadCard(context),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildHeadCard(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  color: Theme.of(context).cardColor
                ),
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB*2, spaceCardPaddingRL, spaceCardPaddingTB*2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("1.00",style: TextStyle(fontSize: ScreenUtil().setSp(90),fontWeight: FontWeight.bold),),
                    SizedBox(height: spaceCardPaddingTB/2,),
                    FlyText.mini30("卡号：119071",color: Theme.of(context).primaryColor.withOpacity(0.5),),
                    SizedBox(height: spaceCardPaddingTB*2,),
                    _buildRechargeButton()
                  ],
                ),
              );
  }

  InkWell _buildRechargeButton() {
    return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(spaceCardMarginRL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                        color: themeProvider.colorMain
                      ),
                      child: Center(
                        child: FlyText.title45("充 值",color: Colors.white,fontWeight: FontWeight.bold,),
                      ),
                    ),
                  );
  }
}
