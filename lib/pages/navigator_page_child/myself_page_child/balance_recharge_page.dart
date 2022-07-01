import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/flying_ui_kit/Text/text.dart';
import 'package:flying_kxz/flying_ui_kit/Theme/theme.dart';
import 'package:flying_kxz/flying_ui_kit/appbar.dart';
import 'package:flying_kxz/flying_ui_kit/config.dart';
import 'package:flying_kxz/flying_ui_kit/loading.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
import 'package:flying_kxz/net_request/balanceRecharge_post.dart';
import 'package:provider/provider.dart';

void toBalanceRechargePage(BuildContext context){
  Navigator.push(context, CupertinoPageRoute(builder: (context)=>BalanceRechargePage()));
}
class BalanceRechargePage extends StatefulWidget {
  @override
  _BalanceRechargePageState createState() => _BalanceRechargePageState();
}

class _BalanceRechargePageState extends State<BalanceRechargePage> {
  TextEditingController controller;
  ThemeProvider themeProvider;
  String num = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //表单状态
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: FlyAppBar(context, "充值"),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(spaceCardMarginRL*2, spaceCardMarginTB, spaceCardMarginRL*2, spaceCardMarginTB),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: spaceCardMarginTB*2,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlyText.main40("  支付方式",color: Theme.of(context).primaryColor.withOpacity(0.5),),
                    FlyText.main40("校园卡绑定的银行卡  ",fontWeight: FontWeight.bold,color: themeProvider.colorMain,),
                  ],
                ),
                _buildInputBar(context, "输入充值金额（元）", controller,onSaved: (value)=>num = value),
                !loading?Wrap(
                  runSpacing: spaceCardMarginTB*2,
                  children: [
                    _buildRechargeButton(),
                    FlyText.main40("充值后请去食堂刷卡消费，才会更新卡内余额数据。",color: Theme.of(context).primaryColor.withOpacity(0.5),maxLine: 3,),
                  ],
                ):Center(child: loadingAnimationIOS(),)
              ],
            ),
          ),
        ),
      ),
    );
  }
  //点击充值
  rechargeHandler() async {
    setState(() {
      loading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());//收起键盘
    //提取输入框数据

    var _form = _formKey.currentState;
    _form.save();
    //判空
    if (num.isEmpty||!isNumeric(num)) {
      showToast("请正确填写");
    }else{
      await balanceRechargePost(context,num: num);
    }
    setState(() {
      loading = false;
    });
  }
  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
  InkWell _buildRechargeButton() {
    return InkWell(
      onTap: ()=>rechargeHandler(),
      child: Container(
        padding: EdgeInsets.all(spaceCardMarginRL),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: themeProvider.colorMain
        ),
        child: Center(
          child: FlyText.title45("确 定",color: Colors.white,fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
  Widget _buildInputBar(
      BuildContext context,
      String hintText,
      TextEditingController controller, {
        FormFieldSetter<String> onSaved,
        bool obscureText = false,
      }) =>
      Container(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL * 1.4,
            spaceCardPaddingTB / 4, spaceCardPaddingRL, spaceCardPaddingTB / 4),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(borderRadiusValue)),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSizeTitle50, color: Theme.of(context).primaryColor),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          cursorColor: colorMain,
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: fontSizeMain40, color: Theme.of(context).primaryColor.withOpacity(0.5)),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
}
