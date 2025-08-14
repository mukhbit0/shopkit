import 'package:flutter/material.dart';
import '../../../theme/shopkit_theme.dart';
import '../../../models/product_model.dart';
import '../../../config/flexible_widget_config.dart';
import '../product_grid_types.dart';

class ProductGridImage extends StatelessWidget {
  final ProductModel product;
  final ShopKitTheme theme;
  final FlexibleWidgetConfig? config;
  final bool showBadges;
  final bool showFavoriteButton;
  final bool showAddToCartButton;
  final ProductGridImageStyle imageStyle;
  final ProductGridLayout layout;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final List<Widget> Function() buildBadges;
  final Widget Function({required IconData icon, required Color color, required VoidCallback onTap, String? semanticsLabel}) buildActionButton;

  const ProductGridImage({super.key, required this.product, required this.theme, required this.config, required this.showBadges, required this.showFavoriteButton, required this.showAddToCartButton, required this.imageStyle, required this.layout, required this.onFavorite, required this.onAddToCart, required this.buildBadges, required this.buildActionButton});

  FlexibleWidgetConfig? get _config => config;
  T _getConfig<T>(String key, T def) => _config?.get<T>(key, def) ?? def;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: layout == ProductGridLayout.list
              ? _config?.getBorderRadius('listImageBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8)
              : _config?.getBorderRadius('productImageBorderRadius', const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))) ?? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          child: Container(
            width: double.infinity,
            height: layout == ProductGridLayout.list ? double.infinity : _getConfig('productImageHeight', 150.0),
            color: theme.surfaceColor,
            child: product.images?.isNotEmpty == true
                ? Image.network(
                    product.images!.first,
                    fit: imageStyle == ProductGridImageStyle.cover ? BoxFit.cover : BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(theme: theme, config: _config),
                  )
                : _ImagePlaceholder(theme: theme, config: _config),
          ),
        ),
        if (showBadges) ...buildBadges(),
        Positioned(
          top: _getConfig('actionButtonsTop', 8.0),
          right: _getConfig('actionButtonsRight', 8.0),
          child: Column(
            children: [
              if (showFavoriteButton)
                buildActionButton(
                  icon: Icons.favorite_border,
                  color: theme.onSurfaceColor.withValues(alpha: 0.6),
                  onTap: onFavorite,
                  semanticsLabel: 'Favorite ${product.name}',
                ),
              if (showAddToCartButton) SizedBox(height: _getConfig('actionButtonSpacing', 8.0)),
              if (showAddToCartButton)
                buildActionButton(
                  icon: Icons.add_shopping_cart,
                  color: theme.primaryColor,
                  onTap: onAddToCart,
                  semanticsLabel: 'Add ${product.name} to cart',
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ShopKitTheme theme;
  final FlexibleWidgetConfig? config;
  const _ImagePlaceholder({required this.theme, required this.config});
  T _getConfig<T>(String key, T def) => config?.get<T>(key, def) ?? def;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.onSurfaceColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.image_outlined,
        color: theme.onSurfaceColor.withValues(alpha: 0.4),
        size: _getConfig('placeholderIconSize', 40.0),
      ),
    );
  }
}
