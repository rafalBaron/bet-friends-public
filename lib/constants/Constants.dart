import 'package:flutter/material.dart';

class Constants {
  // Kolory
  static const Color primaryWhite = Color(0xFFdbe8f1);
  static const Color lightBlack = Color(0xff464545);
  static const Color primaryRed = Color(0xFFe4010b);
  static const Color primaryBlue = Color(0xFF004ea0);
  static const Color primaryGreen = Color(0xFF00a85d);
  static const Color primaryYellow = Color(0xFFffd600);
  static const Color primaryBlack = Color(0xFF2b2c36);

  // Insets
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24.0);
  static const EdgeInsets listPaddingSmall = EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0);
  static const EdgeInsets listPaddingMedium = EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0);
  static const EdgeInsets listPaddingLarge = EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0);

  // Border Radius
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(16.0));

  static BoxShadow primaryShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: 0.05,
    blurRadius: 7,
    offset: const Offset(0, 0), // changes position of shadow
  );

}