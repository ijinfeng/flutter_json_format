/*
 * @Author: your name
 * @Date: 2022-02-18 22:28:06
 * @LastEditTime: 2022-02-20 10:54:49
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /jsonformat/lib/models/json_manager.dart
 */
import 'dart:convert';

import 'package:jsonformat/models/json_file.dart';
import 'output_serializer.dart';
import 'string_extension_json.dart';
import 'output_manager.dart';

// dart json转换文档
// https://dart.cn/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more

/// json管理类（单利）
class JSONManager {
  JSONManager._instance();
  static final JSONManager _manager = JSONManager._instance();
  factory JSONManager() => _manager;

  FormatJSONOutputSerializer _outputSerializer = FormatJSONOutputSerializer();

  // json文件操作
  JSONFile? _file;
  void setFile(JSONFile? file) => _file = file;
  JSONFile? get file => _file;
  void deleteFile() => _file = null;

  /// 输入框中的json
  String? inputJSON;

  /// 是否有输入json
  bool get hasInputJSON {
    return inputJSON?.isNotEmpty ?? false;
  }

  /// 输入的是否为json格式
  bool get isJSON {
    bool hasJson = hasInputJSON;
    if (!hasJson) return false;
    return inputJSON.isJSON;
  }

  /// 自动修正JSON
  bool autoFixJSON = false;

/// 格式化
  void format() {
    String? format_json;

    if (!autoFixJSON) {
      if (!isJSON) return;
      format_json = _outputSerializer.format(inputJSON);
    } else {
      format_json = _outputSerializer.format(_fixJSON(inputJSON));
    }
    
    // 将格式化之后的数据传递给输出窗口
    OutputManager().write(format_json);
  }
}


extension JSONHelper on JSONManager {
  /// 修正输入json格式
  String? _fixJSON(String? json) {
    bool isJSON = json.isJSON;
    if (isJSON) return json;

    // TODO: json修正

  // 1、移除特殊字符

    return json;
  }
}
