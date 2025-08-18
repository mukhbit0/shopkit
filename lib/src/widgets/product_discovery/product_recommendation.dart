import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../theme/theme.dart';
import 'product_card.dart';

/// A widget for displaying product recommendations
class ProductRecommendation extends StatelessWidget {
  const ProductRecommendation({
    super.key,
    required this.products,
    required this.title,
    this.subtitle,
    this.onProductTap,
    this.onAddToCart,
    this.onToggleWishlist,
    this.isScrollable = true,
    this.showViewAllButton = true,
    this.onViewAllTap,
    this.itemCount,
    this.spacing,
  });

  /// List of recommended products
  final List<ProductModel> products;

  /// Title of the recommendation section
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Callback when a product is tapped
  final ValueChanged<ProductModel>? onProductTap;

  /// Callback when add to cart is tapped
  final ValueChanged<ProductModel>? onAddToCart;

  /// Callback when wishlist toggle is tapped
  final ValueChanged<ProductModel>? onToggleWishlist;

  /// Whether the list should be horizontally scrollable
  final bool isScrollable;

  /// Whether to show "View All" button
  final bool showViewAllButton;

  /// Callback when "View All" is tapped
  final VoidCallback? onViewAllTap;

  /// Number of items to display (null for all)
  final int? itemCount;

  /// Optional spacing override between cards. If null, uses theme spacing.
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final recTheme = shopKitTheme?.productRecommendationTheme;
    final spacingVal = spacing ?? shopKitTheme?.spacing.md ?? 16.0;
    final cardAspect = recTheme?.cardAspectRatio ?? 0.75;

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayProducts =
        itemCount != null ? products.take(itemCount!).toList() : products;
    final resolvedPadding = EdgeInsets.all(shopKitTheme?.spacing.md ?? 16);
    final bg = recTheme?.backgroundColor ?? theme.colorScheme.surface;
    final radius = recTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.lg ?? 12);
    final sectionTitle = title;
    final sectionSubtitle = subtitle ?? '';
    final effectiveProducts = displayProducts;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme, sectionTitle, sectionSubtitle, showViewAllButton),

          const SizedBox(height: 16),

          // Products
          if (isScrollable)
            _buildScrollableProducts(effectiveProducts, theme, spacingVal, cardAspect)
          else
            _buildGridProducts(effectiveProducts, theme, context, spacingVal, cardAspect),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String titleText, String subtitleText, bool showViewAll) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
        titleText,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
      if (subtitleText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
        subtitleText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
    if (showViewAll && onViewAllTap != null)
          TextButton(
            onPressed: onViewAllTap,
            child: const Text('View All'),
          ),
      ],
    );
  }

  Widget _buildScrollableProducts(List<ProductModel> products, ThemeData theme, double spacing, double aspect) {
    return SizedBox(
  height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
    width: 200,
    child: _buildProductCard(product, theme, aspect),
          );
        },
      ),
    );
  }

  Widget _buildGridProducts(List<ProductModel> products, ThemeData theme, BuildContext context, double spacing, double aspect) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        )),
    childAspectRatio: aspect,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
    return _buildProductCard(product, theme, aspect);
      },
    );
  }

  Widget _buildProductCard(ProductModel product, ThemeData theme, double aspect) {
    return ProductCard(
      product: product,
      onTap: () => onProductTap?.call(product),
      onAddToCart:
          onAddToCart != null ? (cartItem) => onAddToCart?.call(product) : null,
      onToggleWishlist: onToggleWishlist != null
          ? () => onToggleWishlist?.call(product)
          : null,
    );
  }

  int _getCrossAxisCount(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}

/// Predefined recommendation types
class RecommendationType {
  static const String youMayAlsoLike = 'you_may_also_like';
  static const String frequentlyBoughtTogether = 'frequently_bought_together';
  static const String recentlyViewed = 'recently_viewed';
  static const String trending = 'trending';
  static const String newArrivals = 'new_arrivals';
  static const String onSale = 'on_sale';
  static const String similar = 'similar';
  static const String recommended = 'recommended';

  static String getTitle(String type) {
    switch (type) {
      case youMayAlsoLike:
        return 'You May Also Like';
      case frequentlyBoughtTogether:
        return 'Frequently Bought Together';
      case recentlyViewed:
        return 'Recently Viewed';
      case trending:
        return 'Trending Now';
      case newArrivals:
        return 'New Arrivals';
      case onSale:
        return 'On Sale';
      case similar:
        return 'Similar Products';
      case recommended:
        return 'Recommended for You';
      default:
        return 'Recommended Products';
    }
  }

  static String getSubtitle(String type) {
    switch (type) {
      case youMayAlsoLike:
        return 'Based on your browsing history';
      case frequentlyBoughtTogether:
        return 'Customers who bought this item also bought';
      case recentlyViewed:
        return 'Items you\'ve recently looked at';
      case trending:
        return 'Popular items right now';
      case newArrivals:
        return 'Latest products in our store';
      case onSale:
        return 'Great deals you don\'t want to miss';
      case similar:
        return 'Products similar to what you\'re viewing';
      case recommended:
        return 'Personalized picks just for you';
      default:
        return 'Discover more great products';
    }
  }
}
