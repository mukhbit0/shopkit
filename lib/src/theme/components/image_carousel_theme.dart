import 'package:flutter/material.dart';
// For lerpDouble

/// A [ThemeExtension] for styling the `ImageCarousel` widget.
@immutable
class ImageCarouselTheme extends ThemeExtension<ImageCarouselTheme> {
  final Color? indicatorColor;
  final Color? activeIndicatorColor;
  final Color? arrowBackgroundColor;
  final Color? arrowIconColor;
  final BorderRadius? borderRadius;

  const ImageCarouselTheme({
    this.indicatorColor,
    this.activeIndicatorColor,
    this.arrowBackgroundColor,
    this.arrowIconColor,
    this.borderRadius,
  });

  @override
  ImageCarouselTheme copyWith({
    Color? indicatorColor,
    Color? activeIndicatorColor,
    Color? arrowBackgroundColor,
    Color? arrowIconColor,
    BorderRadius? borderRadius,
  }) {
    return ImageCarouselTheme(
      indicatorColor: indicatorColor ?? this.indicatorColor,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      arrowBackgroundColor: arrowBackgroundColor ?? this.arrowBackgroundColor,
      arrowIconColor: arrowIconColor ?? this.arrowIconColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ImageCarouselTheme lerp(ThemeExtension<ImageCarouselTheme>? other, double t) {
    if (other is! ImageCarouselTheme) {
      return this;
    }
    return ImageCarouselTheme(
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      activeIndicatorColor: Color.lerp(activeIndicatorColor, other.activeIndicatorColor, t),
      arrowBackgroundColor: Color.lerp(arrowBackgroundColor, other.arrowBackgroundColor, t),
      arrowIconColor: Color.lerp(arrowIconColor, other.arrowIconColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
    );
  }
}