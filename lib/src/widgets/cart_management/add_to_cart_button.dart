import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system

/// An animated button for adding products to the cart, styled via ShopKitTheme.
///
/// This widget handles various states like loading, success (in cart), and out of stock,
/// with smooth animations. Its appearance is now controlled centrally through the
/// `AddToCartButtonTheme` within your app's `ShopKitTheme`.
class AddToCartButton extends StatefulWidget {
  /// Creates an Add to Cart button.
  ///
  /// The constructor is now focused on data and behavior, not styling.
  const AddToCartButton({
    super.key,
    required this.product,
    this.variant,
    this.quantity = 1,
    this.onAddToCart,
    this.onAddToCartAnimationComplete,
    this.isInCart = false,
    this.isLoading = false,
    this.isOutOfStock = false,
    this.showIcon = true,
    this.showQuantitySelector = false,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    // --- Text content can be overridden for specific instances ---
    this.text = 'Add to Cart',
    this.inCartText = 'In Cart',
    this.outOfStockText = 'Out of Stock',
    this.loadingText = 'Adding...',
    this.successText = 'Added!',
  });

  /// The product to be added to the cart.
  final ProductModel product;

  /// The selected product variant, if any.
  final VariantModel? variant;

  /// The quantity of the product to add.
  final int quantity;

  /// Callback fired when the button is pressed.
  final void Function(CartItemModel)? onAddToCart;

  /// Callback fired after the success animation completes.
  final VoidCallback? onAddToCartAnimationComplete;

  /// Determines if the product is already in the cart to show a success state.
  final bool isInCart;

  /// If true, shows a loading indicator.
  final bool isLoading;

  /// If true, disables the button and shows an "Out of Stock" message.
  final bool isOutOfStock;

  /// Toggles the visibility of the leading icon.
  final bool showIcon;

  /// If true, displays a quantity selector next to the button.
  final bool showQuantitySelector;

  /// The minimum quantity selectable.
  final int minQuantity;

  /// The maximum quantity selectable.
  final int maxQuantity;

  // --- Customizable Text Properties ---
  final String text;
  final String inCartText;
  final String outOfStockText;
  final String loadingText;
  final String successText;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  int _currentQuantity = 1;
  bool _showSuccessState = false;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;

    // Initialize animation controllers. Durations will be sourced from the theme.
    _scaleController = AnimationController(vsync: this);
    _checkController = AnimationController(vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _checkController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(covariant AddToCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quantity != oldWidget.quantity) {
      _currentQuantity = widget.quantity;
    }
  }

  void _handleAddToCart() async {
    if (widget.isLoading || widget.isOutOfStock) return;

    // Get animation durations and curves from the theme
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    _scaleController.duration = shopKitTheme?.scaleDuration ?? const Duration(milliseconds: 200);
    _checkController.duration = shopKitTheme?.bounceDuration ?? const Duration(milliseconds: 600);

    // Update animations with theme curves
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(
          parent: _scaleController, 
          curve: shopKitTheme?.easeInOutCurve ?? Curves.easeInOut
        ));

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _checkController, 
          curve: shopKitTheme?.elasticCurve ?? Curves.elasticOut
        ));

    await _scaleController.forward();
    await _scaleController.reverse();

    final cartItem = CartItemModel.createSafe(
      product: widget.product,
      variant: widget.variant,
      quantity: _currentQuantity,
      pricePerItem: widget.product.discountedPrice + (widget.variant?.additionalPrice ?? 0),
    );

    widget.onAddToCart?.call(cartItem);

    if (mounted) {
      setState(() => _showSuccessState = true);
    }

    await _checkController.forward();
    await Future.delayed(shopKitTheme?.verySlowAnimation ?? const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _showSuccessState = false);
      _checkController.reset();
      widget.onAddToCartAnimationComplete?.call();
    }
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= widget.minQuantity && newQuantity <= widget.maxQuantity) {
      setState(() {
        _currentQuantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showQuantitySelector) {
      return _buildWithQuantitySelector();
    }
    return _buildSimpleButton();
  }

  Widget _buildSimpleButton() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final buttonTheme = shopKitTheme?.addToCartButtonTheme;
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: buttonTheme?.height ?? 48.0,
        child: ElevatedButton(
          onPressed: widget.isLoading || widget.isOutOfStock ? null : _handleAddToCart,
          style: _getButtonStyle(theme, shopKitTheme),
          child: _buildButtonContent(theme, shopKitTheme),
        ),
      ),
    );
  }

  Widget _buildWithQuantitySelector() {
    final theme = Theme.of(context);
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final buttonTheme = shopKitTheme?.addToCartButtonTheme;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
            borderRadius: buttonTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _currentQuantity > widget.minQuantity ? () => _updateQuantity(_currentQuantity - 1) : null,
                icon: const Icon(Icons.remove),
                iconSize: 18,
              ),
              Text(
                _currentQuantity.toString(),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _currentQuantity < widget.maxQuantity ? () => _updateQuantity(_currentQuantity + 1) : null,
                icon: const Icon(Icons.add),
                iconSize: 18,
              ),
            ],
          ),
        ),
        SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
        Expanded(child: _buildSimpleButton()),
      ],
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final buttonTheme = shopKitTheme?.addToCartButtonTheme;
    
    Color getBackgroundColor() {
      if (widget.isOutOfStock) return buttonTheme?.disabledColor ?? theme.disabledColor;
      if (widget.isLoading) return buttonTheme?.backgroundColor?.withOpacity(0.7) ?? shopKitTheme?.colors.primary.withOpacity(0.7) ?? theme.colorScheme.primary.withOpacity(0.7);
      if (_showSuccessState || widget.isInCart) return buttonTheme?.successColor ?? shopKitTheme?.colors.success ?? Colors.green;
      return buttonTheme?.backgroundColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: getBackgroundColor(),
      foregroundColor: buttonTheme?.foregroundColor ?? shopKitTheme?.colors.onPrimary ?? theme.colorScheme.onPrimary,
      elevation: buttonTheme?.elevation ?? 0,
      textStyle: buttonTheme?.textStyle ?? shopKitTheme?.typography.button,
      shape: RoundedRectangleBorder(
        borderRadius: buttonTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme, ShopKitTheme? shopKitTheme) {
    Widget content;
    IconData? icon;
    String label;

    if (widget.isLoading) {
      label = widget.loadingText;
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                shopKitTheme?.addToCartButtonTheme?.foregroundColor ?? shopKitTheme?.colors.onPrimary ?? theme.colorScheme.onPrimary
              ),
            ),
          ),
          SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
          Text(label),
        ],
      );
    } else {
      if (widget.isOutOfStock) {
        label = widget.outOfStockText;
        icon = Icons.block;
      } else if (_showSuccessState) {
        label = widget.successText;
        icon = Icons.check_circle_outline;
      } else if (widget.isInCart) {
        label = widget.inCartText;
        icon = Icons.check_circle;
      } else {
        label = widget.text;
        icon = Icons.add_shopping_cart;
      }

      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showIcon) ...[
            Icon(icon, size: 20),
            SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
          ],
          Text(label),
        ],
      );
    }

    // Apply success animation if needed
    if (_showSuccessState) {
      return AnimatedBuilder(
        animation: _checkAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _checkAnimation.value,
            child: child,
          );
        },
        child: content,
      );
    }

    return content;
  }
}
