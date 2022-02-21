/*
 * @Author: your name
 * @Date: 2022-02-20 10:36:45
 * @LastEditTime: 2022-02-20 11:17:05
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

    // 1. 看下最外层是[]还是{}
    var _json = json!;
    // var first = _json.first!;
    // print("first== ${first}");
    var data = jsonDecode(_json);
    if (data is Map) {
print("+++++map");
    } else if (data is Array) {
print("+++++array");
    } else if (data is String) {
print("+++++string");
    } else if (data is num) {
print("+++++num");
    } else {
print("+++++null");
    }

    return _json;
  }
}

