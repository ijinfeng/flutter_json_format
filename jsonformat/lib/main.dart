import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:jsonformat/views/json_input_window.dart';
import 'package:jsonformat/views/main_toolbar_window.dart';
import 'package:jsonformat/views/json_format_output_window.dart';
import 'package:jsonformat/views/output_toolbar_view.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(600, 500);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Json Format";
    appWindow.show();
  });
}

Color _mainColor = Colors.blueGrey;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        body: WindowBorder(
          child: Column(
          children: [
            _WindowTopBox(),
            Padding(
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [TopLeftJsonInputSide(), TopRightToolBarSide()],
            ),
            padding: const EdgeInsets.only(top: 16),
            ),
            Divider(color: _mainColor,),
            BottomOutputSide(),
            BottomOutputLogToolBarView()
          ],
        ), 
          color: Colors.blueGrey
          ),
      ),
    );
  }
}

class _WindowTopBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget current;

    current = WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(
            child:
            Container(color: _mainColor, child: MoveWindow(),),),
          _WindowButtons(),
        ],
      ),
    );

    return current;
  }
}

class _WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return Row(
  children: [
    CloseWindowButton(),
    MinimizeWindowButton(),
    MaximizeWindowButton(),
  ],
);
    
  }
}

