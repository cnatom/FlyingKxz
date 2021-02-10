import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/Text/text.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_color.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/course_data.dart';

class CourseTableChild extends StatefulWidget {
  final List<CourseData> courseList;
  final double height;
  final double width;
  CourseTableChild(this.courseList,this.width,this.height);
  @override
  _CourseTableChildState createState() => _CourseTableChildState();
}

class _CourseTableChildState extends State<CourseTableChild> {
  double unitHeight;
  double unitWidth;
  List<Widget> cards = [];
  void _init(BuildContext context){
    cards.clear();
    this.unitHeight = widget.height/10.0;
    this.unitWidth = widget.width/7.0;
    for(var course in widget.courseList){
      cards.add(CourseCard(course, unitHeight, unitWidth));
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return Stack(
      children: cards,
    );
  }
}


class CourseCard extends StatefulWidget {
  final CourseData courseData;
  final double unitHeight;
  final double unitWidth;

  CourseCard(this.courseData,this.unitHeight,this.unitWidth);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    if(widget.courseData!=null){
      return _buildCard();
    }else{
      return Container();
    }
  }
  BoxDecoration cardDecoration ()=>BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: CourseColor.fromStr(widget.courseData.title.toString()).withOpacity(0.9)
  );
  EdgeInsets cardMargin()=>EdgeInsets.all(widget.unitWidth/40);
  EdgeInsets cardPadding()=>EdgeInsets.all(widget.unitWidth/35);
  void _handleClick(){

  }

  Widget _buildCard(){
    double top = (widget.courseData.lessonNum-1)*widget.unitHeight;
    double left = (widget.courseData.weekNum-1)*widget.unitWidth;
    double height = widget.unitHeight*widget.courseData.durationNum;
    return Positioned(
      top:top,
      left:left,
      child:  InkWell(
        onTap: ()=>_handleClick(),
        child: Container(
          height: height,
          width: widget.unitWidth,
          padding: cardMargin(),
          child: Container(
            padding: cardPadding(),
            decoration: cardDecoration(),
            child: _buildCardInfo(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardText(widget.courseData.title, 33),
        SizedBox(height: ScreenUtil().setSp(10),),
        _buildCardText(widget.courseData.location, 25),
      ],
    );
  }
  Widget _buildCardText(String text,int sp){
    return Text(
      text,
      style: TextStyle(
          fontSize:
          ScreenUtil().setSp(sp),
          color: Colors.white),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

}
