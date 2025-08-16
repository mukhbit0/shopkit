import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `CategoryTabs` widget.
@immutable
class CategoryTabsTheme extends ThemeExtension<CategoryTabsTheme> {
  final Color? backgroundColor;
  final Color? indicatorColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BoxDecoration? indicatorDecoration;

  const CategoryTabsTheme({
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.indicatorDecoration,
  });

  @override
  CategoryTabsTheme copyWith({
    Color? backgroundColor,
    Color? indicatorColor,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
    BoxDecoration? indicatorDecoration,
  }) {
    return CategoryTabsTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      indicatorDecoration: indicatorDecoration ?? this.indicatorDecoration,
    );
  }

  @override
  CategoryTabsTheme lerp(ThemeExtension<CategoryTabsTheme>? other, double t) {
    if (other is! CategoryTabsTheme) {
      return this;
    }
    return CategoryTabsTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      selectedLabelStyle: TextStyle.lerp(selectedLabelStyle, other.selectedLabelStyle, t),
      unselectedLabelStyle: TextStyle.lerp(unselectedLabelStyle, other.unselectedLabelStyle, t),
      indicatorDecoration: BoxDecoration.lerp(indicatorDecoration, other.indicatorDecoration, t),
    );
  }
}