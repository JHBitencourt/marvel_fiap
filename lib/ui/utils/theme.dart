import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class MarvelTheme {
  MarvelTheme._();

  static ThemeData applicationTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: MarvelColors.primaryPalette,
        primaryColor: MarvelColors.primary,
        textTheme: textTheme(context),
        buttonTheme: buttonTheme(context),
        snackBarTheme: snackBarTheme,
        iconTheme: iconTheme,
      );

  static IconThemeData get iconTheme => const IconThemeData(
        color: MarvelColors.primary,
      );

  static SnackBarThemeData get snackBarTheme => const SnackBarThemeData(
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      );

  static TextTheme textTheme(BuildContext context) =>
      GoogleFonts.firaCodeTextTheme(
        Theme.of(context).textTheme.copyWith(
              bodyText1: const TextStyle(
                color: MarvelColors.text,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              bodyText2: const TextStyle(
                color: MarvelColors.text,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              headline1: const TextStyle(
                color: MarvelColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.normal,
              ),
            ),
      );

  static ButtonThemeData buttonTheme(BuildContext context) => ButtonThemeData(
        buttonColor: MarvelColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textTheme: ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
}
