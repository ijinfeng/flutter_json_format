import 'package:flutter/material.dart';

class JSONOutputWindow extends StatelessWidget {
const JSONOutputWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Widget current = const TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 999,
        decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
      );

    current = Container(
      padding: const EdgeInsets.only(left: 8, bottom: 0,right: 16),
      child: current,
    );

  current = Expanded(child: current);

    return current;
    
  }
  
}