import 'package:flutter/material.dart';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

import 'package:jsonformat/models/json_file.dart';
import 'package:jsonformat/models/json_manager.dart';
import 'package:jsonformat/models/log_message.dart';
import 'main_style_button.dart';

/// 文件拖拽区域。拖拽窗口+文件操作的三个按钮
class FileDargView extends StatefulWidget {
  bool mouseHover = false;

  @override
  State<StatefulWidget> createState() {
    return _FileDargViewState();
  }
}

class _FileDargViewState extends State<FileDargView> {
  Future<String?> readFile(JSONFile? jsonFile) async {
    if (jsonFile == null) return null;
    try {
      File file = File(jsonFile.path);
      return await file.readAsString();
    } catch (error) {
      if (error.toString().isEmpty) {
        LogManager().write(const LogMessage('文件解析错误', level: LogLevel.error));
      } else {
        LogManager().write(LogMessage(error.toString(), level: LogLevel.error));
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget current;

    bool existFile = JSONManager().file != null;
    // 存在文件时，读取文件内容
    if (existFile) {
      readFile(JSONManager().file).then((value) {
        // print("读取文件内容--->\n$value");
        JSONManager().inputJSON = value;
        // 文件读取完毕，需要刷新内容
        JSONManager().reloadData();
      });
    }

    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    );

    Widget space = const SizedBox(
      height: 7,
    );
    // 选择文件按钮
    Widget selectFileButton = MainStyleButton(
        onPressed: () {
          Future<FilePickerResult?> result = FilePicker.platform.pickFiles();
          result.then((value) {
            if (value != null && value.count > 0) {
              JSONFile file = JSONFile.pickFile(value.files.first);
              JSONManager().setFile(file);
              setState(() {});
            }
          });
        },
        child: Text(
          '选择文件',
          style: textStyle,
        ));

// 重新读取文件内容
    Widget resetButton = MainStyleButton(
      onPressed: () {
        if (JSONManager().file != null) {
          readFile(JSONManager().file).then((value) {
            JSONManager().inputJSON = value;
            // 文件读取完毕，需要刷新内容
            JSONManager().reloadData();
            LogManager().writeMessage('重新读取数据');
          });
        }
      },
      child: Text(
        '重新读取',
        style: textStyle,
      ),
      disabled: !existFile,
    );

    // 删除
    Widget deleteButton = MainStyleButton(
      onPressed: () {
        setState(() {
          JSONManager().deleteFile();
        });
      },
      child: Text(
        '删除文件',
        style: textStyle,
      ),
      disabled: !existFile,
    );

    List<Widget> buttons = [
      selectFileButton,
      space,
      resetButton,
      space,
      deleteButton
    ];

    current = Column(
      children: buttons,
    );

    double size = 100;

    Widget fileDectorIcon;

    if (existFile) {
      fileDectorIcon = Image.asset('assets/json_icon.jpeg');
    } else {
      fileDectorIcon = const Icon(
        Icons.undo,
        size: 30,
      );

      fileDectorIcon = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          fileDectorIcon,
          const Text(
            '将文件拖入此处',
            style: TextStyle(fontSize: 12),
          )
        ],
      );
    }

    fileDectorIcon = Container(
      child: fileDectorIcon,
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: widget.mouseHover ? Colors.black12 : const Color(0xFFFFFAF0),
          border: Border.all(width: 2, color: Colors.blueGrey)),
    );

    fileDectorIcon = DropTarget(
      child: fileDectorIcon,
      onDragDone: (detail) {
        // List<XFile>
        List<XFile> files = detail.files;
        if (files.isEmpty) return;
        // 读取第一个文件
        XFile file = files.first;
        // print("file >>>> \npath: ${file.path}\nmimeType: ${file.mimeType}\nname: ${file.name}\nlength: ${file.length()}");

        JSONFile json = JSONFile.xfile(file);
        JSONManager().setFile(json);

        setState(() {});
      },
      onDragEntered: (detail) {
        setState(() {
          widget.mouseHover = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          widget.mouseHover = false;
        });
      },
    );

    current = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        fileDectorIcon,
        const SizedBox(
          width: 20,
        ),
        current
      ],
    );

    Widget fileName = Text(JSONManager().file?.name ?? '当前没有文件');

    fileName = SizedBox(
      height: 18,
      child: fileName,
    );

    fileName = Padding(
      padding: const EdgeInsets.only(left: 10),
      child: fileName,
    );

    current = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        current,
        const SizedBox(
          height: 8,
        ),
        fileName
      ],
    );

    return current;
  }
}
