import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `ProductFilter` widget.
@immutable
class ProductFilterTheme extends ThemeExtension<ProductFilterTheme> {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? headerTextStyle;
  final TextStyle? filterTitleStyle;
  final Color? activeChipColor;
  final Color? inactiveChipColor;
  final TextStyle? activeChipTextStyle;
  final TextStyle? inactiveChipTextStyle;

  const ProductFilterTheme({
    this.backgroundColor,
    this.borderRadius,
    this.headerTextStyle,
    this.filterTitleStyle,
    this.activeChipColor,
    this.inactiveChipColor,
    this.activeChipTextStyle,
    this.inactiveChipTextStyle,
  });

  @override
  ProductFilterTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? headerTextStyle,
    TextStyle? filterTitleStyle,
    Color? activeChipColor,
    Color? inactiveChipColor,
    TextStyle? activeChipTextStyle,
    TextStyle? inactiveChipTextStyle,
  }) {
    return ProductFilterTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      filterTitleStyle: filterTitleStyle ?? this.filterTitleStyle,
      activeChipColor: activeChipColor ?? this.activeChipColor,
      inactiveChipColor: inactiveChipColor ?? this.inactiveChipColor,
      activeChipTextStyle: activeChipTextStyle ?? this.activeChipTextStyle,
      inactiveChipTextStyle: inactiveChipTextStyle ?? this.inactiveChipTextStyle,
    );
  }

  @override
  ProductFilterTheme lerp(ThemeExtension<ProductFilterTheme>? other, double t) {
    if (other is! ProductFilterTheme) {
      return this;
    }
    return ProductFilterTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      headerTextStyle: TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      filterTitleStyle: TextStyle.lerp(filterTitleStyle, other.filterTitleStyle, t),
      activeChipColor: Color.lerp(activeChipColor, other.activeChipColor, t),
      inactiveChipColor: Color.lerp(inactiveChipColor, other.inactiveChipColor, t),
      activeChipTextStyle: TextStyle.lerp(activeChipTextStyle, other.activeChipTextStyle, t),
      inactiveChipTextStyle: TextStyle.lerp(inactiveChipTextStyle, other.inactiveChipTextStyle, t),
    );
  }
}