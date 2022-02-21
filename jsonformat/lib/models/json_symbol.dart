import 'dart:ui';

import 'package:flutter/material.dart';

abstract class JSONSymbol {
  String get value;
  Color get formatColor;

  const JSONSymbol();
}

/// 引号
class Quotation extends JSONSymbol {
  @override
  Color get formatColor => Colors.orange;
  @override
  String get value => "\"";

  const Quotation();
}

/// 逗号
class Comma extends JSONSymbol {
  @override
  Color get formatColor => Colors.black;

  @override
  String get value => ",";
}

/// 中括号
class SquareBrackets {
  JSONSymbol get left => const _LeftSquareBrackets();
  JSONSymbol get right => const _RightSquareBrackets();

  const SquareBrackets();
}

class _LeftSquareBrackets extends JSONSymbol {
  @override
  Color get formatColor => Colors.black;

  @override
  String get value => "[";

  const _LeftSquareBrackets();
}

class _RightSquareBrackets extends JSONSymbol {
  @override
  Color get formatColor => Colors.black;

  @override
  String get value => "]";

  const _RightSquareBrackets();
}

/// 花括号
class Brace {
  JSONSymbol get left => const _LeftBrace();
  JSONSymbol get right => const _RightBrace();

  const Brace();
}

class _LeftBrace extends JSONSymbol {
  @override
  Color get formatColor => Colors.black;

  @override
  String get value => "{";

  const _LeftBrace();
}

class _RightBrace extends JSONSymbol {
  @override
  Color get formatColor => Colors.black;

  @override
  String get value => "}";

  const _RightBrace();
}
