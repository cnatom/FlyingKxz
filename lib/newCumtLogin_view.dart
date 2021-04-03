

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';

import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:flying_kxz/test.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewCumtLoginView extends StatefulWidget {
  @override
  _NewCumtLoginViewState createState() => _NewCumtLoginViewState();
}

class _NewCumtLoginViewState extends State<NewCumtLoginView> {
  TextEditingController _userNameController;
  TextEditingController _passWordController;
  ThemeProvider themeProvider;
  String _username; //账号
  String _password; //密码
  bool autoLogin = false;
  bool ok = false;
  int loginType = Prefs.cumtLoginMethod??1;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //表单状态
  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController(text: Prefs.cumtLoginUsername??Prefs.username??"");
    _passWordController = new TextEditingController(text: Prefs.cumtLoginPassword??"");
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return FlyUnitCard(
      0xe619,
      "校园网登录",
      Prefs.cumtLoginPassword!=null?"已开启自动登录":"未开启自动登录",
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 10,
          children: [
            _buildBottom(context),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }



  Container _buildSelect() {
    return Container(
                child: DropdownButton(
                  style: TextStyle(fontSize: fontSizeTip33,color: themeProvider.colorMain),
                  iconEnabledColor: themeProvider.colorMain,
                  dropdownColor: Theme.of(context).cardColor.withOpacity(0.5),
                  elevation: 0,
                  underline: Container(),
                  value: loginType ,
                  onChanged: (value) {
                    setState(() {
                      loginType = value;
                    });
                  }, items: [
                  DropdownMenuItem(value: 0,child: Text("校园"),onTap: (){},),
                  DropdownMenuItem(value: 1,child: Text("电信"),onTap: (){},),
                  DropdownMenuItem(value: 2,child: Text("联通"),onTap: (){},),
                  DropdownMenuItem(value: 3,child: Text("移动"),onTap: (){},),
                ],
                ),
              );
  }

  Wrap _buildInputArea(BuildContext context) {
    return Wrap(
          runSpacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: inputBar('输入账号', _userNameController,
                      onSaved: (String value) => _username = value),
                ),
                SizedBox(width: spaceCardPaddingRL/2,),
                cumtLoginButton(0,"登录",onTap: ()=>_loginFunc())
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: inputBar('输入密码', _passWordController,
                      onSaved: (String value) => _password = value,obscureText:true),
                ),
                SizedBox(width: spaceCardPaddingRL/2,),
                cumtLoginButton(1,"注销",onTap: ()=>cumtLogoutGet(context)),
              ],
            )

          ],
        );
  }
  Row _buildBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIconTextButton("用前必看",onTap:()=>toCumtLoginHelpPage(context)),
        _buildIconTextButton("用户自助服务系统↗",onTap:()=>launch("http://202.119.196.6:8080/Self/login/")),
        _buildSelect(),


      ],
    );
  }

  Widget _buildIconTextButton(String title,{GestureTapCallback onTap}) {
    return Container(
      padding: EdgeInsets.fromLTRB(fontSizeMain40, 5, fontSizeMain40, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 1, color: themeProvider.colorMain.withOpacity(0.6)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Icon(IconData(0xe618,fontFamily: "CY"),color: themeProvider.colorMain,),
            FlyText.mini30(title,color: themeProvider.colorMain,)
          ],
        ),
      ),
    );
  }
  //点击登录后的行为
  _loginFunc() async {
    FocusScope.of(context).requestFocus(FocusNode());//收起键盘
    //提取输入框数据
    var _form = _formKey.currentState;
    _form.save();
    //判空
    if (_password.isEmpty||_username.isEmpty) {
      showToast(context, "请填写账号密码");
      return;
    }
    //登录请求并决定是否跳转
    await cumtLoginGet(context,username: _username,password: _password,loginMethod: loginType);
    setState(() {

    });
  }
  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
      {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)
        ),
        child: TextFormField(
          cursorColor: themeProvider.colorMain,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSizeMain40,color: themeProvider.colorNavText),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: fontSizeTip33,color: themeProvider.colorNavText.withOpacity(0.5)),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
  //登录按钮
  Widget cumtLoginButton(int type,String title,{@required GestureTapCallback onTap})=>Material(
    borderRadius: BorderRadius.circular(5),
    elevation: 0,
    color: type==0?themeProvider.colorMain.withOpacity(0.1):Theme.of(context).disabledColor.withOpacity(0.5),
    child: InkWell(
      splashColor: Colors.black12,
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
          height: fontSizeMain40*3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),),
          child: FlyText.mini30(title,color: type==0?themeProvider.colorMain:themeProvider.colorNavText.withOpacity(0.8),)
      ),
    ),
  );



}
//跳转到当前页面
void toCumtLoginHelpPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => CumtLoginHelpPage()));
}
class CumtLoginHelpPage extends StatefulWidget {
  @override
  _CumtLoginHelpPageState createState() => _CumtLoginHelpPageState();
}

class _CumtLoginHelpPageState extends State<CumtLoginHelpPage> {
  Widget helpItem(String imageResource,String text,)=>Wrap(
    children: [
      FlyText.title45(text,maxLine: 100,),
      Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(deviceWidth*0.1)),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                boxShadowMain
              ]
          ),
          child: Center(
            child: Image.asset(imageResource,fit: BoxFit.fill,),
          ),
        ),
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "《校园网登录秘籍-看完不后悔系列》"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(spaceCardMarginRL),
          child: Wrap(
            children: [
              helpItem("images/cumtLoginHelp1.png",
                  '1、在系统设置中连接校园网CUMT_Stu，并等待上方出现wifi标志'),
              helpItem("images/cumtLoginHelp2.png",
                  '2、打开矿小助输入账号密码就可以登录了\n（第二次打开这个框框就不用填账号密码了哦）'),
              helpItem('images/cumtLoginHelp1.png',
                  "你以为这就结束了？？？\n用脚趾头想想也知道那必不可能（滑稽\n\n矿小助还可以一键登录校园网\n(前提是你已经用上述1、2步骤手动登录过了)\n\n1、连接wifi，等待出现wifi标志"),
              helpItem('images/cumtLoginHelp3.png',
                  "2、打开矿小助"),
              helpItem('images/cumtLoginHelp4.png',
                  "然后就可以愉快的上网了～\n\n"
                      "特别注意：如果无法自动登录，就重启矿小助。\n\n"
                      "（自动登录函数只会在App初始化的时候执行，无法登录说明后台还开着矿小助）\n\n"
                      "如果喜欢的话可以将矿小助推荐给其他人哦～\n\n"
                      "——用爱发电的程序员小哥")
            ],
          ),
        ),
      ),
    );
  }
}
