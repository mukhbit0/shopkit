import 'package:flutter/material.dart';
import '../../models/wishlist_model.dart';
import '../../models/product_model.dart';
import '../product_discovery/product_card.dart';
import '../../config/flexible_widget_config.dart';

/// Configuration class enabling deep customization of the Wishlist widget.
///
/// This follows the flexible widget architecture used across ShopKit and
/// allows consumers to override layout, styling, behavior and even provide
/// full custom builders for each major section.
class FlexibleWishlistConfig {
  const FlexibleWishlistConfig({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.headerTextStyle,
    this.subtitleTextStyle,
    this.priceTextStyle,
    this.originalPriceTextStyle,
    this.ratingColor,
    this.iconColor,
    this.actionSpacing,
    this.gridCrossAxisCount,
    this.itemAspectRatio,
    this.spacing,
    this.showMoveToCartButton,
    this.showShareButton,
    this.showRemoveButton,
    // Builders
  this.headerBuilder,
  this.controlsBuilder,
  this.gridItemBuilder,
  this.listItemBuilder,
  this.emptyStateBuilder,
  this.moveToCartButtonBuilder,
  });

  /// Outer padding for the wishlist container.
  final EdgeInsets? padding;
  /// External margin (not applied internally by default container here but available for wrapper usage).
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? headerTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? priceTextStyle;
  final TextStyle? originalPriceTextStyle;
  final Color? ratingColor;
  final Color? iconColor;
  final double? actionSpacing;
  final int? gridCrossAxisCount;
  final double? itemAspectRatio;
  final double? spacing;
  final bool? showMoveToCartButton;
  final bool? showShareButton;
  final bool? showRemoveButton;

  // Section builders
  final Widget Function(BuildContext context, Wishlist widget)? headerBuilder;
  final Widget Function(BuildContext context, Wishlist widget)? controlsBuilder;
  final Widget Function(BuildContext context, ProductModel product, Wishlist widget)? gridItemBuilder;
  final Widget Function(BuildContext context, ProductModel product, Wishlist widget)? listItemBuilder;
  final Widget Function(BuildContext context, Wishlist widget)? emptyStateBuilder;
  final Widget Function(BuildContext context, ProductModel product, VoidCallback? onPressed, Wishlist widget)? moveToCartButtonBuilder;

  FlexibleWishlistConfig copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    TextStyle? headerTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? priceTextStyle,
    TextStyle? originalPriceTextStyle,
    Color? ratingColor,
    Color? iconColor,
    double? actionSpacing,
    int? gridCrossAxisCount,
    double? itemAspectRatio,
    double? spacing,
    bool? showMoveToCartButton,
    bool? showShareButton,
    bool? showRemoveButton,
  Widget Function(BuildContext, Wishlist)? headerBuilder,
  Widget Function(BuildContext, Wishlist)? controlsBuilder,
  Widget Function(BuildContext, ProductModel, Wishlist)? gridItemBuilder,
  Widget Function(BuildContext, ProductModel, Wishlist)? listItemBuilder,
  Widget Function(BuildContext, Wishlist)? emptyStateBuilder,
  Widget Function(BuildContext, ProductModel, VoidCallback?, Wishlist)? moveToCartButtonBuilder,
  }) {
    return FlexibleWishlistConfig(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      priceTextStyle: priceTextStyle ?? this.priceTextStyle,
      originalPriceTextStyle: originalPriceTextStyle ?? this.originalPriceTextStyle,
      ratingColor: ratingColor ?? this.ratingColor,
      iconColor: iconColor ?? this.iconColor,
      actionSpacing: actionSpacing ?? this.actionSpacing,
      gridCrossAxisCount: gridCrossAxisCount ?? this.gridCrossAxisCount,
      itemAspectRatio: itemAspectRatio ?? this.itemAspectRatio,
      spacing: spacing ?? this.spacing,
      showMoveToCartButton: showMoveToCartButton ?? this.showMoveToCartButton,
      showShareButton: showShareButton ?? this.showShareButton,
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
  headerBuilder: headerBuilder ?? this.headerBuilder,
  controlsBuilder: controlsBuilder ?? this.controlsBuilder,
  gridItemBuilder: gridItemBuilder ?? this.gridItemBuilder,
  listItemBuilder: listItemBuilder ?? this.listItemBuilder,
  emptyStateBuilder: emptyStateBuilder ?? this.emptyStateBuilder,
  moveToCartButtonBuilder: moveToCartButtonBuilder ?? this.moveToCartButtonBuilder,
    );
  }
}

