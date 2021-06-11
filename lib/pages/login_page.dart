//登录页面 是进入App的第一个页面
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/custome_router.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/dialog.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/login_check_get.dart';
import 'package:flying_kxz/NetRequest/login_post.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_upgrade.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';

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
  int loginCount = 1; //登陆次数,>=3则特别提示
  @override
  void initState() {
    super.initState();
    checkUpgrade(context);
  }
  //用户登录
  _loginHandler() async {
    FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
    setState(() {_loading = true;});
    var _form = _formKey.currentState;
    _form.save();
    //判空
    if (_password.isEmpty || _username.isEmpty) {
      showToast( "请填写学号密码");
      setState(() {
        _loading = false;
      });
      return;
    }
    //检测是否激活&验证码
    if (await loginCheckGet(context, username: _username)) {
      //新登录
      if(await cumt.login(_username, _password,)){
        Prefs.visitor = false;
        var namePhoneMap = await cumt.getNamePhone();
        Prefs.name = namePhoneMap['name'];
        Prefs.phone = namePhoneMap['phone'];
        toNavigatorPage(context);
      }else{
        setState(() {
          _loading = false;
        });
      }
    }else{
      setState(() {
        _loading = false;
      });
    }

  }
  //游客访问
  void _visitorHandler() async {
    FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
    setState(() {
      _loading = true;
    });
    if (await loginVisitor(context, 1,
        username: "12345678", password: "12345678")) {
      Prefs.visitor = true;
      toNavigatorPage(context);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Material(
        child: Stack(
          children: [
            _buildBackground(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(deviceWidth * 0.08), 0,
                  ScreenUtil().setWidth(deviceWidth * 0.08), 0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildHeader(),
                  ),
                  Expanded(
                    flex: 10,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildInputBody(),
                          // Opacity(
                          //   opacity: 0.95,
                          //   child: NoticeCard(),
                          // ),
                          _buildBottom()
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Center(
          //   child:Image.asset(
          //     'images/logo.png',
          //     height: fontSizeMini38 * 3.5,
          //   ),
          // ),
          Text(
            'Hi 欢迎使用矿小助',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(80),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: fontSizeMini38 / 2,
          ),
          Text(
            '矿大人自己的App',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: ScreenUtil().setSp(40),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildInputBody() {
    return Column(
      children: [
        _buildInputBar(
          context,
          '输入学号',
          _userNameController,
          onSaved: (String value) => _username = value,
        ),
        SizedBox(
          height: fontSizeMini38 * 2,
        ),
        _buildInputBar(
          context,
          '融合门户密码(默认身份证后6位）',
          _passWordController,
          onSaved: (String value) => _password = value,
          obscureText: true,
        ),
        SizedBox(
          height: fontSizeMini38 * 5,
        ),
        _buildLoginButton(),
      ],
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
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100)),
        child: TextFormField(
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: fontSizeMain40, color: Colors.white),
          obscureText: obscureText, //是否是密码
          controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
          cursorColor: colorMain,
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: fontSizeMain40, color: Colors.white.withOpacity(0.8)),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );
  Widget _buildBottom() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildFlatButton("游客访问", onPressed: () => _visitorHandler())
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(35),
              width: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildFlatButton("无法登录", onPressed: () async {
                    Clipboard.setData(ClipboardData(text: "839372371"));
                    showToast( "已复制反馈QQ群号至剪切板");
                    FlyDialogDIYShow(context,
                        content: Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FlyText.main40(
                                  "矿小助的密码与融合门户的密码保持一致\n",
                                  maxLine: 10,
                                ),
                                InkWell(
                                  onTap: () => launch(
                                      "http://authserver.cumt.edu.cn/authserver/login"),
                                  child: FlyText.main35("➡️点我跳转至融合门户验证或找回密码",
                                      maxLine: 10, color: Colors.blue),
                                ),
                                FlyText.mainTip35(
                                    "\n如果依然无法登录请进反馈群联系我们\n（已自动复制QQ群号）",
                                    maxLine: 10),
                              ],
                            ),
                          ],
                        ));
                  })
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: fontSizeMini38,
        ),
      ],
    );
  }

  //小按钮
  Widget _buildFlatButton(String text,
          {VoidCallback onPressed, double fontSize}) =>
      FlatButton(
        onPressed: onPressed,
        highlightColor: Colors.transparent, //点击后的颜色为透明
        splashColor: Colors.transparent, //点击波纹的颜色为透明
        child: FlyText.main35(
          text,
          color: Colors.white.withOpacity(0.6),
        ),
      );
  //登录按钮
  Widget _buildLoginButton() {
    return LayoutBuilder(
      builder: (context, parSize) {
        return _loading == false
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: colorLoginPageMain.withOpacity(0.6),
                ),
                child: InkWell(
                  splashColor: Colors.black12,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => _loginHandler(),
                  child: Container(
                      height: fontSizeMain40 * 2.8,
                      width: parSize.maxWidth * 0.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: FlyText.title45('登录', color: Colors.white)),
                ),
              )
            : Container(
                alignment: Alignment.topCenter,
                height: fontSizeMain40 * 2.8,
                width: parSize.maxWidth * 0.7,
                child: loadingAnimationTwoCircles(),
              );
      },
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            //背景过滤器
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ],
    );
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
