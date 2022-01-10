import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flying_kxz/CumtSpider/cumt.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/FlyingUiKit/Theme/theme.dart';
import 'package:flying_kxz/FlyingUiKit/appbar.dart';
import 'package:flying_kxz/FlyingUiKit/loading.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/Model/global.dart';
import 'package:flying_kxz/Model/video__data.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/video_panel.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

import '../../../FlyingUiKit/toast.dart';

//跳转到当前页面
void toVideoPage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => VideoPage()));
  sendInfo('课堂回放', '初始化课堂回放页面');
}
class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool loading = true;
  ThemeProvider themeProvider;
  FocusNode searchBarFocus = new FocusNode();


  Future<void> init()async{
    if(await cumt.searchVideo()){
      showToast('获取成功');
      setState(() {
        loading = false;
      });
    }else{
      showToast('获取失败');
    }
  }
  Future<void> searchVideo(String courseName)async{
    setState(() {
      loading = true;
    });
    if(await cumt.searchVideo(courseName: courseName)){
      setState(() {
        loading = false;
      });
      sendInfo('课堂回放', '搜索课程:$courseName');
    }
  }
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    Global.videoInfo = new VideoInfo();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: _searchBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading?Container(
          padding: EdgeInsets.all(50),
          alignment: Alignment.center,
          child: loadingAnimationIOS(),
        ):Global.videoInfo.lstDataSource!=null?Column(
          children: [
            Column(
              children: Global.videoInfo.lstDataSource.map((item){
                return _buildViewCard(item,item.course.imageUrl, item.course.courseName, item.course.schoolYear, item.course.userName, item.course.showTerm);
              }).toList(),
            )
          ],
        ):Column(
          children: [
            SizedBox(height: 40,),
            Center(
              child: FlyText.mainTip35('搜不到这门课哦'),
            )
          ],
        ),
      ),
    );
  }
  Widget _searchBar(){
    return AppBar(
        brightness: Theme.of(context).brightness,
        leadingWidth: 0,
        leading: Container(),
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: fontSizeMain40,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            Expanded(child: Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.search,
                      size: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: searchBarFocus,
                      decoration: InputDecoration(
                        hintText: "输入课程名（需内网或VPN）",
                        border: InputBorder.none,
                        isDense: true,
                        hintStyle: TextStyle(
                          fontSize: fontSizeMini38,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.3,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (videoName){
                        searchVideo(videoName);

                      },
                    ),
                  ),
                ],
              ),
            ),),

          ],
        )
    );
  }
  Widget _buildViewCard(Lst_DataSource videoData,String imageUrl,String courseName,String schoolYear,String userName,String term){
    return Column(
      children: [
        InkWell(
          onTap: ()=>Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>VideoPreViewCard(videoData: videoData,))),
          child: Container(
            margin: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, spaceCardMarginTB),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      //左侧书籍封面
                      Container(
                        height: fontSizeMain40*7,
                        child: AspectRatio(
                          aspectRatio: 1.777,
                          child: Image.network(imageUrl,fit: BoxFit.contain,height: fontSizeMain40*7,),
                        ),
                      ),
                      Positioned(
                          bottom: 3,
                          right: 3,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.black.withOpacity(0.5)
                            ),
                            child: FlyText.mini30(videoData.courseDateList.length.toString(),color: Colors.white,),
                          )
                      )

                    ],
                  ),
                ),
                SizedBox(width: spaceCardPaddingRL,),
                Expanded(
                  child: Container(
                    height: fontSizeMain40*7,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlyText.title45(courseName,fontWeight: FontWeight.bold,maxLine: 2,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FlyText.mainTip35(userName,),
                            Row(
                              children: [
                                FlyText.mainTip35(schoolYear),
                                SizedBox(width: spaceCardPaddingRL/2,),
                                FlyText.mainTip35(term),

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),


        Divider()
      ],
    );
  }

}
class VideoPreViewCard extends StatefulWidget {
  final Lst_DataSource videoData;

  const VideoPreViewCard({Key key, this.videoData}) : super(key: key);
  @override
  _VideoPreViewCardState createState() => _VideoPreViewCardState();
}
enum ViewType{All,Student,PPT}
class _VideoPreViewCardState extends State<VideoPreViewCard> {
  final FijkPlayer player = FijkPlayer();
  ThemeProvider themeProvider;
  bool loading = true;
  Map<ViewType,int> view = {
    ViewType.All:0,
    ViewType.Student:1,
    ViewType.PPT:2
  };
  var urlList = [];
  var curTimeRangeList = [];//[08:00-08:30,08:00-08:30,08:00-08:30]
  var curDate = '';//08-01
  var curTime = '';//08:00-08:30
  var curView = ViewType.All;

  Map<String,List<String>> map = {};

