import 'package:flutter/material.dart';

import '../constants/style/colors.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.arrow_back,
        color: Constants.secondaryColor,
      ),
    );
  }
}
