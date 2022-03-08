import 'package:flutter/material.dart';

class MarvelColors {
  MarvelColors._();

  static const _primary = 0xFFED2885;
  static const primary = Color(_primary);
  static const primaryLight = Color(0xFFF269AA);
  static const primaryLighter = Color(0xFFF694C2);
  static const primaryDark = Color(0xFFBE206A);
  static const primaryDarker = Color(0xFF8E1850);

  static const MaterialColor primaryPalette = MaterialColor(
    _primary,
    <int, Color>{
      50: primaryLighter,
      100: Color(0xFFF47EB6),
      200: primaryLight,
      300: Color(0xFFF1539D),
      400: Color(0xFFD52478),
      500: Color(_primary),
      600: Color(0xFFD52478),
      700: primaryDark,
      800: Color(0xFFA61C5D),
      900: primaryDarker,
    },
  );

  static const grey = Color(0xFF9E9E9E);
  static const MaterialColor greyPalette = Colors.grey;

  /// Common use case colors
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const background = Color(0xFF121212);
  static const text = Color(0xFFFFFFFF);
  static const border = Color(0xFFDFDFDF);
  static const hintText = Color(0xFFB9B9B9);
  static const redError = Color(0xFFF65B75);
}
