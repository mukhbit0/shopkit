import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../models/cart_model.dart';

/// A comprehensive cart summary widget with advanced features and unlimited customization
/// Features: Expandable sections, multiple layouts, animations, calculations, and extensive theming
class CartSummaryAdvanced extends StatefulWidget {
  const CartSummaryAdvanced({
    super.key,
    required this.cartItems,
    this.config,
    this.customBuilder,
    this.customItemBuilder,
    this.customTotalBuilder,
    this.customHeaderBuilder,
    this.customFooterBuilder,
    this.onQuantityChanged,
    this.onItemRemoved,
    this.onClearCart,
    this.onCheckout,
    this.showHeader = true,
    this.showFooter = true,
    this.enableItemEditing = true,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showCouponSection = true,
    this.showShippingSection = true,
    this.showTaxSection = true,
    this.style = CartSummaryStyle.standard,
    this.layout = CartSummaryLayout.list,
    this.subtotal,
    this.shipping,
    this.tax,
    this.discount,
    this.couponCode,
    this.currency = '\$',
  });

  /// List of cart items
  final List<CartItemModel> cartItems;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<CartItemModel>, CartSummaryAdvancedState)? customBuilder;

  /// Custom item builder
  final Widget Function(BuildContext, CartItemModel, int)? customItemBuilder;

  /// Custom total section builder
  final Widget Function(BuildContext, CartTotals)? customTotalBuilder;

  /// Custom header builder
  final Widget Function(BuildContext, List<CartItemModel>)? customHeaderBuilder;

  /// Custom footer builder
  final Widget Function(BuildContext, CartTotals)? customFooterBuilder;

  /// Callback when item quantity changes
  final Function(CartItemModel, int)? onQuantityChanged;

  /// Callback when item is removed
  final Function(CartItemModel)? onItemRemoved;

  /// Callback when cart is cleared
  final VoidCallback? onClearCart;

  /// Callback when checkout is tapped
  final VoidCallback? onCheckout;

  /// Whether to show header
  final bool showHeader;

  /// Whether to show footer
  final bool showFooter;

  /// Whether to enable item editing
  final bool enableItemEditing;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show coupon section
  final bool showCouponSection;

  /// Whether to show shipping section
  final bool showShippingSection;

  /// Whether to show tax section
  final bool showTaxSection;

  /// Style of the cart summary
  final CartSummaryStyle style;

  /// Layout of the cart items
  final CartSummaryLayout layout;

  /// Custom subtotal (calculated if null)
  final double? subtotal;

  /// Shipping cost
  final double? shipping;

  /// Tax amount
  final double? tax;

  /// Discount amount
  final double? discount;

  /// Applied coupon code
  final String? couponCode;

  /// Currency symbol
  final String currency;

  @override
  State<CartSummaryAdvanced> createState() => CartSummaryAdvancedState();
}

