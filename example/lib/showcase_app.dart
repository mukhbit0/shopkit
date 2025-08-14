import 'package:flutter/material.dart';
import 'themes/theme_helper.dart';
import 'screens/home_screen.dart';

class ShopKitShowcaseApp extends StatefulWidget {
  const ShopKitShowcaseApp({super.key});

  @override
  State<ShopKitShowcaseApp> createState() => _ShopKitShowcaseAppState();
}

class _ShopKitShowcaseAppState extends State<ShopKitShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _currentThemeStyle = 'material3';

  final Map<String, ThemeData Function()> _lightThemes = {
    'material3': ThemeHelper.material3Light,
    'neumorphism': ThemeHelper.neumorphicLight,
    'glassmorphism': ThemeHelper.glassmorphicLight,
  };

  final Map<String, ThemeData Function()> _darkThemes = {
    'material3': ThemeHelper.material3Dark,
    'neumorphism': ThemeHelper.neumorphicDark,
    'glassmorphism': ThemeHelper.glassmorphicDark,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopKit Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _lightThemes[_currentThemeStyle]!(),
      darkTheme: _darkThemes[_currentThemeStyle]!(),
      home: HomeScreen(
        onThemeChanged: (style) => setState(() => _currentThemeStyle = style),
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
        currentThemeStyle: _currentThemeStyle,
        currentThemeMode: _themeMode,
      ),
    );
  }
}
