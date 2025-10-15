import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF024792),
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF5F5F5), // Fondo usuarios
          onSurface: Colors.black, // Texto general (subtítulos)
          error: Colors.red,
          onError: Colors.white,
          secondary: const Color(0xFFFFCF01),
          onSecondary: Colors.black,
          tertiary: Colors.green, // Éxito
        ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.red,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF121212),
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.black,
          tertiary: Colors.greenAccent,
        ),
  );
}
