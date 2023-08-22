import 'package:flutter/material.dart';

class LogoBox extends StatelessWidget {
  const LogoBox({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
