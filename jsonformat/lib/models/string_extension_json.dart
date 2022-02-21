/*
 * @Author: your name
 * @Date: 2022-02-20 10:49:06
 * @LastEditTime: 2022-02-20 10:51:09
 * @LastEditors: Please set LastEditors
 * @Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 * @FilePath: /jsonformat/lib/models/string_extension_json.dart
 */

import 'dart:convert';

extension JSONHelper on String? {
  /// 输入字符串是否是JSON
  bool get isJSON {
    if (this == null) return false;
    try {
      jsonDecode(this!);
    } catch (error) {
      print("input is not json: ${error.toString()}");
      return false;
    }
    return true;
  }
}
