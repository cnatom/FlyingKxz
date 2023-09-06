import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/course_date_picker.dart';
import 'package:flying_kxz/pages/tip_page.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../cumt/cumt.dart';
import '../../../../../cumt/cumt_format.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

enum ImportCourseType { BK, YJS }

class ImportPage extends StatefulWidget {
  ImportCourseType importType;

  ImportPage({Key key, @required this.importType}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  InAppWebViewController _controller;
  ThemeProvider themeProvider;
  double progress = 0.0;
  var urlMap = {
    ImportCourseType.BK:
        "http://jwxt.cumt.edu.cn/jwglxt/kbcx/xskbcx_cxXskbcxIndex.html?gnmkdm=N253508&layout=default",
    ImportCourseType.YJS: "http://yjsxt.cumt.edu.cn/",
  };
  bool loadingWeb = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (!await Cumt.checkConnect()) {
      toTipPage();
    }
  }

  _import() async {
    showToast("请选择开学时间", duration: 5);
    var courseDatePicker = CourseDatePicker();
    String dateTime = await courseDatePicker.show(context);
    if (dateTime == '') {
      showToast('日期选择失败');
      return;
    }
    Prefs.admissionDate = dateTime;
    setState(() {
      loading = true;
    });
    String html;
    if (widget.importType == ImportCourseType.YJS) {
      html = await _controller.evaluateJavascript(
          source:
              "document.getElementById('PageFrame').contentDocument.body.innerHTML;");
    } else {
      html = await _controller.getHtml();
    }
    List<dynamic> list = CumtFormat.courseHtmlToList(html, widget.importType);
    setState(() {
      loading = false;
    });
    if (list == null) {
      showToast('解析网页HTML失败，请确保当前为课表页');
      return;
    }
    Navigator.of(context).pop(list);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, loadingWeb ? "从教务获取课表(加载中……)" : "矿大教务",
          actions: [
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  await _controller.clearCache();
                  await _controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(urlMap[widget.importType])));
                }),
            IconButton(
                icon: Icon(
                  Boxicons.bx_help_circle,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => ImportHelpPage(type: widget.importType,)));
                }),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white70.withOpacity(0),
              value: progress > 0.99 ? 0 : progress,
              valueColor: new AlwaysStoppedAnimation<Color>(colorMain),
            ),
          )),
      body: Stack(
        alignment: Alignment.center,
        children: [
          InAppWebView(
            initialOptions: InAppWebViewGroupOptions(
                android:
                    AndroidInAppWebViewOptions(useHybridComposition: true)),
            initialUrlRequest:
                URLRequest(url: Uri.parse(urlMap[widget.importType])),
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onLoadStart: (controller, url) async {
              setState(() {
                loadingWeb = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                loadingWeb = false;
              });
              // 教务系统自动登录
              if (url.toString().contains(
                  "http://jwxt.cumt.edu.cn/jwglxt/xtgl/login_slogin.html")) {
                await _controller.evaluateJavascript(
                    source:
                        'document.getElementById("yhm").value = "${Prefs.username}";');
              }
              // 融合门户自动登录
              if (url.toString().contains(
                  "https://authserver.cumt.edu.cn/authserver/login")) {
                await _controller.evaluateJavascript(
                    source:
                        'document.getElementById("username").value = "${Prefs.username}";');
                await _controller.evaluateJavascript(
                    source:
                        'document.getElementById("password").value = "${Prefs.password}";');
                await _controller.evaluateJavascript(
                    source: 'document.getElementById("login_submit").click();');
              }
              // 自动跳转到课表页面
              if (url
                  .toString()
                  .contains("http://yjsxt.cumt.edu.cn/Gstudent/Default.aspx")) {
                String courseSwitchJS =
                    "document.getElementById('MenuFrame').contentDocument.querySelector('#tree1_4_a').click();";
                showToast("正在自动跳转到课表页面......请耐心等待，若我自动消失后还没出现课表页，可按下方[导入步骤]手动跳转", duration: 15);
                await _controller.zoomBy(zoomFactor: 2,animated: true);
                await _controller.scrollTo(x: 0, y: 0,animated: true);
                await _controller.evaluateJavascript(source: courseSwitchJS);
              }
            },
            onProgressChanged: (controller, process) {
              setState(() {
                progress = process / 100.0;
              });
            },
          ),
          Positioned(
            bottom: 40,
            child: Row(
              children: [
                InkWell(
                  onTap: () => _import(),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                        color: themeProvider.colorMain.withOpacity(0.9),
                        boxShadow: [boxShadowMain]),
                    child: FlyText.title50(
                      loading ? '提取中……' : '提取课表到矿小助',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: FlyText.main40(
                    widget.importType == ImportCourseType.BK
                        ? '登录教务后，查询想要提取的课表，然后点击下方按钮就可以啦～'
                        : "导入步骤：关闭[培养管理]->打开[课务管理]-->点击[学期课表信息查询]->选择学期->点击\"提取课表到矿小助\"",
                    color: Colors.white,
                    maxLine: 10,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ImportHelpPage extends StatefulWidget {
  final ImportCourseType type;

  ImportHelpPage({this.type});

  @override
  _ImportHelpPageState createState() => _ImportHelpPageState();
}

class _ImportHelpPageState extends State<ImportHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlyAppBar(context, '《矿小姬的问答课堂-胎教版》'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              spaceCardPaddingRL * 2, 0, spaceCardPaddingRL * 2, 0),
          child: Wrap(
            runSpacing: spaceCardMarginTB,
            children: [
              _buildTitle('Q1：我为什么一直在加载？'),
              _buildText('可能未连接"校内网"。您可以连接校内的Wifi，比如下面这两个:'),
              _buildImage('images/wifi.png'),
              _buildText(
                  '(连接之后记得进http://10.2.5.251网站登录，或者也可以用矿小助的"校园网登录"功能自动登录哦～）'),
              Divider(),
              _buildTitle('Q2：可是我不在学校怎么办呀？'),
              _buildText('那就用VPN吧！小姬姬已经给你准备好链接啦 ⬇️'),
              size(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton('苹果VPN', MdiIcons.apple, 'iOS VPN指引',
                      'http://nic.cumt.edu.cn/info/1201/2407.htm'),
                  _buildButton('安卓VPN', MdiIcons.android, '安卓 VPN指引',
                      'http://nic.cumt.edu.cn/info/1201/2408.htm')
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              _buildTitle('Q3:怎么提取课表呀？'),
              _buildText('1、先在下面这个界面登录'),
              _buildImage(widget.type == ImportCourseType.BK
                  ? 'images/importHelp1.png'
                  : 'images/importHelpYJS1.png'),
              _buildText('2、然后将页面切换到想要提取的课表页面，点击下方"提取课表到矿小助"即可'),
              _buildImage(widget.type == ImportCourseType.BK
                  ? 'images/importHelp2.png'
                  : 'images/importHelpYJS2.png'),
              Divider(),
              _buildTitle('Q4:课表是实时更新的吗？'),
              _buildText('不是实时更新的！如果有老师调课了，记得重新导入一遍呀！（其实上课好好听也就知道老师调课了'),
              Divider(),
              _buildTitle('Q5:我遇到了其他问题怎么办？'),
              _buildText(
                  '那就私聊小姬姬吧，写代码的小哥哥会一对一解答的～。\n当然，也可以加小姬姬的粉丝群哦，QQ群号：839372371'),
              Divider(),
              size(),
              size(),
              size(),
              size(),
            ],
          ),
        ),
      ),
    );
  }

  Widget size() {
    return Row(
      children: [
        SizedBox(
          height: spaceCardMarginTB,
        )
      ],
    );
  }

  Widget _buildButton(
      String title, IconData iconData, String urlTitle, String url) {
    return InkWell(
      onTap: () {
        launch(url);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            Icon(iconData, size: fontSizeMain40 * 1.5),
            SizedBox(
              height: 5,
            ),
            FlyText.main40(title)
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0.05,
                  color: Colors.black12.withAlpha(5))
            ]),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.title50(
              title,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(
          height: spaceCardMarginTB,
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return FlyText.main40(
      text,
      maxLine: 100,
    );
  }

  Widget _buildImage(String resource) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(boxShadow: [boxShadowMain]),
      child: Image.asset(resource),
    );
  }
}
