import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system
import '../../models/cart_model.dart';

/// A comprehensive cart summary widget, styled via ShopKitTheme.
///
/// Features expandable sections, multiple layouts, animations, and extensive theming.
/// The appearance is now controlled centrally through the `CartSummaryTheme`.
class CartSummaryAdvanced extends StatefulWidget {
  /// Creates a Cart Summary widget.
  /// The constructor is now clean and focuses on data and behavior.
  const CartSummaryAdvanced({
    super.key,
    required this.cartItems,
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
    this.style = CartSummaryStyle.standard,
    this.layout = CartSummaryLayout.list,
    this.subtotal,
    this.shipping,
    this.tax,
    this.discount,
    this.couponCode,
    this.currency = '\$',
  });

  final List<CartItemModel> cartItems;
  final Widget Function(BuildContext, List<CartItemModel>, CartSummaryAdvancedState)? customBuilder;
  final Widget Function(BuildContext, CartItemModel, int)? customItemBuilder;
  final Widget Function(BuildContext, CartTotals)? customTotalBuilder;
  final Widget Function(BuildContext, List<CartItemModel>)? customHeaderBuilder;
  final Widget Function(BuildContext, CartTotals)? customFooterBuilder;
  final Function(CartItemModel, int)? onQuantityChanged;
  final Function(CartItemModel)? onItemRemoved;
  final VoidCallback? onClearCart;
  final VoidCallback? onCheckout;
  final bool showHeader;
  final bool showFooter;
  final bool enableItemEditing;
  final bool enableAnimations;
  final bool enableHaptics;
  final bool showCouponSection;
  final CartSummaryStyle style;
  final CartSummaryLayout layout;
  final double? subtotal;
  final double? shipping;
  final double? tax;
  final double? discount;
  final String? couponCode;
  final String currency;

  @override
  State<CartSummaryAdvanced> createState() => CartSummaryAdvancedState();
}

