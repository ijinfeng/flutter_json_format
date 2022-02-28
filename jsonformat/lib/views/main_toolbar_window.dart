import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:jsonformat/models/json_manager.dart';
import 'package:jsonformat/views/filedrag_view.dart';
import 'main_style_button.dart';
import 'package:jsonformat/models/log_message.dart';
import 'package:jsonformat/models/model_convert.dart';

import 'package:jsonformat/models/json_file.dart';

/// 右侧工具菜单栏
class MainToolBarSide extends StatelessWidget {

  /// 自动修复指json格式不正确时，sdk将根据json格式自动为其补偿确实的内容，如“”，{}等
  bool autoFix = false;

  @override
  Widget build(BuildContext context) {
    Widget current;

    double height = 140;

// 文件选择区域
    current = FileDargView();

// 分割线
    Widget seperateLine = Container(
      color: Colors.black26,
      width: 1,
      height: height - 10,
    );

    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 15,
    );

    Widget space = const SizedBox(
      height: 10,
    );

// 检测是否为JSON格式
    Widget dectorJSONButton = MainStyleButton(
        onPressed: () {
ReplaceClassModel model = ReplaceClassModel();
model.fromJson({
    "a": 10,
    "name": "jack",
    "dic": {
        "bb": false,
        "cc": 0,
        "dd": ["1", "2", "3"],
        "ee": {
            "ty": false,
            "ll": [],
            "uu": {"y": "Hello"}
        }
    },
    "address": "地球村",
    "empty": {},
    "objects": [
        {"x": 1,"y": 2},
        {"x": 2, "y": 3}
    ],
    "kong": null,
    "taowa": [[[{"ni": 0.1, "hao": -0.88}]]]
});
print(model);
          return;
          bool hasJSON = JSONManager().hasInputJSON;
          if (hasJSON) {
            bool isJSON = JSONManager().isJSON;
            if (isJSON) {
              LogManager().writeMessage('JSON格式正确');
            } else {
              LogManager().write(const LogMessage('JSON格式不正确', level: LogLevel.error));
            }
          } else {
            LogManager().writeMessage('没有任何JSON输入');
          }
        },
        child: Text(
          'JSON探测',
          style: textStyle,
        ));

// 格式化
    Widget formatButton = MainStyleButton(
        onPressed: () {
          bool formatSuccess = JSONManager().format();
          formatSuccess ? LogManager().writeMessage("格式化成功") : LogManager().write(const LogMessage("格式化失败", level: LogLevel.error));
        },
        child: Text(
          '格式化',
          style: textStyle,
        ));

    Widget format = Row(
      children: [
        formatButton,
        const SizedBox(
          width: 10,
        ),
        _JSONFormatFixView(autoFix),
      ],
    );

    // 转模型
    _DropDownMenu menu = _DropDownMenu(JSONManager().la);
    Widget convertButton = MainStyleButton(
        onPressed: () {
          JSONManager().la = menu.la;
          print("当前选择的语言类型为：${languageEnumToString(JSONManager().la)}");
          JSONManager().convert();
        },
        child: Text(
          "转模型",
          style: textStyle,
        ));

    Widget convert = Row(
      children: [
        convertButton,
        const SizedBox(
          width: 10,
        ),
        menu
      ],
    );

    Widget buttons = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dectorJSONButton,
        const SizedBox(
          height: 20,
        ),
        format,
        space,
        convert
      ],
    );

    buttons = Padding(
      padding: const EdgeInsets.only(left: 10),
      child: buttons,
    );

    current = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧的按钮
        buttons,
        const SizedBox(
          width: 20,
        ),
        // 中间的分割线
        seperateLine,
        const SizedBox(
          width: 10,
        ),
        // 右侧的文件拖拽
        current
      ],
    );

    current = SizedBox(
      height: height,
      child: Container(
        child: current,
      ),
    );
    return current;
  }
}

class _JSONFormatFixView extends StatefulWidget {
  bool autoFix = false;
  bool showTip = false;

  _JSONFormatFixView(this.autoFix);

  @override
  State<StatefulWidget> createState() {
    return _JSONFormatFixState();
  }
}

class _JSONFormatFixState extends State<_JSONFormatFixView> {
  OverlayEntry? overlay;

  void showTip(BuildContext context, PointerHoverEvent? event) {
    Widget entry = const Text(
      '自动修正指输入的JSON格式不正确时，工具将根据正确的JSON格式自动补全。如“”、{}、:等，或移除多余字符。',
      style: TextStyle(fontSize: 14, color: Colors.black),
    );

    entry = Material(
      child: entry,
    );

    entry = Container(
      child: entry,
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0)]),
    );

    entry = Positioned(
      child: entry,
      left: 20,
      top: 130,
    );

    OverlayEntry overlay = OverlayEntry(
      builder: (_) {
        return entry;
      },
    );
    Overlay.of(context)?.insert(overlay);

    this.overlay = overlay;
  }

  @override
  Widget build(BuildContext context) {
    Widget box = Checkbox(
        value: widget.autoFix,
        onChanged: (value) {
          setState(() {
            widget.autoFix = !widget.autoFix;
            JSONManager().autoFixJSON = widget.autoFix;
          });
        });

    Widget space = const SizedBox(
      width: 2,
    );

    Widget tip = Row(
      children: [
        const Text('自动修正'),
        space,
        const Icon(
          Icons.help,
          size: 18,
        ),
      ],
    );

    // tip = Listener(
    //   child: tip,
    //   onPointerHover: (event) {
    //   // print(event);

    // },);

    tip = InkWell(
      child: tip,
      hoverColor: Colors.white,
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onHover: (value) {
        bool needChangeState = widget.showTip != value;
        if (needChangeState) {
          if (value) {
            // 鼠标在tip上，显示提示
            showTip(context, null);
          } else {
            overlay?.remove();
          }
        }
        widget.showTip = value;
      },
      onTap: () {},
    );

    box = Row(
      children: [box, space, tip],
    );

    return box;
  }
}

// 下拉弹窗选择语言
class _DropDownMenu extends StatefulWidget {
  FormatLanguage la;

  _DropDownMenu(this.la);

  @override
  State<StatefulWidget> createState() {
    return _DropDownMenuState();
  }
}

class _DropDownMenuState extends State<_DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    Widget dropDownMenu = DropdownButton(
        hint: Text(languageEnumToString(widget.la)),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        value: widget.la,
        borderRadius: BorderRadius.circular(8),
        items: [
          DropdownMenuItem(
            child: const Text('Dart'),
            value: FormatLanguage.dart,
            enabled: widget.la != FormatLanguage.dart,
          ),
          DropdownMenuItem(
            child: const Text('ObjectiveC'),
            value: FormatLanguage.objectiveC,
            enabled: widget.la != FormatLanguage.objectiveC,
          ),
          DropdownMenuItem(
            child: const Text('Swift'),
            value: FormatLanguage.swift,
            enabled: widget.la != FormatLanguage.swift,
          ),
        ],
        onChanged: (la) {
          setState(() {
            widget.la = la as FormatLanguage;
          });
        });
    return dropDownMenu;
  }
}
