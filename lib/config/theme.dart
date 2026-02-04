import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFFF9D59B),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9800),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF9D59B),
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData dark = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9800),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}