  Future<void> getDateDetail(CourseDateList data)async{
    var courseID = data.courseID;
    var courseCode = data.courseCode;
    var courseDate = data.date;
    var courseName = widget.videoData.course.courseName;
    var a = await cumt.dio.get('http://class.cumt.edu.cn/StudentCourseVideo/StudentCourseVideoDemandInfo',
    queryParameters: {
        'CourseID':courseID,
        'CourseCode':courseCode,
        'CourseDate':courseDate,
        'CourseName':courseName
    });
    var document = parser.parse(a.data);
    var urlRaw = document.body.querySelector("#hidShowpath").attributes['value']??'';
    var timeRaw = document.body.querySelectorAll('a[href="#"]');
    map.clear();
    curTimeRangeList.clear();
    for(int i = 1;i<=timeRaw.length;i++){
      var key = timeRaw[i-1].text;
      curTimeRangeList.add(key);
      map[key] = [];
      var listRaw = urlRaw.split('|');
      for(var url in listRaw){
        if(url.length<10)continue;
        url = url.substring(0,url.length-5);
        url += "$i.mp4";
        map[key].add(url);
      }
    }
    setState(() {
      loading = false;
    });
    // curDate = timeRaw[0].text;
    // print(map.toString());
    // var s= map[timeRaw[1].text][view[ViewType.All]];
    // player.setDataSource(s,showCover: true);
    // print("当前链接："+s);
    // setState(() {
    //   loading = false;
    // });
  }
  Future<void> setView(String time,ViewType viewType)async{
    curView = viewType;
    curTime = time;
    var url = map[time][view[viewType]];
    await player.reset();
    await player.setDataSource(url,showCover: true);
    setState(() {

    });
  }
  Future<void> init()async{
    //初始化变量
    curView = ViewType.All;
    //获取第一个时间段的视频信息
    curDate = widget.videoData.courseDateList[0].date;
    await getDateDetail(widget.videoData.courseDateList[0]);
    //播放
    await setView(curTimeRangeList[0],curView);
    player.start();
    sendInfo('课堂回放', '查看视频:${widget.videoData.course.courseName}');
  }
  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  void dispose() {
    super.dispose();
    player.release();
    sendInfo('课堂回放', '结束观看:${widget.videoData.course.courseName}');
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(context, widget.videoData.course.courseName),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width*0.5625,
              child: FijkView(player: player,fit: FijkFit.fitWidth,
                color: Colors.black,
                panelBuilder: flyFijkPanelBuilder,),
            ),
            _buildPreview(),
            Divider(),
            _buildDateView(),
            _buildTimeView(),
            _buildSetView(),
          ],
        ),
      ),
    );
  }
  Widget _buildPreview(){
    return Container(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB, spaceCardMarginRL, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlyText.title45(widget.videoData.course.courseName,fontWeight: FontWeight.bold,maxLine: 2,),
                SizedBox(height: spaceCardPaddingTB,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlyText.mainTip35(widget.videoData.course.userName,),
                    Row(
                      children: [
                        FlyText.mainTip35(widget.videoData.course.schoolYear),
                        SizedBox(width: spaceCardPaddingRL/2,),
                        FlyText.mainTip35(widget.videoData.course.showTerm),

                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.file_download,color: themeProvider.colorMain,),
            onPressed: (){
              launch(player.dataSource);
            },
          )
        ],
      )
    );
  }
  Widget _buildDateView(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: widget.videoData.courseDateList.map((item){
          return _buildButton(item.date.substring(item.date.length-5),
              cur: item.date==curDate,
              onTap: ()async{
                await getDateDetail(item);
                curDate = item.date;
                await setView(curTimeRangeList[0],curView);
              },
          );
        }).toList(),
      ),
    );
  }
  Widget _buildTimeView(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: curTimeRangeList.map((item){
          return _buildButton(item,
              cur: item==curTime,
              onTap: ()=>setView(item, curView));
        }).toList(),
      ),
    );
  }
  Widget _buildSetView(){
    var text = ['默认视图','学生视图','PPT视图'];
    var type = [ViewType.All,ViewType.Student,ViewType.PPT];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [for(int i = 0;i<3;i++)Column(
          children: [
            _buildButton(text[i],
                cur: curView==type[i],
                onTap: (){
                  var pos = player.currentPos.inMicroseconds;
                  setView(curTime, type[i]);
                  player.seekTo(pos);
                }),
          ],
        )],
      )
    );
  }
  Widget _buildButton(String text,{GestureTapCallback onTap,bool cur = false}){
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: cur?themeProvider.colorMain:Colors.grey)
        ),
        margin: EdgeInsets.fromLTRB(5, spaceCardPaddingTB, 5, 0),
        padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
        child: Column(
          children: [
            FlyText.main40(text,color:cur?themeProvider.colorMain:Colors.grey,)
          ],
        ),
      ),
    );
  }
}

