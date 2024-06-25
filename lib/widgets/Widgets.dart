import 'package:flutter/material.dart';

import '../constants/Constants.dart';

class TopSnackBar extends StatelessWidget {
  final String message;

  const TopSnackBar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Container(
      padding: Constants.paddingMedium,
      decoration: const BoxDecoration(
        color: Constants.primaryRed,
        borderRadius: Constants.borderRadiusSmall,
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
