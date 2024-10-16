import 'package:flutter/material.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/toast.dart';

import 'config.dart';

Future<String?> FlyDialogInputShow(BuildContext context,
    {String hintText = '请在此填写',
    VoidCallback? onPressedYes,
    int maxLines = 12,
    String confirmText = "确定"}) async {
  FocusNode focusNode = FocusNode();
  FocusScope.of(context).requestFocus(focusNode);
  String result = '';
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).disabledColor,

        ),
        padding: EdgeInsets.fromLTRB(
            spaceCardPaddingRL / 2, 0, spaceCardPaddingRL / 2, 0),
        child: TextField(
          autofocus: true,

          focusNode: focusNode,
          maxLines: maxLines,
          onChanged: (text) {
            result = text;
          },
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: fontSizeMain40,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
      actions: <Widget>[

        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: FlyText.mainTip40("取消", ),
        ),
        TextButton(
          onPressed: () {
            if (result == '') {
              showToast( "小助听不懂哑语哦~");
              return;
            }
            showToast( "感谢您的反馈！");
            Navigator.of(context).pop(result);
          },
          child: FlyText.main40(confirmText, color: colorMain),
        ),
      ],
    ),
  );
}

Future<dynamic> FlyDialogDIYShow(BuildContext context,
    {required Widget content,List<Widget>? actions}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: content,
      actions: actions,
    ),
  );
}

Future<bool?> showDialogConfirm(BuildContext context,{required String title,VoidCallback? onConfirm,VoidCallback? onCancel}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: FlyText.main40(title,maxLine: 100,),
      actions: <Widget>[
        TextButton(
          onPressed: (){
            if (onConfirm!=null){
              onConfirm();
            }
            Navigator.of(context).pop(true);
          },
          child: FlyText.main40('确定',color: colorMain),),
        TextButton(
          onPressed: (){
            if(onCancel!=null){
              onCancel();
            }
            Navigator.of(context).pop(false);
          },
          child: FlyText.mainTip40('取消',),
        ),
      ],
    ),
  );
}
