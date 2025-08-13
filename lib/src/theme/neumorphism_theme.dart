// neumorphism_theme.dart
import 'package:flutter/material.dart';
import 'base_theme.dart';

/// Neumorphism design system theme implementation
class ShopKitNeumorphismTheme extends ShopKitBaseTheme {
  const ShopKitNeumorphismTheme({
    required super.colorScheme,
    required super.typography,
    required super.spacing,
    required super.borderRadius,
    required super.elevation,
    required super.animation,
    super.customProperties = const {},
    this.surfaceColor = const Color(0xFFE0E5EC),
    this.shadowColor = const Color(0xFFA3B1C6),
    this.highlightColor = const Color(0xFFFFFFFF),
    this.shadowBlur = 20.0,
    this.shadowOffset = const Offset(8, 8),
    this.highlightBlur = 20.0,
    this.highlightOffset = const Offset(-8, -8),
    this.intensity = 1.0,
    this.pressedDepth = 2.0,
    this.raisedDepth = 8.0,
    this.flatDepth = 0.0,
  }) : super(designSystem: DesignSystem.neumorphism);

  /// Base surface color for neumorphic elements
  final Color surfaceColor;

  /// Shadow color for neumorphic depth
  final Color shadowColor;

  /// Highlight color for neumorphic depth
  final Color highlightColor;

  /// Shadow blur radius
  final double shadowBlur;

  /// Shadow offset
  final Offset shadowOffset;

  /// Highlight blur radius
  final double highlightBlur;

  /// Highlight offset
  final Offset highlightOffset;

  /// Overall intensity of neumorphic effect (0.0 - 2.0)
  final double intensity;

  /// Depth for pressed state
  final double pressedDepth;

  /// Depth for raised elements
  final double raisedDepth;

  /// Depth for flat elements
  final double flatDepth;

