import 'package:flutter/material.dart';

import 'package:jsonformat/models/json_manager.dart';

/// Json输入框
class JsonInputWindow extends StatelessWidget {
  const JsonInputWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    controller.addListener(() {
      JSONManager().inputJSON = controller.text;
      print("======>\n${controller.text}");
    });

// json 输入框
    Widget current = TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 999,
      decoration: InputDecoration(
          border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
    );

    current = Container(
      padding: const EdgeInsets.only(left: 16, bottom: 0, right: 8),
      child: current,
    );

    current = Expanded(child: current);

    return current;
  }
}
