import 'package:flutter/material.dart';

@immutable
class PaymentMethodSelectorTheme extends ThemeExtension<PaymentMethodSelectorTheme> {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? itemSpacing;
  final EdgeInsets? itemPadding;
  final BorderRadius? itemBorderRadius;
  final Color? itemSelectedBorderColor;
  final Color? itemSelectedBackgroundColor;
  final Color? iconBackgroundColor;
  final BorderRadius? iconBorderRadius;
  final TextStyle? headerTextStyle;
  final ButtonStyle? addButtonStyle;
  final TextStyle? emptyTitleStyle;
  final TextStyle? emptySubtitleStyle;
  final Color? selectionIndicatorColor;

  const PaymentMethodSelectorTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.itemSpacing,
    this.itemPadding,
    this.itemBorderRadius,
    this.itemSelectedBorderColor,
    this.itemSelectedBackgroundColor,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.headerTextStyle,
    this.addButtonStyle,
    this.emptyTitleStyle,
    this.emptySubtitleStyle,
    this.selectionIndicatorColor,
  });

  @override
  PaymentMethodSelectorTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? itemSpacing,
    EdgeInsets? itemPadding,
    BorderRadius? itemBorderRadius,
    Color? itemSelectedBorderColor,
    Color? itemSelectedBackgroundColor,
    Color? iconBackgroundColor,
    BorderRadius? iconBorderRadius,
    TextStyle? headerTextStyle,
    ButtonStyle? addButtonStyle,
    TextStyle? emptyTitleStyle,
    TextStyle? emptySubtitleStyle,
    Color? selectionIndicatorColor,
  }) {
    return PaymentMethodSelectorTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      itemPadding: itemPadding ?? this.itemPadding,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemSelectedBorderColor: itemSelectedBorderColor ?? this.itemSelectedBorderColor,
      itemSelectedBackgroundColor: itemSelectedBackgroundColor ?? this.itemSelectedBackgroundColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconBorderRadius: iconBorderRadius ?? this.iconBorderRadius,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      addButtonStyle: addButtonStyle ?? this.addButtonStyle,
      emptyTitleStyle: emptyTitleStyle ?? this.emptyTitleStyle,
      emptySubtitleStyle: emptySubtitleStyle ?? this.emptySubtitleStyle,
      selectionIndicatorColor: selectionIndicatorColor ?? this.selectionIndicatorColor,
    );
  }

  @override
  PaymentMethodSelectorTheme lerp(ThemeExtension<PaymentMethodSelectorTheme>? other, double t) {
    if (other is! PaymentMethodSelectorTheme) return this;
    return PaymentMethodSelectorTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      itemSpacing: (itemSpacing == null && other.itemSpacing == null) ? null : _lerpDouble(itemSpacing ?? 0, other.itemSpacing ?? 0, t),
      itemPadding: EdgeInsets.lerp(itemPadding, other.itemPadding, t),
      itemBorderRadius: BorderRadius.lerp(itemBorderRadius, other.itemBorderRadius, t),
      itemSelectedBorderColor: Color.lerp(itemSelectedBorderColor, other.itemSelectedBorderColor, t),
      itemSelectedBackgroundColor: Color.lerp(itemSelectedBackgroundColor, other.itemSelectedBackgroundColor, t),
      iconBackgroundColor: Color.lerp(iconBackgroundColor, other.iconBackgroundColor, t),
      iconBorderRadius: BorderRadius.lerp(iconBorderRadius, other.iconBorderRadius, t),
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      addButtonStyle: ButtonStyle.lerp(addButtonStyle, other.addButtonStyle, t),
      emptyTitleStyle: TextStyle.lerp(emptyTitleStyle, other.emptyTitleStyle, t),
      emptySubtitleStyle: TextStyle.lerp(emptySubtitleStyle, other.emptySubtitleStyle, t),
      selectionIndicatorColor: Color.lerp(selectionIndicatorColor, other.selectionIndicatorColor, t),
    );
  }
}

// Helper for lerpDouble without importing dart:ui directly
double? _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
