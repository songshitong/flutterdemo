import 'package:flutter/material.dart';

class MyColor {
  static const int primaryValue = 0xFFb19b7f;
  static const Color PRIMARYCOLOR = Color(primaryValue);
  static const MaterialColor primarySwatch =
      const MaterialColor(primaryValue, const <int, Color>{
    50: PRIMARYCOLOR,
    100: PRIMARYCOLOR,
    200: PRIMARYCOLOR,
    300: PRIMARYCOLOR,
    400: PRIMARYCOLOR,
    500: PRIMARYCOLOR,
    600: PRIMARYCOLOR,
    700: PRIMARYCOLOR,
    800: PRIMARYCOLOR,
    900: PRIMARYCOLOR
  });
}