  @override
  ShopKitNeumorphismTheme copyWith({
    ShopKitColorScheme? colorScheme,
    ShopKitTypography? typography,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic>? customProperties,
    Color? surfaceColor,
    Color? shadowColor,
    Color? highlightColor,
    double? shadowBlur,
    Offset? shadowOffset,
    double? highlightBlur,
    Offset? highlightOffset,
    double? intensity,
    double? pressedDepth,
    double? raisedDepth,
    double? flatDepth,
  }) {
    return ShopKitNeumorphismTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      animation: animation ?? this.animation,
      customProperties: customProperties ?? this.customProperties,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      shadowColor: shadowColor ?? this.shadowColor,
      highlightColor: highlightColor ?? this.highlightColor,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      highlightBlur: highlightBlur ?? this.highlightBlur,
      highlightOffset: highlightOffset ?? this.highlightOffset,
      intensity: intensity ?? this.intensity,
      pressedDepth: pressedDepth ?? this.pressedDepth,
      raisedDepth: raisedDepth ?? this.raisedDepth,
      flatDepth: flatDepth ?? this.flatDepth,
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
  ShopKitNeumorphismTheme lerp(ShopKitBaseTheme? other, double t) {
    if (other is! ShopKitNeumorphismTheme) return this;
    
    return ShopKitNeumorphismTheme(
      colorScheme: colorScheme, // Simplified for brevity
      typography: typography,
      spacing: spacing,
      borderRadius: borderRadius,
      elevation: elevation,
      animation: animation,
      customProperties: t < 0.5 ? customProperties : other.customProperties,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      shadowBlur: shadowBlur + (other.shadowBlur - shadowBlur) * t,
      shadowOffset: Offset.lerp(shadowOffset, other.shadowOffset, t)!,
      highlightBlur: highlightBlur + (other.highlightBlur - highlightBlur) * t,
      highlightOffset: Offset.lerp(highlightOffset, other.highlightOffset, t)!,
      intensity: intensity + (other.intensity - intensity) * t,
      pressedDepth: pressedDepth + (other.pressedDepth - pressedDepth) * t,
      raisedDepth: raisedDepth + (other.raisedDepth - raisedDepth) * t,
      flatDepth: flatDepth + (other.flatDepth - flatDepth) * t,
    );
  }

  /// Get neumorphic box decoration for raised elements
  BoxDecoration getRaisedDecoration({
    double? depth,
    double? borderRadius,
    Color? backgroundColor,
  }) {
    final effectiveDepth = (depth ?? raisedDepth) * intensity;
    final effectiveRadius = borderRadius ?? this.borderRadius.md;
    
    return BoxDecoration(
      color: backgroundColor ?? surfaceColor,
      borderRadius: BorderRadius.circular(effectiveRadius),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.2 * intensity),
          offset: shadowOffset * (effectiveDepth / raisedDepth),
          blurRadius: shadowBlur * (effectiveDepth / raisedDepth),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: highlightColor.withValues(alpha: 0.8 * intensity),
          offset: highlightOffset * (effectiveDepth / raisedDepth),
          blurRadius: highlightBlur * (effectiveDepth / raisedDepth),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Get neumorphic box decoration for pressed elements
  BoxDecoration getPressedDecoration({
    double? depth,
    double? borderRadius,
    Color? backgroundColor,
  }) {
    final effectiveDepth = (depth ?? pressedDepth) * intensity;
    final effectiveRadius = borderRadius ?? this.borderRadius.md;
    
    return BoxDecoration(
      color: backgroundColor ?? surfaceColor,
      borderRadius: BorderRadius.circular(effectiveRadius),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.3 * intensity),
          offset: -shadowOffset * (effectiveDepth / pressedDepth) * 0.5,
          blurRadius: shadowBlur * (effectiveDepth / pressedDepth) * 0.5,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: highlightColor.withValues(alpha: 0.1 * intensity),
          offset: -highlightOffset * (effectiveDepth / pressedDepth) * 0.5,
          blurRadius: highlightBlur * (effectiveDepth / pressedDepth) * 0.5,
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Get neumorphic box decoration for flat elements
  BoxDecoration getFlatDecoration({
    double? borderRadius,
    Color? backgroundColor,
  }) {
    final effectiveRadius = borderRadius ?? this.borderRadius.md;
    
    return BoxDecoration(
      color: backgroundColor ?? surfaceColor,
      borderRadius: BorderRadius.circular(effectiveRadius),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.1 * intensity),
          offset: shadowOffset * 0.25,
          blurRadius: shadowBlur * 0.25,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: highlightColor.withValues(alpha: 0.4 * intensity),
          offset: highlightOffset * 0.25,
          blurRadius: highlightBlur * 0.25,
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Factory constructors for light and dark neumorphic themes
  factory ShopKitNeumorphismTheme.light({
    Color? surfaceColor,
    double? intensity,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    final surface = surfaceColor ?? const Color(0xFFE0E5EC);
    
    final colorScheme = ShopKitColorScheme(
      primary: const Color(0xFF6366F1),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE0E7FF),
      onPrimaryContainer: const Color(0xFF1E1B4B),
      secondary: const Color(0xFF8B5CF6),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFF3E8FF),
      onSecondaryContainer: const Color(0xFF3C1361),
      tertiary: const Color(0xFF06B6D4),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFCFFAFE),
      onTertiaryContainer: const Color(0xFF0C4A6E),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: const Color(0xFF7F1D1D),
      surface: surface,
      onSurface: const Color(0xFF374151),
      surfaceVariant: const Color(0xFFF3F4F6),
      onSurfaceVariant: const Color(0xFF6B7280),
      outline: const Color(0xFFD1D5DB),
      outlineVariant: const Color(0xFFE5E7EB),
      shadow: const Color(0xFFA3B1C6),
      scrim: Colors.black,
      inverseSurface: const Color(0xFF111827),
      onInverseSurface: Colors.white,
      inversePrimary: const Color(0xFF818CF8),
      surfaceTint: const Color(0xFF6366F1),
      success: const Color(0xFF10B981),
      onSuccess: Colors.white,
      warning: const Color(0xFFF59E0B),
      onWarning: Colors.white,
      info: const Color(0xFF3B82F6),
      onInfo: Colors.white,
    );
    
    return ShopKitNeumorphismTheme(
      colorScheme: colorScheme,
      typography: _defaultNeumorphicTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      surfaceColor: surface,
      shadowColor: const Color(0xFFA3B1C6),
      highlightColor: Colors.white,
      intensity: intensity ?? 1.0,
    );
  }

  factory ShopKitNeumorphismTheme.dark({
    Color? surfaceColor,
    double? intensity,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    final surface = surfaceColor ?? const Color(0xFF2D3748);
    
    final colorScheme = ShopKitColorScheme(
      primary: const Color(0xFF818CF8),
      onPrimary: const Color(0xFF1E1B4B),
      primaryContainer: const Color(0xFF3730A3),
      onPrimaryContainer: const Color(0xFFE0E7FF),
      secondary: const Color(0xFFA78BFA),
      onSecondary: const Color(0xFF3C1361),
      secondaryContainer: const Color(0xFF6D28D9),
      onSecondaryContainer: const Color(0xFFF3E8FF),
      tertiary: const Color(0xFF22D3EE),
      onTertiary: const Color(0xFF0C4A6E),
      tertiaryContainer: const Color(0xFF0891B2),
      onTertiaryContainer: const Color(0xFFCFFAFE),
      error: const Color(0xFFF87171),
      onError: const Color(0xFF7F1D1D),
      errorContainer: const Color(0xFFDC2626),
      onErrorContainer: const Color(0xFFFEE2E2),
      surface: surface,
      onSurface: const Color(0xFFF9FAFB),
      surfaceVariant: const Color(0xFF4A5568),
      onSurfaceVariant: const Color(0xFFE2E8F0),
      outline: const Color(0xFF718096),
      outlineVariant: const Color(0xFF2D3748),
      shadow: const Color(0xFF1A202C),
      scrim: Colors.black,
      inverseSurface: const Color(0xFFF9FAFB),
      onInverseSurface: const Color(0xFF111827),
      inversePrimary: const Color(0xFF6366F1),
      surfaceTint: const Color(0xFF818CF8),
      success: const Color(0xFF34D399),
      onSuccess: const Color(0xFF064E3B),
      warning: const Color(0xFFFBBF24),
      onWarning: const Color(0xFF78350F),
      info: const Color(0xFF60A5FA),
      onInfo: const Color(0xFF1E3A8A),
    );
    
    return ShopKitNeumorphismTheme(
      colorScheme: colorScheme,
      typography: _defaultNeumorphicTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      surfaceColor: surface,
      shadowColor: const Color(0xFF1A202C),
      highlightColor: const Color(0xFF4A5568),
      intensity: intensity ?? 1.0,
    );
  }
}

// Default configurations for neumorphism
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
  xs: 8.0,
  sm: 12.0,
  md: 16.0,
  lg: 24.0,
  xl: 32.0,
  full: 9999.0,
);

const _defaultElevation = ShopKitElevation(
  none: 0.0,
  xs: 2.0,
  sm: 4.0,
  md: 8.0,
  lg: 12.0,
  xl: 20.0,
);

const _defaultAnimation = ShopKitAnimation(
  fast: Duration(milliseconds: 200),
  normal: Duration(milliseconds: 400),
  slow: Duration(milliseconds: 600),
  easeCurve: Curves.easeInOut,
  bounceInCurve: Curves.elasticOut,
  bounceOutCurve: Curves.elasticIn,
);

const _defaultNeumorphicTypography = ShopKitTypography(
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.25),
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w300, letterSpacing: 0),
  displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, letterSpacing: 0),
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
  labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
);
