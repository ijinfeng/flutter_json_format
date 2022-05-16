/*
 * @Author: your name
 * @Date: 2022-02-21 22:11:31
 * @LastEditTime: 2022-02-22 22:51:32
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /flutter_json_format/jsonformat/lib/views/json_input_window.dart
 */
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:jsonformat/models/json_manager.dart';

/// Json输入框
class JsonInputWindow extends StatelessWidget {
  const JsonInputWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    controller.addListener(() {
      ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle())..addText(controller.text);

  pb.addText(controller.text);

  List lines = pb.build().computeLineMetrics();


    print(lines.length);
      JSONManager().inputJSON = controller.text;
    });
    JSONManager().addListener(() {
      if (JSONManager().inputJSON != null) {
        controller.text = JSONManager().inputJSON!;
      }
    });

// json 输入框
    Widget current = TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: 999,
      decoration: const InputDecoration(
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
