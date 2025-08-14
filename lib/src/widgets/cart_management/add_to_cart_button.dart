import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../models/variant_model.dart';
import '../../theme/ecommerce_theme.dart';
import '../../config/flexible_widget_config.dart';

/// Configuration class for AddToCartButton widget customization
class FlexibleAddToCartButtonConfig {
  const FlexibleAddToCartButtonConfig({
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.loadingColor,
    this.successColor,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.shadowColor,
    this.width,
    this.height,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.loadingIndicatorColor,
    this.animationDuration,
    this.showIcon,
    this.showQuantitySelector,
    this.showLoadingIndicator,
    this.text,
    this.inCartText,
    this.outOfStockText,
    this.loadingText,
    this.addIcon,
    this.inCartIcon,
    this.minQuantity,
    this.maxQuantity,
    this.buttonBuilder,
    this.quantitySelectorBuilder,
    this.loadingBuilder,
  });

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final Color? loadingColor;
  final Color? successColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final Color? shadowColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final double? iconSize;
  final Color? iconColor;
  final Color? loadingIndicatorColor;
  final Duration? animationDuration;
  final bool? showIcon;
  final bool? showQuantitySelector;
  final bool? showLoadingIndicator;
  final String? text;
  final String? inCartText;
  final String? outOfStockText;
  final String? loadingText;
  final IconData? addIcon;
  final IconData? inCartIcon;
  final int? minQuantity;
  final int? maxQuantity;

  // Builder functions for complete customization
  final Widget Function(BuildContext context, VoidCallback? onPressed,
      bool isLoading, bool isInCart, bool isOutOfStock)? buttonBuilder;
  final Widget Function(
      BuildContext context,
      int quantity,
      VoidCallback onIncrement,
      VoidCallback onDecrement)? quantitySelectorBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;

  FlexibleAddToCartButtonConfig copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? textColor,
    Color? disabledColor,
    Color? loadingColor,
    Color? successColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    Color? shadowColor,
    double? width,
    double? height,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    Color? loadingIndicatorColor,
    Duration? animationDuration,
    bool? showIcon,
    bool? showQuantitySelector,
    bool? showLoadingIndicator,
    String? text,
    String? inCartText,
    String? outOfStockText,
    String? loadingText,
    IconData? addIcon,
    IconData? inCartIcon,
    int? minQuantity,
    int? maxQuantity,
    Widget Function(BuildContext context, VoidCallback? onPressed,
            bool isLoading, bool isInCart, bool isOutOfStock)?
        buttonBuilder,
    Widget Function(BuildContext context, int quantity,
            VoidCallback onIncrement, VoidCallback onDecrement)?
        quantitySelectorBuilder,
    Widget Function(BuildContext context)? loadingBuilder,
  }) {
    return FlexibleAddToCartButtonConfig(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      disabledColor: disabledColor ?? this.disabledColor,
      loadingColor: loadingColor ?? this.loadingColor,
      successColor: successColor ?? this.successColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      width: width ?? this.width,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      loadingIndicatorColor:
          loadingIndicatorColor ?? this.loadingIndicatorColor,
      animationDuration: animationDuration ?? this.animationDuration,
      showIcon: showIcon ?? this.showIcon,
      showQuantitySelector: showQuantitySelector ?? this.showQuantitySelector,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      text: text ?? this.text,
      inCartText: inCartText ?? this.inCartText,
      outOfStockText: outOfStockText ?? this.outOfStockText,
      loadingText: loadingText ?? this.loadingText,
      addIcon: addIcon ?? this.addIcon,
      inCartIcon: inCartIcon ?? this.inCartIcon,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      buttonBuilder: buttonBuilder ?? this.buttonBuilder,
      quantitySelectorBuilder:
          quantitySelectorBuilder ?? this.quantitySelectorBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
    );
  }
}

