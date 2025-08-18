import 'dart:ui';

import 'package:flutter/material.dart';

/// Theme extension for the Currency Converter widget
@immutable
class CurrencyConverterTheme extends ThemeExtension<CurrencyConverterTheme> {
  const CurrencyConverterTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.compact,
    this.showDropdown,
    this.showSymbol,
    this.showCode,
    this.decimalPlaces,
    this.headerText,
    this.fromLabel,
    this.toLabel,
    this.iconColor,
    this.amountStyle,
    this.convertedAmountStyle,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool? compact;
  final bool? showDropdown;
  final bool? showSymbol;
  final bool? showCode;
  final int? decimalPlaces;
  final String? headerText;
  final String? fromLabel;
  final String? toLabel;
  final Color? iconColor;
  final TextStyle? amountStyle;
  final TextStyle? convertedAmountStyle;

  @override
  CurrencyConverterTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool? compact,
    bool? showDropdown,
    bool? showSymbol,
    bool? showCode,
    int? decimalPlaces,
    String? headerText,
    String? fromLabel,
    String? toLabel,
    Color? iconColor,
    TextStyle? amountStyle,
    TextStyle? convertedAmountStyle,
  }) {
    return CurrencyConverterTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      compact: compact ?? this.compact,
      showDropdown: showDropdown ?? this.showDropdown,
      showSymbol: showSymbol ?? this.showSymbol,
      showCode: showCode ?? this.showCode,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      headerText: headerText ?? this.headerText,
      fromLabel: fromLabel ?? this.fromLabel,
      toLabel: toLabel ?? this.toLabel,
      iconColor: iconColor ?? this.iconColor,
      amountStyle: amountStyle ?? this.amountStyle,
      convertedAmountStyle: convertedAmountStyle ?? this.convertedAmountStyle,
    );
  }

  @override
  CurrencyConverterTheme lerp(ThemeExtension<CurrencyConverterTheme>? other, double t) {
    if (other is! CurrencyConverterTheme) return this;

    return CurrencyConverterTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      compact: t < 0.5 ? compact : other.compact,
      showDropdown: t < 0.5 ? showDropdown : other.showDropdown,
      showSymbol: t < 0.5 ? showSymbol : other.showSymbol,
      showCode: t < 0.5 ? showCode : other.showCode,
      decimalPlaces: lerpDouble(decimalPlaces?.toDouble(), other.decimalPlaces?.toDouble(), t)?.round(),
      headerText: t < 0.5 ? headerText : other.headerText,
      fromLabel: t < 0.5 ? fromLabel : other.fromLabel,
      toLabel: t < 0.5 ? toLabel : other.toLabel,
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      amountStyle: TextStyle.lerp(amountStyle, other.amountStyle, t),
      convertedAmountStyle: TextStyle.lerp(convertedAmountStyle, other.convertedAmountStyle, t),
    );
  }
}
