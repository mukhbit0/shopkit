// theme_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'base_theme.dart';
import 'material3_theme.dart';
import 'neumorphism_theme.dart';
import 'glassmorphism_theme.dart';

/// Theme manager for ShopKit with hot reload support
class ShopKitThemeManager extends ChangeNotifier {
  ShopKitThemeManager({
    ShopKitBaseTheme? initialTheme,
    this.enableHotReload = true,
    this.persistTheme = false,
    this.themePersistenceKey = 'shopkit_theme',
  }) : _currentTheme = initialTheme ?? ShopKitMaterial3Theme.light();

  ShopKitBaseTheme _currentTheme;
  final bool enableHotReload;
  final bool persistTheme;
  final String themePersistenceKey;

  /// Current active theme
  ShopKitBaseTheme get currentTheme => _currentTheme;

  /// Current design system
  DesignSystem get designSystem => _currentTheme.designSystem;

  /// Whether current theme is dark
  bool get isDarkTheme => _currentTheme is ShopKitMaterial3Theme
      ? (_currentTheme as ShopKitMaterial3Theme).brightness == Brightness.dark
      : _currentTheme.colorScheme.surface.computeLuminance() < 0.5;

  /// Set new theme
  void setTheme(ShopKitBaseTheme theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      if (persistTheme) {
        _persistTheme(theme);
      }
      notifyListeners();
    }
  }

  /// Update theme with custom properties
  void updateTheme(Map<String, dynamic> customProperties) {
    final updatedTheme = _currentTheme.withCustomProperties(customProperties);
    setTheme(updatedTheme);
  }

  /// Toggle between light and dark theme
  void toggleBrightness() {
    switch (_currentTheme.designSystem) {
      case DesignSystem.material3:
        final material3Theme = _currentTheme as ShopKitMaterial3Theme;
        final newTheme = material3Theme.brightness == Brightness.light
            ? ShopKitMaterial3Theme.dark(
                seedColor: material3Theme.seedColor,
                spacing: material3Theme.spacing,
                borderRadius: material3Theme.borderRadius,
                elevation: material3Theme.elevation,
                animation: material3Theme.animation,
                customProperties: material3Theme.customProperties,
              )
            : ShopKitMaterial3Theme.light(
                seedColor: material3Theme.seedColor,
                spacing: material3Theme.spacing,
                borderRadius: material3Theme.borderRadius,
                elevation: material3Theme.elevation,
                animation: material3Theme.animation,
                customProperties: material3Theme.customProperties,
              );
        setTheme(newTheme);
        break;
      case DesignSystem.neumorphism:
        final neumorphismTheme = _currentTheme as ShopKitNeumorphismTheme;
        final newTheme = neumorphismTheme.surfaceColor.computeLuminance() > 0.5
            ? ShopKitNeumorphismTheme.dark(
                intensity: neumorphismTheme.intensity,
                spacing: neumorphismTheme.spacing,
                borderRadius: neumorphismTheme.borderRadius,
                elevation: neumorphismTheme.elevation,
                animation: neumorphismTheme.animation,
                customProperties: neumorphismTheme.customProperties,
              )
            : ShopKitNeumorphismTheme.light(
                intensity: neumorphismTheme.intensity,
                spacing: neumorphismTheme.spacing,
                borderRadius: neumorphismTheme.borderRadius,
                elevation: neumorphismTheme.elevation,
                animation: neumorphismTheme.animation,
                customProperties: neumorphismTheme.customProperties,
              );
        setTheme(newTheme);
        break;
      case DesignSystem.glassmorphism:
        final glassTheme = _currentTheme as ShopKitGlassmorphismTheme;
        final newTheme = glassTheme.colorScheme.surface.computeLuminance() > 0.5
            ? ShopKitGlassmorphismTheme.dark(
                blurIntensity: glassTheme.blurIntensity,
                backdropOpacity: glassTheme.backdropOpacity,
                glowEffect: glassTheme.glowEffect,
                spacing: glassTheme.spacing,
                borderRadius: glassTheme.borderRadius,
                elevation: glassTheme.elevation,
                animation: glassTheme.animation,
                customProperties: glassTheme.customProperties,
              )
            : ShopKitGlassmorphismTheme.light(
                blurIntensity: glassTheme.blurIntensity,
                backdropOpacity: glassTheme.backdropOpacity,
                glowEffect: glassTheme.glowEffect,
                spacing: glassTheme.spacing,
                borderRadius: glassTheme.borderRadius,
                elevation: glassTheme.elevation,
                animation: glassTheme.animation,
                customProperties: glassTheme.customProperties,
              );
        setTheme(newTheme);
        break;
      default:
        // For other design systems, just update custom properties
        updateTheme({'isDark': !isDarkTheme});
    }
  }

  /// Create Material 3 theme with seed color
  void setMaterial3Theme({
    required Color seedColor,
    Brightness? brightness,
    Map<String, dynamic> customProperties = const {},
  }) {
    final theme = brightness == Brightness.dark
        ? ShopKitMaterial3Theme.dark(
            seedColor: seedColor,
            customProperties: customProperties,
          )
        : ShopKitMaterial3Theme.light(
            seedColor: seedColor,
            customProperties: customProperties,
          );
    setTheme(theme);
  }

  /// Create Neumorphism theme
  void setNeumorphismTheme({
    Color? surfaceColor,
    double? intensity,
    bool isDark = false,
    Map<String, dynamic> customProperties = const {},
  }) {
    final theme = isDark
        ? ShopKitNeumorphismTheme.dark(
            surfaceColor: surfaceColor,
            intensity: intensity,
            customProperties: customProperties,
          )
        : ShopKitNeumorphismTheme.light(
            surfaceColor: surfaceColor,
            intensity: intensity,
            customProperties: customProperties,
          );
    setTheme(theme);
  }

  /// Create Glassmorphism theme
  void setGlassmorphismTheme({
    double? blurIntensity,
    double? backdropOpacity,
    bool? glowEffect,
    bool isDark = false,
    Map<String, dynamic> customProperties = const {},
  }) {
    final theme = isDark
        ? ShopKitGlassmorphismTheme.dark(
            blurIntensity: blurIntensity,
            backdropOpacity: backdropOpacity,
            glowEffect: glowEffect,
            customProperties: customProperties,
          )
        : ShopKitGlassmorphismTheme.light(
            blurIntensity: blurIntensity,
            backdropOpacity: backdropOpacity,
            glowEffect: glowEffect,
            customProperties: customProperties,
          );
    setTheme(theme);
  }

  /// Hot reload theme changes in development
  void hotReloadTheme(ShopKitBaseTheme theme) {
    if (enableHotReload && kDebugMode) {
      setTheme(theme);
    }
  }

  /// Load theme from persistence
  Future<void> loadPersistedTheme() async {
    if (!persistTheme) return;
    
    // Implementation would depend on your persistence solution
    // e.g., SharedPreferences, Hive, etc.
    // For now, this is a placeholder
  }

  /// Persist current theme
  Future<void> _persistTheme(ShopKitBaseTheme theme) async {
    // Implementation would depend on your persistence solution
    // For now, this is a placeholder
  }

  /// Get theme extension from current theme
  T? getThemeExtension<T extends ThemeExtension<T>>() {
    return _currentTheme.getCustomProperty<T>('themeExtension');
  }

  /// Set theme extension
  void setThemeExtension<T extends ThemeExtension<T>>(T extension) {
    updateTheme({'themeExtension': extension});
  }

  /// Create theme variant with modifications
  ShopKitBaseTheme createVariant({
    ShopKitColorScheme? colorScheme,
    ShopKitTypography? typography,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic>? customProperties,
  }) {
    switch (_currentTheme.designSystem) {
      case DesignSystem.material3:
        return (_currentTheme as ShopKitMaterial3Theme).copyWith(
          colorScheme: colorScheme,
          typography: typography,
          spacing: spacing,
          borderRadius: borderRadius,
          elevation: elevation,
          animation: animation,
          customProperties: customProperties,
        );
      case DesignSystem.neumorphism:
        return (_currentTheme as ShopKitNeumorphismTheme).copyWith(
          colorScheme: colorScheme,
          typography: typography,
          spacing: spacing,
          borderRadius: borderRadius,
          elevation: elevation,
          animation: animation,
          customProperties: customProperties,
        );
      case DesignSystem.glassmorphism:
        return (_currentTheme as ShopKitGlassmorphismTheme).copyWith(
          colorScheme: colorScheme,
          typography: typography,
          spacing: spacing,
          borderRadius: borderRadius,
          elevation: elevation,
          animation: animation,
          customProperties: customProperties,
        );
      default:
        return _currentTheme;
    }
  }

  /// Export theme configuration as JSON
  Map<String, dynamic> exportTheme() {
    return {
      'designSystem': _currentTheme.designSystem.toString(),
      'colorScheme': _exportColorScheme(_currentTheme.colorScheme),
      'typography': _exportTypography(_currentTheme.typography),
      'spacing': _exportSpacing(_currentTheme.spacing),
      'borderRadius': _exportBorderRadius(_currentTheme.borderRadius),
      'elevation': _exportElevation(_currentTheme.elevation),
      'animation': _exportAnimation(_currentTheme.animation),
      'customProperties': _currentTheme.customProperties,
    };
  }

  /// Import theme configuration from JSON
  void importTheme(Map<String, dynamic> themeData) {
    // Implementation for importing theme from JSON
    // This would recreate the theme based on the exported data
  }

  Map<String, dynamic> _exportColorScheme(ShopKitColorScheme colorScheme) {
    int c(Color c) => c.toARGB32();
    int? cOpt(Color? c) => c?.toARGB32();
    return {
      'primary': c(colorScheme.primary),
      'onPrimary': c(colorScheme.onPrimary),
      'primaryContainer': c(colorScheme.primaryContainer),
      'onPrimaryContainer': c(colorScheme.onPrimaryContainer),
      'secondary': c(colorScheme.secondary),
      'onSecondary': c(colorScheme.onSecondary),
      'secondaryContainer': c(colorScheme.secondaryContainer),
      'onSecondaryContainer': c(colorScheme.onSecondaryContainer),
      'tertiary': c(colorScheme.tertiary),
      'onTertiary': c(colorScheme.onTertiary),
      'tertiaryContainer': c(colorScheme.tertiaryContainer),
      'onTertiaryContainer': c(colorScheme.onTertiaryContainer),
      'error': c(colorScheme.error),
      'onError': c(colorScheme.onError),
      'errorContainer': c(colorScheme.errorContainer),
      'onErrorContainer': c(colorScheme.onErrorContainer),
      'surface': c(colorScheme.surface),
      'onSurface': c(colorScheme.onSurface),
  // surfaceVariant deprecated: exporting as surface to maintain backward compatibility
  'surfaceVariant': c(colorScheme.surface),
  'onSurfaceVariant': c(colorScheme.onSurface),
      'outline': c(colorScheme.outline),
      'outlineVariant': c(colorScheme.outlineVariant),
      'shadow': c(colorScheme.shadow),
      'scrim': c(colorScheme.scrim),
      'inverseSurface': c(colorScheme.inverseSurface),
      'onInverseSurface': c(colorScheme.onInverseSurface),
      'inversePrimary': c(colorScheme.inversePrimary),
      'surfaceTint': c(colorScheme.surfaceTint),
      'success': cOpt(colorScheme.success),
      'onSuccess': cOpt(colorScheme.onSuccess),
      'warning': cOpt(colorScheme.warning),
      'onWarning': cOpt(colorScheme.onWarning),
      'info': cOpt(colorScheme.info),
      'onInfo': cOpt(colorScheme.onInfo),
      'customColors': colorScheme.customColors.map((k, v) => MapEntry(k, v.toARGB32())),
    };
  }

  Map<String, dynamic> _exportTypography(ShopKitTypography typography) {
    return {
      'displayLarge': _exportTextStyle(typography.displayLarge),
      'displayMedium': _exportTextStyle(typography.displayMedium),
      'displaySmall': _exportTextStyle(typography.displaySmall),
      'headlineLarge': _exportTextStyle(typography.headlineLarge),
      'headlineMedium': _exportTextStyle(typography.headlineMedium),
      'headlineSmall': _exportTextStyle(typography.headlineSmall),
      'titleLarge': _exportTextStyle(typography.titleLarge),
      'titleMedium': _exportTextStyle(typography.titleMedium),
      'titleSmall': _exportTextStyle(typography.titleSmall),
      'bodyLarge': _exportTextStyle(typography.bodyLarge),
      'bodyMedium': _exportTextStyle(typography.bodyMedium),
      'bodySmall': _exportTextStyle(typography.bodySmall),
      'labelLarge': _exportTextStyle(typography.labelLarge),
      'labelMedium': _exportTextStyle(typography.labelMedium),
      'labelSmall': _exportTextStyle(typography.labelSmall),
      'customTextStyles': typography.customTextStyles.map((k, v) => MapEntry(k, _exportTextStyle(v))),
    };
  }

  Map<String, dynamic> _exportTextStyle(TextStyle style) {
    return {
      'fontSize': style.fontSize,
      'fontWeight': style.fontWeight?.index,
      'letterSpacing': style.letterSpacing,
      'height': style.height,
      'fontFamily': style.fontFamily,
    };
  }

  Map<String, dynamic> _exportSpacing(ShopKitSpacing spacing) {
    return {
      'none': spacing.none,
      'xs': spacing.xs,
      'sm': spacing.sm,
      'md': spacing.md,
      'lg': spacing.lg,
      'xl': spacing.xl,
      'xxl': spacing.xxl,
      'customSpacing': spacing.customSpacing,
    };
  }

  Map<String, dynamic> _exportBorderRadius(ShopKitBorderRadius borderRadius) {
    return {
      'none': borderRadius.none,
      'xs': borderRadius.xs,
      'sm': borderRadius.sm,
      'md': borderRadius.md,
      'lg': borderRadius.lg,
      'xl': borderRadius.xl,
      'full': borderRadius.full,
      'customRadius': borderRadius.customRadius,
    };
  }

  Map<String, dynamic> _exportElevation(ShopKitElevation elevation) {
    return {
      'none': elevation.none,
      'xs': elevation.xs,
      'sm': elevation.sm,
      'md': elevation.md,
      'lg': elevation.lg,
      'xl': elevation.xl,
      'customElevation': elevation.customElevation,
    };
  }

  Map<String, dynamic> _exportAnimation(ShopKitAnimation animation) {
    return {
      'fast': animation.fast.inMilliseconds,
      'normal': animation.normal.inMilliseconds,
      'slow': animation.slow.inMilliseconds,
      'customDurations': animation.customDurations.map((k, v) => MapEntry(k, v.inMilliseconds)),
    };
  }
}

/// Widget to provide theme manager to descendants
class ShopKitThemeProvider extends InheritedNotifier<ShopKitThemeManager> {
  const ShopKitThemeProvider({
    super.key,
    required ShopKitThemeManager themeManager,
    required super.child,
  }) : super(notifier: themeManager);

  static ShopKitThemeManager? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShopKitThemeProvider>()?.notifier;
  }

  static ShopKitThemeManager of(BuildContext context) {
    final themeManager = maybeOf(context);
    assert(themeManager != null, 'No ShopKitThemeProvider found in context');
    return themeManager!;
  }

  static ShopKitBaseTheme themeOf(BuildContext context) {
    return of(context).currentTheme;
  }
}

/// Color utilities avoiding deprecated direct .value access patterns.
extension ShopKitColorExport on Color {
  int toARGB32() {
    // Use modern channel accessors (.a,.r,.g,.b produce 0..1 doubles)
    final aInt = (a * 255.0).round() & 0xFF;
    final rInt = (r * 255.0).round() & 0xFF;
    final gInt = (g * 255.0).round() & 0xFF;
    final bInt = (b * 255.0).round() & 0xFF;
    return (aInt << 24) | (rInt << 16) | (gInt << 8) | bInt;
  }
}
