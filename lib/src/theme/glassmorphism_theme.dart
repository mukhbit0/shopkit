// glassmorphism_theme.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'base_theme.dart';

/// Glassmorphism design system theme implementation
class ShopKitGlassmorphismTheme extends ShopKitBaseTheme {
  const ShopKitGlassmorphismTheme({
    required super.colorScheme,
    required super.typography,
    required super.spacing,
    required super.borderRadius,
    required super.elevation,
    required super.animation,
    super.customProperties = const {},
    this.backdropOpacity = 0.1,
    this.blurIntensity = 20.0,
    this.borderOpacity = 0.2,
    this.borderWidth = 1.0,
    this.gradientOpacity = 0.1,
    this.shadowOpacity = 0.1,
    this.reflectionIntensity = 0.3,
    this.glowEffect = false,
    this.frostedEffect = true,
  }) : super(designSystem: DesignSystem.glassmorphism);

  /// Opacity of the backdrop color
  final double backdropOpacity;

  /// Intensity of the backdrop blur effect
  final double blurIntensity;

  /// Opacity of the border
  final double borderOpacity;

  /// Width of the border
  final double borderWidth;

  /// Opacity of gradient overlays
  final double gradientOpacity;

  /// Opacity of shadows
  final double shadowOpacity;

  /// Intensity of reflection effects
  final double reflectionIntensity;

  /// Whether to show glow effects
  final bool glowEffect;

  /// Whether to show frosted glass effect
  final bool frostedEffect;

