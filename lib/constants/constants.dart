import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';

import 'package:flutter/material.dart';

const primaryColor = Color(0x00013051);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const pdfColors = PdfColor.fromInt(0x00013051);

const defaultPadding = 16.0;

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'SatoshiVariable',
    primaryColor: const Color.fromARGB(255, 20, 23, 58),
    primaryColorLight: const Color.fromARGB(255, 21, 40, 69),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 21, 40, 69),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: const Color.fromARGB(255, 21, 40, 69)),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 21, 40, 69)),
        bodyMedium: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 21, 40, 69),
            fontWeight: FontWeight.w400),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 21, 40, 69),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );

  // 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'SatoshiVariable',
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(47, 0, 0, 0),
    primaryColorLight: const Color.fromARGB(225, 255, 255, 255),
    scaffoldBackgroundColor: const Color.fromARGB(255, 22, 21, 21),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 43, 42, 42),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(TextTheme(
      headlineMedium: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );
}
