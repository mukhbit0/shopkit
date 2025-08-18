import 'package:flutter/material.dart';
import 'dart:ui';

@immutable
class TrustBadgeTheme extends ThemeExtension<TrustBadgeTheme> {
  const TrustBadgeTheme({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.width,
    this.height,
    this.textColor,
    this.iconScale,
    this.showTooltip,
    this.animateOnHover,
    this.borderColor,
  });

  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;
  final double? width;
  final double? height;
  final Color? textColor;
  final double? iconScale;
  final bool? showTooltip;
  final bool? animateOnHover;
  final Color? borderColor;

  @override
  TrustBadgeTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? elevation,
    double? width,
    double? height,
    Color? textColor,
    double? iconScale,
    bool? showTooltip,
    bool? animateOnHover,
    Color? borderColor,
  }) {
    return TrustBadgeTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      width: width ?? this.width,
      height: height ?? this.height,
      textColor: textColor ?? this.textColor,
      iconScale: iconScale ?? this.iconScale,
      showTooltip: showTooltip ?? this.showTooltip,
      animateOnHover: animateOnHover ?? this.animateOnHover,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  TrustBadgeTheme lerp(ThemeExtension<TrustBadgeTheme>? other, double t) {
    if (other is! TrustBadgeTheme) return this;
    return TrustBadgeTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      iconScale: lerpDouble(iconScale, other.iconScale, t),
      showTooltip: t < 0.5 ? showTooltip : other.showTooltip,
      animateOnHover: t < 0.5 ? animateOnHover : other.animateOnHover,
      borderColor: Color.lerp(borderColor, other.borderColor, t),
    );
  }
}
