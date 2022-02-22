import 'package:flutter/material.dart';

import 'output_serializer.dart';

extension TextSpanHelper on TextSpan {
  TextSpan operator +(TextSpan text) {
    return TextSpan(children: [this, text]);
  }

  TextSpan appendString(String? text) {
    if (text == null) return this;
    return TextSpan(children: [this, TextSpan(text: text, style: style)]);
  }
}