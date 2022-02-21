import 'package:flutter/material.dart';

/// 管理输出窗口
class OutputManager with ChangeNotifier {
  OutputManager._instance();
  static final OutputManager _manager = OutputManager._instance();
  factory OutputManager() => _manager;

  String? _outputText;

  void write(String? output) {
    _outputText = output;
    notifyListeners();
  }

  String? get readOutput {
    return _outputText; 
  }
}