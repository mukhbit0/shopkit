import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';
import '../../config/flexible_widget_config.dart';

/// A sticky add-to-cart widget that appears at the bottom of the screen
class StickyAddToCart extends StatefulWidget {
  const StickyAddToCart({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.selectedVariant,
    this.quantity = 1,
    this.onQuantityChanged,
    this.onVariantChanged,
    this.isVisible = true,
    this.showProductInfo = true,
    this.showQuantitySelector = true,
    this.showVariantSelector = true,
    this.backgroundColor,
    this.elevation = 8.0,
    this.borderRadius,
    this.padding,
    this.margin,
    this.animationDuration = const Duration(milliseconds: 300),
  this.flexibleConfig,
  });

  /// Product to add to cart
  final ProductModel product;

  /// Callback when add to cart is tapped
  final ValueChanged<CartItemModel> onAddToCart;

  /// Currently selected variant
  final VariantModel? selectedVariant;

  /// Current quantity
  final int quantity;

  /// Callback when quantity changes
  final ValueChanged<int>? onQuantityChanged;

  /// Callback when variant changes
  final ValueChanged<VariantModel>? onVariantChanged;

  /// Whether the widget is visible
  final bool isVisible;

  /// Whether to show product info (image, name, price)
  final bool showProductInfo;

  /// Whether to show quantity selector
  final bool showQuantitySelector;

  /// Whether to show variant selector
  final bool showVariantSelector;

  /// Background color
  final Color? backgroundColor;

  /// Elevation of the widget
  final double elevation;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// External margin
  final EdgeInsets? margin;

  /// Animation duration for show/hide
  final Duration animationDuration;

  /// Universal flexible configuration for deep overrides.
  /// Namespaced keys: stickyAddToCart.*
  /// Supported keys: backgroundColor, elevation, borderRadius, padding, margin,
  /// showProductInfo, showQuantitySelector, showVariantSelector, isVisible,
  /// buttonLabel, outOfStockLabel, quantityStep (int), enableAnimations (bool)
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<StickyAddToCart> createState() => _StickyAddToCartState();
}

class _StickyAddToCartState extends State<StickyAddToCart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late int _currentQuantity;
  VariantModel? _currentVariant;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
    _currentVariant = widget.selectedVariant;

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(StickyAddToCart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    if (widget.quantity != oldWidget.quantity) {
      _currentQuantity = widget.quantity;
    }

    if (widget.selectedVariant != oldWidget.selectedVariant) {
      _currentVariant = widget.selectedVariant;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    // Config resolution helper
    T cfg<T>(String key, T fallback) {
      final fc = widget.flexibleConfig;
      if (fc != null) {
        if (fc.has('stickyAddToCart.$key')) {
          try { return fc.get<T>('stickyAddToCart.$key', fallback); } catch (_) {}
        }
        if (fc.has(key)) {
          try { return fc.get<T>(key, fallback); } catch (_) {}
        }
      }
      return fallback;
    }

    final isVisible = cfg<bool>('isVisible', widget.isVisible);
    final padding = widget.padding ?? cfg<EdgeInsets>('padding', const EdgeInsets.all(16));
    final margin = widget.margin ?? cfg<EdgeInsets>('margin', EdgeInsets.only(bottom: mediaQuery.viewPadding.bottom));
    final bgColor = widget.backgroundColor ?? cfg<Color>('backgroundColor', colorScheme.surface);
    final borderRadius = widget.borderRadius ?? cfg<BorderRadius>('borderRadius', const BorderRadius.vertical(top: Radius.circular(16)));
    final showProductInfo = cfg<bool>('showProductInfo', widget.showProductInfo);
    final showQuantitySelector = cfg<bool>('showQuantitySelector', widget.showQuantitySelector);
    final showVariantSelector = cfg<bool>('showVariantSelector', widget.showVariantSelector);
    final buttonLabel = cfg<String>('buttonLabel', 'Add to Cart');
    final outOfStockLabel = cfg<String>('outOfStockLabel', 'Out of Stock');

    // Keep animation controller in sync with visibility override
    if (isVisible && !_animationController.isAnimating && _animationController.status != AnimationStatus.forward) {
      _animationController.forward();
    } else if (!isVisible && !_animationController.isAnimating && _animationController.status != AnimationStatus.reverse) {
      _animationController.reverse();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: margin,
        child: Material(
          elevation: widget.elevation,
          borderRadius: borderRadius,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product info row
                  if (showProductInfo) ...[
                    _buildProductInfo(theme),
                    const SizedBox(height: 12),
                  ],

                  // Variant selector
                  if (showVariantSelector &&
                      widget.product.variants?.isNotEmpty == true) ...[
                    _buildVariantSelector(theme),
                    const SizedBox(height: 12),
                  ],

                  // Quantity and add to cart row
                  _buildActionRow(theme, showQuantitySelector, buttonLabel, outOfStockLabel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
    return Row(
      children: [
        // Product image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: widget.product.imageUrl != null
              ? Image.network(
                  widget.product.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
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
                widget.product.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (widget.product.discountPercentage != null) ...[
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '\$${widget.product.discountedPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Variant',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.product.variants!.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final variant = widget.product.variants![index];
              final isSelected = _currentVariant?.id == variant.id;

              return InkWell(
                onTap: () {
                  setState(() {
                    _currentVariant = variant;
                  });
                  widget.onVariantChanged?.call(variant);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    variant.name,
                    style: TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(ThemeData theme, bool showQuantitySelector, String buttonLabel, String outOfStockLabel) {
    return Row(
      children: [
        // Quantity selector
        if (showQuantitySelector) ...[
          _buildQuantitySelector(theme),
          const SizedBox(width: 16),
        ],

        // Add to cart button
        Expanded(
          child: ElevatedButton(
            onPressed: widget.product.isInStock ? _onAddToCartPressed : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.product.isInStock ? buttonLabel : outOfStockLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _currentQuantity > 1
                ? () => _updateQuantity(_currentQuantity - 1)
                : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.remove,
                size: 18,
                color: _currentQuantity > 1
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Text(
              '$_currentQuantity',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () => _updateQuantity(_currentQuantity + 1),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.add,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      _currentQuantity = newQuantity;
    });
    widget.onQuantityChanged?.call(newQuantity);
  }

  void _onAddToCartPressed() {
    final cartItem = CartItemModel(
      id: '${widget.product.id}_${_currentVariant?.id ?? 'default'}_${DateTime.now().millisecondsSinceEpoch}',
      product: widget.product,
      variant: _currentVariant,
      quantity: _currentQuantity,
      pricePerItem: widget.product.discountedPrice,
    );

    widget.onAddToCart(cartItem);
  }
}