/// A widget for displaying and managing wishlist items
class Wishlist extends StatefulWidget {
  const Wishlist({
    super.key,
    required this.wishlist,
    this.onProductTap,
    this.onRemoveFromWishlist,
    this.onAddToCart,
    this.onMoveToCart,
    this.onShare,
    this.showMoveToCartButton = true,
    this.showShareButton = true,
    this.showRemoveButton = true,
    this.gridCrossAxisCount,
    this.itemAspectRatio = 0.75,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.spacing = 16.0,
  this.config,
  this.flexibleConfig,
  });

  /// Wishlist to display
  final WishlistModel wishlist;

  /// Callback when a product is tapped
  final ValueChanged<ProductModel>? onProductTap;

  /// Callback when remove from wishlist is tapped
  final ValueChanged<ProductModel>? onRemoveFromWishlist;

  /// Callback when add to cart is tapped
  final ValueChanged<ProductModel>? onAddToCart;

  /// Callback when move to cart is tapped
  final ValueChanged<ProductModel>? onMoveToCart;

  /// Callback when share is tapped
  final VoidCallback? onShare;

  /// Whether to show move to cart button
  final bool showMoveToCartButton;

  /// Whether to show share button
  final bool showShareButton;

  /// Whether to show remove button
  final bool showRemoveButton;

  /// Number of columns in grid (null for responsive)
  final int? gridCrossAxisCount;

  /// Aspect ratio for wishlist items
  final double itemAspectRatio;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// Spacing between items
  final double spacing;

  /// Optional configuration for deep customization.
  final FlexibleWishlistConfig? config;

  /// New universal flexible configuration. When provided, it can override core
  /// layout/styling props (padding, spacing, colors, booleans) while remaining
  /// backward compatible with the legacy [FlexibleWishlistConfig].
  ///
  /// Supported keys (namespaced suggestions):
  ///  - wishlist.padding (EdgeInsets / double / map)
  ///  - wishlist.margin (EdgeInsets / double / map)
  ///  - wishlist.spacing (double)
  ///  - wishlist.backgroundColor (Color)
  ///  - wishlist.borderRadius (double / BorderRadius)
  ///  - wishlist.borderColor (Color)
  ///  - wishlist.borderWidth (double)
  ///  - wishlist.showMoveToCartButton (bool)
  ///  - wishlist.showShareButton (bool)
  ///  - wishlist.showRemoveButton (bool)
  ///  - wishlist.headerTextStyle (TextStyle)
  ///  - wishlist.subtitleTextStyle (TextStyle)
  ///  - wishlist.ratingColor (Color)
  ///  - wishlist.iconColor (Color)
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  bool _isGridView = true;
  String _sortBy = 'recently_added';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Helper to read from flexibleConfig with fallbacks to legacy config and then widget props
    T cfg0<T>(String key, T fallback) {
      // Try namespaced key first then generic key for convenience
      if (widget.flexibleConfig != null) {
        if (widget.flexibleConfig!.has('wishlist.$key')) {
          try { return widget.flexibleConfig!.get<T>('wishlist.$key', fallback); } catch (_) {}
        }
        if (widget.flexibleConfig!.has(key)) {
          try { return widget.flexibleConfig!.get<T>(key, fallback); } catch (_) {}
        }
      }
      return fallback;
    }

