import 'output_model.dart';
import 'string_extension_json.dart';
import 'dart:convert';

import 'inner_model.dart';

class ModelConvert {
  OutputModel? convert(FormatLanguage la, String? json) {
    if (!json.isJSON) return null;

    var data = jsonDecode(json!);

    OutputModel model = _convertOutput(la, data);
    print(model.toString());
    return model;
  }

  InnerModel? convertInnerModel(FormatLanguage la, String? json) {
    if (!json.isJSON) return null;

    var data = jsonDecode(json!);
    if (data is Map) {
      InnerModel model = InnerModel(innerModelClassName, data);
      return model;
    } else {
      return null;
    }
  }

  OutputModel _convertOutput(FormatLanguage la, dynamic data) {
    if (data is Map) {
      InnerModel model = InnerModel(innerModelClassName, data);
      _Reader reader = _createReader(model, la);
      String? header = reader.readHeader();
      String impl = reader.readImpl();
      return OutputModel(la, impl, header: header);
    } else {
      return OutputModel(la, data.toString());
    }
  }

  _Reader _createReader(InnerModel model, FormatLanguage la) {
    _Reader reader;
    if (la == FormatLanguage.dart) {
      reader = _DartReader(model);
    } else if (la == FormatLanguage.swift) {
      reader = _SwiftReader(model);
    } else {
      reader = _ObjectiveCReader(model);
    }
    return reader;
  }
}

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

abstract class _Reader {
  final InnerModel _model;
  final FormatLanguage _la;

  _Reader(this._model, this._la);

  String? readHeader();
  String readImpl();
}

class _DartReader extends _Reader {
  _DartReader(InnerModel model) : super(model, FormatLanguage.dart);

  @override
  String? readHeader() => null;

  @override
  String readImpl() {
    String output = '';
    if (_model.type == InnerType.object) {
      output = _parseModel(_model);
    }
    return output;
  }

  String _parseModel(InnerModel model) {
    String output = '';
    const String wrap = '\n';
    output += 'class ${model.name} {';
    // 嵌套的模型
    List<InnerModel> nestModels = [];
    if (model.propertys != null) {
      for (var property in model.propertys!) {
        if (property.subModel != null) {
          nestModels.add(property.subModel!);
        }
        output += wrap;
        String writePro = _parseProperty(property);
        output += writePro;
      }
    }
    output += wrap;
    output += '}';
    if (nestModels.isNotEmpty) {
      for (var model in nestModels) {
        output += wrap;
        output += _parseModel(model);
      }
    }
    return output;
  }

/*
class TestModel {
  bool isTip = false;

  TestModel();

  void fromJson(String json) {}
  String toJson() => '';
}
*/
  String _parseProperty(InnerProperty property) {
    String output = '';
    const String space = '\t';
    switch (property.type) {
      case InnerType.bool:
        {
          output += space;
          if (property.optional) {
            output += 'bool? ${property.name};';
          } else {
            output += 'bool ${property.name} = false;';
          }
        }
        break;
      case InnerType.int:
        {
          output += space;
          if (property.optional) {
            output += 'int? ${property.name};';
          } else {
            output += 'int ${property.name} = 0;';
          }
        }
        break;
      case InnerType.double:
        {
          output += space;
          if (property.optional) {
            output += 'double? ${property.name};';
          } else {
            output += 'double ${property.name} = 0.0;';
          }
        }
        break;
      case InnerType.string:
        {
          output += space;
          if (property.optional) {
            output += 'String? ${property.name};';
          } else {
            output += "String ${property.name} = '';";
          }
        }
        break;
      case InnerType.list:
        {
          output += space;
          List arr = property.value;
          String nameT = '';
          if (arr.isNotEmpty) {
            dynamic first = arr.first;
            String t;
            if (property.subModel != null) {
              t = property.subModel!.name;
            } else {
              t = arr.first.runtimeType.toString();
            }
            dynamic inner = first;
            while (inner is List) {
              t = '<$t>';
              if (inner.isNotEmpty) {
                inner = inner.first;
              }
            }
            print("hehe--$t");
            nameT = '<$t>';
          }
          if (property.optional) {
            output += 'List$nameT? ${property.name};';
          } else {
            output += 'List$nameT ${property.name} = [];';
          }
        }
        break;
      case InnerType.object:
        {
          output += space;
          InnerModel _model = property.value;
          if (property.optional) {
            output += '${_model.name}? ${property.name};';
          } else {
            output += "$_model.name ${property.name} = ${_model.name}();";
          }
        }
        break;
      default:
        break;
    }
    return output;
  }
}

class _SwiftReader extends _Reader {
  _SwiftReader(InnerModel model) : super(model, FormatLanguage.swift);

  @override
  String? readHeader() => null;

  @override
  String readImpl() {
    // TODO: implement readImpl
    throw UnimplementedError();
  }
}

class _ObjectiveCReader extends _Reader {
  _ObjectiveCReader(InnerModel model) : super(model, FormatLanguage.objectiveC);

  @override
  String? readHeader() {
    // TODO: implement readHeader
    throw UnimplementedError();
  }

  @override
  String readImpl() {
    // TODO: implement readImpl
    throw UnimplementedError();
  }
}
