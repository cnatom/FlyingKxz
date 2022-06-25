import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/config.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/picker.dart';
import 'package:flying_kxz/FlyingUiKit/picker_data.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/power/utils/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

void toPowerPage(BuildContext context){
  Navigator.push(context, CupertinoPageRoute(builder: (context)=>PowerPage()));
  sendInfo('宿舍电量', '初始化宿舍电量页面');
}
class PowerPage extends StatefulWidget {
  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _powerRoomidController = new TextEditingController(text: Prefs.powerRoomid??'');
  bool powerLoading = false;
  ThemeProvider themeProvider;
  PowerProvider powerProvider;
  String powerBuilding = Prefs.powerBuilding;
  String powerRoomid = Prefs.powerRoomid;
  void _handlePower()async{
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      powerLoading = true;
    });
    if(_powerRoomidController.text.isNotEmpty&&powerBuilding!=null){
      powerRoomid = _powerRoomidController.text.toString();
      await powerProvider.get(powerBuilding, powerRoomid);
    }else{
      showToast( "请输入完整");
    }
    setState(() {
      powerLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    powerProvider = Provider.of<PowerProvider>(context);
    double percent = 0.0;
    if(powerProvider.power!=null&&powerProvider.power>0.0&&powerProvider.power<=Prefs.power){
      percent = powerProvider.power/Prefs.powerMax;
    }
    print(percent);
    return Scaffold(
      key: _scaffoldKey,
      appBar: FlyAppBar(context, "宿舍电量",
      actions: [
        IconButton(onPressed: (){
          powerProvider.test();
        }, icon: Icon(Icons.ac_unit))
      ]),
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
              powerProvider.power==null?"未绑定":powerProvider.power.toString(),color: themeProvider.colorMain,fontWeight: FontWeight.bold,
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
        colorRight: themeProvider.colorMain,
        isArray: false,
        onConfirm: (Picker picker, List value) {
          String home = picker.getSelectedValues()[0].toString();
          powerBuilding = home;
          setState(() {

          });
        });
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
  Widget _buildInputButton(String title,{GestureTapCallback onTap}){
    return _buildDiyButton(title,
        child: _buildInputBar("输入寝室号(如B1052)", _powerRoomidController)
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

    return Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: Column(
          children: [
            _buildPreviewButton("宿舍楼",powerBuilding??"未选择",onTap: ()=>_handlePowerPicker()),
            _buildInputButton("宿舍号"),
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
