import 'package:flutter/material.dart';
import 'dart:ui'; // For lerpDouble

/// A [ThemeExtension] for styling the `StickyHeader` widget.
@immutable
class StickyHeaderTheme extends ThemeExtension<StickyHeaderTheme> {
  final Color? backgroundColor;
  final double? elevation;
  final TextStyle? titleStyle;
  final Color? iconColor;

  const StickyHeaderTheme({
    this.backgroundColor,
    this.elevation,
    this.titleStyle,
    this.iconColor,
  });

  @override
  StickyHeaderTheme copyWith({
    Color? backgroundColor,
    double? elevation,
    TextStyle? titleStyle,
    Color? iconColor,
  }) {
    return StickyHeaderTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      titleStyle: titleStyle ?? this.titleStyle,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  StickyHeaderTheme lerp(ThemeExtension<StickyHeaderTheme>? other, double t) {
    if (other is! StickyHeaderTheme) {
      return this;
    }
    return StickyHeaderTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}