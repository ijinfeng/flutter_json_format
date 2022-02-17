
import 'package:flutter/material.dart';

import 'main_style_button.dart';

class BottomOutputLogToolBarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget current;

//日志输出
  Widget log = const Text(
    '日志输出',
    style: TextStyle(color: Colors.white, fontSize: 16),
    );
log = Padding(
  padding: const EdgeInsets.only(left: 16, right: 16),
  child: log,
  );

// 按钮模块
TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
  Widget copyButton = MainStyleButton(onPressed: () {}, child: Text('复制', style: textStyle,));
  Widget exportButton = MainStyleButton(onPressed: () {}, child: Text('导出', style: textStyle,));

  List<Widget> buttons = [
copyButton,
const SizedBox(width: 12,),
exportButton,
  ];

  Widget buttonsWidget = Row(
    children: buttons,
  );

  buttonsWidget = Padding(
    padding: const EdgeInsets.only(right: 16,left: 16),
    child: buttonsWidget,
  );

  current = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      log,
buttonsWidget
    ],

  );


  current = Container(
    color: Colors.orangeAccent[200],
    child: current,
  );

    current = SizedBox(
      height: 35,
      child: current,
    );
    return current;
  }
}