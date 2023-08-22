import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key? key,
    required this.child,
    this.color = Colors.blue,
    required this.onPressed,

  }) : super(key: key);

  final Widget child;
  final Color color;
  final double borderRadius = 15.0;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(color),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    )),
    ),
    onPressed: onPressed,
    child: child,
    );
  }
}