    // Derived values with override order: flexibleConfig -> legacy config -> explicit widget prop / default
    final padding = widget.padding ?? widget.config?.padding ?? cfg0<EdgeInsets>('padding', const EdgeInsets.all(16));
    final bgColor = widget.backgroundColor ?? widget.config?.backgroundColor ?? cfg0<Color>('backgroundColor', colorScheme.surface);
    final borderRadius = widget.borderRadius ?? widget.config?.borderRadius ?? cfg0<BorderRadius>('borderRadius', BorderRadius.circular(12));
    final borderColor = widget.config?.borderColor ?? cfg0<Color>('borderColor', colorScheme.outline.withValues(alpha: 0.2));
    final borderWidth = widget.config?.borderWidth ?? cfg0<double>('borderWidth', 1.0);
    final spacing = cfg0<double>('spacing', widget.config?.spacing ?? widget.spacing);
    final showMoveToCart = cfg0<bool>('showMoveToCartButton', widget.config?.showMoveToCartButton ?? widget.showMoveToCartButton);
    final showShare = cfg0<bool>('showShareButton', widget.config?.showShareButton ?? widget.showShareButton);
    final showRemove = cfg0<bool>('showRemoveButton', widget.config?.showRemoveButton ?? widget.showRemoveButton);
    final ratingColor = widget.config?.ratingColor ?? cfg0<Color>('ratingColor', Colors.amber);

    // Store derived booleans for reuse down the tree via InheritedWidget pattern (future) or locals now
    final derived = _WishlistDerived(
      spacing: spacing,
      showMoveToCart: showMoveToCart,
      showShare: showShare,
      showRemove: showRemove,
      ratingColor: ratingColor,
      padding: padding,
      bgColor: bgColor,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );

  if (widget.wishlist.items.isEmpty) {
      // Allow custom empty state
      if (widget.config?.emptyStateBuilder != null) {
        return widget.config!.emptyStateBuilder!(context, widget);
      }
      return _buildEmptyState(theme);
    }

    final sortedItems = _sortItems(widget.wishlist.items);

    final cfg = widget.config;
    return Container(
      padding: derived.padding,
      decoration: BoxDecoration(
        color: derived.bgColor,
        borderRadius: derived.borderRadius,
        border: Border.all(color: derived.borderColor, width: derived.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          cfg?.headerBuilder != null
              ? cfg!.headerBuilder!(context, widget)
              : _buildHeader(theme, showShare),

          SizedBox(height: derived.spacing),

          // Controls
      cfg?.controlsBuilder != null
        ? cfg!.controlsBuilder!(context, widget)
        : _buildControls(theme),

          SizedBox(height: derived.spacing),

          // Items
          Expanded(
            child: _isGridView
                ? _buildGridView(sortedItems, theme, derived)
                : _buildListView(sortedItems, theme, derived),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool showShare) {
    final cfg = widget.config;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.wishlist.name,
                style: (cfg?.headerTextStyle ?? theme.textTheme.titleLarge)?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.wishlist.itemCount} items • Total value: \$${widget.wishlist.totalValue.toStringAsFixed(2)}',
                style: (cfg?.subtitleTextStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                  color: (cfg?.subtitleTextStyle?.color ?? theme.colorScheme.onSurface).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        if (showShare && widget.onShare != null)
          IconButton(
            onPressed: widget.onShare,
            icon: const Icon(Icons.share),
            tooltip: 'Share wishlist',
          ),
      ],
    );
  }

  Widget _buildControls(ThemeData theme) {
    return Row(
      children: [
        // Sort dropdown
        DropdownButton<String>(
          value: _sortBy,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(
                value: 'recently_added', child: Text('Recently Added')),
            DropdownMenuItem(value: 'name_asc', child: Text('Name A-Z')),
            DropdownMenuItem(value: 'name_desc', child: Text('Name Z-A')),
            DropdownMenuItem(value: 'price_low', child: Text('Price Low-High')),
            DropdownMenuItem(
                value: 'price_high', child: Text('Price High-Low')),
          ],
          onChanged: (value) {
            setState(() {
              _sortBy = value ?? 'recently_added';
            });
          },
        ),

        const Spacer(),

        // View toggle
        IconButton(
          onPressed: () => setState(() => _isGridView = !_isGridView),
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
          tooltip: _isGridView ? 'List view' : 'Grid view',
        ),
      ],
    );
  }

