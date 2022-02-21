
import 'package:flutter/material.dart';

class RichTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    print("改变了");
    return TextSpan(
style: style,
children: <TextSpan>[
  TextSpan(
    text: value.text
  )
]
    );
  }
}