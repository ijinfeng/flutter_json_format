/*
 * @Author: your name
 * @Date: 2022-02-18 22:28:06
 * @LastEditTime: 2022-02-22 22:23:46
 * @LastEditors: your name
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /flutter_json_format/jsonformat/lib/views/output_toolbar_view.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jsonformat/models/json_manager.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'main_style_button.dart';
import 'package:jsonformat/models/log_message.dart';
import 'package:jsonformat/models/output_manager.dart';

class BottomOutputLogToolBarView extends StatelessWidget {
  const BottomOutputLogToolBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget current;

//日志输出
    Widget log = const LogMessageWidget('日志输出');

    log = Padding(
      padding: const EdgeInsets.only(left: 16, right: 0),
      child: log,
    );

    log = Flexible(child: log);

// 按钮模块
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    Widget copyButton = MainStyleButton(
        onPressed: () {
          String? formatJSON = OutputManager().readOutput;
          if (formatJSON == null) return;
          Clipboard.setData(ClipboardData(text: formatJSON));
          LogManager().writeMessage('复制成功');
        },
        child: Text(
          '复制',
          style: textStyle,
        ));
    Widget exportButton = MainStyleButton(
        onPressed: () async {
          if (OutputManager().readOutput == null) {
            LogManager()
                .write(const LogMessage('当前没有输出', level: LogLevel.warn));
            return;
          }
          Directory? downloadDir = await getDownloadsDirectory();
          if (downloadDir != null) {
            String createDirPath = downloadDir.path;
            print("path= ${createDirPath}");
            File file = File(createDirPath + '/my_format_json.json');
            try {
              bool exists = await file.exists();
              if (!exists) {
                print("文件不存在，开始创建文件");
                file = await file.create();
              }
              file.writeAsString(OutputManager().readOutput!);
              LogManager().write(LogMessage("文件已写入 $createDirPath"));
            } catch (error) {
              print("创建文件失败: ${error.toString()}");
              LogManager()
                  .write(LogMessage(error.toString(), level: LogLevel.error));
            }
          }
        },
        child: Text(
          '导出',
          style: textStyle,
        ));

    List<Widget> buttons = [
      copyButton,
      const SizedBox(
        width: 12,
      ),
      exportButton,
    ];

    Widget buttonsWidget = Row(
      children: buttons,
    );

    buttonsWidget = Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: buttonsWidget,
    );

    current = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [log, buttonsWidget],
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
