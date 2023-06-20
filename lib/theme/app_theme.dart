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
    final colorCode = int.parse('562626', radix: 16);
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MaterialColor(
        0xff562626,
        <int, Color>{
          50: Color(colorCode),
          100: Color(colorCode),
          200: Color(colorCode),
          300: Color(colorCode),
          400: Color(colorCode),
          500: Color(colorCode),
          600: Color(colorCode),
          700: Color(colorCode),
          800: Color(colorCode),
          900: Color(colorCode),
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
          backgroundColor: const Color(0xff562626),
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
    final colorCode = int.parse('562626', radix: 16);
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      primarySwatch: MaterialColor(
        0xFF562626,
        <int, Color>{
          50: Color(colorCode),
          100: Color(colorCode),
          200: Color(colorCode),
          300: Color(colorCode),
          400: Color(colorCode),
          500: Color(colorCode),
          600: Color(colorCode),
          700: Color(colorCode),
          800: Color(colorCode),
          900: Color(colorCode),
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
          backgroundColor: const Color(0xff562626),
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
