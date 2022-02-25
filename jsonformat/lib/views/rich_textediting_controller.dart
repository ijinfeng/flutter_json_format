import 'package:flutter/material.dart';
import 'package:jsonformat/models/json_manager.dart';
import 'package:jsonformat/models/output_serializer.dart';
import 'package:jsonformat/models/output_manager.dart';

class RichTextEditingController extends TextEditingController {
  /// 高亮显示
  bool highlight = true;

  /// 是否可折叠。当为`true`时，数组和字典可以折叠
  bool canFold = false;

  /// 格式化富文本
  final FormatJSONOutputSerializer _serializer = FormatJSONOutputSerializer();

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    if (highlight) {
      TextSpan text;
      if (OutputManager().isJSONText) {
        String? input = OutputManager().inputJSON;
        text = _serializer.formatRich(input) ?? const TextSpan();
      } else {
        String? input = JSONManager().inputJSON;
        text = _serializer.formatModelRich(input) ?? const TextSpan();
      }
      return text;
    }
    String json = value.text;
    return TextSpan(text: json, style: style);
  }
}
