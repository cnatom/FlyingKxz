// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import '../../../../../ui/ui.dart';
//
// FlyContainer _buildControlCard(BuildContext context) {
//   return FlyContainer(
//     margin:
//     EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
//     decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(borderRadiusValue),
//         boxShadow: [boxShadowMain]),
//     child: Column(
//       children: [
//         topArea(),
//         _searchBarButton('点击导入成绩', "自动计算，自由筛选", onTap: () => _import()),
//       ],
//     ),
//   );
// }
//
// Widget topArea({@required String jiaquan, @required String jidian}) {
//   //展开闭合组件
//   return Container(
//     padding:
//     EdgeInsets.fromLTRB(spaceCardPaddingRL, 0, spaceCardPaddingRL, 0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         Expanded(
//           flex: 5,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   FlyText.mini30(
//                     "加权：",
//                   ),
//                   Text(
//                     jiaquan != null && jiaquan != 'NaN'
//                         ? jiaquan
//                         : "00.00",
//                     style: TextStyle(
//                         color: themeProvider.colorMain,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontSizeMain40),
//                   )
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   FlyText.mini30(
//                     "绩点：",
//                   ),
//                   Text(
//                     jidian != null && jidian != 'NaN'
//                         ? jidian
//                         : "0.00",
//                     style: TextStyle(
//                         color: themeProvider.colorMain,
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontSizeMain40),
//                   )
//                 ],
//               ),
//               Container(),
//             ],
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Builder(builder: (context){
//                 if(showFilter) return selectAllChip();
//                 return IntroStepBuilder(
//                     order: 2,
//                     text: "查看具体的平时分与考试分",
//                     builder: (context,key) {
//                       return expandChip(key: key);
//                     }
//                 );
//               }),
//               filterChip(key: key)
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }
//
// Widget expandChip({Key key,GestureTapCallback onTap}) {
//   return InkWell(
//     key: key,
//     onTap: onTap,
//     child: Container(
//       height: fontSizeMini38 * 3,
//       child: Row(
//         children: [
//           // scoreDetailAllExpand?FlyText.main35('详细信息',):FlyText.main35('简略信息',),
//           FlyText.main35(
//             '成绩明细',
//           ),
//           Icon(
//             Icons.chevron_right,
//             size: fontSizeMini38,
//           )
//           // scoreDetailAllExpand?Icon(Icons.expand_more,size: fontSizeMini38,):Icon(Icons.expand_less,size: fontSizeMini38),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget filterChip({Key key,GestureTapCallback onTap}) {
//   return InkWell(
//     key: key,
//     onTap: onTap,
//     child: Container(
//       height: fontSizeMini38 * 3,
//       child: Row(
//         children: [
//           FlyText.main35('筛选', fontWeight: FontWeight.w300),
//           Icon(
//             MdiIcons.filterOutline,
//             size: fontSizeMini38 * 1.2,
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget selectAllChip({GestureTapCallback onTap,bool selectAll = false}) {
//   return InkWell(
//     onTap: onTap,
//     child: Container(
//       height: fontSizeMini38 * 3,
//       child: Row(
//         children: [
//           selectAll
//               ? FlyText.main35(
//             '取消全选',
//           )
//               : FlyText.main35(
//             '全部选择',
//           ),
//         ],
//       ),
//     ),
//   );
// }