/// An animated button for adding products to cart
@Deprecated('Use AddToCartButton (unified theming-aware version) from package:shopkit/shopkit.dart. This legacy implementation will be removed in a future major release.')
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
    this.config,
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

  /// Generic flexible configuration (new). When provided it augments/overrides the legacy individual properties.
  final FlexibleWidgetConfig? config;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  FlexibleWidgetConfig? _config;

  int _currentQuantity = 1;
  bool _showSuccessState = false;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.quantity;
    _config = widget.config ??
        FlexibleWidgetConfig.forWidget('add_to_cart_button_legacy',
            context: context,
            overrides: {
              // Seed overrides with any explicitly passed widget properties so they win over theme defaults
              if (widget.width != null) 'width': widget.width!,
              if (widget.height != null) 'height': widget.height!,
              if (widget.backgroundColor != null)
                'backgroundColor': widget.backgroundColor!,
              if (widget.textColor != null) 'textColor': widget.textColor!,
              if (widget.disabledColor != null)
                'disabledColor': widget.disabledColor!,
              if (widget.loadingColor != null)
                'loadingColor': widget.loadingColor!,
              if (widget.successColor != null)
                'successColor': widget.successColor!,
              if (widget.borderRadius != null)
                'borderRadius': widget.borderRadius!,
              'showIcon': widget.showIcon,
              'showQuantitySelector': widget.showQuantitySelector,
              'minQuantity': widget.minQuantity,
              'maxQuantity': widget.maxQuantity,
            });

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
        width:
            widget.width ?? _config?.get<double>('width', null) ?? widget.width,
        height: (widget.height ??
            _config?.get<double>('height', theme.buttonHeight) ??
            theme.buttonHeight),
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
      backgroundColor = widget.disabledColor ??
          _config?.getColor('disabledColor', theme.effectiveDisabledColor) ??
          theme.effectiveDisabledColor;
    } else if (widget.isLoading) {
      backgroundColor = widget.loadingColor ??
          _config?.getColor(
              'loadingColor', theme.primaryColor.withValues(alpha: 0.7)) ??
          theme.primaryColor.withValues(alpha: 0.7);
    } else if (_showSuccessState || widget.isInCart) {
      backgroundColor = widget.successColor ??
          _config?.getColor('successColor', theme.successColor) ??
          theme.successColor;
    } else {
      backgroundColor = widget.backgroundColor ??
          _config?.getColor('backgroundColor', theme.primaryColor) ??
          theme.primaryColor;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: widget.textColor ??
          _config?.getColor('textColor', Colors.white) ??
          Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ??
              _config?.get<double>('borderRadius', theme.buttonRadius) ??
              theme.buttonRadius,
        ),
      ),
      minimumSize: Size.fromHeight(widget.height ??
          _config?.get<double>('height', theme.buttonHeight) ??
          theme.buttonHeight),
    );
  }

  Widget _buildButtonContent(ECommerceTheme theme) {
    if (widget.isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _config?.getColor('loadingIndicatorColor', Colors.white) ??
                      Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(widget.loadingText ??
              _config?.get<String>('loadingText', 'Adding...') ??
              'Adding...'),
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
          Text(widget.outOfStockText ??
              _config?.get<String>('outOfStockText', 'Out of Stock') ??
              'Out of Stock'),
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
              Text(_config?.get<String>('successText', 'Added!') ?? 'Added!'),
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
          Text(widget.inCartText ??
              _config?.get<String>('inCartText', 'In Cart') ??
              'In Cart'),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if ((widget.showIcon ||
            _config?.get<bool>('showIcon', widget.showIcon) == true)) ...[
          const Icon(Icons.add_shopping_cart, size: 16),
          const SizedBox(width: 8),
        ],
        Text(widget.text ??
            _config?.get<String>('text', 'Add to Cart') ??
            'Add to Cart'),
        if ((widget.showQuantitySelector ||
                _config?.get<bool>(
                        'showQuantitySelector', widget.showQuantitySelector) ==
                    true) &&
            _currentQuantity > 1) ...[
          const SizedBox(width: 4),
          Text('($_currentQuantity)'),
        ],
      ],
    );
  }
}
