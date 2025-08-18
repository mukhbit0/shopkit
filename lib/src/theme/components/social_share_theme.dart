import 'package:flutter/material.dart';
import 'dart:ui';

@immutable
class SocialShareTheme extends ThemeExtension<SocialShareTheme> {
  const SocialShareTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.iconSize,
    this.spacing,
    this.iconBorderRadius,
    this.copyToastBackground,
    this.copyToastTextStyle,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? iconSize;
  final double? spacing;
  final BorderRadius? iconBorderRadius;
  final Color? copyToastBackground;
  final TextStyle? copyToastTextStyle;

  @override
  SocialShareTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? iconSize,
    double? spacing,
    BorderRadius? iconBorderRadius,
    Color? copyToastBackground,
    TextStyle? copyToastTextStyle,
  }) {
    return SocialShareTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      iconBorderRadius: iconBorderRadius ?? this.iconBorderRadius,
      copyToastBackground: copyToastBackground ?? this.copyToastBackground,
      copyToastTextStyle: copyToastTextStyle ?? this.copyToastTextStyle,
    );
  }

  @override
  SocialShareTheme lerp(ThemeExtension<SocialShareTheme>? other, double t) {
    if (other is! SocialShareTheme) return this;
    return SocialShareTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      spacing: lerpDouble(spacing, other.spacing, t),
      iconBorderRadius: BorderRadius.lerp(iconBorderRadius, other.iconBorderRadius, t),
      copyToastBackground: Color.lerp(copyToastBackground, other.copyToastBackground, t),
      copyToastTextStyle: t < 0.5 ? copyToastTextStyle : other.copyToastTextStyle,
    );
  }
}
