

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/cumt_login.dart';
import 'package:url_launcher/url_launcher.dart';

class CumtLoginView extends StatefulWidget {
  @override
  _CumtLoginViewState createState() => _CumtLoginViewState();
}

class _CumtLoginViewState extends State<CumtLoginView> {
  TextEditingController _userNameController;
  TextEditingController _passWordController;
  String _username; //账号
  String _password; //密码
  bool ok = false;
  int loginType = Global.prefs.getInt(Global.prefsStr.cumtLoginMethod)??1;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //表单状态

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
    if(await cumtLoginGet(context,username: _username,password: _password,loginMethod: loginType)){
      Navigator.pop(context);
    }
  }
  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
      {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 242,243,247),
            borderRadius: BorderRadius.circular(5)
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSizeMain40,color: colorMainText,),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: fontSizeMain40,color: Colors.grey),
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
    color: type==0?colorLoginPageMain:colorPageBackground,
    child: InkWell(
      splashColor: Colors.black12,
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
          height: fontSizeMain40*2.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),),
          child: FlyTextTitle45(title,color: type==0?Colors.white:colorLoginPageMain)
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController(text: Global.prefs.getString(Global.prefsStr.cumtLoginUsername)??"");
    _passWordController = new TextEditingController(text: Global.prefs.getString(Global.prefsStr.cumtLoginPassword)??"");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 10,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                width: fontSizeMini38/4,
                height: fontSizeTitle45,
                decoration: BoxDecoration(color: colorMain,borderRadius: BorderRadius.circular(borderRadiusValue)),
              ),
              SizedBox(width: ScreenUtil().setSp(35),),
              Text(
                "校园网登录",
                style: TextStyle(
                  color: colorMainText,
                  fontSize: fontSizeTitle45,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          Container(),
          Wrap(
            runSpacing: 10,
            children: [
              inputBar('输入账号', _userNameController,
                  onSaved: (String value) => _username = value),
              inputBar('输入密码', _passWordController,
                  onSaved: (String value) => _password = value,obscureText:true),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()=>launch("http://202.119.196.6:8080/Self/login/"),
                child: Text("用户自助服务系统",style: TextStyle(fontSize: fontSizeMain40,color: colorMain,decoration: TextDecoration.underline),textWidthBasis: TextWidthBasis.longestLine,),
              ),
              Container(
                child: DropdownButton(
                  style: TextStyle(fontSize: fontSizeMini38,color: colorMain),
                  iconEnabledColor: colorMain,
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
              )
            ],
          ),

          Wrap(
            runSpacing: 10,
            children: [
              cumtLoginButton(0,"登录",onTap: ()=>_loginFunc()),
              cumtLoginButton(1,"注销",onTap: ()=>cumtLogoutGet(context)),
              FlyTextTip30("小助会记住您的账号密码（本地存储）\n打开App后可以自动帮您连接校园网",maxLine: 5),
            ],
          ),

        ],
      ),
    );
  }
}
