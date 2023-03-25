import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';
import 'util/login.dart';
import 'util/util.dart';


class CumtLoginView extends StatefulWidget {
  @override
  _CumtLoginViewState createState() => _CumtLoginViewState();
}

class _CumtLoginViewState extends State<CumtLoginView> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  ThemeProvider themeProvider;
  CumtLoginAccount cumtLoginAccount = CumtLoginAccount();
  @override
  void initState() {
    super.initState();
    _usernameController.text = cumtLoginAccount.username;
    _passwordController.text = cumtLoginAccount.password;
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          spaceCardPaddingRL, spaceCardPaddingTB, spaceCardPaddingRL, 0),
      child: Wrap(
        runSpacing: spaceCardPaddingTB,
        children: [
          Container(),
          buildTextField("账号", _usernameController, showPopButton: true),
          buildTextField("密码", _passwordController, obscureText: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 10),
              buildPickerButton(onTap: () => _showLocationMethodPicker()),
              SizedBox(width: 10),
              cumtLoginButton(0, "登录", onTap: () => _handleLogin(context)),
              SizedBox(width: 10),
              cumtLoginButton(1, "注销", onTap: () => _handleLogout(context)),
            ],
          ),
          Container()
        ],
      ),
    );
  }

  InkWell buildPickerButton({GestureTapCallback onTap}) {
    return InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    FlyText.main40(
                      "${cumtLoginAccount.cumtLoginLocation?.name} ${cumtLoginAccount.cumtLoginMethod?.name}",
                      color: themeProvider.colorNavText,
                    ),
                    Icon(Icons.arrow_drop_down,color: themeProvider.colorNavText,),
                  ],
                ));
  }

  Widget buildTextField(
      String labelText, TextEditingController textEditingController,
      {obscureText = false, showPopButton = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(color: themeProvider.colorNavText.withOpacity(0.3),
              width: 1,),),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSizeMain40, color: themeProvider.colorNavText),
            controller: textEditingController,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  fontSize: fontSizeMain40,
                  color: themeProvider.colorNavText.withOpacity(0.9)),
              hintText: labelText, //点击后显示的提示语
            ),
          ),
          showPopButton
              ? PopupMenuButton<CumtLoginAccount>(
                  icon: Icon(Icons.arrow_drop_down_outlined,color: themeProvider.colorNavText,),
                  onOpened: () {
                    FocusScope.of(context).unfocus();
                  },
                  onSelected: (account) {
                    setState(() {
                      cumtLoginAccount = account.clone();
                      _usernameController.text = cumtLoginAccount.username;
                      _passwordController.text = cumtLoginAccount.password;
                    });
                  },
                  itemBuilder: (context) {
                    return CumtLoginAccount.list.map((account) {
                      return PopupMenuItem<CumtLoginAccount>(
                        value: account,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${account.username}"
                                " ${account.cumtLoginLocation?.name} ${account.cumtLoginMethod?.name}",
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  CumtLoginAccount.removeList(account);
                                  showToast("删除成功");
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close))
                          ],
                        ),
                      );
                    }).toList();
                  })
              : Container(),
        ],
      ),
    );
  }

  //输入框组件
  Widget inputBar(String hintText, TextEditingController controller,
          {FormFieldSetter<String> onSaved, bool obscureText = false}) =>
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: fontSizeMain40, color: themeProvider.colorNavText),
          obscureText: obscureText,
          //是否是密码
          controller: controller,
          //控制正在编辑的文本。通过其可以拿到输入的文本值
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontSize: fontSizeMain40,
                color: themeProvider.colorNavText.withOpacity(0.5)),
            border: InputBorder.none, //下划线
            hintText: hintText, //点击后显示的提示语
          ),
          onSaved: onSaved,
        ),
      );

  void _handleLogout(BuildContext context) {
    CumtLogin.logout(account: cumtLoginAccount).then((value) {
      showToast(value);
    });
  }

  void _handleLogin(BuildContext context) {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showToast('账号或密码不能为空');
      return;
    }
    cumtLoginAccount.username = _usernameController.text.trim();
    cumtLoginAccount.password = _passwordController.text.trim();

    CumtLogin.login(account: cumtLoginAccount).then((value) {
      setState(() {
        showToast(value);
      });
    });
  }

  //登录按钮
  Widget cumtLoginButton(int type, String title,
      {@required GestureTapCallback onTap}) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(5),
        elevation: 0,
        color: type == 0
            ? themeProvider.colorMain.withOpacity(0.8)
            : Theme.of(context).disabledColor.withOpacity(0.5),
        child: InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
              height: fontSizeMain40 * 2.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: FlyText.title45(title,
                  color: type == 0
                      ? Colors.white
                      : themeProvider.colorNavText.withOpacity(0.8))),
        ),
      ),
    );
  }

  void _showLocationMethodPicker() {
    Picker(
        adapter: PickerDataAdapter<dynamic>(pickerData: [
          CumtLoginLocationExtension.nameList,
          CumtLoginMethodExtension.nameList,
        ], isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            cumtLoginAccount
                .setCumtLoginLocationByName(picker.getSelectedValues()[0]);
            cumtLoginAccount
                .setCumtLoginMethodByName(picker.getSelectedValues()[1]);
          });
        }).showModal(context);
  }
}

