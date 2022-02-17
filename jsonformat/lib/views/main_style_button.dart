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

    );

    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
       child: child,
       style: style,
       );
  }
}
