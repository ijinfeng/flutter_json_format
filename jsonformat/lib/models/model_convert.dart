import 'output_model.dart';
import 'string_extension_json.dart';
import 'dart:convert';

import 'inner_model.dart';

class ModelConvert {
  OutputModel? convert(FormatLanguage la, String? json) {
    if (!json.isJSON) return null;

    var data = jsonDecode(json!);

    OutputModel model = _convertOutput(la, data);
    // print(model.toString());
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

  /// \n
  static String wrap = '\n';

  /// \t
  static String space = '\t';

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
    output += wrap * 2;
    // constructor api
    output += '${model.name}();';
    // json api
    output += wrap * 2;
    output += _parseFromJsonApi(model);
    output += wrap * 2;
    output += _parseToJsonApi(model);
    output += wrap;
    output += '}';
    if (nestModels.isNotEmpty) {
      for (var model in nestModels) {
        output += wrap * 2;
        output += _parseModel(model);
      }
    }
    return output;
  }

  String _parseProperty(InnerProperty property) {
    String output = '';
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
              t = 'List<$t>';
              if (inner.isNotEmpty) {
                inner = inner.first;
              }
            }
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
      case InnerType.nil:
        {
          output += space;
          output += "dynamic ${property.name};";
        }
        break;
      default:
        break;
    }
    return output;
  }

  /*
 class MyTestModel {
  String? aa;
  int a = 0;
  SubModel? sub;
  List<SubModel>? ss;
  List<List<SubModel>>? subs;

  MyTestModel();

  void fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    aa = json['aa'];
    a = json['a'] ?? 0;
    sub = SubModel()..fromJson(json['a']);
    ss = (json[ss] as List).map((e) => SubModel()..fromJson(e)).toList();
    subs = (json[subs] as List)
        .map((e) => (e as List).map((e) => SubModel()..fromJson(e)).toList())
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'aa': aa,
      'a': a,
      'sub': sub?.toJson(),
      'ss': ss?.map((e) => e.toJson()).toList(),
      'subs': subs?.map((e) => e.map((e) => e.toJson()).toList()).toList()
    };
  }
}

class SubModel {
  void fromJson(Map<String, dynamic>? json) {}
  Map<String, dynamic> toJson() => {};
}
  */

  String _parseFromJsonApi(InnerModel model) {
    String output = 'void fromJson(Map<String, dynamic>? json) {';
    output += wrap;
    output += space + 'if (json == null) return;';
    if (model.propertys != null) {
      for (var property in model.propertys!) {
        output += wrap;
        output += space;
        if (property.type == InnerType.object) {
          assert(property.subModel != null);
          output +=
              "${property.name} = ${property.subModel?.name}()..fromJson(Map<String, dynamic>.from(json['${property.name}']));";
        } else if (property.type == InnerType.list) {
          if (property.subModel != null) {
            List _list = property.value;
            if (_list.isNotEmpty) {
              output += "${property.name} = (json['${property.name}'] as List)";
              output += '.map((e) => ';
              dynamic first = _list.first;
              String append = '';
              while (first is List) {
                output += '(e as List).map((e) => ';
                append += ').toList()';
                first = first.first;
              }
              if (first is InnerModel) {
                output += '${first.name}()..fromJson(e)';
              }
              output += append;
              output += ').toList();';
            } 
          } else {
            output += "${property.name} = json['${property.name}']" + (property.optional ? '' : ' ?? ') + ';';
          }
        } else {
          output += "${property.name} = json['${property.name}']";
          if (property.optional) {
            switch (property.type) {
              case InnerType.bool:
                {
                  output += ' ?? false';
                }
                break;
              case InnerType.int:
              case InnerType.double:
                {
                  output += ' ?? 0';
                }
                break;
              case InnerType.string:
                {
                  output += " ?? ''";
                }
                break;
              case InnerType.list:
                {
                  output += ' ?? []';
                }
                break;
              default:
                break;
            }
          }
          output += ';';
        }
      }
    }
    output += wrap;
    output += '}';
    return output;
  }

  String _parseToJsonApi(InnerModel model) {
    String output = 'Map<String, dynamic> toJson() {';
    output += wrap;
    output += 'return {';
    if (model.propertys != null) {
      for (var property in model.propertys!) {
        output += wrap;
        output += space;
        switch (property.type) {
          case InnerType.object: {
            output += "'${property.name}': ${property.name}${property.optional ? '?':''}.toJson(),";
          } break;
          case InnerType.list: {
            if (property.subModel != null) {
              output += "'${property.name}': ${property.name}${property.optional ? '?':''}.map((e) => ";
              List arr = property.value;
              if (arr.isNotEmpty) {
                dynamic first = arr.first;
                String append = '';
                while (first is List) {
                  first = first.first;
                  output += 'e.map((e) => ';
                  append += ').toList()';
                }
                if (first is InnerModel) {
                  output += 'e.toJson()';
                }
                output += append;
              }
              output += ').toList(),';
            } else {
              output += "'${property.name}': ${property.name},";  
            }
          } break;
          default: {
            output += "'${property.name}': ${property.name},";
          } break;
        }
      }
      output += wrap;
    }
    output += '};';
    output += wrap;
    output += '}';
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
