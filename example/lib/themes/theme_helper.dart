import 'package:flutter/material.dart';

// Theme configurations with distinct visual styles and animations
class ThemeHelper {
  // MATERIAL 3 - Modern, clean with smooth animations
  static ThemeData material3Light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData material3Dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // NEUMORPHIC - Soft shadows, pressed/raised effects, bouncy animations
  static ThemeData neumorphicLight() {
    return ThemeData(
      useMaterial3: false, // Use Material 2 for custom shadow control
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: const Color(0xFFE0E5EC),
      cardTheme: const CardThemeData(
        elevation: 0, // Custom shadows instead
        color: Color(0xFFE0E5EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFE0E5EC),
          foregroundColor: const Color(0xFF4A5568),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFFE0E5EC),
        foregroundColor: Color(0xFF4A5568),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF8B5CF6),
        surface: Color(0xFFE0E5EC),
        onSurface: Color(0xFF4A5568),
      ),
    );
  }

  static ThemeData neumorphicDark() {
    return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: const Color(0xFF2D3748),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Color(0xFF2D3748),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF2D3748),
          foregroundColor: const Color(0xFFE2E8F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF2D3748),
        foregroundColor: Color(0xFFE2E8F0),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF818CF8),
        secondary: Color(0xFFA78BFA),
        surface: Color(0xFF2D3748),
        onSurface: Color(0xFFE2E8F0),
      ),
    );
  }

  // GLASSMORPHIC - Frosted glass effects, blur, floating animations
  static ThemeData glassmorphicLight() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan,
        brightness: Brightness.light,
      ).copyWith(
        surface: Colors.white.withValues(alpha: 0.1),
        surfaceContainer: Colors.white.withValues(alpha: 0.2),
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F9FF),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          side: BorderSide(
            color: Colors.white24,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: const Color(0xFF0891B2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          animationDuration: const Duration(milliseconds: 400),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        foregroundColor: const Color(0xFF0891B2),
      ),
    );
  }

  static ThemeData glassmorphicDark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyan,
        brightness: Brightness.dark,
      ).copyWith(
        surface: Colors.white.withValues(alpha: 0.05),
        surfaceContainer: Colors.white.withValues(alpha: 0.1),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          side: BorderSide(
            color: Colors.white12,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          foregroundColor: const Color(0xFF22D3EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          animationDuration: const Duration(milliseconds: 400),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        foregroundColor: const Color(0xFF22D3EE),
      ),
    );
  }
}
