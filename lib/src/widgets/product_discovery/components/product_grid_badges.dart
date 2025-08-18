import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../models/product_model.dart';
// FlexibleWidgetConfig removed

class ProductGridBadgesBuilder {
  final ShopKitTheme theme;
  const ProductGridBadgesBuilder(this.theme);
  T _get<T>(String key, T def) => def;

  List<Widget> build(ProductModel product) {
    final badges = <Widget>[];
    if (product.hasDiscount) {
      badges.add(_badge(
        top: _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('saleBadgeText', 'SALE'),
  color: Colors.red,
      ));
    }
    if (!product.hasDiscount) {
      badges.add(_badge(
        top: product.hasDiscount ? _get('badgeTop', 8.0) + _get('badgeSpacing', 32.0) : _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('newBadgeText', 'NEW'),
  color: Colors.green,
      ));
    }
    return badges;
  }

  Widget _badge({required double top, required double left, required String text, required Color color}) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _get('badgeHorizontalPadding', 8.0),
          vertical: _get('badgeVerticalPadding', 4.0),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: _get('badgeTextSize', 10.0),
          ),
        ),
      ),
    );
  }

  // Themed variant removed; single badge style retained
}
