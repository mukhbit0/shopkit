// material3_theme.dart
import 'package:flutter/material.dart';
import 'base_theme.dart';

/// Material 3 design system theme implementation
class ShopKitMaterial3Theme extends ShopKitBaseTheme {
  const ShopKitMaterial3Theme({
    required super.colorScheme,
    required super.typography,
    required super.spacing,
    required super.borderRadius,
    required super.elevation,
    required super.animation,
    super.customProperties = const {},
    this.useMaterial3 = true,
    this.dynamicColorEnabled = false,
    this.seedColor,
    this.brightness = Brightness.light,
    this.stateLayerOpacity = const StateLayerOpacity(),
    this.containerElevation = const ContainerElevation(),
    this.surfaceTint,
  }) : super(designSystem: DesignSystem.material3);

  /// Whether to use Material 3 design
  final bool useMaterial3;

  /// Whether to enable dynamic color from system
  final bool dynamicColorEnabled;

  /// Seed color for dynamic color generation
  final Color? seedColor;

  /// Theme brightness
  final Brightness brightness;

  /// State layer opacity configuration
  final StateLayerOpacity stateLayerOpacity;

  /// Container elevation configuration
  final ContainerElevation containerElevation;

  /// Surface tint color
  final Color? surfaceTint;

  @override
  ShopKitMaterial3Theme copyWith({
    ShopKitColorScheme? colorScheme,
    ShopKitTypography? typography,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic>? customProperties,
    bool? useMaterial3,
    bool? dynamicColorEnabled,
    Color? seedColor,
    Brightness? brightness,
    StateLayerOpacity? stateLayerOpacity,
    ContainerElevation? containerElevation,
    Color? surfaceTint,
  }) {
    return ShopKitMaterial3Theme(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      animation: animation ?? this.animation,
      customProperties: customProperties ?? this.customProperties,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      dynamicColorEnabled: dynamicColorEnabled ?? this.dynamicColorEnabled,
      seedColor: seedColor ?? this.seedColor,
      brightness: brightness ?? this.brightness,
      stateLayerOpacity: stateLayerOpacity ?? this.stateLayerOpacity,
      containerElevation: containerElevation ?? this.containerElevation,
      surfaceTint: surfaceTint ?? this.surfaceTint,
    );
  }

  @override
  ShopKitBaseTheme withCustomProperty(String key, dynamic value) {
    return copyWith(customProperties: {...customProperties, key: value});
  }

  @override
  ShopKitBaseTheme withCustomProperties(Map<String, dynamic> properties) {
    return copyWith(customProperties: {...customProperties, ...properties});
  }

