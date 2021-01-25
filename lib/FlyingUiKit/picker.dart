import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';

import 'Text/text.dart';
import 'config.dart';


void showPicker(BuildContext context,GlobalKey scaffoldKey,{@required List pickerDatas,@required PickerConfirmCallback onConfirm}) {
  var picker = new Picker(
      textStyle: TextStyle(fontSize: fontSizeMain40,color: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).cardColor,
      title: FlyText.main40('导入课表'),
      adapter: PickerDataAdapter<String>(pickerdata: pickerDatas, isArray: true),
      confirmText: '确定',
      confirmTextStyle: TextStyle(fontSize: fontSizeMain40,color: colorMain),
      cancelText: '取消',
      cancelTextStyle: TextStyle(fontSize: fontSizeMain40,color: Colors.grey),
      onConfirm: onConfirm);
  picker.show(scaffoldKey.currentState);
}
