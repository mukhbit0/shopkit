import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../models/product_model.dart';
// Removed FlexibleWidgetConfig dependency
import '../product_grid_types.dart';

class ProductGridImage extends StatelessWidget {
  final ProductModel product;
  final ShopKitTheme theme;
  final bool showBadges;
  final bool showFavoriteButton;
  final bool showAddToCartButton;
  final ProductGridImageStyle imageStyle;
  final ProductGridLayout layout;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final List<Widget> Function() buildBadges;
  final Widget Function({required IconData icon, required Color color, required VoidCallback onTap, String? semanticsLabel}) buildActionButton;

  const ProductGridImage({super.key, required this.product, required this.theme, required this.showBadges, required this.showFavoriteButton, required this.showAddToCartButton, required this.imageStyle, required this.layout, required this.onFavorite, required this.onAddToCart, required this.buildBadges, required this.buildActionButton});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
      borderRadius: layout == ProductGridLayout.list
        ? BorderRadius.circular(8)
        : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          child: Container(
            width: double.infinity,
            height: layout == ProductGridLayout.list ? double.infinity : 150.0,
            color: theme.surfaceColor,
            child: product.images?.isNotEmpty == true
                ? Image.network(
                    product.images!.first,
                    fit: imageStyle == ProductGridImageStyle.cover ? BoxFit.cover : BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(theme: theme),
                  )
                : _ImagePlaceholder(theme: theme),
          ),
        ),
        if (showBadges) ...buildBadges(),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Column(
            children: [
              if (showFavoriteButton)
                buildActionButton(
                  icon: Icons.favorite_border,
                  color: theme.primaryColor,
                  onTap: onFavorite,
                  semanticsLabel: 'Add to favorites',
                ),
              if (showFavoriteButton && showAddToCartButton)
                const SizedBox(height: 8.0),
              if (showAddToCartButton)
                buildActionButton(
                  icon: Icons.add_shopping_cart,
                  color: theme.primaryColor,
                  onTap: onAddToCart,
                  semanticsLabel: 'Add to cart',
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
  const _ImagePlaceholder({required this.theme});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.onSurfaceColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.image_outlined,
        color: theme.onSurfaceColor.withValues(alpha: 0.4),
        size: 40.0,
      ),
    );
  }
}

// Removed themed placeholder variant – unified placeholder used
