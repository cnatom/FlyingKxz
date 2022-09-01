import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/ui/Text/text.dart';
import 'package:flying_kxz/ui/Text/text_widgets.dart';
import 'package:flying_kxz/ui/buttons.dart';
import 'package:flying_kxz/ui/webview.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        FlyTitle('隐私政策'),
        RichText(
          text: TextSpan(
            text: '您可阅读',
            style: TextStyle(fontSize: fontSizeMain40, color: Colors.black),
            children: [
              TextSpan(
                text: '《隐私政策》',
                style: TextStyle(fontSize: fontSizeMain40, color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => FlyWebView(
                      title: "隐私政策",
                      initialUrl: "https://kxz.atcumt.com/privacy.html",
                    )));
                  },
              ),
              TextSpan(
                text: '了解详细信息。如你同意，请点击"同意"开始接受我们的服务。',
                style: TextStyle(fontSize: fontSizeMain40, color: Colors.black),
              ),
            ],
          ),
        ),
        Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlyTextButton('暂不使用',color: Colors.black.withOpacity(0.5),onTap: (){
              Prefs.prefs.setBool('privacy', false);
              Navigator.of(context).pop(false);
            },),
            Container(),
            FlyTextButton('同意',onTap: (){
              Prefs.prefs.setBool('privacy', true);
              Navigator.of(context).pop(true);
            },)

          ],
        )
      ],
    );
  }
}
