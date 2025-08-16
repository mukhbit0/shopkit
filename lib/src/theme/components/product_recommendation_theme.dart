import 'dart:ui';

import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `ProductRecommendation` widget.
@immutable
class ProductRecommendationTheme extends ThemeExtension<ProductRecommendationTheme> {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? cardAspectRatio;

  const ProductRecommendationTheme({
    this.backgroundColor,
    this.borderRadius,
    this.titleStyle,
    this.subtitleStyle,
    this.cardAspectRatio,
  });

  // copyWith and lerp methods...
  @override
  ProductRecommendationTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? cardAspectRatio,
  }) {
    return ProductRecommendationTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      cardAspectRatio: cardAspectRatio ?? this.cardAspectRatio,
    );
  }

  @override
  ProductRecommendationTheme lerp(ThemeExtension<ProductRecommendationTheme>? other, double t) {
    if (other is! ProductRecommendationTheme) {
      return this;
    }
    return ProductRecommendationTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      cardAspectRatio: lerpDouble(cardAspectRatio, other.cardAspectRatio, t),
    );
  }
}