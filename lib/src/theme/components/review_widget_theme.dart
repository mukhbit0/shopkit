import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `ReviewWidget`.
@immutable
class ReviewWidgetTheme extends ThemeExtension<ReviewWidgetTheme> {
  final Color? summaryBackgroundColor;
  final Color? starColor;
  final Color? ratingBarColor;
  final TextStyle? authorTextStyle;
  final TextStyle? bodyTextStyle;
  final TextStyle? dateTextStyle;

  const ReviewWidgetTheme({
    this.summaryBackgroundColor,
    this.starColor,
    this.ratingBarColor,
    this.authorTextStyle,
    this.bodyTextStyle,
    this.dateTextStyle,
  });

  @override
  ReviewWidgetTheme copyWith({
    Color? summaryBackgroundColor,
    Color? starColor,
    Color? ratingBarColor,
    TextStyle? authorTextStyle,
    TextStyle? bodyTextStyle,
    TextStyle? dateTextStyle,
  }) {
    return ReviewWidgetTheme(
      summaryBackgroundColor: summaryBackgroundColor ?? this.summaryBackgroundColor,
      starColor: starColor ?? this.starColor,
      ratingBarColor: ratingBarColor ?? this.ratingBarColor,
      authorTextStyle: authorTextStyle ?? this.authorTextStyle,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      dateTextStyle: dateTextStyle ?? this.dateTextStyle,
    );
  }

  @override
  ReviewWidgetTheme lerp(ThemeExtension<ReviewWidgetTheme>? other, double t) {
    if (other is! ReviewWidgetTheme) {
      return this;
    }
    return ReviewWidgetTheme(
      summaryBackgroundColor: Color.lerp(summaryBackgroundColor, other.summaryBackgroundColor, t),
      starColor: Color.lerp(starColor, other.starColor, t),
      ratingBarColor: Color.lerp(ratingBarColor, other.ratingBarColor, t),
      authorTextStyle: TextStyle.lerp(authorTextStyle, other.authorTextStyle, t),
      bodyTextStyle: TextStyle.lerp(bodyTextStyle, other.bodyTextStyle, t),
      dateTextStyle: TextStyle.lerp(dateTextStyle, other.dateTextStyle, t),
    );
  }
}