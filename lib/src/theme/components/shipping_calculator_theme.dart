import 'package:flutter/material.dart';

@immutable
class ShippingCalculatorTheme extends ThemeExtension<ShippingCalculatorTheme> {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? headerTextStyle;
  final TextStyle? addressHeaderTextStyle;
  final TextStyle? methodsHeaderTextStyle;
  final ButtonStyle? calculateButtonStyle;
  final double? loadingIndicatorSize;
  final BorderRadius? methodItemBorderRadius;
  final EdgeInsets? methodItemPadding;
  final Color? methodSelectedBorderColor;
  final Color? methodSelectedBackgroundColor;

  const ShippingCalculatorTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.headerTextStyle,
    this.addressHeaderTextStyle,
    this.methodsHeaderTextStyle,
    this.calculateButtonStyle,
    this.loadingIndicatorSize,
    this.methodItemBorderRadius,
    this.methodItemPadding,
    this.methodSelectedBorderColor,
    this.methodSelectedBackgroundColor,
  });

  @override
  ShippingCalculatorTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? headerTextStyle,
    TextStyle? addressHeaderTextStyle,
    TextStyle? methodsHeaderTextStyle,
    ButtonStyle? calculateButtonStyle,
    double? loadingIndicatorSize,
    BorderRadius? methodItemBorderRadius,
    EdgeInsets? methodItemPadding,
    Color? methodSelectedBorderColor,
    Color? methodSelectedBackgroundColor,
  }) {
    return ShippingCalculatorTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      addressHeaderTextStyle: addressHeaderTextStyle ?? this.addressHeaderTextStyle,
      methodsHeaderTextStyle: methodsHeaderTextStyle ?? this.methodsHeaderTextStyle,
      calculateButtonStyle: calculateButtonStyle ?? this.calculateButtonStyle,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
      methodItemBorderRadius: methodItemBorderRadius ?? this.methodItemBorderRadius,
      methodItemPadding: methodItemPadding ?? this.methodItemPadding,
      methodSelectedBorderColor: methodSelectedBorderColor ?? this.methodSelectedBorderColor,
      methodSelectedBackgroundColor: methodSelectedBackgroundColor ?? this.methodSelectedBackgroundColor,
    );
  }

  @override
  ShippingCalculatorTheme lerp(ThemeExtension<ShippingCalculatorTheme>? other, double t) {
    if (other is! ShippingCalculatorTheme) return this;
    return ShippingCalculatorTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      addressHeaderTextStyle: TextStyle.lerp(addressHeaderTextStyle, other.addressHeaderTextStyle, t),
      methodsHeaderTextStyle: TextStyle.lerp(methodsHeaderTextStyle, other.methodsHeaderTextStyle, t),
      calculateButtonStyle: ButtonStyle.lerp(calculateButtonStyle, other.calculateButtonStyle, t),
      loadingIndicatorSize: (loadingIndicatorSize == null && other.loadingIndicatorSize == null) ? null : (loadingIndicatorSize ?? 0) + ((other.loadingIndicatorSize ?? 0) - (loadingIndicatorSize ?? 0)) * t,
      methodItemBorderRadius: BorderRadius.lerp(methodItemBorderRadius, other.methodItemBorderRadius, t),
      methodItemPadding: EdgeInsets.lerp(methodItemPadding, other.methodItemPadding, t),
      methodSelectedBorderColor: Color.lerp(methodSelectedBorderColor, other.methodSelectedBorderColor, t),
      methodSelectedBackgroundColor: Color.lerp(methodSelectedBackgroundColor, other.methodSelectedBackgroundColor, t),
    );
  }
}
