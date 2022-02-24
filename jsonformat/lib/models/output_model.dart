
import 'model_convert.dart';

class OutputModel {
  FormatLanguage la;

/// 有些语言分为头文件和实现文件，如ObjectiveC，
/// 像dart和swift就没有头文件，他们只有一个实现文件
  String? header;
  String impl;

  OutputModel(this.la, this.impl, {this.header});

  @override
  String toString() {
    String output = '============ ${languageEnumToString(la)} =========>\n';
    if (header != null) {
      output += 'header =>\n';
      output += header!;
    }
    output += '\n';
    output += 'impl =>\n';
    output += impl;
    output += '\n=====================================';
    return output;
  }
}