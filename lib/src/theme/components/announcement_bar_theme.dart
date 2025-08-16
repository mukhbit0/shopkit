import 'dart:ui';

import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `AnnouncementBar` widget.
@immutable
class AnnouncementBarTheme extends ThemeExtension<AnnouncementBarTheme> {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? height;

  const AnnouncementBarTheme({
    this.backgroundColor,
    this.textStyle,
    this.height,
  });

  @override
  AnnouncementBarTheme copyWith({Color? backgroundColor, TextStyle? textStyle, double? height}) {
    return AnnouncementBarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      height: height ?? this.height,
    );
  }

  @override
  AnnouncementBarTheme lerp(ThemeExtension<AnnouncementBarTheme>? other, double t) {
    if (other is! AnnouncementBarTheme) {
      return this;
    }
    return AnnouncementBarTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      height: lerpDouble(height, other.height, t),
    );
  }
}