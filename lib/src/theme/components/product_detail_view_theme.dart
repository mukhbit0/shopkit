
import 'package:flutter/material.dart';

/// A [ThemeExtension] for styling the `ProductDetailViewNew` widget.
@immutable
class ProductDetailViewTheme extends ThemeExtension<ProductDetailViewTheme> {
  final Color? backgroundColor;
  final TextStyle? productNameStyle;
  final TextStyle? productPriceStyle;
  final TextStyle? originalPriceStyle;
  final TextStyle? descriptionTextStyle;
  final Color? starColor;
  final Color? appBarColor;
  final Color? appBarIconColor;
  final ButtonStyle? buyNowButtonStyle;
  final ButtonStyle? addToCartButtonStyle;

  const ProductDetailViewTheme({
    this.backgroundColor,
    this.productNameStyle,
    this.productPriceStyle,
    this.originalPriceStyle,
    this.descriptionTextStyle,
    this.starColor,
    this.appBarColor,
    this.appBarIconColor,
    this.buyNowButtonStyle,
    this.addToCartButtonStyle,
  });

  @override
  ProductDetailViewTheme copyWith({
    Color? backgroundColor,
    TextStyle? productNameStyle,
    TextStyle? productPriceStyle,
    TextStyle? originalPriceStyle,
    TextStyle? descriptionTextStyle,
    Color? starColor,
    Color? appBarColor,
    Color? appBarIconColor,
    ButtonStyle? buyNowButtonStyle,
    ButtonStyle? addToCartButtonStyle,
  }) {
    return ProductDetailViewTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      productNameStyle: productNameStyle ?? this.productNameStyle,
      productPriceStyle: productPriceStyle ?? this.productPriceStyle,
      originalPriceStyle: originalPriceStyle ?? this.originalPriceStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
      starColor: starColor ?? this.starColor,
      appBarColor: appBarColor ?? this.appBarColor,
      appBarIconColor: appBarIconColor ?? this.appBarIconColor,
      buyNowButtonStyle: buyNowButtonStyle ?? this.buyNowButtonStyle,
      addToCartButtonStyle: addToCartButtonStyle ?? this.addToCartButtonStyle,
    );
  }

  @override
  ProductDetailViewTheme lerp(ThemeExtension<ProductDetailViewTheme>? other, double t) {
    if (other is! ProductDetailViewTheme) {
      return this;
    }
    return ProductDetailViewTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      productNameStyle: TextStyle.lerp(productNameStyle, other.productNameStyle, t),
      productPriceStyle: TextStyle.lerp(productPriceStyle, other.productPriceStyle, t),
      originalPriceStyle: TextStyle.lerp(originalPriceStyle, other.originalPriceStyle, t),
      descriptionTextStyle: TextStyle.lerp(descriptionTextStyle, other.descriptionTextStyle, t),
      starColor: Color.lerp(starColor, other.starColor, t),
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t),
      appBarIconColor: Color.lerp(appBarIconColor, other.appBarIconColor, t),
      buyNowButtonStyle: ButtonStyle.lerp(buyNowButtonStyle, other.buyNowButtonStyle, t),
      addToCartButtonStyle: ButtonStyle.lerp(addToCartButtonStyle, other.addToCartButtonStyle, t),
    );
  }
}