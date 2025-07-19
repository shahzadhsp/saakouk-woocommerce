import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57.0,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  static TextTheme get darkTextTheme {
    return textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      textTheme: AppTextTheme.textTheme,
      fontFamily: 'Poppins',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      textTheme: AppTextTheme.darkTextTheme,
      fontFamily: 'Poppins',
    );
  }
}

// Usage:
ThemeData themeData = AppTheme.lightTheme;
// or
ThemeData darkThemeData = AppTheme.darkTheme;
