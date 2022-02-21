/*
 * @Author: your name
 * @Date: 2022-02-20 10:36:45
 * @LastEditTime: 2022-02-21 23:17:02
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /jsonformat/lib/models/output_serial.dart
 */

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'string_extension_json.dart';
import 'json_symbol.dart';

/*
JSON数据类型

1. Number：整数或浮点数
2. String：字符串
3. Boolean：true 或 false
4. Array：数组包含在⽅括号[]中
5. Object：对象包含在⼤括号{}中
6. Null：空类型
*/

class FormatJSONOutputSerializer {
  /*
  input: {"s": "hello", "i": 10}

  output: 
  {
    "s": "hello",
    "i": 10
  }
  */
  String? format(String? json) {
    if (json.isJSON == false) return null;

    print("========> Start format JSON:\n");

    var _json = json!;
    var data = jsonDecode(_json);
    var output = _formatData(data);

    print("$output\n========> End format JSON:\n");
    return output;
  }

  /// json格式化输出
  String _formatData(dynamic data, {String box = '', String space = ''}) {
    if (data is Map) {
      box += "{";
      String endSpace = space;
      space += "\t\t";
      var keys = data.keys.toList();
      for (int i = 0; i < data.length; i++) {
        box += "\n";
        var key = keys[i];
        if (i == data.length - 1) {
          box += space + "\"$key\": " + _formatData(data[key], space: space);
        } else {
          box += space + "\"$key\": " + _formatData(data[key], space: space) + ","; 
        }
      }
      box += "\n";
      box += endSpace + "}";
    } else if (data is List) {
      box += "[";
      String endSpace = space;
      space += "\t\t";
      for (int i = 0; i < data.length; i++) {
        box += "\n";
        var e = data[i];
        if (i == data.length - 1) {
          box += space + _formatData(e, space: space);
        } else {
          box += space + _formatData(e, space: space) + ",";
        }
      }
      box += "\n";
      box += endSpace + "]";
    } else if (data is String) {
      box += "\"$data\"";
    } else if (data is num) {
      box += "$data";
    } else if (data is bool) {
      box += "$data";
    } else {
      box += "null";
    }
    return box;
  }
}
