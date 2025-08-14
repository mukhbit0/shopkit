import 'package:flutter/material.dart';

/// Supported theme styles for ShopKit widgets
enum ShopKitThemeStyle {
  material3,
  materialYou,
  neumorphism,
  glassmorphism,
  cupertino,
  minimal,
  retro,
  neon,
}

/// Extension to get theme style from string
extension ShopKitThemeStyleExtension on ShopKitThemeStyle {
  String get name {
    switch (this) {
      case ShopKitThemeStyle.material3:
        return 'material3';
      case ShopKitThemeStyle.materialYou:
        return 'materialYou';
      case ShopKitThemeStyle.neumorphism:
        return 'neumorphism';
      case ShopKitThemeStyle.glassmorphism:
        return 'glassmorphism';
      case ShopKitThemeStyle.cupertino:
        return 'cupertino';
      case ShopKitThemeStyle.minimal:
        return 'minimal';
      case ShopKitThemeStyle.retro:
        return 'retro';
      case ShopKitThemeStyle.neon:
        return 'neon';
    }
  }

  static ShopKitThemeStyle fromString(String value) {
    switch (value.toLowerCase()) {
      case 'material3':
        return ShopKitThemeStyle.material3;
      case 'materialyou':
        return ShopKitThemeStyle.materialYou;
      case 'neumorphism':
      case 'neumorphic':
        return ShopKitThemeStyle.neumorphism;
      case 'glassmorphism':
      case 'glassmorphic':
      case 'glass':
        return ShopKitThemeStyle.glassmorphism;
      case 'cupertino':
      case 'ios':
        return ShopKitThemeStyle.cupertino;
      case 'minimal':
        return ShopKitThemeStyle.minimal;
      case 'retro':
        return ShopKitThemeStyle.retro;
      case 'neon':
        return ShopKitThemeStyle.neon;
      default:
        return ShopKitThemeStyle.material3;
    }
  }
}

/// Theme configuration for different styles
class ShopKitThemeConfig {
  final double borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final Color? shadowColor;
  final EdgeInsets padding;
  final Duration animationDuration;
  final Curve animationCurve;
  final double hoverScale;
  final bool enableBlur;
  final bool enableShadows;
  final bool enableGradients;
  final bool enableAnimations;

  const ShopKitThemeConfig({
    required this.borderRadius,
    required this.elevation,
    this.backgroundColor,
    this.primaryColor,
    this.onPrimaryColor,
    this.shadowColor,
    required this.padding,
    required this.animationDuration,
    required this.animationCurve,
    required this.hoverScale,
    required this.enableBlur,
    required this.enableShadows,
    required this.enableGradients,
    required this.enableAnimations,
  });

  static ShopKitThemeConfig forStyle(ShopKitThemeStyle style, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (style) {
      case ShopKitThemeStyle.material3:
        return ShopKitThemeConfig(
          borderRadius: 12.0,
          elevation: 1.0,
          backgroundColor: colorScheme.surface,
          primaryColor: colorScheme.primary,
          onPrimaryColor: colorScheme.onPrimary,
          shadowColor: colorScheme.shadow,
          padding: const EdgeInsets.all(16),
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeOut,
          hoverScale: 0.98,
          enableBlur: false,
          enableShadows: true,
          enableGradients: false,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.materialYou:
        return ShopKitThemeConfig(
          borderRadius: 28.0,
          elevation: 2.0,
          backgroundColor: colorScheme.surfaceContainer,
          primaryColor: colorScheme.primary,
          onPrimaryColor: colorScheme.onPrimary,
          shadowColor: colorScheme.shadow,
          padding: const EdgeInsets.all(20),
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeOutCubic,
          hoverScale: 0.96,
          enableBlur: false,
          enableShadows: true,
          enableGradients: true,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.neumorphism:
        final isDark = theme.brightness == Brightness.dark;
        return ShopKitThemeConfig(
          borderRadius: 20.0,
          elevation: 0.0,
          backgroundColor: isDark ? const Color(0xFF2D3748) : const Color(0xFFE0E5EC),
          primaryColor: colorScheme.primary,
          onPrimaryColor: colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(24),
          animationDuration: const Duration(milliseconds: 400),
          animationCurve: Curves.elasticOut,
          hoverScale: 0.95,
          enableBlur: false,
          enableShadows: true, // Custom neumorphic shadows
          enableGradients: false,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.glassmorphism:
        return ShopKitThemeConfig(
          borderRadius: 24.0,
          elevation: 0.0,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          primaryColor: colorScheme.primary,
          onPrimaryColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(24),
          animationDuration: const Duration(milliseconds: 500),
          animationCurve: Curves.easeOutQuart,
          hoverScale: 1.02,
          enableBlur: true,
          enableShadows: false,
          enableGradients: true,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.cupertino:
        return ShopKitThemeConfig(
          borderRadius: 8.0,
          elevation: 0.0,
          backgroundColor: colorScheme.surface,
          primaryColor: colorScheme.primary,
          onPrimaryColor: colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(16),
          animationDuration: const Duration(milliseconds: 150),
          animationCurve: Curves.easeInOut,
          hoverScale: 0.97,
          enableBlur: false,
          enableShadows: false,
          enableGradients: false,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.minimal:
        return ShopKitThemeConfig(
          borderRadius: 4.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          primaryColor: colorScheme.primary,
          onPrimaryColor: colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(12),
          animationDuration: const Duration(milliseconds: 100),
          animationCurve: Curves.linear,
          hoverScale: 1.0,
          enableBlur: false,
          enableShadows: false,
          enableGradients: false,
          enableAnimations: false,
        );

      case ShopKitThemeStyle.retro:
        return const ShopKitThemeConfig(
          borderRadius: 0.0,
          elevation: 8.0,
          backgroundColor: Color(0xFFFFF8DC),
          primaryColor: Color(0xFFFF6B35),
          onPrimaryColor: Colors.white,
          shadowColor: Colors.black54,
          padding: EdgeInsets.all(20),
          animationDuration: Duration(milliseconds: 600),
          animationCurve: Curves.bounceOut,
          hoverScale: 0.9,
          enableBlur: false,
          enableShadows: true,
          enableGradients: true,
          enableAnimations: true,
        );

      case ShopKitThemeStyle.neon:
        return const ShopKitThemeConfig(
          borderRadius: 16.0,
          elevation: 0.0,
          backgroundColor: Colors.black87,
          primaryColor: Colors.cyan,
          onPrimaryColor: Colors.black,
          shadowColor: Colors.cyan,
          padding: EdgeInsets.all(18),
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.easeInOutBack,
          hoverScale: 1.05,
          enableBlur: true,
          enableShadows: true, // Neon glow effects
          enableGradients: true,
          enableAnimations: true,
        );
    }
  }
}
