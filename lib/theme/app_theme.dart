import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBA44FF)),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Poppins',
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
