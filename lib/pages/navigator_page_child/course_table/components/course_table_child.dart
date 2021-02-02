import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/course_table/utils/provider.dart';
import 'package:provider/provider.dart';

class CourseTableChild extends StatefulWidget {
  final int week;
  final double height;
  final double width;
  CourseTableChild(this.week,this.width,this.height);
  @override
  _CourseTableChildState createState() => _CourseTableChildState();
}

class _CourseTableChildState extends State<CourseTableChild> {
  double unitHeight;
  double unitWidth;
  List<Widget> cards = [];
  void _init(BuildContext context){
    this.unitHeight = widget.height/10;
    this.unitWidth = widget.width/7;
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
  Map info;
  double unitHeight;
  double unitWidth;
  CourseCard(this.info,this.unitHeight,this.unitWidth);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {

  double cardWidth;

  int duration;
  String name;
  String type;
  String location;
  String teacher;
  String credit;
  String weeksStr;
  String durationStr;

  BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.red
  );
  void _parseInfo(){
    name = widget.info['name'];
    type = widget.info['type'];
    location = widget.info['location'];
    teacher = widget.info['teacher'];
    credit = widget.info['credit'];
    weeksStr = widget.info['weeksStr'];
    durationStr = widget.info['durationStr'];
    duration = widget.info['duration'];
  }
  void _handleClick(){

  }

  Widget _buildCard(){
    return Positioned(
      top:0,
      left:0,
      child: InkWell(
        onTap: ()=>_handleClick(),
        child: Container(
          height: widget.unitHeight*duration,
          width: widget.unitWidth,
          decoration: cardDecoration,
          child: Text(name),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(widget.info!=null){
      _parseInfo();
      return _buildCard();
    }else{
      return Container();
    }
  }
}
