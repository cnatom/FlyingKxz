//主页
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/import_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/components/import_course/import_selector_new.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/animated_state_text_provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_provider.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/cumt_login/util/util.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:provider/provider.dart';
import '../../../Model/prefs.dart';
import 'components/animated_state_text.dart';
import 'components/back_curWeek.dart';
import 'components/course_table_child.dart';
import 'components/output_ics/output_ics_page.dart';
import 'components/point_components/point_main.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late CourseProvider courseProvider;
  late ThemeProvider themeProvider;
  late AnimatedStateTextProvider stateTextProvider;
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  GlobalKey<PointMainState> _rightGlobalKey = new GlobalKey<PointMainState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static late PageController coursePageController;
  final GlobalKey<PopupMenuButtonState> _popupMenuKey =
      GlobalKey(); // 用于打开PopupMenuButton
  int? _maxLesson;

  void _openPopupMenu() {
    final dynamic popupMenuState = _popupMenuKey.currentState;
    popupMenuState.showButtonMenu();
  }

  int get maxLesson {
    if (_maxLesson == null) {
      if (Prefs.prefs?.getInt("maxLessonNum") != null) {
        _maxLesson = Prefs.prefs?.getInt("maxLessonNum");
      } else {
        _maxLesson = 10;
      }
    }
    return _maxLesson!;
  }

  set maxLesson(int value) {
    _maxLesson = value;
    Prefs.prefs?.setInt("maxLessonNum", value);
  }

  final lessonTimes = [
    ["08:00", "08:50"],
    ["08:55", "09:45"],
    ["10:15", "11:05"],
    ["11:10", "12:00"],
    ["14:00", "14:50"],
    ["14:55", "15:45"],
    ["16:15", "17:05"],
    ["17:10", "18:00"],
    ["19:00", "19:50"],
    ["19:55", "20:45"],
    ["20:50", "21:40"],
    ["21:45", "22:35"],
  ];

  //导出ICS课表文件
  _outputIcs() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => OutputIcsPage(courseProvider.infoByCourse)));
  }

  // 导入课表
  _setCourse(List? result) async {
    if (result == null || result.isEmpty) {
      return;
    }
    if (result[0] == "import" && result[2] == true) {
      showToast('🎉导入成功！');
      if (result[1] == ImportCourseType.YJS) {
        maxLesson = 12;
      }
      if (result[1] == ImportCourseType.BK) {
        maxLesson = 10;
      }
      Future.delayed(Duration(seconds: 1), () {
        _changePageWithAnimation(0);
      });
    }
    if (result[0] == "date") {
      Future.delayed(Duration(seconds: 1), () {
        _changePageWithAnimation(0);
      });
    }
  }

  _changePageWithAnimation(int page) {
    coursePageController.animateToPage(
      page,
      curve: Curves.easeOutQuint,
      duration: Duration(seconds: 1),
    );
  }

  // 回到本周
  _backToCurWeek() {
    _changePageWithAnimation(courseProvider.initialWeek - 1);
    stateTextProvider.changeWeek(courseProvider.initialWeek);
  }

  // 第一次使用时弹出课表导入菜单
  _firstUse() {
    String prefsTag = "course_page_init";
    if (Prefs.prefs?.getBool(prefsTag) == null) {
      _openPopupMenu();
      Prefs.prefs?.setBool(prefsTag, true);
    }
  }

  Future<void> cumtAutoLogin() async {
    CumtLoginAccount _account = CumtLoginAccount();
    if (_account.isEmpty) {
      return;
    }
    stateTextProvider.updateText("正在登录校园网");
    String res = await CumtLogin.autoLogin(account: _account);
    Logger.log("CumtLogin", "自动登录", {
      "username": _account.username,
      "method": _account.cumtLoginMethod.name,
      "location": _account.cumtLoginLocation.name,
      "result": res
    });
    await Future.delayed(Duration(milliseconds: 600));
    stateTextProvider.updateText(res);
    await Future.delayed(Duration(milliseconds: 600));
    stateTextProvider.restoreText();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      _firstUse();
      cumtAutoLogin();
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      stateTextProvider.restoreDirection();
      cumtAutoLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => AnimatedStateTextProvider()),
      ],
      builder: (context, _) {
        courseProvider = Provider.of<CourseProvider>(context);
        themeProvider = Provider.of<ThemeProvider>(context);
        stateTextProvider = Provider.of<AnimatedStateTextProvider>(context);
        coursePageController = PageController(
          initialPage: courseProvider.curWeek - 1,
        );
        stateTextProvider.init(initWeek: courseProvider.curWeek);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildTop(),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildLeft(),
                              ),
                              Expanded(
                                child: _buildBody(),
                                flex: 8,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: fontSizeTip33 / 5,
                        ),
                      ],
                    ),
                  ),
                  PointMain(
                    key: _rightGlobalKey,
                  )
                ],
              ),
              BackCurWeekButton(
                themeProvider: themeProvider,
                onTap: () => _backToCurWeek(),
                show: courseProvider.curWeek != courseProvider.initialWeek,
              )
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: themeProvider.simpleMode
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      title: AnimatedStateText(
        text: stateTextProvider.stateText,
        direction: stateTextProvider.direction,
        textColor: themeProvider.colorNavText,
      ),
      actions: [
        _buildPopupAction(Icons.add,
            child: ImportSelectorNew(
              onImport: (result) => this._setCourse(result as List?),
              courseProvider: courseProvider,
            )),
        _buildAction(Boxicons.bx_share_alt, onPressed: () => _outputIcs()),
        _buildAction(Boxicons.bx_menu_alt_right,
            onPressed: () => _rightGlobalKey.currentState?.show())
      ],
    );
  }

  Widget _buildPopupAction(IconData iconData, {Widget? child}) {
    return PopupMenuButton(
      key: _popupMenuKey,
      popUpAnimationStyle: AnimationStyle(
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
      ),
      menuPadding: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      color: Colors.transparent,
      iconColor: themeProvider.colorNavText,
      shadowColor: Colors.black,
      icon: Icon(
        iconData,
        color: themeProvider.colorNavText,
      ),
      elevation: 0,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // 设置模糊程度
            child: child,
          ),
        ),
      ],
      offset: Offset(-5, kToolbarHeight),
    );
  }

  Widget _buildAction(IconData iconData, {VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(
        iconData,
        color: themeProvider.colorNavText,
      ),
      onPressed: onPressed,
    );
  }

  bool _isToday(DateTime dateTime) {
    var todayDate = DateTime.now();
    if (todayDate.day == dateTime.day && todayDate.month == dateTime.month) {
      return true;
    } else {
      return false;
    }
  }

  //顶部 周次+日期
  Widget _buildTop() {
    var mondayDate = courseProvider.getCurMondayDate;
    final weeks = [
      '周一',
      '周二',
      '周三',
      '周四',
      '周五',
      '周六',
      '周日',
    ];
    List<DateTime> subDates = [];
    for (int i = 0; i < 7; i++) {
      subDates.add(mondayDate.add(Duration(days: i)));
    }
    return Row(
      children: [
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child: Builder(builder: (context) {
            List<Widget> children = [];
            for (int i = 0; i < 7; i++) {
              bool isToday = _isToday(subDates[i]);
              children.add(Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: isToday
                          ? themeProvider.colorMain.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                          top: BorderSide(
                              width: 5,
                              color: isToday
                                  ? themeProvider.colorMain
                                  : Colors.transparent))),
                  child: _buildTopItem(weeks[i], subDates[i]),
                ),
              ));
            }
            return Row(
              children: children,
            );
          }),
        )
      ],
    );
  }

  Widget _buildTopItem(String week, DateTime subDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlyText.mini30(
          week,
          color: themeProvider.colorNavText,
        ),
        FlyText.mini25(
          "${subDate.month}/${subDate.day}",
          color: themeProvider.colorNavText,
        )
      ],
    );
  }

  //左侧 节次+时间段
  Widget _buildLeft() {
    DateTime _formatTime(String timeStr) {
      //"08:00" -> DateTime
      DateTime result;
      DateTime now = courseProvider.getCurMondayDate
          .add(Duration(days: DateTime.now().weekday - 1));
      result = DateTime(now.year, now.month, now.day,
          int.parse(timeStr.substring(0, 2)), int.parse(timeStr.substring(3)));
      return result;
    }

    bool _isNow(List<String> times) {
      var now = DateTime.now();
      var firstTime = _formatTime(times[0]);
      var secondTime = _formatTime(times[1]);
      if (now.isAfter(firstTime) && now.isBefore(secondTime)) return true;
      return false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < maxLesson; i++)
          Expanded(
            child: FlyWidgetBuilder(
              whenFirst: _isNow(lessonTimes[i]),
              firstChild: _buildLeftNowItem("${i + 1}", lessonTimes[i]),
              secondChild: _buildLeftItem("${i + 1}", lessonTimes[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildLeftItem(String num, List<String> subTimeList) {
    return LayoutBuilder(builder: (context, parSize) {
      return Container(
        width: parSize.maxWidth,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 5, //宽度
              color: Colors.transparent, //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.mini30(num, color: themeProvider.colorNavText),
            SizedBox(
              height: 3,
            ),
            for (int i = 0; i < subTimeList.length; i++)
              FlyText.mini20(subTimeList[i] + (i != 0 ? '\n' : ''),
                  color: themeProvider.colorNavText)
          ],
        ),
      );
    });
  }

  Widget _buildLeftNowItem(String num, List subTimeList) {
    return LayoutBuilder(builder: (context, parSize) {
      return Container(
        width: parSize.maxWidth,
        decoration: BoxDecoration(
          color: themeProvider.colorMain.withOpacity(0.1),
          border: Border(
            left: BorderSide(
              width: 5, //宽度
              color: themeProvider.colorMain, //边框颜色
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlyText.mini30(num, color: themeProvider.colorNavText),
            SizedBox(
              height: 3,
            ),
            for (int i = 0; i < subTimeList.length; i++)
              FlyText.mini20(subTimeList[i] + (i != 0 ? '\n' : ''),
                  color: themeProvider.colorNavText)
          ],
        ),
      );
    });
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, parSize) {
        List<Widget> children = [];
        double height = parSize.maxHeight;
        double width = parSize.maxWidth;
        for (int i = 1; i <= 22; i++) {
          children.add(new CourseTableChild(
              courseProvider.info[i], width, height, maxLesson * 1.0));
        }

        return PageView(
          physics: BouncingScrollPhysics(),
          controller: coursePageController,
          onPageChanged: (value) {
            courseProvider.changeWeek(value + 1);
            stateTextProvider.changeWeek(courseProvider.curWeek);
          },
          scrollDirection: Axis.vertical,
          children: children,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
