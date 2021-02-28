

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/buttons.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';

import 'package:flying_kxz/FlyingUiKit/text_editer.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/newLogin_post.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:url_launcher/url_launcher.dart';
//跳转到当前页面
void toActiveStepPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => ActiveStepPage()));
}
class ActiveStepPage extends StatefulWidget {
  @override
  _ActiveStepPageState createState() => _ActiveStepPageState();
}

class _ActiveStepPageState extends State<ActiveStepPage> {
  int _position = 0;
  bool _loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = new TextEditingController(text: Prefs.username);
  TextEditingController passwordController = new TextEditingController();
  void nextStep(){
    if(_position<2) setState(()=>_position++);
  }
  void lastStep(){
    if(_position>0)setState(()=>_position--);
  }
  Widget stepView({List<Widget> children,Widget rightChild,Widget leftChild}){
    if(rightChild==null)rightChild = Container();
    if(leftChild==null)leftChild = Container();
    return Wrap(
      runSpacing: spaceCardMarginTB*2,
      children: [
        Wrap(
          runSpacing: spaceCardMarginTB*2,
          children: children,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            leftChild,
            rightChild
          ],
        )
      ],
    );
  }
  Widget stepButton(String text,int type,{@required VoidCallback onPressed}){
    return FlatButton(onPressed: onPressed, child: Text(text),color: type!=0?colorMain:Colors.black12.withOpacity(0.05),textColor: type!=0?Colors.white:colorMain,);
  }
  Widget firstView()=>stepView(
      children: [FlyText.main40('校园卡余额的信息是从新版教务系统上面提取的，而新版教务现在还未正式投入使用，需要用户自己去激活账号。',maxLine: 100)],
      rightChild: stepButton('了解', 1, onPressed: ()=>nextStep()),
    );
  Widget secondView()=>stepView(
    children: [],
    leftChild: stepButton('已激活', 0, onPressed: ()=>nextStep()),
    rightChild: stepButton('前往激活', 1, onPressed: (){
      launch('http://authserver.cumt.edu.cn/retrieve-password/accountActivation/index.html#/?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice');
      nextStep();
  }),
  );
  Widget thirdView(){

    return stepView(
      children: [
        FlyInputBar(context,'学号', usernameController),
        FlyInputBar(context,'密码（新版教务）', passwordController,obscureText: true),
        FlyText.main40('如果忘记了新版教务的密码\n请点击以下链接验证或找回密码',maxLine: 100),
        Row(
          children: [
            InkWell(
              onTap: ()=>launch("http://authserver.cumt.edu.cn/authserver/login?service=http%3A%2F%2Fportal.cumt.edu.cn%2Fcasservice"),
              child: Text("新版教务系统",style: TextStyle(fontSize: fontSizeMain40,color: colorMain,decoration: TextDecoration.underline),textWidthBasis: TextWidthBasis.longestLine,),
            ),
          ],
        )
      ],
      leftChild: !_loading?stepButton('上一步', 0, onPressed: ()=>lastStep()):Container(),
      rightChild: !_loading?stepButton('登录', 1, onPressed: ()async{
        setState(() {_loading = true;});
        print(usernameController.text+' '+passwordController.text);
        if(await newLoginPost(context,username: usernameController.text,password: passwordController.text)){
          showToast(context, '激活成功！重启App后生效。',gravity: Toast.CENTER,duration: 3);
          Navigator.pop(context,);
        }
        setState(() {_loading = false;});
      }):loadingAnimationTwoCircles(color: colorMain),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: FlyAppBar(context, "激活校园卡余额"),
      body: Container(
        child: Stepper(

            type: StepperType.vertical,
            currentStep: _position,
            controlsBuilder: (_,
                {VoidCallback onStepContinue,
                  VoidCallback onStepCancel}) {
              return Row(
                children: [

                ],
              );
            },
            steps: [
              Step(
                isActive: _position == 0 ? true : false,
                title: FlyText.main40('为什么需要激活？'),
                content: firstView(),
              ),
              Step(
                  isActive: _position == 1 ? true : false,
                  title: FlyText.main40('激活账号'),
                  content: secondView()),
              Step(
                  isActive: _position == 2 ? true : false,
                  title: FlyText.main40('登录以获取校园卡余额'),
                  content: thirdView()),
            ]),
      ),
    );
  }
}
