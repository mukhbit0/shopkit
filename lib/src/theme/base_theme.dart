// base_theme.dart
import 'package:flutter/material.dart';

/// Enumeration of supported design systems
enum DesignSystem {
  material3,
  material2,
  cupertino,
  neumorphism,
  glassmorphism,
  brutalism,
  minimal,
  custom
}

/// Base theme interface for ShopKit theming system
abstract class ShopKitBaseTheme extends ThemeExtension<ShopKitBaseTheme> {
  const ShopKitBaseTheme({
    required this.designSystem,
    required this.colorScheme,
    required this.typography,
    required this.spacing,
    required this.borderRadius,
    required this.elevation,
    required this.animation,
    this.customProperties = const {},
  });

  /// The design system being used
  final DesignSystem designSystem;

  /// Color scheme for the theme
  final ShopKitColorScheme colorScheme;

  /// Typography configuration
  final ShopKitTypography typography;

  /// Spacing configuration
  final ShopKitSpacing spacing;

  /// Border radius configuration
  final ShopKitBorderRadius borderRadius;

  /// Elevation configuration
  final ShopKitElevation elevation;

  /// Animation configuration
  final ShopKitAnimation animation;

  /// Custom properties for unlimited extensibility
  final Map<String, dynamic> customProperties;

  /// Get a custom property value with type safety
  T? getCustomProperty<T>(String key) {
    final value = customProperties[key];
    return value is T ? value : null;
  }

  /// Create a copy with custom properties
  ShopKitBaseTheme withCustomProperty(String key, dynamic value);

  /// Create a copy with multiple custom properties
  ShopKitBaseTheme withCustomProperties(Map<String, dynamic> properties);
}

/// Comprehensive color scheme configuration
class ShopKitColorScheme {
  const ShopKitColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceTint,
    this.success,
    this.onSuccess,
    this.warning,
    this.onWarning,
    this.info,
    this.onInfo,
    this.gradient,
    this.customColors = const {},
  });

  // Material 3 standard colors
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color surfaceTint;

  // E-commerce specific colors
  final Color? success;
  final Color? onSuccess;
  final Color? warning;
  final Color? onWarning;
  final Color? info;
  final Color? onInfo;

  // Gradient support
  final Gradient? gradient;

  // Custom colors for unlimited extensibility
  final Map<String, Color> customColors;

  /// Get a custom color by key
  Color? getCustomColor(String key) => customColors[key];

  /// Create a copy with custom color
  ShopKitColorScheme withCustomColor(String key, Color color) {
    return copyWith(customColors: {...customColors, key: color});
  }

  ShopKitColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Gradient? gradient,
    Map<String, Color>? customColors,
  }) {
    return ShopKitColorScheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      gradient: gradient ?? this.gradient,
      customColors: customColors ?? this.customColors,
    );
  }
}

/// Typography configuration with complete flexibility
class ShopKitTypography {
  const ShopKitTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    this.customTextStyles = const {},
  });

  // Material 3 text styles
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // Custom text styles for unlimited extensibility
  final Map<String, TextStyle> customTextStyles;

  /// Get a custom text style by key
  TextStyle? getCustomTextStyle(String key) => customTextStyles[key];

  /// Create a copy with custom text style
  ShopKitTypography withCustomTextStyle(String key, TextStyle style) {
    return copyWith(customTextStyles: {...customTextStyles, key: style});
  }

  ShopKitTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    Map<String, TextStyle>? customTextStyles,
  }) {
    return ShopKitTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      customTextStyles: customTextStyles ?? this.customTextStyles,
    );
  }
}

/// Spacing configuration with semantic naming
class ShopKitSpacing {
  const ShopKitSpacing({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    this.customSpacing = const {},
  });

  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  // Custom spacing values
  final Map<String, double> customSpacing;

  /// Get a custom spacing value by key
  double? getCustomSpacing(String key) => customSpacing[key];

  /// Create a copy with custom spacing
  ShopKitSpacing withCustomSpacing(String key, double value) {
    return copyWith(customSpacing: {...customSpacing, key: value});
  }

  ShopKitSpacing copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    Map<String, double>? customSpacing,
  }) {
    return ShopKitSpacing(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      customSpacing: customSpacing ?? this.customSpacing,
    );
  }
}

/// Border radius configuration
class ShopKitBorderRadius {
  const ShopKitBorderRadius({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
    this.customRadius = const {},
  });

  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  // Custom radius values
  final Map<String, double> customRadius;

  /// Get a custom radius value by key
  double? getCustomRadius(String key) => customRadius[key];

  /// Create a copy with custom radius
  ShopKitBorderRadius withCustomRadius(String key, double value) {
    return copyWith(customRadius: {...customRadius, key: value});
  }

  ShopKitBorderRadius copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
    Map<String, double>? customRadius,
  }) {
    return ShopKitBorderRadius(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
      customRadius: customRadius ?? this.customRadius,
    );
  }
}

/// Elevation configuration
class ShopKitElevation {
  const ShopKitElevation({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    this.customElevation = const {},
  });

  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  // Custom elevation values
  final Map<String, double> customElevation;

  /// Get a custom elevation value by key
  double? getCustomElevation(String key) => customElevation[key];

  /// Create a copy with custom elevation
  ShopKitElevation withCustomElevation(String key, double value) {
    return copyWith(customElevation: {...customElevation, key: value});
  }

  ShopKitElevation copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    Map<String, double>? customElevation,
  }) {
    return ShopKitElevation(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      customElevation: customElevation ?? this.customElevation,
    );
  }
}

/// Animation configuration
class ShopKitAnimation {
  const ShopKitAnimation({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.easeCurve,
    required this.bounceInCurve,
    required this.bounceOutCurve,
    this.customDurations = const {},
    this.customCurves = const {},
  });

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve easeCurve;
  final Curve bounceInCurve;
  final Curve bounceOutCurve;

  // Custom durations and curves
  final Map<String, Duration> customDurations;
  final Map<String, Curve> customCurves;

  /// Get a custom duration by key
  Duration? getCustomDuration(String key) => customDurations[key];

  /// Get a custom curve by key
  Curve? getCustomCurve(String key) => customCurves[key];

  ShopKitAnimation copyWith({
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Curve? easeCurve,
    Curve? bounceInCurve,
    Curve? bounceOutCurve,
    Map<String, Duration>? customDurations,
    Map<String, Curve>? customCurves,
  }) {
    return ShopKitAnimation(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      easeCurve: easeCurve ?? this.easeCurve,
      bounceInCurve: bounceInCurve ?? this.bounceInCurve,
      bounceOutCurve: bounceOutCurve ?? this.bounceOutCurve,
      customDurations: customDurations ?? this.customDurations,
      customCurves: customCurves ?? this.customCurves,
    );
  }
}
