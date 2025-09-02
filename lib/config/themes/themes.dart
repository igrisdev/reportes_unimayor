import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF5F5F5), // Fondo alternativo
          onSurface: Colors.black, // Texto general (subtítulos)
          error: Colors.red,
          onError: Colors.white,
          tertiary: Colors.green, // Éxito
          // Puedes usar surfaceContainer etc. si quieres más roles
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