class CartSummaryAdvancedState extends State<CartSummaryAdvanced>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  FlexibleWidgetConfig? _config;
  final TextEditingController _couponController = TextEditingController();
  bool _isCouponExpanded = false;
  bool _isShippingExpanded = false;
  CartTotals _totals = CartTotals.empty();

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('cart_summary', context: context);
    _setupAnimations();
    _calculateTotals();
    
    if (widget.couponCode != null) {
      _couponController.text = widget.couponCode!;
    }
  }

  void _setupAnimations() {
    _expandController = AnimationController(
      duration: Duration(milliseconds: _getConfig('expandAnimationDuration', 300)),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: _getConfig('fadeAnimationDuration', 200)),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: _getConfig('slideAnimationDuration', 400)),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: _config?.getCurve('expandAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
    ));

    if (widget.enableAnimations) {
      _fadeController.forward();
      _slideController.forward();
    } else {
      _fadeController.value = 1.0;
      _slideController.value = 1.0;
    }
  }

  void _calculateTotals() {
    double subtotal = widget.subtotal ?? widget.cartItems.fold(0.0, (total, item) {
      return total + (item.pricePerItem * item.quantity);
    });

    double shipping = widget.shipping ?? 0.0;
    double tax = widget.tax ?? (subtotal * _getConfig('defaultTaxRate', 0.08));
    double discount = widget.discount ?? 0.0;
    
    if (widget.couponCode != null && widget.couponCode!.isNotEmpty) {
      discount = _calculateCouponDiscount(subtotal);
    }

    double total = subtotal + shipping + tax - discount;

    _totals = CartTotals(
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      discount: discount,
      total: total,
      itemCount: widget.cartItems.length,
      totalQuantity: widget.cartItems.fold(0, (sum, item) => sum + item.quantity),
    );
  }

  double _calculateCouponDiscount(double subtotal) {
    // Mock coupon calculation - implement your own logic
    final discountRate = _getConfig('couponDiscountRate', 0.1);
    final maxDiscount = _getConfig('maxCouponDiscount', 50.0);
    
    double discount = subtotal * discountRate;
    return discount > maxDiscount ? maxDiscount : discount;
  }

  void _handleQuantityChange(CartItemModel item, int newQuantity) {
    if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
      HapticFeedback.lightImpact();
    }

    widget.onQuantityChanged?.call(item, newQuantity);
    
    setState(() {
      _calculateTotals();
    });
  }

  void _handleItemRemove(CartItemModel item) {
    if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
      HapticFeedback.mediumImpact();
    }

    widget.onItemRemoved?.call(item);
    
    setState(() {
      _calculateTotals();
    });
  }

  void _toggleCouponSection() {
    setState(() {
      _isCouponExpanded = !_isCouponExpanded;
    });

    if (widget.enableAnimations) {
      if (_isCouponExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  void _toggleShippingSection() {
    setState(() {
      _isShippingExpanded = !_isShippingExpanded;
    });
  }

  @override
  void didUpdateWidget(CartSummaryAdvanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('cart_summary', context: context);
    
    if (widget.cartItems != oldWidget.cartItems ||
        widget.subtotal != oldWidget.subtotal ||
        widget.shipping != oldWidget.shipping ||
        widget.tax != oldWidget.tax ||
        widget.discount != oldWidget.discount) {
      _calculateTotals();
    }

    if (widget.couponCode != oldWidget.couponCode && widget.couponCode != null) {
      _couponController.text = widget.couponCode!;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.cartItems, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    Widget content = _buildCartSummary(context, theme);

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildCartSummary(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case CartSummaryStyle.compact:
        return _buildCompactSummary(context, theme);
      case CartSummaryStyle.detailed:
        return _buildDetailedSummary(context, theme);
      case CartSummaryStyle.minimal:
        return _buildMinimalSummary(context, theme);
      case CartSummaryStyle.card:
        return _buildCardSummary(context, theme);
      case CartSummaryStyle.standard:
        return _buildStandardSummary(context, theme);
    }
  }

  Widget _buildStandardSummary(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('containerPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('borderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        border: _getConfig('showBorder', true)
          ? Border.all(
              color: _config?.getColor('borderColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              width: _getConfig('borderWidth', 1.0),
            )
          : null,
        boxShadow: _getConfig('enableShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.08)),
                blurRadius: _getConfig('shadowBlurRadius', 8.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) _buildHeader(context, theme),
          
          if (widget.cartItems.isNotEmpty) ...[
            _buildItemsList(context, theme),
            
            if (widget.showCouponSection || widget.showShippingSection)
              _buildAdditionalSections(context, theme),
            
            _buildTotalsSection(context, theme),
          ] else
            _buildEmptyState(context, theme),
          
          if (widget.showFooter) _buildFooter(context, theme),
        ],
      ),
    );
  }

  Widget _buildCompactSummary(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('compactPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _config?.getColor('borderColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_totals.itemCount} items',
                style: TextStyle(
                  color: _config?.getColor('textColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  fontSize: _getConfig('compactFontSize', 14.0),
                ),
              ),
              Text(
                '${widget.currency}${_totals.total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _config?.getColor('totalColor', theme.primaryColor) ?? theme.primaryColor,
                  fontSize: _getConfig('compactTotalFontSize', 16.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          if (widget.showFooter) ...[
            SizedBox(height: _getConfig('compactSpacing', 8.0)),
            _buildCheckoutButton(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedSummary(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('detailedPadding', 20.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.onSurfaceColor.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) _buildDetailedHeader(context, theme),
          _buildDetailedItemsList(context, theme),
          _buildDetailedTotals(context, theme),
          if (widget.showFooter) _buildDetailedFooter(context, theme),
        ],
      ),
    );
  }

  Widget _buildMinimalSummary(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('minimalHorizontalPadding', 16.0),
        vertical: _getConfig('minimalVerticalPadding', 8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_totals.itemCount} items',
            style: TextStyle(
              color: _config?.getColor('textColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('minimalFontSize', 14.0),
            ),
          ),
          Text(
            '${widget.currency}${_totals.total.toStringAsFixed(2)}',
            style: TextStyle(
              color: _config?.getColor('totalColor', theme.primaryColor) ?? theme.primaryColor,
              fontSize: _getConfig('minimalTotalFontSize', 16.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSummary(BuildContext context, ShopKitTheme theme) {
    return Card(
      elevation: _getConfig('cardElevation', 4.0),
      color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: _config?.getBorderRadius('cardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(_getConfig('cardPadding', 16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showHeader) _buildHeader(context, theme),
            _buildItemsList(context, theme),
            _buildTotalsSection(context, theme),
            if (widget.showFooter) _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ShopKitTheme theme) {
    if (widget.customHeaderBuilder != null) {
      return widget.customHeaderBuilder!(context, widget.cartItems);
    }

    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('headerBottomMargin', 16.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getConfig('headerTitle', 'Cart Summary'),
            style: TextStyle(
              color: _config?.getColor('headerTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('headerFontSize', 18.0),
              fontWeight: _config?.getFontWeight('headerFontWeight', FontWeight.bold) ?? FontWeight.bold,
            ),
          ),
          
          if (widget.onClearCart != null && widget.cartItems.isNotEmpty)
            TextButton(
              onPressed: widget.onClearCart,
              child: Text(
                _getConfig('clearCartText', 'Clear'),
                style: TextStyle(
                  color: _config?.getColor('clearButtonColor', theme.errorColor) ?? theme.errorColor,
                  fontSize: _getConfig('clearButtonFontSize', 14.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedHeader(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('detailedHeaderBottomMargin', 20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getConfig('detailedHeaderTitle', 'Order Summary'),
                style: TextStyle(
                  color: _config?.getColor('headerTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  fontSize: _getConfig('detailedHeaderFontSize', 22.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              if (widget.onClearCart != null && widget.cartItems.isNotEmpty)
                IconButton(
                  onPressed: widget.onClearCart,
                  icon: Icon(
                    Icons.clear_all,
                    color: _config?.getColor('clearButtonColor', theme.errorColor) ?? theme.errorColor,
                  ),
                ),
            ],
          ),
          
          Text(
            '${_totals.totalQuantity} items in your cart',
            style: TextStyle(
              color: _config?.getColor('subHeaderTextColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
              fontSize: _getConfig('subHeaderFontSize', 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, ShopKitTheme theme) {
    switch (widget.layout) {
      case CartSummaryLayout.grid:
        return _buildItemsGrid(context, theme);
      case CartSummaryLayout.compact:
        return _buildCompactItemsList(context, theme);
      case CartSummaryLayout.list:
        return _buildItemsListView(context, theme);
    }
  }

  Widget _buildItemsListView(BuildContext context, ShopKitTheme theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.cartItems.length,
      separatorBuilder: (context, index) => Divider(
        height: _getConfig('itemSeparatorHeight', 16.0),
        color: _config?.getColor('separatorColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        
        if (widget.customItemBuilder != null) {
          return widget.customItemBuilder!(context, item, index);
        }
        
        return _buildStandardCartItem(context, theme, item, index);
      },
    );
  }

  Widget _buildItemsGrid(BuildContext context, ShopKitTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getConfig('gridCrossAxisCount', 2),
        childAspectRatio: _getConfig('gridChildAspectRatio', 1.2),
        mainAxisSpacing: _getConfig('gridMainAxisSpacing', 12.0),
        crossAxisSpacing: _getConfig('gridCrossAxisSpacing', 12.0),
      ),
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        return _buildGridCartItem(context, theme, item, index);
      },
    );
  }

  Widget _buildCompactItemsList(BuildContext context, ShopKitTheme theme) {
    return Column(
      children: widget.cartItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildCompactCartItem(context, theme, item, index);
      }).toList(),
    );
  }

  Widget _buildDetailedItemsList(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('detailedItemsBottomMargin', 20.0)),
      child: Column(
        children: widget.cartItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildDetailedCartItem(context, theme, item, index);
        }).toList(),
      ),
    );
  }

  Widget _buildStandardCartItem(BuildContext context, ShopKitTheme theme, CartItemModel item, int index) {
    return Container(
      padding: EdgeInsets.all(_getConfig('itemPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('itemBackgroundColor', Colors.transparent) ?? Colors.transparent,
        borderRadius: BorderRadius.circular(_getConfig('itemBorderRadius', 8.0)),
      ),
      child: Row(
        children: [
          // Product Image
          if (item.product.images?.isNotEmpty == true)
            ClipRRect(
              borderRadius: BorderRadius.circular(_getConfig('itemImageBorderRadius', 6.0)),
              child: Image.network(
                item.product.images!.first,
                width: _getConfig('itemImageSize', 60.0),
                height: _getConfig('itemImageSize', 60.0),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: _getConfig('itemImageSize', 60.0),
                  height: _getConfig('itemImageSize', 60.0),
                  color: theme.surfaceColor,
                  child: Icon(
                    Icons.image_not_supported,
                    color: theme.onSurfaceColor,
                  ),
                ),
              ),
            ),
          
          SizedBox(width: _getConfig('itemContentSpacing', 12.0)),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    color: _config?.getColor('itemNameColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                    fontSize: _getConfig('itemNameFontSize', 16.0),
                    fontWeight: _config?.getFontWeight('itemNameFontWeight', FontWeight.w500) ?? FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: _getConfig('itemDetailsSpacing', 4.0)),
                
                Text(
                  '${widget.currency}${item.pricePerItem.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _config?.getColor('itemPriceColor', theme.primaryColor) ?? theme.primaryColor,
                    fontSize: _getConfig('itemPriceFontSize', 14.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          if (widget.enableItemEditing)
            _buildQuantityControls(context, theme, item),
        ],
      ),
    );
  }

  Widget _buildGridCartItem(BuildContext context, ShopKitTheme theme, CartItemModel item, int index) {
    return Container(
      padding: EdgeInsets.all(_getConfig('gridItemPadding', 8.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('gridItemBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(_getConfig('gridItemBorderRadius', 8.0)),
      ),
      child: Column(
        children: [
          // Product Image
          if (item.product.images?.isNotEmpty == true)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  item.product.images!.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          
          SizedBox(height: _getConfig('gridItemSpacing', 8.0)),
          
          // Product Details
          Text(
            item.product.name,
            style: TextStyle(
              color: _config?.getColor('gridItemNameColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('gridItemNameFontSize', 12.0),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          Text(
            '${widget.currency}${item.pricePerItem.toStringAsFixed(2)} × ${item.quantity}',
            style: TextStyle(
              color: _config?.getColor('gridItemPriceColor', theme.primaryColor) ?? theme.primaryColor,
              fontSize: _getConfig('gridItemPriceFontSize', 10.0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCartItem(BuildContext context, ShopKitTheme theme, CartItemModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('compactItemSpacing', 8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${item.product.name} × ${item.quantity}',
              style: TextStyle(
                color: _config?.getColor('compactItemNameColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                fontSize: _getConfig('compactItemNameFontSize', 14.0),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          Text(
            '${widget.currency}${(item.pricePerItem * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              color: _config?.getColor('compactItemPriceColor', theme.primaryColor) ?? theme.primaryColor,
              fontSize: _getConfig('compactItemPriceFontSize', 14.0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCartItem(BuildContext context, ShopKitTheme theme, CartItemModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('detailedItemSpacing', 16.0)),
      padding: EdgeInsets.all(_getConfig('detailedItemPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('detailedItemBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(_getConfig('detailedItemBorderRadius', 12.0)),
        border: Border.all(
          color: _config?.getColor('detailedItemBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              if (item.product.images?.isNotEmpty == true)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    item.product.images!.first,
                    width: _getConfig('detailedItemImageSize', 80.0),
                    height: _getConfig('detailedItemImageSize', 80.0),
                    fit: BoxFit.cover,
                  ),
                ),
              
              SizedBox(width: _getConfig('detailedItemContentSpacing', 16.0)),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: TextStyle(
                        color: _config?.getColor('detailedItemNameColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                        fontSize: _getConfig('detailedItemNameFontSize', 16.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    if (item.product.description?.isNotEmpty == true) ...[
                      SizedBox(height: 4.0),
                      Text(
                        item.product.description ?? "",
                        style: TextStyle(
                          color: _config?.getColor('detailedItemDescriptionColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                          fontSize: _getConfig('detailedItemDescriptionFontSize', 12.0),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    SizedBox(height: 8.0),
                    
                    Text(
                      '${widget.currency}${item.pricePerItem.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _config?.getColor('detailedItemPriceColor', theme.primaryColor) ?? theme.primaryColor,
                        fontSize: _getConfig('detailedItemPriceFontSize', 16.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: _getConfig('detailedItemControlsSpacing', 12.0)),
          
          // Quantity Controls and Remove Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.enableItemEditing)
                _buildQuantityControls(context, theme, item),
              
              TextButton.icon(
                onPressed: () => _handleItemRemove(item),
                icon: Icon(
                  Icons.delete_outline,
                  size: _getConfig('removeIconSize', 16.0),
                  color: _config?.getColor('removeButtonColor', theme.errorColor) ?? theme.errorColor,
                ),
                label: Text(
                  _getConfig('removeButtonText', 'Remove'),
                  style: TextStyle(
                    color: _config?.getColor('removeButtonColor', theme.errorColor) ?? theme.errorColor,
                    fontSize: _getConfig('removeButtonFontSize', 12.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, ShopKitTheme theme, CartItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: _config?.getColor('quantityControlsBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(_getConfig('quantityControlsBorderRadius', 20.0)),
        border: Border.all(
          color: _config?.getColor('quantityControlsBorderColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: item.quantity > 1 ? () => _handleQuantityChange(item, item.quantity - 1) : null,
            icon: Icon(
              Icons.remove,
              size: _getConfig('quantityControlIconSize', 16.0),
              color: item.quantity > 1 
                ? _config?.getColor('quantityControlIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor
                : _config?.getColor('quantityControlDisabledIconColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
            ),
            padding: EdgeInsets.all(_getConfig('quantityControlIconPadding', 4.0)),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: _getConfig('quantityTextPadding', 8.0)),
            child: Text(
              item.quantity.toString(),
              style: TextStyle(
                color: _config?.getColor('quantityTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                fontSize: _getConfig('quantityTextFontSize', 14.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          IconButton(
            onPressed: () => _handleQuantityChange(item, item.quantity + 1),
            icon: Icon(
              Icons.add,
              size: _getConfig('quantityControlIconSize', 16.0),
              color: _config?.getColor('quantityControlIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
            ),
            padding: EdgeInsets.all(_getConfig('quantityControlIconPadding', 4.0)),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSections(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _getConfig('additionalSectionsMargin', 16.0)),
      child: Column(
        children: [
          if (widget.showCouponSection) _buildCouponSection(context, theme),
          if (widget.showShippingSection) _buildShippingSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('couponSectionBottomMargin', 12.0)),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleCouponSection,
            child: Container(
              padding: EdgeInsets.all(_getConfig('couponHeaderPadding', 12.0)),
              decoration: BoxDecoration(
                color: _config?.getColor('couponHeaderBackgroundColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(_getConfig('couponHeaderBorderRadius', 8.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer,
                        color: _config?.getColor('couponIconColor', theme.primaryColor) ?? theme.primaryColor,
                        size: _getConfig('couponIconSize', 20.0),
                      ),
                      SizedBox(width: _getConfig('couponIconSpacing', 8.0)),
                      Text(
                        _getConfig('couponSectionTitle', 'Have a coupon?'),
                        style: TextStyle(
                          color: _config?.getColor('couponTitleColor', theme.primaryColor) ?? theme.primaryColor,
                          fontSize: _getConfig('couponTitleFontSize', 14.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isCouponExpanded ? Icons.expand_less : Icons.expand_more,
                    color: _config?.getColor('couponExpandIconColor', theme.primaryColor) ?? theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          
          if (widget.enableAnimations)
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: _buildCouponInput(context, theme),
            )
          else if (_isCouponExpanded)
            _buildCouponInput(context, theme),
        ],
      ),
    );
  }

  Widget _buildCouponInput(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(top: _getConfig('couponInputTopMargin', 8.0)),
      padding: EdgeInsets.all(_getConfig('couponInputPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('couponInputBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(_getConfig('couponInputBorderRadius', 8.0)),
        border: Border.all(
          color: _config?.getColor('couponInputBorderColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: _getConfig('couponInputHint', 'Enter coupon code'),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  color: _config?.getColor('couponInputHintColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
                  fontSize: _getConfig('couponInputFontSize', 14.0),
                ),
              ),
              style: TextStyle(
                color: _config?.getColor('couponInputTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                fontSize: _getConfig('couponInputFontSize', 14.0),
              ),
            ),
          ),
          
          TextButton(
            onPressed: () {
              // Apply coupon logic
              setState(() {
                _calculateTotals();
              });
            },
            child: Text(
              _getConfig('couponApplyText', 'Apply'),
              style: TextStyle(
                color: _config?.getColor('couponApplyButtonColor', theme.primaryColor) ?? theme.primaryColor,
                fontSize: _getConfig('couponApplyButtonFontSize', 14.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSection(BuildContext context, ShopKitTheme theme) {
    return InkWell(
      onTap: _toggleShippingSection,
      child: Container(
        padding: EdgeInsets.all(_getConfig('shippingSectionPadding', 12.0)),
        decoration: BoxDecoration(
          color: _config?.getColor('shippingSectionBackgroundColor', theme.secondaryColor.withValues(alpha: 0.1)) ?? theme.secondaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(_getConfig('shippingSectionBorderRadius', 8.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  color: _config?.getColor('shippingIconColor', theme.secondaryColor) ?? theme.secondaryColor,
                  size: _getConfig('shippingIconSize', 20.0),
                ),
                SizedBox(width: _getConfig('shippingIconSpacing', 8.0)),
                Text(
                  _getConfig('shippingSectionTitle', 'Shipping options'),
                  style: TextStyle(
                    color: _config?.getColor('shippingTitleColor', theme.secondaryColor) ?? theme.secondaryColor,
                    fontSize: _getConfig('shippingTitleFontSize', 14.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              _isShippingExpanded ? Icons.expand_less : Icons.expand_more,
              color: _config?.getColor('shippingExpandIconColor', theme.secondaryColor) ?? theme.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection(BuildContext context, ShopKitTheme theme) {
    if (widget.customTotalBuilder != null) {
      return widget.customTotalBuilder!(context, _totals);
    }

    return Container(
      margin: EdgeInsets.only(top: _getConfig('totalsSectionTopMargin', 16.0)),
      padding: EdgeInsets.all(_getConfig('totalsSectionPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('totalsSectionBackgroundColor', theme.surfaceColor.withValues(alpha: 0.5)) ?? theme.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(_getConfig('totalsSectionBorderRadius', 8.0)),
      ),
      child: Column(
        children: [
          _buildTotalLine(context, theme, 'Subtotal', _totals.subtotal),
          
          if (widget.showShippingSection && _totals.shipping > 0)
            _buildTotalLine(context, theme, 'Shipping', _totals.shipping),
          
          if (widget.showTaxSection && _totals.tax > 0)
            _buildTotalLine(context, theme, 'Tax', _totals.tax),
          
          if (_totals.discount > 0)
            _buildTotalLine(context, theme, 'Discount', -_totals.discount, isDiscount: true),
          
          Divider(
            color: _config?.getColor('totalsDividerColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
            height: _getConfig('totalsDividerHeight', 20.0),
          ),
          
          _buildTotalLine(
            context, 
            theme, 
            'Total', 
            _totals.total, 
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTotals(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('detailedTotalsBottomMargin', 20.0)),
      padding: EdgeInsets.all(_getConfig('detailedTotalsPadding', 20.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('detailedTotalsBackgroundColor', theme.primaryColor.withValues(alpha: 0.05)) ?? theme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(_getConfig('detailedTotalsBorderRadius', 12.0)),
        border: Border.all(
          color: _config?.getColor('detailedTotalsBorderColor', theme.primaryColor.withValues(alpha: 0.2)) ?? theme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            _getConfig('detailedTotalsTitle', 'Order Summary'),
            style: TextStyle(
              color: _config?.getColor('detailedTotalsTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('detailedTotalsTitleFontSize', 18.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: _getConfig('detailedTotalsSpacing', 16.0)),
          
          _buildTotalLine(context, theme, 'Subtotal', _totals.subtotal),
          
          if (_totals.shipping > 0)
            _buildTotalLine(context, theme, 'Shipping', _totals.shipping),
          
          if (_totals.tax > 0)
            _buildTotalLine(context, theme, 'Tax', _totals.tax),
          
          if (_totals.discount > 0)
            _buildTotalLine(context, theme, 'Discount', -_totals.discount, isDiscount: true),
          
          Divider(
            color: _config?.getColor('detailedTotalsDividerColor', theme.primaryColor) ?? theme.primaryColor,
            thickness: 2.0,
            height: 24.0,
          ),
          
          _buildTotalLine(
            context, 
            theme, 
            'Total', 
            _totals.total, 
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalLine(BuildContext context, ShopKitTheme theme, String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _getConfig('totalLineVerticalMargin', 4.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal 
                ? _config?.getColor('totalLabelColor', theme.onSurfaceColor) ?? theme.onSurfaceColor
                : _config?.getColor('subtotalLabelColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
              fontSize: isTotal 
                ? _getConfig('totalLabelFontSize', 16.0)
                : _getConfig('subtotalLabelFontSize', 14.0),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          
          Text(
            '${isDiscount ? '-' : ''}${widget.currency}${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: isTotal 
                ? _config?.getColor('totalAmountColor', theme.primaryColor) ?? theme.primaryColor
                : isDiscount
                  ? _config?.getColor('discountAmountColor', theme.successColor) ?? theme.successColor
                  : _config?.getColor('subtotalAmountColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: isTotal 
                ? _getConfig('totalAmountFontSize', 18.0)
                : _getConfig('subtotalAmountFontSize', 14.0),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('emptyStatePadding', 40.0)),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: _getConfig('emptyStateIconSize', 64.0),
            color: _config?.getColor('emptyStateIconColor', theme.onSurfaceColor.withValues(alpha: 0.4)) ?? theme.onSurfaceColor.withValues(alpha: 0.4),
          ),
          
          SizedBox(height: _getConfig('emptyStateSpacing', 16.0)),
          
          Text(
            _getConfig('emptyStateTitle', 'Your cart is empty'),
            style: TextStyle(
              color: _config?.getColor('emptyStateTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('emptyStateTitleFontSize', 18.0),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: _getConfig('emptyStateDescriptionSpacing', 8.0)),
          
          Text(
            _getConfig('emptyStateDescription', 'Add some products to get started'),
            style: TextStyle(
              color: _config?.getColor('emptyStateDescriptionColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('emptyStateDescriptionFontSize', 14.0),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ShopKitTheme theme) {
    if (widget.customFooterBuilder != null) {
      return widget.customFooterBuilder!(context, _totals);
    }

    return Container(
      margin: EdgeInsets.only(top: _getConfig('footerTopMargin', 16.0)),
      child: _buildCheckoutButton(context, theme),
    );
  }

  Widget _buildDetailedFooter(BuildContext context, ShopKitTheme theme) {
    return Column(
      children: [
        _buildCheckoutButton(context, theme),
        
        SizedBox(height: _getConfig('detailedFooterSpacing', 12.0)),
        
        Text(
          _getConfig('detailedFooterText', 'Secure checkout with SSL encryption'),
          style: TextStyle(
            color: _config?.getColor('detailedFooterTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            fontSize: _getConfig('detailedFooterTextFontSize', 12.0),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, ShopKitTheme theme) {
    final isEnabled = widget.cartItems.isNotEmpty && widget.onCheckout != null;
    
    return SizedBox(
      width: double.infinity,
      height: _getConfig('checkoutButtonHeight', 48.0),
      child: ElevatedButton(
        onPressed: isEnabled ? widget.onCheckout : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _config?.getColor('checkoutButtonBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
          foregroundColor: _config?.getColor('checkoutButtonTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
          disabledBackgroundColor: _config?.getColor('checkoutButtonDisabledBackgroundColor', theme.onSurfaceColor.withValues(alpha: 0.12)) ?? theme.onSurfaceColor.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: _config?.getBorderRadius('checkoutButtonBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          ),
          elevation: _getConfig('checkoutButtonElevation', 2.0),
        ),
        child: Text(
          _getConfig('checkoutButtonText', 'Proceed to Checkout • ${widget.currency}${_totals.total.toStringAsFixed(2)}'),
          style: TextStyle(
            fontSize: _getConfig('checkoutButtonFontSize', 16.0),
            fontWeight: _config?.getFontWeight('checkoutButtonFontWeight', FontWeight.w600) ?? FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Public API for external access
  CartTotals get totals => _totals;
  
  bool get hasItems => widget.cartItems.isNotEmpty;
  
  int get itemCount => _totals.itemCount;
  
  int get totalQuantity => _totals.totalQuantity;
  
  void refreshTotals() {
    setState(() {
      _calculateTotals();
    });
  }
  
  void applyCoupon(String couponCode) {
    _couponController.text = couponCode;
    setState(() {
      _calculateTotals();
    });
  }
  
  void clearCoupon() {
    _couponController.clear();
    setState(() {
      _calculateTotals();
    });
  }
}

/// Style options for cart summary
enum CartSummaryStyle {
  standard,
  compact,
  detailed,
  minimal,
  card,
}

/// Layout options for cart items
enum CartSummaryLayout {
  list,
  grid,
  compact,
}

/// Data class for cart totals
class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    required this.itemCount,
    required this.totalQuantity,
  });

  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final int itemCount;
  final int totalQuantity;

  CartTotals.empty()
      : subtotal = 0.0,
        shipping = 0.0,
        tax = 0.0,
        discount = 0.0,
        total = 0.0,
        itemCount = 0,
        totalQuantity = 0;

  @override
  String toString() {
    return 'CartTotals(subtotal: $subtotal, shipping: $shipping, tax: $tax, discount: $discount, total: $total, itemCount: $itemCount, totalQuantity: $totalQuantity)';
  }
}
