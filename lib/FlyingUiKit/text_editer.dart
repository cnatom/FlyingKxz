//输入框组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config.dart';

Widget FlyInputBar(String hintText, TextEditingController controller,
    {FormFieldSetter<String> onSaved, bool obscureText = false,TextAlign textAlign = TextAlign.center}) =>
    Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 242,243,247),
          borderRadius: BorderRadius.circular(100)
      ),
      child: TextFormField(
        textAlign: textAlign,
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