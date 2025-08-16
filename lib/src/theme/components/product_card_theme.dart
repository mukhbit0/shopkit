import 'package:flutter/material.dart';
import 'dart:ui'; // For lerpDouble

/// A [ThemeExtension] for styling the `ProductCard` widget.
///
/// Contains all the customizable visual properties for a product card,
/// allowing developers to create a consistent look for product displays.
@immutable
class ProductCardTheme extends ThemeExtension<ProductCardTheme> {
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? priceStyle;
  final Color? wishlistIconColor;

  const ProductCardTheme({
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.titleStyle,
    this.priceStyle,
    this.wishlistIconColor,
  });

  @override
  ProductCardTheme copyWith({
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    TextStyle? titleStyle,
    TextStyle? priceStyle,
    Color? wishlistIconColor,
  }) {
    return ProductCardTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      priceStyle: priceStyle ?? this.priceStyle,
      wishlistIconColor: wishlistIconColor ?? this.wishlistIconColor,
    );
  }

  @override
  ProductCardTheme lerp(ThemeExtension<ProductCardTheme>? other, double t) {
    if (other is! ProductCardTheme) {
      return this;
    }
    return ProductCardTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      priceStyle: TextStyle.lerp(priceStyle, other.priceStyle, t),
      wishlistIconColor: Color.lerp(wishlistIconColor, other.wishlistIconColor, t),
    );
  }
}