  Widget _buildGridView(List<ProductModel> items, ThemeData theme, _WishlistDerived derived) {
    final cfg = widget.config;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cfg?.gridCrossAxisCount ?? widget.gridCrossAxisCount ?? _getGridCrossAxisCount(),
        childAspectRatio: cfg?.itemAspectRatio ?? widget.itemAspectRatio,
        crossAxisSpacing: derived.spacing,
        mainAxisSpacing: derived.spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        if (cfg?.gridItemBuilder != null) {
          return cfg!.gridItemBuilder!(context, product, widget);
        }
        return _buildGridItem(product, theme, derived);
      },
    );
  }

  Widget _buildListView(List<ProductModel> items, ThemeData theme, _WishlistDerived derived) {
    final cfg = widget.config;
    final spacing = derived.spacing;
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final product = items[index];
    if (cfg?.listItemBuilder != null) {
      return cfg!.listItemBuilder!(context, product, widget);
        }
        return _buildListItem(product, theme, derived);
      },
    );
  }

  Widget _buildGridItem(ProductModel product, ThemeData theme, _WishlistDerived derived) {
    final cfg = widget.config;
    final showMoveToCart = derived.showMoveToCart;
    final showRemove = derived.showRemove;
  return Stack(
      children: [
        ProductCard(
          product: product,
          onTap: () => widget.onProductTap?.call(product),
          isInWishlist: true,
      onToggleWishlist: showRemove ? () => widget.onRemoveFromWishlist?.call(product) : null,
          onAddToCart: widget.onAddToCart != null
              ? (cartItem) => widget.onAddToCart?.call(product)
              : null,
        ),

        // Move to cart button
        if (showMoveToCart && widget.onMoveToCart != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: cfg?.moveToCartButtonBuilder != null
                ? cfg!.moveToCartButtonBuilder!(
                    context,
                    product,
                    () => widget.onMoveToCart?.call(product),
                    widget,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () => widget.onMoveToCart?.call(product),
                      icon: Icon(
                        Icons.shopping_cart,
                        color: theme.colorScheme.onPrimary,
                        size: 18,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Move to cart',
                    ),
                  ),
          ),
      ],
    );
  }

  Widget _buildListItem(ProductModel product, ThemeData theme, _WishlistDerived derived) {
    final showMoveToCart = derived.showMoveToCart;
    final showRemove = derived.showRemove;
    final ratingColor = derived.ratingColor;
  return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.shopping_bag,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (product.rating != null)
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product.rating!.floor()
                              ? Icons.star
                              : index < product.rating!
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 14,
                          color: ratingColor,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount ?? 0})',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (product.discountPercentage != null) ...[
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (showMoveToCart && widget.onMoveToCart != null)
                      TextButton.icon(
                        onPressed: () => widget.onMoveToCart?.call(product),
                        icon: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text('Move to Cart'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    const Spacer(),
                    if (showRemove && widget.onRemoveFromWishlist != null)
                      IconButton(
                        onPressed: () =>
                            widget.onRemoveFromWishlist?.call(product),
                        icon: const Icon(Icons.delete_outline, size: 20),
                        tooltip: 'Remove from wishlist',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Wishlist is Empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save items you love for later by adding them to your wishlist',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate back or to products
                Navigator.of(context).pop();
              },
              child: const Text('Start Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _sortItems(List<ProductModel> items) {
    final sorted = List<ProductModel>.from(items);

    switch (_sortBy) {
      case 'name_asc':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price_low':
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'price_high':
        sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'recently_added':
      default:
        // Assuming items are already ordered by recently added
        break;
    }

    return sorted;
  }

  int _getGridCrossAxisCount() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  // Internal data holder for resolved configuration values to avoid recomputing
}

class _WishlistDerived {
  final double spacing;
  final bool showMoveToCart;
  final bool showShare;
  final bool showRemove;
  final Color ratingColor;
  final EdgeInsets padding;
  final Color bgColor;
  final BorderRadius borderRadius;
  final Color borderColor;
  final double borderWidth;
  const _WishlistDerived({
    required this.spacing,
    required this.showMoveToCart,
    required this.showShare,
    required this.showRemove,
    required this.ratingColor,
    required this.padding,
    required this.bgColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  });
}
