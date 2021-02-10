import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'Text/text.dart';
import 'config.dart';

Widget flyBottomSheetScaffold(BuildContext context,{String title = '标题',VoidCallback onDetermine,VoidCallback onCancel,@required Widget child}){
  return Container(
    height: ScreenUtil().setHeight(deviceHeight*0.8),
      padding: EdgeInsets.all(spaceCardPaddingRL),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onCancel,
                child: FlyText.mainTip40(
                  '取消',
                ),
              ),
              FlyText.title45(title, fontWeight: FontWeight.bold),
              TextButton(
                onPressed: onDetermine,
                child: FlyText.main40("确定", color: colorMain),
              )
            ],
          ),
          SizedBox(height: spaceCardMarginBigTB * 2,),
          Expanded(
            child: child
          )
        ],
      ));
}

