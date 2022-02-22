/*
 * @Author: your name
 * @Date: 2022-02-18 22:28:06
 * @LastEditTime: 2022-02-20 11:14:48
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /jsonformat/lib/views/json_format_output_window.dart
 */
import 'package:flutter/material.dart';

import 'package:jsonformat/models/output_manager.dart';
import 'rich_textediting_controller.dart';

class JSONOutputWindow extends StatelessWidget {
  const JSONOutputWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = RichTextEditingController();

    OutputManager().addListener(() {
      if (controller.highlight) {
        // controller.text = OutputManager().inputJSON ?? "";
        controller.text = OutputManager().readOutput ?? "";
      } else {
        controller.text = OutputManager().readOutput ?? "";
      }
    });

    Widget current = TextField(
      controller: controller,
      readOnly: true,
      keyboardType: TextInputType.multiline,
      maxLines: 999,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
    );

    current = Container(
      padding: const EdgeInsets.only(left: 8, bottom: 0, right: 16),
      child: current,
    );

    current = Expanded(child: current);

    return current;
  }
}
