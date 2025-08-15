import 'package:flutter/material.dart';
import '../../../theme/shopkit_theme.dart';
import '../../../models/product_model.dart';
import '../../../config/flexible_widget_config.dart';

class ProductGridBadgesBuilder {
  final FlexibleWidgetConfig? config;
  final ShopKitTheme theme;
  final String? themeStyle; // NEW: Built-in theme styling support
  
  const ProductGridBadgesBuilder(this.config, this.theme, [this.themeStyle]);
  T _get<T>(String key, T def) => config?.get<T>(key, def) ?? def;

  List<Widget> build(ProductModel product) {
    if (themeStyle != null) {
      return _buildThemedBadges(product);
    }
    
    final badges = <Widget>[];
    if (product.hasDiscount) {
      badges.add(_badge(
        top: _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('saleBadgeText', 'SALE'),
        color: config?.getColor('saleBadgeColor', Colors.red) ?? Colors.red,
      ));
    }
    if (!product.hasDiscount) {
      badges.add(_badge(
        top: product.hasDiscount ? _get('badgeTop', 8.0) + _get('badgeSpacing', 32.0) : _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('newBadgeText', 'NEW'),
        color: config?.getColor('newBadgeColor', Colors.green) ?? Colors.green,
      ));
    }
    return badges;
  }

  /// Build themed badges using ShopKitThemeConfig  
  List<Widget> _buildThemedBadges(ProductModel product) {
    // For builder class, we'll use legacy theme fallback since no context available
    // This maintains compatibility while providing basic theming
    final badges = <Widget>[];
    
    if (product.hasDiscount) {
      badges.add(_themedBadge(
        top: _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('saleBadgeText', 'SALE'),
        color: theme.primaryColor,
        borderRadius: 4.0,
        elevation: 2.0,
      ));
    }
    if (!product.hasDiscount) {
      badges.add(_themedBadge(
        top: product.hasDiscount ? _get('badgeTop', 8.0) + _get('badgeSpacing', 32.0) : _get('badgeTop', 8.0),
        left: _get('badgeLeft', 8.0),
        text: _get('newBadgeText', 'NEW'),
        color: theme.secondaryColor,
        borderRadius: 4.0,
        elevation: 2.0,
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
          borderRadius: config?.getBorderRadius('badgeBorderRadius', BorderRadius.circular(4)) ?? BorderRadius.circular(4),
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

  /// Themed badge widget using simple theme properties
  Widget _themedBadge({
    required double top, 
    required double left, 
    required String text, 
    required Color color,
    required double borderRadius,
    required double elevation,
  }) {
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
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: elevation,
              offset: const Offset(0, 1),
            ),
          ],
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
}
