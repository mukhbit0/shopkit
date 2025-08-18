import 'package:flutter/material.dart';
import 'theme.dart'; // Import the new master theme file

/// An enum to represent the available pre-built theme styles.
enum ShopKitThemeStyle { material3, materialYou, glassmorphic, neumorphic, cupertino, retro, neon }

/// Manages the active ShopKit theme and notifies listeners of changes.
///
/// This ChangeNotifier is designed to work with the new `ThemeExtension`-based
/// ShopKit theming system. It allows for runtime theme switching.
///
/// --- How to Use ---
/// 1. Wrap your MaterialApp with a ChangeNotifierProvider:
///
///    ChangeNotifierProvider(
///      create: (context) => ShopKitThemeManager(
///        lightColorScheme: ThemeData.light().colorScheme,
///        darkColorScheme: ThemeData.dark().colorScheme,
///      ),
///      child: Consumer<ShopKitThemeManager>(
///        builder: (context, themeManager, _) {
///          return MaterialApp(
///            theme: ThemeData(
///              colorScheme: themeManager.lightColorScheme,
///              extensions: [themeManager.currentTheme],
///            ),
///            darkTheme: ThemeData(
///              colorScheme: themeManager.darkColorScheme,
///              extensions: [themeManager.currentTheme],
///            ),
///            themeMode: themeManager.themeMode,
///            // ... your app
///          );
///        },
///      ),
///    )
///
/// 2. In your UI, access the manager to change themes:
///
///    // To toggle light/dark mode:
///    Provider.of<ShopKitThemeManager>(context, listen: false).toggleThemeMode();
///
///    // To switch to a different style (e.g., glassmorphic):
///    Provider.of<ShopKitThemeManager>(context, listen: false)
///        .setThemeStyle(ShopKitThemeStyle.glassmorphic);
///
class ShopKitThemeManager extends ChangeNotifier {
  /// The light ColorScheme for your app.
  final ColorScheme lightColorScheme;
  
  /// The dark ColorScheme for your app.
  final ColorScheme darkColorScheme;

  ShopKitTheme _currentTheme;
  ThemeMode _themeMode;
  ShopKitThemeStyle _currentStyle;

  ShopKitThemeManager({
    required this.lightColorScheme,
    required this.darkColorScheme,
    ThemeMode initialThemeMode = ThemeMode.system,
    ShopKitThemeStyle initialStyle = ShopKitThemeStyle.material3,
  })  : _themeMode = initialThemeMode,
        _currentStyle = initialStyle,
        _currentTheme = _getThemeFromStyle(
            initialStyle,
            initialThemeMode == ThemeMode.dark ? darkColorScheme : lightColorScheme,
          );

  /// The currently active ShopKit theme extension.
  ShopKitTheme get currentTheme => _currentTheme;

  /// The current theme mode (light, dark, or system).
  ThemeMode get themeMode => _themeMode;

  /// The current theme style (e.g., material3, glassmorphic).
  ShopKitThemeStyle get currentStyle => _currentStyle;

  /// Toggles the theme mode between light and dark.
  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _updateTheme();
  }

  /// Sets the theme mode to a specific value.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _updateTheme();
  }

  /// Sets the visual style of the theme (e.g., to glassmorphic, retro).
  void setThemeStyle(ShopKitThemeStyle style) {
    if (_currentStyle == style) return;
    _currentStyle = style;
    _updateTheme();
  }

  /// Rebuilds the current theme based on the active style and mode.
  void _updateTheme() {
    final colorScheme = _themeMode == ThemeMode.dark ? darkColorScheme : lightColorScheme;
    _currentTheme = _getThemeFromStyle(_currentStyle, colorScheme);
    notifyListeners();
  }

  /// A helper map to retrieve the correct theme factory based on the style enum.
  static ShopKitTheme _getThemeFromStyle(ShopKitThemeStyle style, ColorScheme colorScheme) {
    switch (style) {
      case ShopKitThemeStyle.material3:
        return ShopKitThemes.material3(colorScheme);
      case ShopKitThemeStyle.materialYou:
        return ShopKitThemes.materialYou(colorScheme);
      case ShopKitThemeStyle.glassmorphic:
        return ShopKitThemes.glassmorphic(colorScheme);
      case ShopKitThemeStyle.neumorphic:
        return ShopKitThemes.neumorphic(colorScheme);
      case ShopKitThemeStyle.cupertino:
        return ShopKitThemes.cupertino(colorScheme);
      case ShopKitThemeStyle.retro:
        return ShopKitThemes.retro(colorScheme);
      case ShopKitThemeStyle.neon:
        return ShopKitThemes.neon(colorScheme);
    }
  }
}