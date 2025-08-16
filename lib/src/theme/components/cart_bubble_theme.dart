import 'package:flutter/material.dart';
import 'dart:ui'; // For lerpDouble

/// A [ThemeExtension] for styling the `CartBubble` widget.
@immutable
class CartBubbleTheme extends ThemeExtension<CartBubbleTheme> {
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? size;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CartBubbleTheme({
    this.backgroundColor,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.size,
    this.iconSize,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  CartBubbleTheme copyWith({
    Color? backgroundColor,
    Color? iconColor,
    Color? badgeColor,
    Color? badgeTextColor,
    double? size,
    double? iconSize,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return CartBubbleTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
      size: size ?? this.size,
      iconSize: iconSize ?? this.iconSize,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  CartBubbleTheme lerp(ThemeExtension<CartBubbleTheme>? other, double t) {
    if (other is! CartBubbleTheme) {
      return this;
    }
    return CartBubbleTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t),
      badgeTextColor: Color.lerp(badgeTextColor, other.badgeTextColor, t),
      size: lerpDouble(size, other.size, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      boxShadow: BoxShadow.lerpList(boxShadow, other.boxShadow, t),
    );
  }
}