//跳转到当前页面
void toCumtLoginHelpPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => CumtLoginHelpPage()));
  Logger.sendInfo('CumtLoginHelp', '进入', {});
}

class CumtLoginHelpPage extends StatefulWidget {
  @override
  _CumtLoginHelpPageState createState() => _CumtLoginHelpPageState();
}

class _CumtLoginHelpPageState extends State<CumtLoginHelpPage> {
  Widget helpItem(
    String imageResource,
    String text,
  ) =>
      Wrap(
        children: [
          FlyText.title45(
            text,
            maxLine: 100,
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(deviceWidth * 0.1)),
            child: Container(
              decoration: BoxDecoration(boxShadow: [boxShadowMain]),
              child: Center(
                child: Image.asset(
                  imageResource,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, "校园网自动登录秘籍"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(spaceCardMarginRL),
          child: Wrap(
            children: [
              helpItem("images/cumtLoginHelp1.png",
                  '1、在系统设置中连接校园网CUMT_Stu，并等待上方出现wifi标志（很重要！）'),
              helpItem("images/cumtLoginHelp5.png",
                  '2、连接网络后可能会自动弹出登录页面，点击取消，选择"不连接互联网使用"（以iOS为例，其他系统也差不多）'),
              helpItem("images/cumtLoginHelp6.png",
                  '3、为避免再弹出登录页面，可以进入CUMT_Stu详情页面，关闭"自动登录"功能。'),
              helpItem("images/cumtLoginHelp2.png",
                  '4、打开矿小助输入账号密码就可以登录了\n（第二次打开这个框框就不用填账号密码了哦）'),
              helpItem('images/cumtLoginHelp1.png',
                  "你以为这就结束了？？？\n用脚趾头想想也知道那必不可能（滑稽\n\n矿小助还可以一键登录校园网\n(前提是你已经用上述步骤手动登录过了)\n\n1、连接wifi，等待出现wifi标志"),
              helpItem('images/cumtLoginHelp3.png', "2、打开矿小助"),
              helpItem(
                  'images/cumtLoginHelp4.png',
                  "然后就可以愉快的上网了～\n\n"
                      "Q:什么情况下会触发自动登录函数？\n1.初始化矿小助时\n2.将矿小助从后台调出时（版本号需 > 1.4.06）\n\n"
                      "如果喜欢的话可以将矿小助推荐给其他人哦～\n\n"
                      "——用爱发电的程序员小哥")
            ],
          ),
        ),
      ),
    );
  }
}
