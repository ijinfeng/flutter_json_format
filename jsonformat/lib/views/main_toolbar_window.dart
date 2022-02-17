

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:jsonformat/views/filedrag_view.dart';
import 'main_style_button.dart';

enum FormatLanguage { dart, objectiveC, swift }

String languageEnumToString(FormatLanguage la) {
  String ret = "";
  switch (la) {
    case FormatLanguage.dart:
      ret = "dart";
      break;
    case FormatLanguage.objectiveC:
      ret = "OC";
      break;
    case FormatLanguage.swift:
      ret = "swift";
      break;
  }
  return ret;
}

/// 右侧工具菜单栏
class TopRightToolBarSide extends StatelessWidget {
  FormatLanguage la = FormatLanguage.dart;

  /// 自动修复指json格式不正确时，sdk将根据json格式自动为其补偿确实的内容，如“”，{}等
  bool autoFix = false;

  @override
  Widget build(BuildContext context) {
    Widget current;

// 文件选择区域
    current = FileDargView();

// 分割线
    Widget seperateLine = const Divider(
      endIndent: 10,
      indent: 10,
    );

    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 15,
    );

    Widget space = const SizedBox(
      height: 10,
    );

    Widget dectorJSONButton = MainStyleButton(
        onPressed: () {},
        child: Text(
          'JSON探测',
          style: textStyle,
        ));

// 格式化
    Widget formatButton = MainStyleButton(
        onPressed: () {},
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
    _DropDownMenu menu = _DropDownMenu(la);
    Widget convertButton = MainStyleButton(
        onPressed: () {
          la = menu.la;
          print("当前选择的语言类型为：${languageEnumToString(la)}");
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

    current = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        current,
        const SizedBox(
          height: 10,
        ),
        seperateLine,
        const SizedBox(
          height: 10,
        ),
        buttons
      ],
    );

    current = SizedBox(
      width: 220,
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

  void showTip(BuildContext context, PointerHoverEvent event) {
    Widget entry = const Text(
      '自动修复指输入的JSON格式不正确时，工具将根据正确的JSON格式自动为其补其确实内容。如“”、{}、:等',
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
      right: 20,
      top: 160,
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
            showTip(context, PointerHoverEvent());
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


