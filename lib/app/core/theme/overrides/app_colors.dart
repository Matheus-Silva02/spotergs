import 'dart:ui';

import 'package:flutter/material.dart';

abstract class AppColors {  

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0XFFFFFFFF);
  static const Color black = Color(0XFF000000);

  static const int _primaryValue = 0XFF96031A;

  static const MaterialColor primary = MaterialColor(_primaryValue, {
    100: Color(0xFFF9D7D9),
    200: Color(0xFFF2AFAF),
    300: Color(0xFFEA8786),
    400: Color(0xFFD95B5D),
    500: Color(_primaryValue),
    600: Color(0xFF7C0214),
    700: Color(0xFF62010F),
    800: Color(0xFF47010A),
    900: Color(0xFF2D0005),
  });
  static const int _secondaryValue = 0XFF1B1B1E;

  static const MaterialColor secondary = MaterialColor(_secondaryValue, {
    50: Color(0XFFF6F7F8),
    100: Color(0XFFEDF0F1),
    200: Color(0XFFDCE0E2),
    300: Color(0XFFBFC8CB),
    400: Color(0XFF9AA3A6),
    500: Color(_secondaryValue),
    600: Color(0XFF161617),
    700: Color(0XFF121213),
    800: Color(0XFF0D0D0E),
    900: Color(0XFF080809),
    950: Color(0XFF030304)
  });

  static const int _neutralPrimaryValue = 0XFF898989;

  static MaterialColor neutral = MaterialColor(_neutralPrimaryValue, {
    15: Color(0XFFFAFAFA),
    10: Color(0XFFF2F0F0),
    50: Color(0XFFEFEFEF),
    100: Color(0XFFFDFDFD),
    200: Color(0XFFFDFDFD),
    300: Color(0XFFF8F8F8),
    400: Color(0XFFE9E9E9),
    500: Color(0xFFD4D4D4),
    600: Color(0XFFACACAC),
    650: Color(0xFF999999),
    700: Color(0XFF696969),
    800: Color(0XFF353535),
    900: Color(0xFF25272C),
    950: Color(0xFF1D1D1D)
  });

}