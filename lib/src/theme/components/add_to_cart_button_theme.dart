import 'package:flutter/material.dart';
import 'dart:ui'; // For lerpDouble

/// A [ThemeExtension] for styling the `AddToCartButton` widget.
@immutable
class AddToCartButtonTheme extends ThemeExtension<AddToCartButtonTheme> {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledColor;
  final Color? successColor;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final double? elevation; // <-- FIXED: Added the missing elevation property

  const AddToCartButtonTheme({
    this.backgroundColor,
    this.foregroundColor,
    this.disabledColor,
    this.successColor,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.elevation, // <-- FIXED: Added to constructor
  });

  @override
  AddToCartButtonTheme copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledColor,
    Color? successColor,
    double? height,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    double? elevation, // <-- FIXED: Added to copyWith
  }) {
    return AddToCartButtonTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      successColor: successColor ?? this.successColor,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      elevation: elevation ?? this.elevation, // <-- FIXED: Added to copyWith logic
    );
  }

  @override
  AddToCartButtonTheme lerp(ThemeExtension<AddToCartButtonTheme>? other, double t) {
    if (other is! AddToCartButtonTheme) {
      return this;
    }
    return AddToCartButtonTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t),
      successColor: Color.lerp(successColor, other.successColor, t),
      height: lerpDouble(height, other.height, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      elevation: lerpDouble(elevation, other.elevation, t), // <-- FIXED: Added lerp logic
    );
  }
}