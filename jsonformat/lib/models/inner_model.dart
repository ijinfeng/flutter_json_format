const String innerModelClassName = 'ReplaceClassModel';

class InnerModel {
  /// 名称，当为对象时，就是类型
  final String name;
  /// 类型，当类型为非对象模型时，如‘String’，那么属性只有一条为这个String
  InnerType type = InnerType.nil;
  /// 属性列表
  List<InnerProperty>? propertys;

  InnerModel(this.name, dynamic data, {String suggestClassName = innerModelClassName}) {
    if (data is Map) {
      type = InnerType.object;
      List<InnerProperty> propertys = [];
      for (var e in data.entries) {
        String key = e.key;
        dynamic value = e.value;
        InnerProperty property = InnerProperty(key, value, suggestClassName: suggestClassName + '_$key');
        propertys.add(property);
      }
      this.propertys = propertys;
    } else if (data is List) {
      type = InnerType.list;
      List<InnerProperty> propertys = [];
      for (var e in data) {
        InnerProperty property = InnerProperty('', e, suggestClassName: suggestClassName);
        propertys.add(property);
      }
      this.propertys = propertys;
    } else if (data is String) {
      propertys = [InnerProperty('', data)];
    } else if (data is num) {
      propertys = [InnerProperty('', data)];
    } else if (data is bool) {
      propertys = [InnerProperty('', data)];
    } else {
      propertys = [InnerProperty('', data)];
    }
  }
}

enum InnerType {
  /// null
  nil,
  bool,
  int,
  double,
  string,
  list,
  object,
}

class InnerProperty {
  InnerType type = InnerType.nil;
  dynamic value;
  String name;
  bool optional;
  InnerModel? subModel;

  InnerProperty(this.name, dynamic value, {String suggestClassName = innerModelClassName, this.optional = true}) {
    if (value is Map) {
      type = InnerType.object;
    } else if (value is List) {
      type = InnerType.list;
    } else if (value is String) {
      type = InnerType.string;
    } else if (value is num) {
      num n = value;
      if (n.toInt() == n) {
        type = InnerType.int;
      } else {
        type = InnerType.double;
      }
      type = InnerType.int;
      optional = false;
    } else if (value is bool) {
      type = InnerType.bool;
      optional = false;
    } else {
      // null
      type = InnerType.nil;
    }
    this.value = _parseValue(value, suggestClassName: suggestClassName);

    // search sub model is exists
    if (type == InnerType.list) {
      dynamic innerItem = this.value;
      while (innerItem is List && innerItem.isNotEmpty) {
          innerItem = innerItem.first;
      }
      if (innerItem is InnerModel) {
        subModel = innerItem;
      }
    } else if (type == InnerType.object) {
      subModel = this.value;
    }
    print("submodel--- ${subModel?.name}");
  }

  dynamic _parseValue(dynamic value, {String suggestClassName = innerModelClassName}) {
    if (value is Map) {
      return InnerModel(suggestClassName, value, suggestClassName: suggestClassName);
    } else if (value is List) {
      List arr = value;
      if (arr.isNotEmpty) {
        dynamic first = arr.first;
        if (first is Map || first is List) {
          List values = [];
          for (var item in arr) {
            dynamic itemValue = _parseValue(item, suggestClassName: suggestClassName);
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
