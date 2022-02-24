import 'output_model.dart';
import 'string_extension_json.dart';
import 'dart:convert';

const String _className = 'OutputClassModel';

class ModelConvert {
  OutputModel? convert(FormatLanguage la, String? json) {
    if (!json.isJSON) return null;

    var data = jsonDecode(json!);

    OutputModel model = _convertJson(la, data);
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
  final String name;
  _InnerType type = _InnerType.unknow;
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

  _InnerProperty(this.name, dynamic value) {
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
    } else if (value is bool) {
      type = _InnerType.bool;
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
      dynamic first = arr.first;
      if (first != null) {
        if (first is Map || first is List) {
          List arr = [];
          for (var item in arr) {
            dynamic itemValue = _parseValue(item, deepth: deepth + 1);
            arr.add(itemValue);
          }
          return arr;
        }
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
      // TODO: parse
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
