import 'package:flutter/material.dart';
import '../../models/wishlist_model.dart';
import '../../models/product_model.dart';
import '../product_discovery/product_card.dart';

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

    if (widget.wishlist.items.isEmpty) {
      return _buildEmptyState(theme);
    }

    final sortedItems = _sortItems(widget.wishlist.items);

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme),

          const SizedBox(height: 16),

          // Controls
          _buildControls(theme),

          const SizedBox(height: 16),

          // Items
          Expanded(
            child: _isGridView
                ? _buildGridView(sortedItems, theme)
                : _buildListView(sortedItems, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.wishlist.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.wishlist.itemCount} items • Total value: \$${widget.wishlist.totalValue.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        if (widget.showShareButton && widget.onShare != null)
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

  Widget _buildGridView(List<ProductModel> items, ThemeData theme) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridCrossAxisCount ?? _getGridCrossAxisCount(),
        childAspectRatio: widget.itemAspectRatio,
        crossAxisSpacing: widget.spacing,
        mainAxisSpacing: widget.spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return _buildGridItem(product, theme);
      },
    );
  }

  Widget _buildListView(List<ProductModel> items, ThemeData theme) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: widget.spacing),
      itemBuilder: (context, index) {
        final product = items[index];
        return _buildListItem(product, theme);
      },
    );
  }

  Widget _buildGridItem(ProductModel product, ThemeData theme) {
    return Stack(
      children: [
        ProductCard(
          product: product,
          onTap: () => widget.onProductTap?.call(product),
          isInWishlist: true,
          onToggleWishlist: widget.showRemoveButton
              ? () => widget.onRemoveFromWishlist?.call(product)
              : null,
          onAddToCart: widget.onAddToCart != null
              ? (cartItem) => widget.onAddToCart?.call(product)
              : null,
        ),

        // Move to cart button
        if (widget.showMoveToCartButton && widget.onMoveToCart != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
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

  Widget _buildListItem(ProductModel product, ThemeData theme) {
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
                          color: Colors.amber,
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
                    if (widget.showMoveToCartButton &&
                        widget.onMoveToCart != null)
                      TextButton.icon(
                        onPressed: () => widget.onMoveToCart?.call(product),
                        icon: const Icon(Icons.shopping_cart, size: 16),
                        label: const Text('Move to Cart'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    const Spacer(),
                    if (widget.showRemoveButton &&
                        widget.onRemoveFromWishlist != null)
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
}