  @override
  ShopKitMaterial3Theme lerp(ShopKitBaseTheme? other, double t) {
    if (other is! ShopKitMaterial3Theme) return this;

    return ShopKitMaterial3Theme(
      colorScheme: ShopKitColorScheme(
        primary: Color.lerp(colorScheme.primary, other.colorScheme.primary, t)!,
        onPrimary:
            Color.lerp(colorScheme.onPrimary, other.colorScheme.onPrimary, t)!,
        primaryContainer: Color.lerp(colorScheme.primaryContainer,
            other.colorScheme.primaryContainer, t)!,
        onPrimaryContainer: Color.lerp(colorScheme.onPrimaryContainer,
            other.colorScheme.onPrimaryContainer, t)!,
        secondary:
            Color.lerp(colorScheme.secondary, other.colorScheme.secondary, t)!,
        onSecondary: Color.lerp(
            colorScheme.onSecondary, other.colorScheme.onSecondary, t)!,
        secondaryContainer: Color.lerp(colorScheme.secondaryContainer,
            other.colorScheme.secondaryContainer, t)!,
        onSecondaryContainer: Color.lerp(colorScheme.onSecondaryContainer,
            other.colorScheme.onSecondaryContainer, t)!,
        tertiary:
            Color.lerp(colorScheme.tertiary, other.colorScheme.tertiary, t)!,
        onTertiary: Color.lerp(
            colorScheme.onTertiary, other.colorScheme.onTertiary, t)!,
        tertiaryContainer: Color.lerp(colorScheme.tertiaryContainer,
            other.colorScheme.tertiaryContainer, t)!,
        onTertiaryContainer: Color.lerp(colorScheme.onTertiaryContainer,
            other.colorScheme.onTertiaryContainer, t)!,
        error: Color.lerp(colorScheme.error, other.colorScheme.error, t)!,
        onError: Color.lerp(colorScheme.onError, other.colorScheme.onError, t)!,
        errorContainer: Color.lerp(
            colorScheme.errorContainer, other.colorScheme.errorContainer, t)!,
        onErrorContainer: Color.lerp(colorScheme.onErrorContainer,
            other.colorScheme.onErrorContainer, t)!,
        surface: Color.lerp(colorScheme.surface, other.colorScheme.surface, t)!,
        onSurface:
            Color.lerp(colorScheme.onSurface, other.colorScheme.onSurface, t)!,
        // Using surface as fallback for deprecated surfaceVariant; can be migrated to container tokens in future
        surfaceVariant:
            Color.lerp(colorScheme.surface, other.colorScheme.surface, t)!,
        onSurfaceVariant:
            Color.lerp(colorScheme.onSurface, other.colorScheme.onSurface, t)!,
        outline: Color.lerp(colorScheme.outline, other.colorScheme.outline, t)!,
        outlineVariant: Color.lerp(
            colorScheme.outlineVariant, other.colorScheme.outlineVariant, t)!,
        shadow: Color.lerp(colorScheme.shadow, other.colorScheme.shadow, t)!,
        scrim: Color.lerp(colorScheme.scrim, other.colorScheme.scrim, t)!,
        inverseSurface: Color.lerp(
            colorScheme.inverseSurface, other.colorScheme.inverseSurface, t)!,
        onInverseSurface: Color.lerp(colorScheme.onInverseSurface,
            other.colorScheme.onInverseSurface, t)!,
        inversePrimary: Color.lerp(
            colorScheme.inversePrimary, other.colorScheme.inversePrimary, t)!,
        surfaceTint: Color.lerp(
            colorScheme.surfaceTint, other.colorScheme.surfaceTint, t)!,
        success:
            colorScheme.success != null && other.colorScheme.success != null
                ? Color.lerp(colorScheme.success, other.colorScheme.success, t)
                : colorScheme.success ?? other.colorScheme.success,
        onSuccess: colorScheme.onSuccess != null &&
                other.colorScheme.onSuccess != null
            ? Color.lerp(colorScheme.onSuccess, other.colorScheme.onSuccess, t)
            : colorScheme.onSuccess ?? other.colorScheme.onSuccess,
        warning:
            colorScheme.warning != null && other.colorScheme.warning != null
                ? Color.lerp(colorScheme.warning, other.colorScheme.warning, t)
                : colorScheme.warning ?? other.colorScheme.warning,
        onWarning: colorScheme.onWarning != null &&
                other.colorScheme.onWarning != null
            ? Color.lerp(colorScheme.onWarning, other.colorScheme.onWarning, t)
            : colorScheme.onWarning ?? other.colorScheme.onWarning,
        info: colorScheme.info != null && other.colorScheme.info != null
            ? Color.lerp(colorScheme.info, other.colorScheme.info, t)
            : colorScheme.info ?? other.colorScheme.info,
        onInfo: colorScheme.onInfo != null && other.colorScheme.onInfo != null
            ? Color.lerp(colorScheme.onInfo, other.colorScheme.onInfo, t)
            : colorScheme.onInfo ?? other.colorScheme.onInfo,
        gradient: t < 0.5 ? colorScheme.gradient : other.colorScheme.gradient,
      ),
      typography: t < 0.5 ? typography : other.typography,
      spacing: ShopKitSpacing(
        none: (spacing.none + (other.spacing.none - spacing.none) * t),
        xs: (spacing.xs + (other.spacing.xs - spacing.xs) * t),
        sm: (spacing.sm + (other.spacing.sm - spacing.sm) * t),
        md: (spacing.md + (other.spacing.md - spacing.md) * t),
        lg: (spacing.lg + (other.spacing.lg - spacing.lg) * t),
        xl: (spacing.xl + (other.spacing.xl - spacing.xl) * t),
        xxl: (spacing.xxl + (other.spacing.xxl - spacing.xxl) * t),
      ),
      borderRadius: ShopKitBorderRadius(
        none: (borderRadius.none +
            (other.borderRadius.none - borderRadius.none) * t),
        xs: (borderRadius.xs + (other.borderRadius.xs - borderRadius.xs) * t),
        sm: (borderRadius.sm + (other.borderRadius.sm - borderRadius.sm) * t),
        md: (borderRadius.md + (other.borderRadius.md - borderRadius.md) * t),
        lg: (borderRadius.lg + (other.borderRadius.lg - borderRadius.lg) * t),
        xl: (borderRadius.xl + (other.borderRadius.xl - borderRadius.xl) * t),
        full: (borderRadius.full +
            (other.borderRadius.full - borderRadius.full) * t),
      ),
      elevation: ShopKitElevation(
        none: (elevation.none + (other.elevation.none - elevation.none) * t),
        xs: (elevation.xs + (other.elevation.xs - elevation.xs) * t),
        sm: (elevation.sm + (other.elevation.sm - elevation.sm) * t),
        md: (elevation.md + (other.elevation.md - elevation.md) * t),
        lg: (elevation.lg + (other.elevation.lg - elevation.lg) * t),
        xl: (elevation.xl + (other.elevation.xl - elevation.xl) * t),
      ),
      animation: t < 0.5 ? animation : other.animation,
      customProperties: t < 0.5 ? customProperties : other.customProperties,
      useMaterial3: t < 0.5 ? useMaterial3 : other.useMaterial3,
      dynamicColorEnabled:
          t < 0.5 ? dynamicColorEnabled : other.dynamicColorEnabled,
      seedColor: Color.lerp(seedColor, other.seedColor, t),
      brightness: t < 0.5 ? brightness : other.brightness,
      stateLayerOpacity: t < 0.5 ? stateLayerOpacity : other.stateLayerOpacity,
      containerElevation:
          t < 0.5 ? containerElevation : other.containerElevation,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t),
    );
  }

  /// Factory constructors for light and dark themes
  factory ShopKitMaterial3Theme.light({
    Color? seedColor,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    final colorScheme = _generateColorScheme(
      seedColor: seedColor ?? const Color(0xFF6750A4),
      brightness: Brightness.light,
    );

    return ShopKitMaterial3Theme(
      colorScheme: colorScheme,
      typography: _defaultTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      brightness: Brightness.light,
      seedColor: seedColor,
    );
  }

  factory ShopKitMaterial3Theme.dark({
    Color? seedColor,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    final colorScheme = _generateColorScheme(
      seedColor: seedColor ?? const Color(0xFF6750A4),
      brightness: Brightness.dark,
    );

    return ShopKitMaterial3Theme(
      colorScheme: colorScheme,
      typography: _defaultTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      brightness: Brightness.dark,
      seedColor: seedColor,
    );
  }

  /// Generate Material 3 color scheme from seed color
  static ShopKitColorScheme _generateColorScheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ShopKitColorScheme(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      surfaceVariant: scheme.surfaceVariant,
      onSurfaceVariant: scheme.onSurfaceVariant,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
      success: brightness == Brightness.light
          ? const Color(0xFF10B981)
          : const Color(0xFF34D399),
      onSuccess: brightness == Brightness.light ? Colors.white : Colors.black,
      warning: brightness == Brightness.light
          ? const Color(0xFFF59E0B)
          : const Color(0xFFFBBF24),
      onWarning: brightness == Brightness.light ? Colors.white : Colors.black,
      info: brightness == Brightness.light
          ? const Color(0xFF3B82F6)
          : const Color(0xFF60A5FA),
      onInfo: brightness == Brightness.light ? Colors.white : Colors.black,
    );
  }
}

