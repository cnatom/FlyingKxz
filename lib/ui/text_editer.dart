//输入框组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Text/text.dart';
import 'config.dart';

Widget FlyInputBar(BuildContext context,String hintText, TextEditingController controller,
    {FormFieldSetter<String> onSaved,EdgeInsetsGeometry padding,bool obscureText = false,TextAlign textAlign = TextAlign.center}) =>
    Container(
      padding: padding,
      decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(100)
      ),
      child: TextFormField(
        textAlign: textAlign,
        style: TextStyle(fontSize: fontSizeMain40),
        obscureText: obscureText, //是否是密码
        controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
        cursorColor: colorMain,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: fontSizeMain40),
          border: InputBorder.none, //下划线
          hintText: hintText, //点击后显示的提示语
        ),
        onSaved: onSaved,
      ),
    );