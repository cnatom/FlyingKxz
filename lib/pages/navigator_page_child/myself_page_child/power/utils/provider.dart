import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/flying_ui_kit/toast.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import '../../../../../cumt_spider/cumt.dart';
import '../../../../../Model/prefs.dart';

enum PowerRequestType{
  account,aid,power
}
typedef PowerPostCallback = String Function(Map<String,dynamic> map);

class PowerProvider extends ChangeNotifier{
  Cumt cumt = Cumt.getInstance();
  double power = Prefs.power;
  bool powerLoading = false;
  static List<String> apartment = ["研梅", "杏苑", "松竹", "桃苑"];
  Map<String, dynamic> _buildingMap = {
    "研梅": "14",
    "杏苑": "13",
    "松竹": "12",
    "桃苑": "11"
  };
  Map<PowerRequestType, String> _urls = {
    PowerRequestType.account: 'http://ykt.cumt.edu.cn:8988/web/Common/Tsm.html',
    PowerRequestType.aid: 'http://ykt.cumt.edu.cn:8988/web/NetWork/AppList.html',
    PowerRequestType.power: 'http://ykt.cumt.edu.cn:8988/web/Common/Tsm.html'
  };
  Map<String,String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
  };

  // 预览信息
  String get previewTextAtDetailPage => power==null?"未绑定":power.toString();
  double get percentAtDetailPage {
    if(power!=null&&power>0.0&&power<=Prefs.power){
      return double.tryParse((power/Prefs.powerMax).toStringAsFixed(2))??0.0;
    }
    return 0.0;
  }

  //宿舍楼、宿舍号码
  String _powerRoomid;
  String _powerBuilding;
  String get powerRoomid => _powerRoomid??Prefs.powerRoomid;
  String get powerBuilding => _powerBuilding??Prefs.powerBuilding;
  set powerRoomid(String value) => _powerRoomid = value;
  set powerBuilding(String powerBuilding){
    this._powerBuilding = powerBuilding;
    notifyListeners();
  }

  Future<bool> getPreview()async{
    try{
      if(Prefs.powerBuilding!=null&&Prefs.powerRoomid!=null){
        bool ok = await _get(Prefs.powerBuilding, Prefs.powerRoomid);
        if(ok) return true;
      }
      return false;
    }catch(e){
      debugPrint("获取预览电量失败");
      return false;
    }
  }

  // 绑定宿舍信息
  void bindInfoAndGetPower(BuildContext context)async{
    FocusScope.of(context).requestFocus(FocusNode());
    powerLoading = true;
    notifyListeners();
    if(powerBuilding!=null&&powerRoomid!=null&&powerRoomid.isNotEmpty){
      await _get(powerBuilding, powerRoomid,show: true);
      sendInfo("宿舍电量", "绑定宿舍:$powerBuilding $powerRoomid");
    }else{
      showToast( "请输入完整");
    }
    powerLoading = false;
    notifyListeners();
  }


  Future<bool> _get(String building,String roomid,{bool show = false})async{
    String power;
    try{
      String account = await _getAccount(Prefs.username);
      String aid = await _getAid();
      power = await _getPower(account, aid, Prefs.username, building, roomid);
      RegExp regExp = new RegExp(r'([0-9]\d*\.?\d*)$');
      if(regExp.hasMatch(power)){
        this.power = double.tryParse(regExp.firstMatch(power).group(0));
        _savePrefs(this.power, building, roomid);
        notifyListeners();
        if(show) showToast("获取电量成功!");
        sendInfo("宿舍电量", "获取宿舍电量:$power");
        return true;
      }else{
        if(show) showToast(power);
        return false;
      }
    }catch (e){
      if(show){
        showToast(power.toString());
        toTipPage();
      }
      sendInfo("宿舍电量", "获取宿舍电量失败:$powerBuilding $powerRoomid");
      return false;
    }
  }

  Future<String> _postStepFunc(String url,data,PowerPostCallback callback)async{
    var res = await cumt.dio.post(url,data: data,options: Options(headers: headers));
    var map = jsonDecode(res.toString()) as Map<String,dynamic>;
    var result = callback(map);
    return result;
  }
  Future<String> _getAccount(String username) async{
    var url = _urls[PowerRequestType.account];
    var data = 'jsondata={"query_card":{"idtype":"sno","id":"' + username +
        '"}}&funname=synjones.onecard.query.card&json=true';
    return await _postStepFunc(url, data, (map){
      return map['query_card']['card'][0]['account'];
    });
  }

  Future<String> _getAid() async{
    var url = _urls[PowerRequestType.aid];
    var data = 'jsondata={"query_applist":{ "apptype": "elec" }}&funname=synjones.onecard.query.applist&json=true';
    return await _postStepFunc(url, data, (map){
      return map['query_applist']['applist'][0]["aid"];
    });
  }
  Future<String> _getPower(String account,String aid,String username,String building,String roomid) async{
    var url = _urls[PowerRequestType.power];
    var data = {
      'jsondata': '{ "query_elec_roominfo": { "aid":"' + aid + '", "account": "' + account + '","room": { "roomid": "' + roomid + '", "room": "' + roomid + '" },  "floor": { "floorid": "", "floor": "" }, "area": { "area": "1", "areaname": "中国矿业大学（南湖校区）" }, "building": { "buildingid": "' +
          _buildingMap[building] + '", "building": "' + building + '" } } }',
      'funname': 'synjones.onecard.query.elec.roominfo',
      'json': 'true'
    };
    return await _postStepFunc(url, data, (map){
      return map['query_elec_roominfo']['errmsg'];
    });
  }

  Future<bool> _savePrefs(double power,String building,String roomid) async {
    //没记录过最大电量，则初始化
    if(Prefs.powerMax==null) Prefs.powerMax = power;
    if(Prefs.power==null) Prefs.power = 0.0;
    //当电量比上次多时，保存最大电量
    if(power>Prefs.power){
      Prefs.powerMax = power;
    }
    //如果更换了绑定信息，则重新统计
    if(building!=Prefs.powerBuilding||roomid!=Prefs.powerRoomid){
      Prefs.powerMax = power;
    }
    //保存电量
    Prefs.power = power;
    //保存绑定信息
    Prefs.powerBuilding = building;
    Prefs.powerRoomid = roomid;
    return true;
  }


}