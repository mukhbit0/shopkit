import 'package:flutter/material.dart';
import '../../config/flexible_widget_config.dart';
import '../../models/product_model.dart';
import '../../theme/shopkit_theme_styles.dart';
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
    this.spacing = 16.0,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.cardAspectRatio = 0.75,
    this.cardElevation = 2.0,
    this.themeStyle,
    this.flexibleConfig,
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

  /// Spacing between items
  final double spacing;

  /// Padding around the widget
  final EdgeInsets? padding;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Aspect ratio for product cards
  final double cardAspectRatio;

  /// Elevation for product cards
  final double cardElevation;

  /// Theme style for consistent visual styling (material3, neumorphism, glassmorphism, etc.)
  final String? themeStyle;

  final FlexibleWidgetConfig? flexibleConfig;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayProducts =
        itemCount != null ? products.take(itemCount!).toList() : products;

    // Theme configuration helper
    ShopKitThemeConfig? themeConfig;
    if (themeStyle != null) {
      final style = ShopKitThemeStyleExtension.fromString(themeStyle!);
      themeConfig = ShopKitThemeConfig.forStyle(style, context);
    }

    T cfg<T>(String key, T fallback) {
      final fc = flexibleConfig;
      if (fc != null) {
        if (fc.has('recommendation.$key')) { try { return fc.get<T>('recommendation.$key', fallback); } catch (_) {} }
        if (fc.has(key)) { try { return fc.get<T>(key, fallback); } catch (_) {} }
      }
      return fallback;
    }

    final resolvedPadding = cfg<EdgeInsets>('padding', padding ?? const EdgeInsets.all(16));
    final bg = cfg<Color>('backgroundColor', backgroundColor ?? themeConfig?.backgroundColor ?? colorScheme.surface);
    final radius = cfg<BorderRadius>('borderRadius', borderRadius ?? BorderRadius.circular(themeConfig?.borderRadius ?? 12));
    final spacingVal = cfg<double>('spacing', spacing);
    final scrollable = cfg<bool>('isScrollable', isScrollable);
    final showViewAll = cfg<bool>('showViewAllButton', showViewAllButton);
    final sectionTitle = cfg<String>('title', title);
    final sectionSubtitle = cfg<String>('subtitle', subtitle ?? '');
    final cardAspect = cfg<double>('cardAspectRatio', cardAspectRatio);
    final cardElev = cfg<double>('cardElevation', themeConfig?.elevation ?? cardElevation);
    final itemCountOverride = cfg<int>('itemCount', itemCount ?? -1);
    final effectiveProducts = itemCountOverride > -1
        ? displayProducts.take(itemCountOverride).toList()
        : displayProducts;

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        boxShadow: themeConfig?.enableShadows == true ? [
          BoxShadow(
            color: themeConfig?.shadowColor ?? Colors.black12,
            blurRadius: themeConfig?.elevation ?? 2,
            offset: Offset(0, themeConfig?.elevation ?? 2),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme, sectionTitle, sectionSubtitle, showViewAll),

          const SizedBox(height: 16),

          // Products
      if (scrollable)
    _buildScrollableProducts(effectiveProducts, theme, spacingVal, cardAspect, cardElev)
          else
    _buildGridProducts(effectiveProducts, theme, context, spacingVal, cardAspect, cardElev),
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

  Widget _buildScrollableProducts(List<ProductModel> products, ThemeData theme, double spacing, double aspect, double elevation) {
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
    child: _buildProductCard(product, theme, aspect, elevation),
          );
        },
      ),
    );
  }

  Widget _buildGridProducts(List<ProductModel> products, ThemeData theme, BuildContext context, double spacing, double aspect, double elevation) {
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
    return _buildProductCard(product, theme, aspect, elevation);
      },
    );
  }

  Widget _buildProductCard(ProductModel product, ThemeData theme, double aspect, double elevation) {
    return ProductCard(
      product: product,
      themeStyle: themeStyle, // Pass themeStyle to child components
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
