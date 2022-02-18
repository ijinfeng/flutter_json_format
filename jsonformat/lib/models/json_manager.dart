import 'dart:convert';

import 'package:jsonformat/models/json_file.dart';
import 'log_message.dart';

// dart json转换文档
// https://dart.cn/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more

/// json管理类（单利）
class JSONManager {
  JSONManager._instance();
  static final JSONManager _manager = JSONManager._instance();
  factory JSONManager() => _manager;

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
    try {
      dynamic ret = jsonDecode(inputJSON!);
      print("ret== ${ret}");
    } catch (error) {
      String? reason;
      reason = error.toString();
      reason ??= "JSON格式不正确";
      LogManager().write(LogMessage(reason, level: LogLevel.error));
        return false;
    }
    return  true;
  }

/// 自动修正JSON
  bool autoFixJSON = false;



}
