import 'package:flutter/material.dart';
import 'dart:ui';

/// ThemeExtension for ExitIntent / popup visuals.
@immutable
class ExitIntentPopupTheme extends ThemeExtension<ExitIntentPopupTheme> {
  const ExitIntentPopupTheme({
    this.overlayColor,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.maxWidth,
    this.showCloseButton,
    this.primaryButtonStyle,
    this.secondaryButtonStyle,
    this.elevation,
    this.enableScale,
    this.enableFade,
    this.enableSlide,
  });

  final Color? overlayColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? maxWidth;
  final bool? showCloseButton;
  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? secondaryButtonStyle;
  final double? elevation;
  final bool? enableScale;
  final bool? enableFade;
  final bool? enableSlide;

  @override
  ExitIntentPopupTheme copyWith({
    Color? overlayColor,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? maxWidth,
    bool? showCloseButton,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? secondaryButtonStyle,
    double? elevation,
    bool? enableScale,
    bool? enableFade,
    bool? enableSlide,
  }) {
    return ExitIntentPopupTheme(
      overlayColor: overlayColor ?? this.overlayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      primaryButtonStyle: primaryButtonStyle ?? this.primaryButtonStyle,
      secondaryButtonStyle: secondaryButtonStyle ?? this.secondaryButtonStyle,
      elevation: elevation ?? this.elevation,
      enableScale: enableScale ?? this.enableScale,
      enableFade: enableFade ?? this.enableFade,
      enableSlide: enableSlide ?? this.enableSlide,
    );
  }

  @override
  ExitIntentPopupTheme lerp(ThemeExtension<ExitIntentPopupTheme>? other, double t) {
    if (other is! ExitIntentPopupTheme) return this;
    return ExitIntentPopupTheme(
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t),
      showCloseButton: t < 0.5 ? showCloseButton : other.showCloseButton,
      primaryButtonStyle: t < 0.5 ? primaryButtonStyle : other.primaryButtonStyle,
      secondaryButtonStyle: t < 0.5 ? secondaryButtonStyle : other.secondaryButtonStyle,
      elevation: lerpDouble(elevation, other.elevation, t),
      enableScale: t < 0.5 ? enableScale : other.enableScale,
      enableFade: t < 0.5 ? enableFade : other.enableFade,
      enableSlide: t < 0.5 ? enableSlide : other.enableSlide,
    );
  }
}
