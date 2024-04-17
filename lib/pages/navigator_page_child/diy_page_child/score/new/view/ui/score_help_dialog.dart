import 'package:flutter/cupertino.dart';
import '../../../../../../../ui/text.dart';


class ScoreHelpDialog extends StatelessWidget {
  const ScoreHelpDialog({Key key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        FlyText.main40(
          '【内网环境】为确保数据安全，请连接学校内的wifi或vpn进行成绩导入\n\n'
              '【加权筛选】"筛选"功能可忽略某些不计入加权的学科成绩\n\n'
              '【加权倍率】按倍率调整成绩与绩点\n\n'
              '【特殊成绩】不同学院年级对于"优秀""良好"等特殊成绩的规定不同，请参照学生手册自行修改对应的学分绩点（点击右上角齿轮）\n\n'
              '【全选操作】点击筛选后还可进行"全选""取消全选"操作，你注意到了吗？\n',
          maxLine: 100,
        ),
        FlyText.miniTip30(
          "仅供参考，出现意外情况开发者概不负责",
          maxLine: 100,
        )
      ],
    );
  }
}
