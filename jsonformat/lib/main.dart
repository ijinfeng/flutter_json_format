import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:bitsdojo_window/bitsdojo_window.dart';

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
            Row(
              children: [_TopLeftJsonInputSide(), _TopRightToolBarSide()],
            ),
            Divider(color: _mainColor,),
            _BottomOutputSide()
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

class _TopLeftJsonInputSide extends StatelessWidget {
@override
  Widget build(BuildContext context) {

// json 输入框
    Widget current = const TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 15,
        decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
      );

    current = Container(
      padding: const EdgeInsets.all(16),
      child: current,
    );

  current = Expanded(child: current);

    return current;
  }
}

class _TopRightToolBarSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget current;
    current = SizedBox(
      width: 160,
      child: Container(
        child: Image.asset('assets/pull_input_file.png'),
      ),
    );
    return current;
  }
}

class _BottomOutputSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
    
  }
  
}