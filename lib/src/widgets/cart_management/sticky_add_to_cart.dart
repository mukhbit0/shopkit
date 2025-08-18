import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system
import 'add_to_cart_button.dart'; // Assuming AddToCartButton is also refactored

/// A sticky add-to-cart widget that appears at the bottom of the screen, styled via ShopKitTheme.
class StickyAddToCart extends StatefulWidget {
  /// Creates a sticky add-to-cart bar.
  /// The constructor is now clean, focusing on data and behavior.
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
  });

  /// The product to be added to the cart.
  final ProductModel product;

  /// Callback when the add to cart button is tapped.
  final ValueChanged<CartItemModel> onAddToCart;

  /// The currently selected product variant.
  final VariantModel? selectedVariant;

  /// The current quantity to be added.
  final int quantity;

  /// Callback when the quantity changes.
  final ValueChanged<int>? onQuantityChanged;

  /// Callback when the variant changes.
  final ValueChanged<VariantModel>? onVariantChanged;

  /// Controls the visibility of the widget.
  final bool isVisible;

  /// If true, shows the product's image, name, and price.
  final bool showProductInfo;

  /// If true, shows the quantity selector.
  final bool showQuantitySelector;

  /// If true, shows the variant selector if variants are available.
  final bool showVariantSelector;

  @override
  State<StickyAddToCart> createState() => _StickyAddToCartState();
}

class _StickyAddToCartState extends State<StickyAddToCart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late int _currentQuantity;
  VariantModel? _currentVariant;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
    _currentVariant = widget.selectedVariant;

    // Animation setup will use theme values once context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAnimations());

    if (widget.isVisible) {
      // Forward animation after a short delay to ensure it's visible on screen load.
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) _animationController.forward();
      });
    }
  }
  
  void _setupAnimations() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    _animationController = AnimationController(
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut));
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

  void _updateQuantity(int newQuantity) {
    setState(() => _currentQuantity = newQuantity);
    widget.onQuantityChanged?.call(newQuantity);
  }

  void _onAddToCartPressed(CartItemModel cartItem) {
    // Side-effects: haptic feedback for better UX
    HapticFeedback.lightImpact();

    // Normalize / validate received cart item
    final variant = cartItem.variant ?? _currentVariant;
    final quantity = (cartItem.quantity <= 0) ? 1 : cartItem.quantity.clamp(1, 999);

    final pricePerItem = (cartItem.pricePerItem <= 0)
        ? (widget.product.discountedPrice + (variant?.additionalPrice ?? 0))
        : cartItem.pricePerItem;

    final id = (cartItem.id.isEmpty)
        ? '${widget.product.id}_${variant?.id ?? 'default'}_${DateTime.now().millisecondsSinceEpoch}'
        : cartItem.id;

    final normalized = CartItemModel.createSafe(
      id: id,
      product: widget.product,
      variant: variant,
      quantity: quantity,
      pricePerItem: pricePerItem,
    );

    // Forward normalized item to consumer
    widget.onAddToCart(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    // Note: No component theme for StickyAddToCart yet, so we use base theme values.
    
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        elevation: 8.0, // A common default for this type of element
        color: shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(shopKitTheme?.radii.lg ?? 16.0)),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            shopKitTheme?.spacing.md ?? 16.0,
            shopKitTheme?.spacing.md ?? 16.0,
            shopKitTheme?.spacing.md ?? 16.0,
            (shopKitTheme?.spacing.md ?? 16.0) + bottomPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showProductInfo) ...[
                _buildProductInfo(theme, shopKitTheme),
                SizedBox(height: shopKitTheme?.spacing.md ?? 16.0),
              ],
              if (widget.showVariantSelector && widget.product.variants?.isNotEmpty == true) ...[
                _buildVariantSelector(theme, shopKitTheme),
                SizedBox(height: shopKitTheme?.spacing.md ?? 16.0),
              ],
              _buildActionRow(theme, shopKitTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(shopKitTheme?.radii.sm ?? 8.0),
          child: widget.product.imageUrl != null
              ? Image.network(
                  widget.product.imageUrl!,
                  width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60, height: 60,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.image_not_supported, color: theme.colorScheme.onSurfaceVariant),
                  ),
                )
              : Container(
                  width: 60, height: 60,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.shopping_bag, color: theme.colorScheme.onSurfaceVariant),
                ),
        ),
        SizedBox(width: shopKitTheme?.spacing.md ?? 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: shopKitTheme?.typography.body1.copyWith(fontWeight: FontWeight.bold) ?? theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: shopKitTheme?.spacing.xs ?? 4.0),
              Text(
                widget.product.formattedPrice,
                style: shopKitTheme?.typography.body1.copyWith(
                  color: shopKitTheme.colors.primary,
                  fontWeight: FontWeight.bold,
                ) ?? theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSelector(ThemeData theme, ShopKitTheme? shopKitTheme) {
    // This could be replaced by the dedicated VariantPicker widget if desired
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.variants!.length,
        separatorBuilder: (context, index) => SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
        itemBuilder: (context, index) {
          final variant = widget.product.variants![index];
          final isSelected = _currentVariant?.id == variant.id;
          return ChoiceChip(
            label: Text(variant.name),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _currentVariant = variant);
                widget.onVariantChanged?.call(variant);
              }
            },
            selectedColor: shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
            labelStyle: shopKitTheme?.typography.body2.copyWith(
              color: isSelected ? shopKitTheme.colors.onPrimary : shopKitTheme.colors.onSurface,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionRow(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Row(
      children: [
        if (widget.showQuantitySelector) ...[
          _buildQuantitySelector(theme, shopKitTheme),
          SizedBox(width: shopKitTheme?.spacing.md ?? 16.0),
        ],
        Expanded(
          child: AddToCartButton(
            product: widget.product,
            quantity: _currentQuantity,
            isOutOfStock: !widget.product.isInStock,
            // Route the AddToCartButton callback to the local helper so
            // the sticky widget builds the cart item consistently and
            // any side-effects (haptics, analytics) can be centralized.
            onAddToCart: (cartItem) => _onAddToCartPressed(cartItem),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _currentQuantity > 1 ? () => _updateQuantity(_currentQuantity - 1) : null,
            icon: const Icon(Icons.remove),
            iconSize: 18,
          ),
          Text(
            '$_currentQuantity',
            style: shopKitTheme?.typography.body1.copyWith(fontWeight: FontWeight.bold) ?? theme.textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () => _updateQuantity(_currentQuantity + 1),
            icon: const Icon(Icons.add),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}
