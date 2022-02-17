
import 'package:flutter/material.dart';

/// Json输入框
class TopLeftJsonInputSide extends StatelessWidget {
  const TopLeftJsonInputSide({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {

// json 输入框
    Widget current = const TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 15,
        decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
      );

    current = Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: current,
    );

  current = Expanded(child: current);

    return current;
  }
}