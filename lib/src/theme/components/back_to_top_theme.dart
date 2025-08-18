import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Theme extension for the BackToTop widget and its AdvancedBackToTop variant.
@immutable
class BackToTopTheme extends ThemeExtension<BackToTopTheme> {
  final double? showAfterOffset;
  final double? buttonSize;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? minimalBackgroundColor;
  final Color? pillBackgroundColor;
  final Color? pillIconColor;
  final Color? pillLabelColor;
  final Color? iconColor;
  final String? tooltip;
  final bool? showLabel;
  final String? label;
  final bool? showProgress;
  final EdgeInsets? margin;

  const BackToTopTheme({
    this.showAfterOffset,
    this.buttonSize,
    this.iconSize,
    this.backgroundColor,
    this.foregroundColor,
    this.minimalBackgroundColor,
    this.pillBackgroundColor,
    this.pillIconColor,
    this.pillLabelColor,
    this.iconColor,
    this.tooltip,
    this.showLabel,
    this.label,
    this.showProgress,
    this.margin,
  });

  @override
  BackToTopTheme copyWith({
    double? showAfterOffset,
    double? buttonSize,
    double? iconSize,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? minimalBackgroundColor,
    Color? pillBackgroundColor,
    Color? pillIconColor,
    Color? pillLabelColor,
    Color? iconColor,
    String? tooltip,
    bool? showLabel,
    String? label,
    bool? showProgress,
    EdgeInsets? margin,
  }) {
    return BackToTopTheme(
      showAfterOffset: showAfterOffset ?? this.showAfterOffset,
      buttonSize: buttonSize ?? this.buttonSize,
      iconSize: iconSize ?? this.iconSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      minimalBackgroundColor: minimalBackgroundColor ?? this.minimalBackgroundColor,
      pillBackgroundColor: pillBackgroundColor ?? this.pillBackgroundColor,
      pillIconColor: pillIconColor ?? this.pillIconColor,
      pillLabelColor: pillLabelColor ?? this.pillLabelColor,
      iconColor: iconColor ?? this.iconColor,
      tooltip: tooltip ?? this.tooltip,
      showLabel: showLabel ?? this.showLabel,
      label: label ?? this.label,
      showProgress: showProgress ?? this.showProgress,
      margin: margin ?? this.margin,
    );
  }

  @override
  BackToTopTheme lerp(ThemeExtension<BackToTopTheme>? other, double t) {
    if (other is! BackToTopTheme) return this;
    return BackToTopTheme(
      showAfterOffset: lerpDouble(showAfterOffset, other.showAfterOffset, t),
      buttonSize: lerpDouble(buttonSize, other.buttonSize, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      minimalBackgroundColor: Color.lerp(minimalBackgroundColor, other.minimalBackgroundColor, t),
      pillBackgroundColor: Color.lerp(pillBackgroundColor, other.pillBackgroundColor, t),
      pillIconColor: Color.lerp(pillIconColor, other.pillIconColor, t),
      pillLabelColor: Color.lerp(pillLabelColor, other.pillLabelColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      tooltip: t < 0.5 ? tooltip : other.tooltip,
      showLabel: t < 0.5 ? showLabel : other.showLabel,
      label: t < 0.5 ? label : other.label,
      showProgress: t < 0.5 ? showProgress : other.showProgress,
      margin: EdgeInsets.lerp(margin, other.margin, t),
    );
  }
}
