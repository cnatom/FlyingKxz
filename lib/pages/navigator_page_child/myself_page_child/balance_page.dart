import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text_widgets.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/balanceDetail_post.dart';
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
  bool loading = true;
  void _getBalanceDetail()async{
    if(await balanceDetailPost()){
      loading = false;
    }else{
      loading = true;
      showToast(context, "请检查网络连接");
    }
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    _getBalanceDetail();//获取余额明细信息
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, "校园卡",),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardMarginTB, spaceCardPaddingRL, spaceCardMarginTB),
            child: Wrap(
              runSpacing: spaceCardMarginTB,
              children: [
                _buildHeadCard(context),
                _buildBalanceDetail(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceDetail(BuildContext context) {
    return _container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlyText.main40("校园卡流水",color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ],
                    ),
                    SizedBox(height: spaceCardPaddingTB*2,),
                    Global.balanceDetailInfo.data!=null?Wrap(
                      runSpacing: spaceCardPaddingTB*1.5,
                      children: Global.balanceDetailInfo.data.map((item){
                        return _buildDetailItem(item.location, item.time, item.costMoney, item.balance);
                      }).toList(),
                    ):loadingAnimationIOS(),
                    SizedBox(height: spaceCardPaddingTB,)
                  ],
                )
              );
  }

  Row _buildDetailItem(String title,String time,String change,String balance) {
    //处理小数点
    balance = (double.parse(balance)/100).toStringAsFixed(2);
    change = (double.parse(change)/100).toStringAsFixed(2);
    //修改余额改变的正负号 并添加色彩
    double changeInt = double.parse(change);
    Color colorItem;//卡片色彩 正为绿 负为橙
    if(changeInt>0){
      change = "+"+change;
      colorItem = Color(0xff00c5a8);
    }else{
      colorItem = Colors.deepOrange;
    }
    //19283->192.83
    return Row(
                      children: [
                        Container(
                          height: fontSizeMain40*3,
                          width: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colorItem,
                          ),
                        ),
                        SizedBox(width: spaceCardPaddingRL/1.5,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FlyText.title45(title),
                                  SizedBox(height: spaceCardPaddingTB/2,),
                                  FlyText.mini30(time,color: Theme.of(context).primaryColor.withOpacity(0.5),)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FlyText.title50(change,fontWeight: FontWeight.bold,),
                                  SizedBox(height: spaceCardPaddingTB/2,),
                                  FlyText.mini30("余额 "+balance,color: Theme.of(context).primaryColor.withOpacity(0.5),)
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
  }
  Widget _container({@required Widget child}){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor
      ),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB*1.6, spaceCardPaddingRL, spaceCardPaddingTB*1.6),
      child: child,
    );
  }
  Widget _buildHeadCard(BuildContext context) {
    return _container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Prefs.balance??"0.00",style: TextStyle(fontSize: ScreenUtil().setSp(90),fontWeight: FontWeight.bold),),
          SizedBox(height: spaceCardPaddingTB/2,),
          FlyText.mini30("卡号："+(Prefs.cardNum==null?"000000":Prefs.cardNum),color: Theme.of(context).primaryColor.withOpacity(0.5),),
          SizedBox(height: spaceCardPaddingTB*1.5,),
          _buildRechargeButton()
        ],
      )
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
