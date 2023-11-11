// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomTheme {
  static const MaterialColor customPrimarySwatch = MaterialColor(
    0xFF02AB72,
    <int, Color>{
      50: Color(0xFF02AB72),
      100: Color(0xFF02AB72),
      200: Color(0xFF02AB72),
      300: Color(0xFF02AB72),
      400: Color(0xFF02AB72),
      500: Color(0xFF02AB72),
      600: Color(0xFF02AB72),
      700: Color(0xFF02AB72),
      800: Color(0xFF02AB72),
      900: Color(0xFF02AB72),
    },
  );

  static ThemeData lightTheme = ThemeData(
    //useMaterial3: true,
    primarySwatch: customPrimarySwatch,
    hintColor: const Color(0xFF02AB90),
    brightness: Brightness.light,
    highlightColor: const Color(0xFF02ABAF),
    splashColor: const Color(0xFF02ABA0),
    scaffoldBackgroundColor: const Color(0xFFF2F2F2),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF333333)),
      bodyMedium: TextStyle(color: Color(0xFF666666)),
    ),
    errorColor: const Color(0xFFFF3333),
  );
}
