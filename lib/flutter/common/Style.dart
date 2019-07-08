import 'package:flutter/material.dart';

class MyColor {
  static const int primaryValue = 0xFFb19b7f;
  static const Color PRIMARYCOLOR = Color(primaryValue);
  static const MaterialColor primarySwatch = const MaterialColor(primaryValue, const <int, Color>{
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

  static const Color mariner = Color(0xFF3B5F8F);
  static const Color mediumPurple = Color(0xFF8266D4);
  static const Color tomato = Color(0xFFF95B57);
  static const Color mySin = Color(0xFFF3A646);
}

class AppColor {
  static final AppColor _singleton = AppColor._instance();
  factory AppColor.getInstance() {
    return _singleton;
  }

  AppColor._instance();
}
