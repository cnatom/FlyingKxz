import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/container.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/NetRequest/power_post.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

void toPowerPage(BuildContext context){
  Navigator.push(context, CupertinoPageRoute(builder: (context)=>PowerPage()));
}
class PowerPage extends StatefulWidget {
  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _powerNumController = new TextEditingController(text: Prefs.powerNum??'');
  bool powerLoading = false;
  ThemeProvider themeProvider;
  String powerNum = Prefs.powerNum??null;
  String powerHome = Prefs.powerHome??null;
  double percent = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    percent = (Prefs.power??0)/(Prefs.powerMax??1);
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: FlyAppBar(context, "宿舍电量"),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, spaceCardMarginTB),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.width/3,
              lineWidth: 13.0,
              animation: true,
              percent: percent,
              backgroundColor: Theme.of(context).disabledColor,
              center: Icon(EvaIcons.flash,size: MediaQuery.of(context).size.width/10,color: themeProvider.colorMain,),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: themeProvider.colorMain,
            ),
            SizedBox(height: spaceCardPaddingTB*2,),
            FlyText.title50(
              Prefs.powerMax==null?"未绑定":(Prefs.power.toString()+' / '+Prefs.powerMax.toString()),color: themeProvider.colorMain,fontWeight: FontWeight.bold,
            ),
            SizedBox(height: spaceCardPaddingTB*3,),
            _container(
              child: _buildPower()
            )
          ],
        ),
      ),
    );
  }
  InkWell _buildButton(String title,{GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spaceCardMarginRL),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: themeProvider.colorMain
        ),
        child: Center(
          child: FlyText.title45(title,color: Colors.white,fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
  void _handlePowerPicker()async{
    showPicker(context, _scaffoldKey,
        title: "选择宿舍楼",
        pickerDatas: PickerData.apartment,
        isArray: false,
        onConfirm: (Picker picker, List value) {
          String home = picker.getSelectedValues()[1].toString();
          powerHome = home;
          setState(() {

          });
        });
  }
  Widget _buildTitleCenterButton(BuildContext context, String title,
      {GestureTapCallback onTap,}) {
    return InkWell(
      onTap: onTap,
      child: FlyContainer(
        margin: EdgeInsets.fromLTRB(
            0, spaceCardPaddingTB , 0, spaceCardPaddingTB ),
        padding: EdgeInsets.fromLTRB(
            0, spaceCardPaddingTB , 0, spaceCardPaddingTB ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlyText.main35(
              title,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
  Widget _buildDiyButton(String title,{@required Widget child,GestureTapCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: fontSizeMain40*3.5,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FlyText.main35(title,color: Theme.of(context).primaryColor,),
            ),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPreviewButton(String title,String previewStr,{GestureTapCallback onTap}){
    return _buildDiyButton(title,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlyText.main35(previewStr,color: Theme.of(context).primaryColor.withOpacity(0.5),),
            SizedBox(width: fontSizeMini38,),
            Icon(
              Icons.arrow_right_sharp,
              size: sizeIconMain50,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            )
          ],
        )
    );
  }
  Widget _buildInputButton(String title,String previewStr,{GestureTapCallback onTap}){
    return _buildDiyButton(title,
        child: _buildInputBar("输入寝室号(如B1052)", _powerNumController)
    );
  }
  Widget _container({@required Widget child}){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor
      ),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB/2, spaceCardPaddingRL, spaceCardPaddingTB*2),
      child: child,
    );
  }
  Widget _buildInputBar(String hintText,TextEditingController controller){
    return TextFormField(
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: fontSizeMain40,color: Theme.of(context).primaryColor.withOpacity(0.7)),
      controller: controller, //控制正在编辑的文本。通过其可以拿到输入的文本值
      cursorColor: colorMain,
      decoration: InputDecoration(
        hintStyle: TextStyle(fontSize: fontSizeMain40,color: Theme.of(context).primaryColor.withOpacity(0.5)),
        border: InputBorder.none, //下划线
        hintText: hintText, //点击后显示的提示语
      ),
    );
  }
  Widget _buildPower(){
    void _handlePower()async{
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        powerLoading = true;
      });
      if(_powerNumController.text.isNotEmpty||Prefs.powerHome!=null){
        powerNum = _powerNumController.text.toString();
        bool ok = await powerPost(context, token: Prefs.token, home: powerHome, num: powerNum);
        if(!ok) showToast(context, "获取失败，请再检查一下参数");
      }else{
        showToast(context, "请输入完整");
      }
      setState(() {
        powerLoading = false;
      });
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: Column(
          children: [
            _buildPreviewButton("宿舍楼",powerHome??"未选择",onTap: ()=>_handlePowerPicker()),
            _buildInputButton("宿舍号", powerNum??"未选择"),
            SizedBox(height: spaceCardPaddingTB,),
            FlyWidgetBuilder(
                whenFirst: powerLoading,
                firstChild: _buildButton("加载中……",onTap: (){},
                ),
                secondChild: _buildButton("绑定",onTap: ()=>_handlePower(),
                ))
          ]
      ),
    );
  }
}
