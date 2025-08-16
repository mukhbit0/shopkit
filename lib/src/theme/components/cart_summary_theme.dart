import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `CartSummary` widget.
@immutable
class CartSummaryTheme extends ThemeExtension<CartSummaryTheme> {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? totalLabelStyle;
  final TextStyle? totalValueStyle;
  final ButtonStyle? checkoutButtonStyle;

  const CartSummaryTheme({
    this.backgroundColor,
    this.borderRadius,
    this.titleStyle,
    this.totalLabelStyle,
    this.totalValueStyle,
    this.checkoutButtonStyle,
  });

  @override
  CartSummaryTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? titleStyle,
    TextStyle? totalLabelStyle,
    TextStyle? totalValueStyle,
    ButtonStyle? checkoutButtonStyle,
  }) {
    return CartSummaryTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      totalLabelStyle: totalLabelStyle ?? this.totalLabelStyle,
      totalValueStyle: totalValueStyle ?? this.totalValueStyle,
      checkoutButtonStyle: checkoutButtonStyle ?? this.checkoutButtonStyle,
    );
  }

  @override
  CartSummaryTheme lerp(ThemeExtension<CartSummaryTheme>? other, double t) {
    if (other is! CartSummaryTheme) {
      return this;
    }
    return CartSummaryTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      totalLabelStyle: TextStyle.lerp(totalLabelStyle, other.totalLabelStyle, t),
      totalValueStyle: TextStyle.lerp(totalValueStyle, other.totalValueStyle, t),
      checkoutButtonStyle: ButtonStyle.lerp(checkoutButtonStyle, other.checkoutButtonStyle, t),
    );
  }
}