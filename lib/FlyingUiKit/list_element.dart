import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/FlyingUiKit/text.dart';

Widget FlyListElementRow01(String title,String content)=>Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    FlyTextMain40(title,color: Colors.black38),
  ],
);

