import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';

/// Modern add to cart button built with shadcn/ui components
class AddToCartButton extends StatefulWidget {
  const AddToCartButton({
    super.key,
    required this.product,
    this.onAddToCart,
    this.quantity = 1,
    this.selectedVariant,
    this.isLoading = false,
    this.disabled = false,
    this.width,
    this.height,
    this.showQuantitySelector = false,
    this.showIcon = true,
    this.text,
    this.loadingText = 'Adding...',
    this.outOfStockText = 'Out of Stock',
  });

  final ProductModel product;
  final Function(CartItemModel)? onAddToCart;
  final int quantity;
  final VariantModel? selectedVariant;
  final bool isLoading;
  final bool disabled;
  final double? width;
  final double? height;
  final bool showQuantitySelector;
  final bool showIcon;
  final String? text;
  final String loadingText;
  final String outOfStockText;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentQuantity = 1;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_isDisabled) return;

    // Animation feedback
    await _animationController.forward();
    await _animationController.reverse();

    final cartItem = CartItemModel.createSafe(
      product: widget.product,
      variant: widget.selectedVariant,
      quantity: _currentQuantity,
      pricePerItem: widget.product.discountedPrice +
          (widget.selectedVariant?.additionalPrice ?? 0),
    );

    widget.onAddToCart?.call(cartItem);
  }

  bool get _isDisabled =>
      widget.disabled ||
      widget.isLoading ||
      !widget.product.isInStock ||
      (widget.selectedVariant != null && !widget.selectedVariant!.isInStock);

  String get _buttonText {
    if (widget.isLoading) return widget.loadingText;
    if (!widget.product.isInStock) return widget.outOfStockText;
    if (widget.selectedVariant != null && !widget.selectedVariant!.isInStock) {
      return widget.outOfStockText;
    }
    return widget.text ?? 'Add to Cart';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showQuantitySelector) ...[
          _buildQuantitySelector(),
          const SizedBox(height: 12),
        ],
        _buildAddToCartButton(),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Quantity:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadButton(
                onPressed: _currentQuantity > 1
                    ? () => setState(() => _currentQuantity--)
                    : null,
                child: const Icon(Icons.remove, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  _currentQuantity.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ShadButton(
                onPressed: () => setState(() => _currentQuantity++),
                child: const Icon(Icons.add, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.width,
            height: widget.height ?? 48,
            child: ShadButton(
              onPressed: _isDisabled ? null : _handleTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (widget.showIcon && widget.product.isInStock) ...[
                    const Icon(Icons.shopping_cart, size: 18),
                    const SizedBox(width: 8),
                  ] else if (!widget.product.isInStock) ...[
                    const Icon(Icons.block, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      _buttonText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
