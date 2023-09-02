import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cumtLogin_help_page.dart';
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
  CumtLogin cumtLogin = CumtLogin();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildLinkButton(onTap: () =>
                  launchUrl(Uri.parse("http://202.119.196.6:8080/Self/login/"),
                      mode: LaunchMode.externalApplication)),
              buildIconButton(onTap: () => toCumtLoginHelpPage(context))
            ],
          ),
          Container(),
          buildTextField("账号", _usernameController, showPopButton: true),
          buildTextField("密码", _passwordController, obscureText: true),
          Container(),
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
          Container(),
          Container()

        ],
      ),
    );
  }

  InkWell buildIconButton({GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        Icons.help_outline,
        color: themeProvider.colorNavText,
      ),
    );
  }

  Widget buildLinkButton({GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Text("用户自助服务系统", style: TextStyle(fontSize: fontSizeMain40,
        color: themeProvider.colorNavText,
        decoration: TextDecoration.underline,),),
    );
  }

  InkWell buildPickerButton({GestureTapCallback onTap}) {
    return InkWell(
        onTap: onTap,
        child: Row(
          children: [
            FlyText.main40(
              "${cumtLoginAccount.cumtLoginLocation?.name} ${cumtLoginAccount
                  .cumtLoginMethod?.name}",
              color: themeProvider.colorNavText,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: themeProvider.colorNavText,
            ),
          ],
        ));
  }

  Widget buildTextField(String labelText,
      TextEditingController textEditingController,
      {obscureText = false, showPopButton = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        border: Border.all(
          color: themeProvider.colorNavText.withOpacity(0.3),
          width: 1,
        ),
      ),
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
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color: themeProvider.colorNavText,
              ),
              onOpened: () {
                FocusScope.of(context).unfocus();
              },
              onSelected: (account) {
                setState(() {
                  cumtLoginAccount = account.clone();
                  account.refreshAccountPrefs();
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
                                " ${account.cumtLoginLocation?.name} ${account
                                .cumtLoginMethod?.name}",
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
            color: Theme
                .of(context)
                .disabledColor
                .withOpacity(0.4),
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
      Logger.log("CumtLogin", "注销", {
        "username": cumtLoginAccount.username,
        "method": cumtLoginAccount.cumtLoginMethod.name,
        "location": cumtLoginAccount.cumtLoginLocation.name,
        "result":value
      });
    });
  }

void _handleLogin(BuildContext context) {
  if (_usernameController.text.trim().isEmpty
      || _passwordController.text.trim().isEmpty) {
    showToast('账号或密码不能为空');
    return;
  }
  cumtLoginAccount.username = _usernameController.text.trim();
  cumtLoginAccount.password = _passwordController.text.trim();
  CumtLogin.login(account: cumtLoginAccount).then((value) {
    setState(() {
      if (value == CumtLoginResult.SUCCESS) {
        showToast("$value\n（已开启自动登录）");
      } else if(value==CumtLoginResult.LOGIN_LIMIT_EXCEEDED){
        showToast('$value\n请在"用户自助服务系统"下线终端。');
      }else if(value==CumtLoginResult.NETWORK_ERROR){
        showToast('$value，确保您已经连接校园网(CUMT_Stu或CUMT_tec)');
      }
    });
    Logger.log("CumtLogin", "登录", {
      "username": cumtLoginAccount.username,
      "method": cumtLoginAccount.cumtLoginMethod.name,
      "location": cumtLoginAccount.cumtLoginLocation.name,
      "result":value
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
            : Theme
            .of(context)
            .disabledColor
            .withOpacity(0.3),
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
        backgroundColor: Theme
            .of(context)
            .cardColor,
        confirmText: '确定',
        textStyle: TextStyle(fontSize: fontSizeMain40, color: Theme
            .of(context)
            .primaryColor),
        confirmTextStyle: TextStyle(
            fontSize: fontSizeMain40, color: themeProvider.colorMain),
        cancelText: '取消',
        cancelTextStyle: TextStyle(
            fontSize: fontSizeMain40, color: Colors.grey),
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
