import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `Wishlist` widget.
@immutable
class WishlistTheme extends ThemeExtension<WishlistTheme> {
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? itemCounterStyle;
  final Color? iconColor;
  final Color? gridItemBorderColor;

  const WishlistTheme({
    this.backgroundColor,
    this.titleStyle,
    this.itemCounterStyle,
    this.iconColor,
    this.gridItemBorderColor,
  });

  @override
  WishlistTheme copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? itemCounterStyle,
    Color? iconColor,
    Color? gridItemBorderColor,
  }) {
    return WishlistTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      itemCounterStyle: itemCounterStyle ?? this.itemCounterStyle,
      iconColor: iconColor ?? this.iconColor,
      gridItemBorderColor: gridItemBorderColor ?? this.gridItemBorderColor,
    );
  }

  @override
  WishlistTheme lerp(ThemeExtension<WishlistTheme>? other, double t) {
    if (other is! WishlistTheme) {
      return this;
    }
    return WishlistTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      itemCounterStyle: TextStyle.lerp(itemCounterStyle, other.itemCounterStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      gridItemBorderColor: Color.lerp(gridItemBorderColor, other.gridItemBorderColor, t),
    );
  }
}