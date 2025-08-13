import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';
import '../../theme/ecommerce_theme.dart';

/// An animated button for adding products to cart
class AddToCartButton extends StatefulWidget {
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
    this.text,
    this.inCartText,
    this.outOfStockText,
    this.loadingText,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.loadingColor,
    this.successColor,
    this.showIcon = true,
    this.showQuantitySelector = false,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  /// Product to add to cart
  final ProductModel product;

  /// Selected product variant
  final VariantModel? variant;

  /// Quantity to add
  final int quantity;

  /// Callback when button is pressed
  final void Function(CartItemModel)? onAddToCart;

  /// Callback when add animation completes
  final VoidCallback? onAddToCartAnimationComplete;

  /// Whether product is already in cart
  final bool isInCart;

  /// Whether button is in loading state
  final bool isLoading;

  /// Whether product is out of stock
  final bool isOutOfStock;

  /// Custom button text
  final String? text;

  /// Text when product is in cart
  final String? inCartText;

  /// Text when product is out of stock
  final String? outOfStockText;

  /// Text when loading
  final String? loadingText;

  /// Custom button width
  final double? width;

  /// Custom button height
  final double? height;

  /// Custom border radius
  final double? borderRadius;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Custom disabled color
  final Color? disabledColor;

  /// Custom loading color
  final Color? loadingColor;

  /// Custom success color (when in cart)
  final Color? successColor;

  /// Whether to show cart icon
  final bool showIcon;

  /// Whether to show quantity selector
  final bool showQuantitySelector;

  /// Minimum quantity allowed
  final int minQuantity;

  /// Maximum quantity allowed
  final int maxQuantity;

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

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  void _handleAddToCart() async {
    if (widget.isLoading || widget.isOutOfStock) return;

    // Scale animation on press
    await _scaleController.forward();
    await _scaleController.reverse();

    // Create cart item
    final cartItem = CartItemModel(
      id: '${widget.product.id}_${widget.variant?.id ?? 'default'}_${DateTime.now().millisecondsSinceEpoch}',
      product: widget.product,
      variant: widget.variant,
      quantity: _currentQuantity,
      pricePerItem: widget.product.discountedPrice +
          (widget.variant?.additionalPrice ?? 0),
    );

    // Call callback
    widget.onAddToCart?.call(cartItem);

    // Show success animation
    setState(() {
      _showSuccessState = true;
    });

    await _checkController.forward();

    // Reset after delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _showSuccessState = false;
      });
      _checkController.reset();
      widget.onAddToCartAnimationComplete?.call();
    }
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= widget.minQuantity &&
        newQuantity <= widget.maxQuantity) {
      setState(() {
        _currentQuantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.ecommerceTheme;

    if (widget.showQuantitySelector) {
      return _buildWithQuantitySelector(theme);
    }

    return _buildSimpleButton(theme);
  }

  Widget _buildSimpleButton(ECommerceTheme theme) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: widget.width,
        height: widget.height ?? theme.buttonHeight,
        child: ElevatedButton(
          onPressed:
              widget.isLoading || widget.isOutOfStock ? null : _handleAddToCart,
          style: _getButtonStyle(theme),
          child: _buildButtonContent(theme),
        ),
      ),
    );
  }

  Widget _buildWithQuantitySelector(ECommerceTheme theme) {
    return Row(
      children: [
        // Quantity Selector
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.effectiveBorderColor),
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? theme.buttonRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _currentQuantity > widget.minQuantity
                    ? () => _updateQuantity(_currentQuantity - 1)
                    : null,
                icon: const Icon(Icons.remove),
                iconSize: 16,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  _currentQuantity.toString(),
                  style: theme.defaultTitleTextStyle.copyWith(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: _currentQuantity < widget.maxQuantity
                    ? () => _updateQuantity(_currentQuantity + 1)
                    : null,
                icon: const Icon(Icons.add),
                iconSize: 16,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Add to Cart Button
        Expanded(
          child: _buildSimpleButton(theme),
        ),
      ],
    );
  }

  ButtonStyle _getButtonStyle(ECommerceTheme theme) {
    Color backgroundColor;

    if (widget.isOutOfStock) {
      backgroundColor = widget.disabledColor ?? theme.effectiveDisabledColor;
    } else if (widget.isLoading) {
      backgroundColor =
          widget.loadingColor ?? theme.primaryColor.withValues(alpha: 0.7);
    } else if (_showSuccessState || widget.isInCart) {
      backgroundColor = widget.successColor ?? theme.successColor;
    } else {
      backgroundColor = widget.backgroundColor ?? theme.primaryColor;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: widget.textColor ?? Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? theme.buttonRadius,
        ),
      ),
      minimumSize: Size.fromHeight(widget.height ?? theme.buttonHeight),
    );
  }

  Widget _buildButtonContent(ECommerceTheme theme) {
    if (widget.isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(widget.loadingText ?? 'Adding...'),
        ],
      );
    }

    if (widget.isOutOfStock) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showIcon) ...[
            const Icon(Icons.block, size: 16),
            const SizedBox(width: 8),
          ],
          Text(widget.outOfStockText ?? 'Out of Stock'),
        ],
      );
    }

    if (_showSuccessState) {
      return AnimatedBuilder(
        animation: _checkAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: _checkAnimation.value,
                child: const Icon(Icons.check, size: 16),
              ),
              const SizedBox(width: 8),
              const Text('Added!'),
            ],
          );
        },
      );
    }

    if (widget.isInCart) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showIcon) ...[
            const Icon(Icons.check_circle, size: 16),
            const SizedBox(width: 8),
          ],
          Text(widget.inCartText ?? 'In Cart'),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.showIcon) ...[
          const Icon(Icons.add_shopping_cart, size: 16),
          const SizedBox(width: 8),
        ],
        Text(widget.text ?? 'Add to Cart'),
        if (widget.showQuantitySelector && _currentQuantity > 1) ...[
          const SizedBox(width: 4),
          Text('($_currentQuantity)'),
        ],
      ],
    );
  }
}
