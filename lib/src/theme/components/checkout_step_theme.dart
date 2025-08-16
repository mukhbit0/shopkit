import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `CheckoutStep` widget.
@immutable
class CheckoutStepTheme extends ThemeExtension<CheckoutStepTheme> {
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;
  final TextStyle? activeTitleStyle;
  final TextStyle? inactiveTitleStyle;
  final Color? connectorColor;

  const CheckoutStepTheme({
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
    this.activeTitleStyle,
    this.inactiveTitleStyle,
    this.connectorColor,
  });

  @override
  CheckoutStepTheme copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? completedColor,
    TextStyle? activeTitleStyle,
    TextStyle? inactiveTitleStyle,
    Color? connectorColor,
  }) {
    return CheckoutStepTheme(
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      completedColor: completedColor ?? this.completedColor,
      activeTitleStyle: activeTitleStyle ?? this.activeTitleStyle,
      inactiveTitleStyle: inactiveTitleStyle ?? this.inactiveTitleStyle,
      connectorColor: connectorColor ?? this.connectorColor,
    );
  }

  @override
  CheckoutStepTheme lerp(ThemeExtension<CheckoutStepTheme>? other, double t) {
    if (other is! CheckoutStepTheme) {
      return this;
    }
    return CheckoutStepTheme(
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
      completedColor: Color.lerp(completedColor, other.completedColor, t),
      activeTitleStyle: TextStyle.lerp(activeTitleStyle, other.activeTitleStyle, t),
      inactiveTitleStyle: TextStyle.lerp(inactiveTitleStyle, other.inactiveTitleStyle, t),
      connectorColor: Color.lerp(connectorColor, other.connectorColor, t),
    );
  }
}