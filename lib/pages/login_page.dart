//登录页面 是进入App的第一个页面
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading_animation.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/NetRequest/feedback_post.dart';
import 'package:flying_kxz/NetRequest/login_post.dart';
import 'package:flying_kxz/pages/navigator_page.dart';

//跳转到当前页面
void toLoginPage(BuildContext context) async {
  Navigator.of(context).pushAndRemoveUntil(
      CustomRoute(LoginPage(), milliseconds: 1000), (route) => route == null);
}

//登录页面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passWordController = new TextEditingController();
  String _username; //账号
  String _password; //密码
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //表单状态
  bool _loading = false;
  //点击登录后的行为
  _loginFunc() async {
    FocusScope.of(context).requestFocus(FocusNode());//收起键盘
    setState(() {_loading = true;});//开始加载
    //提取输入框数据
    var _form = _formKey.currentState;
    _form.save();
    //判空
    if (_password.isEmpty||_username.isEmpty) {
      showToast(context, "请填写学号密码");
      setState(() {_loading = false;});
      return;
    }
    //登录请求并决定是否跳转
    if(await loginPost(context,username: _username, password: _password)){
      toNavigatorPage(context);
    }else{
      setState(() {_loading = false;});
    }
  }
  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
      {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 242,243,247),
            borderRadius: BorderRadius.circular(100)
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
      ); //输入文本框区域
  //登录按钮
  Widget loginButton()=>LayoutBuilder(
    builder: (context,parSize){
      return _loading==false?Material(
        borderRadius: BorderRadius.circular(100),
        elevation: 0,
        color: colorLoginPageMain,
        child: InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(100),
          onTap: ()=>_loginFunc(),
          child: Container(
              height: fontSizeMain40*2.8,
              width: parSize.maxWidth*0.7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),),
              child: FlyTextTitle45('登录',color: Colors.white)
          ),
        ),
      ):Container(
        alignment: Alignment.topCenter,
        height: fontSizeMain40*2.8,
        width: parSize.maxWidth*0.7,
        child: loadingAnimationTwoCircles(),
      );
    },
  );
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250,250,250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromARGB(255, 250,250,250),
          elevation: 0,
        ),
      ),
        body: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(deviceWidth*0.1), 0, ScreenUtil().setWidth(deviceWidth*0.1), 0),
        child: Stack(
          children: [
            Positioned(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('images/logo.png',height: fontSizeMini38*4,),
                        SizedBox(height: fontSizeMini38*2,),
                        Text('矿小助内测版',style: TextStyle(color: colorLoginPageMain,fontSize: fontSizeMain40,fontWeight: FontWeight.bold,letterSpacing: 3),)
                      ],
                    ),
                  ),
                  Expanded(
                    flex:6,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              inputBar('输入学号', _userNameController,
                                  onSaved: (String value) => _username = value),
                              SizedBox(height: fontSizeMini38*2,),
                              inputBar('统一认证密码', _passWordController,
                                  onSaved: (String value) => _password = value,obscureText:true),
                              SizedBox(height: fontSizeMini38*5,),
                              loginButton(),

                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlyGreyFlatButton("忘记密码",
                                      onPressed: () => showToast(context, '初始密码为身份证后六位\n即教务系统密码')),
                                  Container(
                                    height: ScreenUtil().setWidth(35),
                                    width: 1,
                                    color: Colors.black.withAlpha(60),
                                  ),
                                  FlyGreyFlatButton("建议反馈",
                                      onPressed: ()async{
                                        Clipboard.setData(ClipboardData(text: "839372371"));
                                        showToast(context,"已复制反馈QQ群号至剪切板");
                                        String text = await FlyInputDialogShow(context,hintText: "感谢您提出宝贵的建议，这对我们非常重要！（完全匿名）\n*｡٩(ˊᗜˋ*)و*｡\n（如果有登陆不上的情况请及时联系我们！）");
                                        if(text!=null){
                                          await feedbackPost(context, text: text);
                                        }
                                      }),
                                ],
                              ),
                              FlyTextTip30('内测结束时间：2020年12月31日'),
                              SizedBox(
                                height: fontSizeMini38,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
//                  RichText(
//                    text: TextSpan(
//                        style: TextStyle(
//                            fontSize: fontSizeTip30,
//                            color: Colors.grey),
//                        children: [
//                          TextSpan(text: '登录即表示已同意《'),
//                          TextSpan(text: '用户协议',style: TextStyle(decoration: TextDecoration.underline),
//                              recognizer: TapGestureRecognizer()..onTap = (){}),
//                          TextSpan(text: '》及《'),
//                          TextSpan(text: '隐私政策',style: TextStyle(decoration: TextDecoration.underline),
//                              recognizer: TapGestureRecognizer()..onTap = (){}),
//                          TextSpan(text: '》'),
//                        ]),
//                  ),