/*
 * @Author: your name
 * @Date: 2022-02-18 22:28:06
 * @LastEditTime: 2022-02-20 10:54:49
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /jsonformat/lib/models/json_manager.dart
 */
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:jsonformat/models/json_file.dart';
import 'package:jsonformat/models/model_convert.dart';
import 'output_serializer.dart';
import 'string_extension_json.dart';
import 'output_manager.dart';
import 'package:jsonformat/models/output_manager.dart';
import 'package:jsonformat/models/output_model.dart';
import 'json_repair.dart';

// dart json转换文档
// https://dart.cn/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more

enum JsonProperty {
  num,
  bool,
  string,
  array,
  map,
  object,
}

/// json管理类（单利）
class JSONManager with ChangeNotifier {
  JSONManager._instance();
  static final JSONManager _manager = JSONManager._instance();
  factory JSONManager() => _manager;

  final FormatJSONOutputSerializer _outputSerializer =
      FormatJSONOutputSerializer();
  final ModelConvert _convert = ModelConvert();

  // json文件操作
  JSONFile? _file;

  /// 设置新文件
  void setFile(JSONFile? file) => _file = file;
  JSONFile? get file => _file;
  void deleteFile() => _file = null;

  /// 输入框中的json
  String? inputJSON;

  /// 更新数据源
  void reloadData() => notifyListeners();

  final JSONRepair _repair = JSONRepair();

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
  bool format() {
    if (inputJSON == null) return false;

    String? _formatJson;
    String? _inputJson;
    if (!autoFixJSON) {
      if (!isJSON) return false;
      _inputJson = inputJSON;
    } else {
      _inputJson = _fixJSON(inputJSON);
    }
    _formatJson = _outputSerializer.format(_inputJson);

    // 将格式化之后的数据传递给输出窗口
    OutputManager().inputJSON = _inputJson;
    OutputManager().write(_formatJson);
    return true;
  }

  FormatLanguage la = FormatLanguage.dart;

  /// 转模型
  bool convert() {
    if (JSONManager().hasInputJSON) {
      OutputModel? model =
          _convert.convert(JSONManager().la, JSONManager().inputJSON);
      if (model != null) {
        OutputManager().writeModel(model);
        return true;
      }
    }
    return false;
  }

  /// 是否可以转成模型
  bool get canConvertModel {
    if (isJSON) {
      dynamic json = jsonDecode(inputJSON!);
      if (json is Map) return true;
    }
    return false;
  }

  bool numOptional = true;
  bool boolOptional = true;
  bool stringOptional = true;
  bool arrayOptional = true;
  bool mapOptional = true;
  bool objectOptional = true;

  // 是否所有类型可选
  bool get allOptional =>
      numOptional &&
      boolOptional &&
      stringOptional &&
      arrayOptional &&
      mapOptional &&
      objectOptional;

  // 所有的[int]和[double]都是用[num]类型
  bool allNumUseNumType = true;
}

extension JSONHelper on JSONManager {
  /// 修正输入json格式
  String? _fixJSON(String? json) {
    String? fixJson = _repair.repair(json);
    return fixJson;
  }
}
