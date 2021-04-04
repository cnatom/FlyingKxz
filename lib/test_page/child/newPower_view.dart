import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/test_page/component/unit_card.dart';

class NewPowerView extends StatefulWidget {
  @override
  _NewPowerViewState createState() => _NewPowerViewState();
}

class _NewPowerViewState extends State<NewPowerView> {
  @override
  Widget build(BuildContext context) {
    return FlyUnitCard(
      0xe611,
      "宿舍电量",
      "66 度",
      child: Column(
        children: [
          Row(
            children: [

            ],
          ),

        ],
      ),
    );
  }
}
