import 'package:flutter/material.dart';

class BottomOutputSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Widget current = const TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 999,
        decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
      );

    current = Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
      child: current,
    );

  current = Expanded(child: current);

    return current;
    
  }
  
}