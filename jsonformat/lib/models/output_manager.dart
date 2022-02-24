import 'package:flutter/material.dart';

import 'package:jsonformat/models/output_model.dart';

/// 输出管理
class OutputManager with ChangeNotifier {
  OutputManager._instance();
  static final OutputManager _manager = OutputManager._instance();
  factory OutputManager() => _manager;

  String? _outputText;
  String? inputJSON;
  OutputModel? _outputModel;

  void write(String? output) {
    _outputModel = null;
    _outputText = output;
    notifyListeners();
  }
  void writeModel(OutputModel? model) {
      _outputText = null;
      _outputModel = model;
      notifyListeners();
  }

  List<String?> get readOutput {
    if (isJSONText) return [_outputText];
    List<String?> output = [_outputModel?.impl];
    if (_outputModel?.header != null) {
        output.insert(0, _outputModel?.header);
    }
    return output; 
  }

  OutputModel? get readModel {
    return _outputModel;
  }

  bool get isEmpty {
    return _outputText == null && _outputModel == null;
  }

  bool get isJSONText {
    if (isEmpty) return true;
    if (_outputText == null) return false;
    return true;
  }
}