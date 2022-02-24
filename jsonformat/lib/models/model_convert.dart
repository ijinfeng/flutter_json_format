import 'output_model.dart';
import 'string_extension_json.dart';
import 'dart:convert';

const String _className = 'OutputClassModel';

class ModelConvert {
  OutputModel? convert(FormatLanguage la, String? json) {
    if (!json.isJSON) return null;

    var data = jsonDecode(json!);

    OutputModel model = _convertJson(la, data);
    print(model.toString());
    return model;
  }

  OutputModel _convertJson(FormatLanguage la, dynamic data) {
    if (data is Map) {
      _InnerModel model = _InnerModel(_className, data);
      _Reader reader = _createReader(model, la);
      String? header = reader.readHeader();
      String impl = reader.readImpl();
      return OutputModel(la, impl, header: header);
    } else {
      return OutputModel(la, data.toString());
    }
  }

  _Reader _createReader(_InnerModel model, FormatLanguage la) {
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

class _InnerModel {
  /// 名称，当为对象时，就是类型
  final String name;
  /// 类型，当类型为非对象模型时，如‘String’，那么属性只有一条为这个String
  _InnerType type = _InnerType.unknow;
  /// 属性列表
  List<_InnerProperty>? propertys;

  _InnerModel(this.name, dynamic data) {
    if (data is Map) {
      type = _InnerType.object;
      List<_InnerProperty> propertys = [];
      for (var e in data.entries) {
        String key = e.key;
        dynamic value = e.value;
        _InnerProperty property = _InnerProperty(key, value);
        propertys.add(property);
      }
      this.propertys = propertys;
    } else if (data is List) {
      type = _InnerType.list;
      List<_InnerProperty> propertys = [];
      for (var e in data) {
        _InnerProperty property = _InnerProperty('', e);
        propertys.add(property);
      }
      this.propertys = propertys;
    } else if (data is String) {
      propertys = [_InnerProperty('', data)];
    } else if (data is num) {
      propertys = [_InnerProperty('', data)];
    } else if (data is bool) {
      propertys = [_InnerProperty('', data)];
    } else {}
  }
}

enum _InnerType {
  unknow,
  bool,
  int,
  double,
  string,
  list,
  object,
}

class _InnerProperty {
  _InnerType type = _InnerType.unknow;
  dynamic value;
  String name;
  bool optional;

  _InnerProperty(this.name, dynamic value, {this.optional = true}) {
    if (value is Map) {
      type = _InnerType.object;
    } else if (value is List) {
      type = _InnerType.list;
    } else if (value is String) {
      type = _InnerType.string;
    } else if (value is num) {
      num n = value;
      if (n.toInt() == n) {
        type = _InnerType.int;
      } else {
        type = _InnerType.double;
      }
      type = _InnerType.int;
      optional = false;
    } else if (value is bool) {
      type = _InnerType.bool;
      optional = false;
    } else {
      // null
      type = _InnerType.unknow;
    }
    this.value = _parseValue(value);
  }

  dynamic _parseValue(dynamic value, {int deepth = 0}) {
    if (value is Map) {
      return _InnerModel('Model$deepth', value);
    } else if (value is List) {
      List arr = value;
      if (arr.isNotEmpty) {
        dynamic first = arr.first;
        if (first is Map || first is List) {
          List values = [];
          for (var item in arr) {
            dynamic itemValue = _parseValue(item, deepth: deepth + 1);
            values.add(itemValue);
          }
          return values;
        } else {
          return value;
        }
      } else {
        return value;
      }
    } else {
      return value;
    }
  }
}

abstract class _Reader {
  final _InnerModel _model;
  final FormatLanguage _la;

  _Reader(this._model, this._la);

  String? readHeader();
  String readImpl();
}

class _DartReader extends _Reader {
  _DartReader(_InnerModel model) : super(model, FormatLanguage.dart);

  @override
  String? readHeader() => null;

  @override
  String readImpl() {
    String output = '';
    if (_model.type == _InnerType.object) {
        output = _parseModel(_model);
    } 
    return output;
  }

  String _parseModel(_InnerModel model) {
    String output = '';
    const String wrap = '\n';
    output += 'class ${model.name} {';
    // 嵌套的模型
    List<_InnerModel> nestModels = [];
    if (model.propertys != null) {
      for (var property in model.propertys!) {
        if (property.value is _InnerModel) {
          nestModels.add(property.value);
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
  String _parseProperty(_InnerProperty property) {
      String output = '';
      const String space = '\t';
      switch (property.type) {
        case _InnerType.bool: {
          output += space;
          if (property.optional) {
            output += 'bool? ${property.name};';
          } else {
            output += 'bool ${property.name} = false;';
          }
        }
        break;
        case _InnerType.int: {
          output += space;
          if (property.optional) {
            output += 'int? ${property.name};'; 
          } else {
            output += 'int ${property.name} = 0;'; 
          }
        }
        break;
        case _InnerType.double: {
          output += space;
          if (property.optional) {
            output += 'double? ${property.name};'; 
          } else {
            output += 'double ${property.name} = 0.0;'; 
          }
        } break;
        case _InnerType.string: {
          output += space;
          if (property.optional) {
            output += 'String? ${property.name};'; 
          } else {
            output += "String ${property.name} = '';"; 
          }
        } break;
        case _InnerType.list: {
          output += space;
          List arr = property.value;
          String nameT = '';
          if (arr.isNotEmpty) {
            String t = arr.first.runtimeType.toString();
            print("hehe--$t");
            nameT = '<$t>';
          }
          if (property.optional) {
            output += 'List$nameT? ${property.name};'; 
          } else {
            output += 'List$nameT ${property.name} = [];'; 
          }
        } break;
        case _InnerType.object: {
          output += space;
          _InnerModel _model = property.value;
          if (property.optional) {
            output += '${_model.name}? ${property.name};'; 
          } else {
            output += "$_model.name ${property.name} = ${_model.name}();"; 
          }
        } break;
        default:
        break;
      }
      return output;
  }
}

class _SwiftReader extends _Reader {
  _SwiftReader(_InnerModel model) : super(model, FormatLanguage.swift);

  @override
  String? readHeader() => null;

  @override
  String readImpl() {
    // TODO: implement readImpl
    throw UnimplementedError();
  }
}

class _ObjectiveCReader extends _Reader {
  _ObjectiveCReader(_InnerModel model)
      : super(model, FormatLanguage.objectiveC);

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
