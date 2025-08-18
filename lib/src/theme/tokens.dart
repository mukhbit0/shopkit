import 'package:flutter/material.dart';

/// Defines the core color palette for the ShopKit design system.
///
/// This immutable class holds semantic color definitions that are used to build
/// component-specific themes, ensuring a consistent color language across the package.
@immutable
class ShopKitColorScheme {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color onError;
  final Color success;
  final Color warning;
  final Color info;

  const ShopKitColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onError,
    required this.success,
    required this.warning,
    required this.info,
  });
}

/// Defines the typographic scale for the ShopKit design system.
///
/// Provides a set of consistent text styles for various UI elements like
/// headlines, body text, and captions.
@immutable
class ShopKitTypography {
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle button;
  final TextStyle caption;

  const ShopKitTypography({
    required this.headline1,
    required this.headline2,
    required this.body1,
    required this.body2,
    required this.button,
    required this.caption,
  });
}

/// Defines the spacing scale (paddings, margins) for consistent layout.
@immutable
class ShopKitSpacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  const ShopKitSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });
}

/// Defines the border radius values for consistent shape language.
@immutable
class ShopKitBorderRadius {
  final double sm;
  final double md;
  final double lg;
  final double full;

  const ShopKitBorderRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });
}

/// Defines the animation timings and curves for the design system.
@immutable
class ShopKitAnimation {
  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Duration veryFast;
  final Duration verySlow;
  
  // Specific animation durations
  final Duration fadeIn;
  final Duration fadeOut;
  final Duration slideIn;
  final Duration slideOut;
  final Duration bounce;
  final Duration scale;
  final Duration rotation;
  final Duration pulse;
  final Duration shimmer;
  final Duration ripple;
  
  // Animation curves
  final Curve easeOut;
  final Curve easeIn;
  final Curve easeInOut;
  final Curve bounceIn;
  final Curve bounceOut;
  final Curve elastic;
  final Curve spring;

  const ShopKitAnimation({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.veryFast,
    required this.verySlow,
    required this.fadeIn,
    required this.fadeOut,
    required this.slideIn,
    required this.slideOut,
    required this.bounce,
    required this.scale,
    required this.rotation,
    required this.pulse,
    required this.shimmer,
    required this.ripple,
    required this.easeOut,
    required this.easeIn,
    required this.easeInOut,
    required this.bounceIn,
    required this.bounceOut,
    required this.elastic,
    required this.spring,
  });
}