  @override
  ShopKitGlassmorphismTheme copyWith({
    ShopKitColorScheme? colorScheme,
    ShopKitTypography? typography,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic>? customProperties,
    double? backdropOpacity,
    double? blurIntensity,
    double? borderOpacity,
    double? borderWidth,
    double? gradientOpacity,
    double? shadowOpacity,
    double? reflectionIntensity,
    bool? glowEffect,
    bool? frostedEffect,
  }) {
    return ShopKitGlassmorphismTheme(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      animation: animation ?? this.animation,
      customProperties: customProperties ?? this.customProperties,
      backdropOpacity: backdropOpacity ?? this.backdropOpacity,
      blurIntensity: blurIntensity ?? this.blurIntensity,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      gradientOpacity: gradientOpacity ?? this.gradientOpacity,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      reflectionIntensity: reflectionIntensity ?? this.reflectionIntensity,
      glowEffect: glowEffect ?? this.glowEffect,
      frostedEffect: frostedEffect ?? this.frostedEffect,
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
  ShopKitGlassmorphismTheme lerp(ShopKitBaseTheme? other, double t) {
    if (other is! ShopKitGlassmorphismTheme) return this;
    
    return ShopKitGlassmorphismTheme(
      colorScheme: colorScheme, // Simplified for brevity
      typography: typography,
      spacing: spacing,
      borderRadius: borderRadius,
      elevation: elevation,
      animation: animation,
      customProperties: t < 0.5 ? customProperties : other.customProperties,
      backdropOpacity: backdropOpacity + (other.backdropOpacity - backdropOpacity) * t,
      blurIntensity: blurIntensity + (other.blurIntensity - blurIntensity) * t,
      borderOpacity: borderOpacity + (other.borderOpacity - borderOpacity) * t,
      borderWidth: borderWidth + (other.borderWidth - borderWidth) * t,
      gradientOpacity: gradientOpacity + (other.gradientOpacity - gradientOpacity) * t,
      shadowOpacity: shadowOpacity + (other.shadowOpacity - shadowOpacity) * t,
      reflectionIntensity: reflectionIntensity + (other.reflectionIntensity - reflectionIntensity) * t,
      glowEffect: t < 0.5 ? glowEffect : other.glowEffect,
      frostedEffect: t < 0.5 ? frostedEffect : other.frostedEffect,
    );
  }

  /// Get glassmorphic container decoration
  BoxDecoration getGlassDecoration({
    Color? backgroundColor,
    double? borderRadius,
    List<Color>? gradientColors,
    bool? enableGlow,
    double? customBlur,
  }) {
    final effectiveRadius = borderRadius ?? this.borderRadius.md;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final useGlow = enableGlow ?? glowEffect;
    final blur = customBlur ?? blurIntensity;
    
    return BoxDecoration(
      color: effectiveBackgroundColor.withValues(alpha: backdropOpacity),
      borderRadius: BorderRadius.circular(effectiveRadius),
      border: Border.all(
        color: colorScheme.outline.withValues(alpha: borderOpacity),
        width: borderWidth,
      ),
      gradient: gradientColors != null
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors
                  .map((color) => color.withValues(alpha: gradientOpacity))
                  .toList(),
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: gradientOpacity),
                Colors.white.withValues(alpha: gradientOpacity * 0.5),
              ],
            ),
      boxShadow: [
        if (shadowOpacity > 0)
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: shadowOpacity),
            blurRadius: blur * 0.5,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        if (useGlow)
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: blur,
            offset: Offset.zero,
            spreadRadius: 2,
          ),
      ],
    );
  }

  /// Get frosted glass decoration with backdrop filter effect
  Widget createFrostedContainer({
    required Widget child,
    Color? backgroundColor,
    double? borderRadius,
    List<Color>? gradientColors,
    bool? enableGlow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
  }) {
    final decoration = getGlassDecoration(
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      gradientColors: gradientColors,
      enableGlow: enableGlow,
    );

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? this.borderRadius.md),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: frostedEffect ? blurIntensity : 0,
            sigmaY: frostedEffect ? blurIntensity : 0,
          ),
          child: Container(
            padding: padding,
            decoration: decoration,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Factory constructors for different glassmorphism styles
  factory ShopKitGlassmorphismTheme.light({
    double? blurIntensity,
    double? backdropOpacity,
    bool? glowEffect,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    const colorScheme = ShopKitColorScheme(
      primary: Color(0xFF6366F1),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF1E1B4B),
      secondary: Color(0xFF8B5CF6),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF3E8FF),
      onSecondaryContainer: Color(0xFF3C1361),
      tertiary: Color(0xFF06B6D4),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFCFFAFE),
      onTertiaryContainer: Color(0xFF0C4A6E),
      error: Color(0xFFEF4444),
      onError: Colors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
      surface: Colors.white,
      onSurface: Color(0xFF111827),
      surfaceVariant: Color(0xFFF9FAFB),
      onSurfaceVariant: Color(0xFF6B7280),
      outline: Color(0xFFE5E7EB),
      outlineVariant: Color(0xFFF3F4F6),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF111827),
      onInverseSurface: Colors.white,
      inversePrimary: Color(0xFF818CF8),
      surfaceTint: Color(0xFF6366F1),
      success: Color(0xFF10B981),
      onSuccess: Colors.white,
      warning: Color(0xFFF59E0B),
      onWarning: Colors.white,
      info: Color(0xFF3B82F6),
      onInfo: Colors.white,
    );
    
    return ShopKitGlassmorphismTheme(
      colorScheme: colorScheme,
      typography: _defaultGlassTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      blurIntensity: blurIntensity ?? 20.0,
      backdropOpacity: backdropOpacity ?? 0.1,
      glowEffect: glowEffect ?? false,
    );
  }

  factory ShopKitGlassmorphismTheme.dark({
    double? blurIntensity,
    double? backdropOpacity,
    bool? glowEffect,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitAnimation? animation,
    Map<String, dynamic> customProperties = const {},
  }) {
    const colorScheme = ShopKitColorScheme(
      primary: Color(0xFF818CF8),
      onPrimary: Color(0xFF1E1B4B),
      primaryContainer: Color(0xFF3730A3),
      onPrimaryContainer: Color(0xFFE0E7FF),
      secondary: Color(0xFFA78BFA),
      onSecondary: Color(0xFF3C1361),
      secondaryContainer: Color(0xFF6D28D9),
      onSecondaryContainer: Color(0xFFF3E8FF),
      tertiary: Color(0xFF22D3EE),
      onTertiary: Color(0xFF0C4A6E),
      tertiaryContainer: Color(0xFF0891B2),
      onTertiaryContainer: Color(0xFFCFFAFE),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      errorContainer: Color(0xFFDC2626),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF111827),
      onSurface: Colors.white,
      surfaceVariant: Color(0xFF1F2937),
      onSurfaceVariant: Color(0xFFD1D5DB),
      outline: Color(0xFF374151),
      outlineVariant: Color(0xFF4B5563),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Colors.white,
      onInverseSurface: Color(0xFF111827),
      inversePrimary: Color(0xFF6366F1),
      surfaceTint: Color(0xFF818CF8),
      success: Color(0xFF34D399),
      onSuccess: Color(0xFF064E3B),
      warning: Color(0xFFFBBF24),
      onWarning: Color(0xFF78350F),
      info: Color(0xFF60A5FA),
      onInfo: Color(0xFF1E3A8A),
    );
    
    return ShopKitGlassmorphismTheme(
      colorScheme: colorScheme,
      typography: _defaultGlassTypography,
      spacing: spacing ?? _defaultSpacing,
      borderRadius: borderRadius ?? _defaultBorderRadius,
      elevation: elevation ?? _defaultElevation,
      animation: animation ?? _defaultAnimation,
      customProperties: customProperties,
      blurIntensity: blurIntensity ?? 20.0,
      backdropOpacity: backdropOpacity ?? 0.15,
      glowEffect: glowEffect ?? true,
    );
  }
}

// Default configurations for glassmorphism
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
  xs: 6.0,
  sm: 12.0,
  md: 18.0,
  lg: 24.0,
  xl: 32.0,
  full: 9999.0,
);

const _defaultElevation = ShopKitElevation(
  none: 0.0,
  xs: 1.0,
  sm: 2.0,
  md: 4.0,
  lg: 8.0,
  xl: 12.0,
);

const _defaultAnimation = ShopKitAnimation(
  fast: Duration(milliseconds: 200),
  normal: Duration(milliseconds: 350),
  slow: Duration(milliseconds: 500),
  easeCurve: Curves.easeInOut,
  bounceInCurve: Curves.easeInBack,
  bounceOutCurve: Curves.easeOutBack,
);

const _defaultGlassTypography = ShopKitTypography(
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w200, letterSpacing: -0.25),
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w200, letterSpacing: 0),
  displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w300, letterSpacing: 0),
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, letterSpacing: 0),
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, letterSpacing: 0),
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, letterSpacing: 0),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 0.5),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 0.25),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, letterSpacing: 0.4),
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
);