/// State layer opacity configuration for Material 3
class StateLayerOpacity {
  const StateLayerOpacity({
    this.hover = 0.08,
    this.focus = 0.12,
    this.pressed = 0.12,
    this.dragged = 0.16,
    this.disabled = 0.12,
  });

  final double hover;
  final double focus;
  final double pressed;
  final double dragged;
  final double disabled;
}

/// Container elevation configuration for Material 3
class ContainerElevation {
  const ContainerElevation({
    this.level0 = 0.0,
    this.level1 = 1.0,
    this.level2 = 3.0,
    this.level3 = 6.0,
    this.level4 = 8.0,
    this.level5 = 12.0,
  });

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;
}

// Default configurations
const _defaultSpacing = ShopKitSpacing(
  none: 0.0,
  xs: 4.0,
  sm: 8.0,
  md: 16.0,
  lg: 24.0,
  xl: 32.0,
  xxl: 48.0,
);

const _defaultBorderRadius = ShopKitBorderRadius(
  none: 0.0,
  xs: 4.0,
  sm: 8.0,
  md: 12.0,
  lg: 16.0,
  xl: 24.0,
  full: 9999.0,
);

const _defaultElevation = ShopKitElevation(
  none: 0.0,
  xs: 1.0,
  sm: 2.0,
  md: 4.0,
  lg: 8.0,
  xl: 16.0,
);

const _defaultAnimation = ShopKitAnimation(
  fast: Duration(milliseconds: 150),
  normal: Duration(milliseconds: 300),
  slow: Duration(milliseconds: 500),
  easeCurve: Curves.easeInOut,
  bounceInCurve: Curves.bounceIn,
  bounceOutCurve: Curves.bounceOut,
);

const _defaultTypography = ShopKitTypography(
  displayLarge: TextStyle(
      fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
  displayMedium:
      TextStyle(fontSize: 45, fontWeight: FontWeight.w400, letterSpacing: 0),
  displaySmall:
      TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineLarge:
      TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineMedium:
      TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineSmall:
      TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
  titleLarge:
      TextStyle(fontSize: 22, fontWeight: FontWeight.w400, letterSpacing: 0),
  titleMedium:
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall:
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge:
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium:
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall:
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelLarge:
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  labelMedium:
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  labelSmall:
      TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
);
