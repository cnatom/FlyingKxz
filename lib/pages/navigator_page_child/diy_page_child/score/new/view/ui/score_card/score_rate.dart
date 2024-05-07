import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_kxz/ui/config.dart';
import 'package:flying_kxz/ui/text.dart';
import 'package:flying_kxz/ui/theme.dart';
import 'package:provider/provider.dart';

import 'score_card.dart';

enum ScoreRateChipType{
  rate,
  other
}

class ScoreRateView extends StatefulWidget {
  const ScoreRateView({Key? key,required this.onRateChange,this.initRate = 1.0}) : super(key: key);
  final ScoreCardRateChange onRateChange;
  final double initRate;

  @override
  State<ScoreRateView> createState() => _ScoreRateViewState();
}

class _ScoreRateViewState extends State<ScoreRateView> {
  late ThemeProvider themeProvider;
  TextEditingController rateController = TextEditingController();
  FocusNode rateFocusNode = FocusNode();
  late double rateResult;
  int curIndex = 0;

  // 确保在排序过程中倍率界面能够相应地调整
  initRateResult(){
    rateResult = widget.initRate;
    if(rateResult != 1.0 && rateResult != 1.2){
      curIndex = 2;
      rateController.text = rateResult.toString();
    }else{
      curIndex = rateResult == 1.0 ? 0 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    initRateResult();
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: themeProvider.colorMain.withOpacity(0.10),
          borderRadius: BorderRadius.circular(borderRadiusValue)
      ),
      child: Row(
        children: [
          buildRateButton(rate: 1.0, index: 0),
          buildRateButton(rate: 1.2, index: 1),
          buildCustomRateInput(index: 2)
        ],
      ),
    );
  }

  // 1.0倍 1.2倍 按钮
  Widget buildRateButton({required double rate,required int index}) {
    return buildChip(
        child: FlyText.title45(rate.toString(), color: getTextColor(index)),
        onTap: () {
          setState(() {
            curIndex = index;
            rateResult = rate;
            widget.onRateChange.call(rateResult);
          });
        },
        index: index
    );
  }

  // 自定义倍数输入按钮
  Widget buildCustomRateInput({required int index}) {
    return buildChip(
        child: TextField(
          controller: rateController,
          focusNode: rateFocusNode,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: getTextColor(index),
              fontSize: fontSizeTitle45
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            NonZeroDigitInputFormatter(),
          ],
          decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(0),
              hintText: "自定义",
              hintStyle: TextStyle(
                  color: getTextColor(index),
                  fontSize: fontSizeTitle45
              )
          ),

          onTap: (){
            if(rateController.text.isEmpty){
              rateController.text = '1.4';
            }
            rateController.selection = TextSelection.fromPosition(TextPosition(offset: rateController.text.length));
            rateResult = double.parse(rateController.text);
            widget.onRateChange?.call(rateResult);
            curIndex = index;
            setState(() {});
            rateFocusNode.unfocus();
            Future.delayed(Duration(milliseconds: 300), () {
              rateFocusNode.requestFocus();
            });
          },
          onChanged: (value) {
            rateResult = double.parse(value);
            widget.onRateChange.call(rateResult);
          },
        ),
        index: index
    );
  }

  Widget buildChip({Widget child, GestureTapCallback onTap, int index}) {
    return Expanded(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: InkWell(
            key: Key((curIndex == index).toString()),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: spaceCardPaddingTB / 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: curIndex == index ? themeProvider.colorMain : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadiusValue)
              ),
              child: child,
            ),
          ),
        )
    );
  }

  Color getTextColor(int index) => curIndex == index ? Colors.white : themeProvider.colorMain;

}

class NonZeroDigitInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final double intValue = double.tryParse(newValue.text);
    if (intValue == null || intValue < 0) {
      return oldValue;
    }
    return newValue;
  }
}
