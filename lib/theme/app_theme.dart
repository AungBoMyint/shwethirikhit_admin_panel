import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/data.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.itim(
      color: Colors.black,
      fontSize: 20,
    ),
    displaySmall: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 16,
    ),
    headlineSmall: GoogleFonts.inika(
      color: Colors.black,
      fontSize: 12,
    ),
    headlineMedium: GoogleFonts.itim(
      color: Colors.black,
      fontSize: 16,
    ),
  );
  static ThemeData lightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: const MaterialColor(
        0xffE8EC37,
        <int, Color>{
          50: Color(0xffF7FA88),
          100: Color(0xffF2F57A),
          200: Color(0xffEDF26C),
          300: Color(0xffE8EC5F),
          400: Color(0xffE3E951),
          500: Color(0xffE8EC37),
          600: Color(0xffD1D52D),
          700: Color(0xffBABF24),
          800: Color(0xffA3A41A),
          900: Color(0xff8C9311),
        },
      ),
      brightness: Brightness.light,
      textTheme: lightTextTheme,
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(
        elevation: 3,
        backgroundColor: Color(0xFFF5F0EA),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffd6da21),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Dark Theme
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.itim(
      color: Colors.white,
      fontSize: 20,
    ),
    displaySmall: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 16,
    ),
    headlineSmall: GoogleFonts.inika(
      color: Colors.white,
      fontSize: 12,
    ),
    headlineMedium: GoogleFonts.itim(
      color: Colors.white,
      fontSize: 16,
    ),
  );
  static ThemeData darkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: const MaterialColor(
        0xffd6da21,
        <int, Color>{
          50: Color(0xfff6f7b6),
          100: Color(0xffeae88d),
          200: Color(0xffddd964),
          300: Color(0xffd1cc3b),
          400: Color(0xffc5c30f),
          500: Color(0xffb3ad00),
          600: Color(0xffa09b00),
          700: Color(0xff8d8800),
          800: Color(0xff7a7600),
          900: Color(0xff635f00),
        },
      ),
      brightness: Brightness.light,
      textTheme: darkTextTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        elevation: 3,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        color: darkThemeCardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffd6da21),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
