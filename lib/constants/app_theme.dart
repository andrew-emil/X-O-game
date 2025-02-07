import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 181, 198, 252), // Light blue
      surface: const Color.fromARGB(26, 10, 185, 248), // Very light blue
      shadow: const Color(0xFF4C72EE), // Blue shadow
      secondary: Colors.redAccent,
      tertiary: Colors.blue[900],
      inversePrimary: Colors.green[900]!,
      onPrimary: Colors.black,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Match background
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: const Color(0xFF4C72EE).withValues(alpha: .2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[900], // Dark background
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF001456), // Dark blue
      surface: Colors.grey.shade900,
      shadow: const Color.fromARGB(255, 2, 49, 201), // Matches primary
      secondary: Colors.red[900]!,
      tertiary: Colors.indigo[900],
      inversePrimary: Colors.lightGreenAccent.shade200,
      onPrimary: Colors.white,
      onSurface: Colors.white70,
    ),
    scaffoldBackgroundColor:const Color(0xFF121212),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E), // Slightly lighter than background
      shadowColor: const Color(0xFF001456).withValues(alpha: .2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
