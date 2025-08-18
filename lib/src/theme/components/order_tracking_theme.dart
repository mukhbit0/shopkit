import 'package:flutter/material.dart';

@immutable
class OrderTrackingTheme extends ThemeExtension<OrderTrackingTheme> {
  const OrderTrackingTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.headerText,
    this.statusBackgrounds,
    this.statusTextColors,
    this.cardBackgroundColor,
    this.cardBorderColor,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final String? headerText;
  final Map<String, Color>? statusBackgrounds;
  final Map<String, Color>? statusTextColors;
  final Color? cardBackgroundColor;
  final Color? cardBorderColor;

  @override
  OrderTrackingTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    String? headerText,
    Map<String, Color>? statusBackgrounds,
    Map<String, Color>? statusTextColors,
    Color? cardBackgroundColor,
    Color? cardBorderColor,
  }) {
    return OrderTrackingTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      headerText: headerText ?? this.headerText,
      statusBackgrounds: statusBackgrounds ?? this.statusBackgrounds,
      statusTextColors: statusTextColors ?? this.statusTextColors,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
    );
  }

  @override
  OrderTrackingTheme lerp(ThemeExtension<OrderTrackingTheme>? other, double t) {
    if (other is! OrderTrackingTheme) return this;
    return OrderTrackingTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      headerText: t < 0.5 ? headerText : other.headerText,
      // maps are not lerped; pick based on t
      statusBackgrounds: t < 0.5 ? statusBackgrounds : other.statusBackgrounds,
      statusTextColors: t < 0.5 ? statusTextColors : other.statusTextColors,
      cardBackgroundColor: Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t),
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t),
    );
  }
}