class CartSummaryAdvancedState extends State<CartSummaryAdvanced> with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _slideController;
  late Animation<double> _expandAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _couponController = TextEditingController();
  bool _isCouponExpanded = false;
  CartTotals _totals = CartTotals.empty();

  @override
  void initState() {
    super.initState();
    // Animations are set up after the first frame to access the theme.
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAnimations());
    _calculateTotals();
    if (widget.couponCode != null) {
      _couponController.text = widget.couponCode!;
    }
  }

  @override
  void didUpdateWidget(CartSummaryAdvanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems ||
        widget.subtotal != oldWidget.subtotal ||
        widget.shipping != oldWidget.shipping ||
        widget.tax != oldWidget.tax ||
        widget.discount != oldWidget.discount) {
      if(mounted) setState(_calculateTotals);
    }
    if (widget.couponCode != oldWidget.couponCode && widget.couponCode != null) {
      _couponController.text = widget.couponCode!;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _slideController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    _expandController = AnimationController(
      duration: shopKitTheme?.animations.fast ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 400),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(parent: _expandController, curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: shopKitTheme?.animations.easeOut ?? Curves.easeOutCubic));

    if (widget.enableAnimations) {
      _slideController.forward();
    } else {
      _slideController.value = 1.0;
    }
  }

  void _calculateTotals() {
    double subtotal = widget.subtotal ?? widget.cartItems.fold(0.0, (total, item) => total + item.totalPrice);
    double shipping = widget.shipping ?? 0.0;
    double tax = widget.tax ?? (subtotal * 0.08); // Assuming 8% default tax
    double discount = widget.discount ?? 0.0;
    
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

void _handleQuantityChange(CartItemModel item, int newQuantity) {
  if (widget.enableHaptics) HapticFeedback.lightImpact();
  // Simply call the callback. Do NOT call setState here.
  widget.onQuantityChanged?.call(item, newQuantity);
}

void _handleItemRemove(CartItemModel item) {
  if (widget.enableHaptics) HapticFeedback.mediumImpact();
  // Simply call the callback. Do NOT call setState here.
  widget.onItemRemoved?.call(item);
}


  void _toggleCouponSection() {
    setState(() => _isCouponExpanded = !_isCouponExpanded);
    if (widget.enableAnimations) {
      _isCouponExpanded ? _expandController.forward() : _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.cartItems, this);
    }
    
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final summaryTheme = shopKitTheme?.cartSummaryTheme;
    final spacing = shopKitTheme?.spacing;

    Widget content = Container(
      padding: EdgeInsets.all(spacing?.md ?? 16.0),
      decoration: BoxDecoration(
        color: summaryTheme?.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: summaryTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.lg ?? 16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) _buildHeader(theme, shopKitTheme),
          if (widget.cartItems.isNotEmpty) ...[
            _buildItemsList(theme, shopKitTheme),
            if (widget.showCouponSection) _buildCouponSection(theme, shopKitTheme),
            _buildTotalsSection(theme, shopKitTheme),
          ] else
            _buildEmptyState(theme, shopKitTheme),
          if (widget.showFooter) _buildFooter(theme, shopKitTheme),
        ],
      ),
    );

    return widget.enableAnimations
        ? SlideTransition(position: _slideAnimation, child: content)
        : content;
  }

  Widget _buildHeader(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final summaryTheme = shopKitTheme?.cartSummaryTheme;
    return Container(
      margin: EdgeInsets.only(bottom: shopKitTheme?.spacing.md ?? 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cart Summary',
            style: summaryTheme?.titleStyle ?? shopKitTheme?.typography.headline2 ?? theme.textTheme.headlineSmall,
          ),
          if (widget.onClearCart != null && widget.cartItems.isNotEmpty)
            TextButton(
              onPressed: widget.onClearCart,
              child: Text(
                'Clear',
                style: TextStyle(color: shopKitTheme?.colors.error ?? theme.colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsList(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.cartItems.length,
      separatorBuilder: (context, index) => Divider(height: shopKitTheme?.spacing.lg ?? 24.0),
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        return widget.customItemBuilder?.call(context, item, index) ??
            _buildStandardCartItem(theme, shopKitTheme, item);
      },
    );
  }

  Widget _buildStandardCartItem(ThemeData theme, ShopKitTheme? shopKitTheme, CartItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item.product.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(shopKitTheme?.radii.sm ?? 8.0),
            child: Image.network(
              item.product.imageUrl!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) => const SizedBox(width: 60, height: 60),
            ),
          ),
        SizedBox(width: shopKitTheme?.spacing.md ?? 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: (shopKitTheme?.typography.body1 ?? theme.textTheme.bodyMedium)!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: shopKitTheme?.spacing.xs ?? 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.currency}${item.pricePerItem.toStringAsFixed(2)}',
                    style: (shopKitTheme?.typography.body2 ?? theme.textTheme.bodySmall)!.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (widget.enableItemEditing) _buildQuantityControls(item, shopKitTheme, theme) else
                    Text('Qty: ${item.quantity}', style: shopKitTheme?.typography.body2),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${widget.currency}${item.totalPrice.toStringAsFixed(2)}',
              style: (shopKitTheme?.typography.body1 ?? theme.textTheme.bodyMedium)!.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.enableItemEditing)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Remove',
                    onPressed: () => _handleItemRemove(item),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(CartItemModel item, ShopKitTheme? shopKitTheme, ThemeData theme) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Decrease quantity',
          onPressed: item.quantity > 1 ? () => _handleQuantityChange(item, item.quantity - 1) : null,
        ),
        Text('${item.quantity}', style: shopKitTheme?.typography.body1 ?? theme.textTheme.bodyMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Increase quantity',
          onPressed: () => _handleQuantityChange(item, item.quantity + 1),
        ),
      ],
    );
  }

  Widget _buildCouponSection(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shopKitTheme?.spacing.md ?? 16.0),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleCouponSection,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Have a coupon?', style: shopKitTheme?.typography.body1),
                Icon(_isCouponExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: EdgeInsets.only(top: shopKitTheme?.spacing.sm ?? 8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _couponController, decoration: InputDecoration(hintText: 'Coupon Code'))),
                  SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
                  ElevatedButton(onPressed: () { /* Apply logic */ }, child: Text('Apply')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final summaryTheme = shopKitTheme?.cartSummaryTheme;
    return Padding(
      padding: EdgeInsets.only(top: shopKitTheme?.spacing.md ?? 16.0),
      child: Column(
        children: [
          _buildTotalLine(
            label: 'Subtotal',
            amount: _totals.subtotal,
            labelStyle: summaryTheme?.totalLabelStyle ?? shopKitTheme?.typography.body1,
            valueStyle: summaryTheme?.totalLabelStyle ?? shopKitTheme?.typography.body1,
          ),
          SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
          if (_totals.shipping > 0)
             _buildTotalLine(
              label: 'Shipping',
              amount: _totals.shipping,
              labelStyle: summaryTheme?.totalLabelStyle ?? shopKitTheme?.typography.body1,
              valueStyle: summaryTheme?.totalLabelStyle ?? shopKitTheme?.typography.body1,
            ),
          SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
          const Divider(),
          SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
          _buildTotalLine(
            label: 'Total',
            amount: _totals.total,
            labelStyle: summaryTheme?.totalValueStyle ?? shopKitTheme?.typography.headline2 ?? theme.textTheme.headlineSmall,
            valueStyle: (summaryTheme?.totalValueStyle ?? shopKitTheme?.typography.headline2 ?? theme.textTheme.headlineSmall)!
                        .copyWith(color: shopKitTheme?.colors.primary ?? theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalLine({required String label, required double amount, TextStyle? labelStyle, TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text('${widget.currency}${amount.toStringAsFixed(2)}', style: valueStyle),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: shopKitTheme?.spacing.xl ?? 32.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.4)),
            SizedBox(height: shopKitTheme?.spacing.md ?? 16.0),
            Text('Your cart is empty', style: shopKitTheme?.typography.headline2),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final summaryTheme = shopKitTheme?.cartSummaryTheme;
    return Padding(
      padding: EdgeInsets.only(top: shopKitTheme?.spacing.md ?? 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.cartItems.isNotEmpty ? widget.onCheckout : null,
          style: summaryTheme?.checkoutButtonStyle ??
              ElevatedButton.styleFrom(
                padding: EdgeInsets.all(shopKitTheme?.spacing.md ?? 16.0),
                textStyle: shopKitTheme?.typography.button,
              ),
          child: const Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}

/// Style options for cart summary
enum CartSummaryStyle { standard, compact, detailed, minimal, card }
/// Layout options for cart items
enum CartSummaryLayout { list, grid, compact }

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

  factory CartTotals.empty() => const CartTotals(
        subtotal: 0.0, shipping: 0.0, tax: 0.0, discount: 0.0,
        total: 0.0, itemCount: 0, totalQuantity: 0,
      );
}
