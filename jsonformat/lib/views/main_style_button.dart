import 'package:flutter/material.dart';

class MainStyleButton extends StatelessWidget {
  const MainStyleButton({
    Key? key,
    this.onPressed,
    this.child,
    this.disabled = false}
  ) : super(key: key);

  final VoidCallback? onPressed;

  final Widget? child;

  final bool disabled;

  @override
  Widget build(BuildContext context) {

    ButtonStyle? style;

    style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(disabled ? Colors.black12 : Colors.blueGrey)
    );

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
       child: child,
       style: style,
       );
  }
}
