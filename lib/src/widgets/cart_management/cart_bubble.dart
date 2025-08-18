import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system
import '../../models/cart_model.dart';

/// A comprehensive cart bubble widget with advanced features and unlimited customization.
/// Features: Animations, badges, counters, custom shapes, and extensive theming.
class CartBubbleAdvanced extends StatefulWidget {
  /// Creates a Cart Bubble widget.
  ///
  /// The constructor is now clean and focuses on data and behavior,
  /// while all styling is handled by the `CartBubbleTheme` within `ShopKitTheme`.
  const CartBubbleAdvanced({
    super.key,
    this.cartItems = const [],
    this.onTap,
    this.customBuilder,
    this.customBadgeBuilder,
    this.customIconBuilder,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showItemCount = true,
    this.showTotalPrice = false,
    this.animateOnChange = true,
    this.position = CartBubblePosition.topRight,
    this.style = CartBubbleStyle.floating,
  });

  /// The list of items currently in the cart.
  final List<CartItemModel> cartItems;

  /// A callback function triggered when the bubble is tapped.
  final VoidCallback? onTap;

  /// A custom builder for rendering the entire widget, offering complete control.
  final Widget Function(BuildContext, List<CartItemModel>, CartBubbleAdvancedState)? customBuilder;

  /// A custom builder for the notification badge.
  final Widget Function(BuildContext, int, double)? customBadgeBuilder;

  /// A custom builder for the main icon.
  final Widget Function(BuildContext, List<CartItemModel>)? customIconBuilder;

  /// Enables or disables all animations.
  final bool enableAnimations;

  /// Enables or disables haptic feedback on tap and cart changes.
  final bool enableHaptics;

  /// Determines whether the item count is displayed in the badge.
  final bool showItemCount;

  /// Determines whether the total price is displayed (in `extended` style).
  final bool showTotalPrice;

  /// If true, the bubble will play a bounce animation when the item count changes.
  final bool animateOnChange;

  /// The position of the bubble on the screen (for layout purposes).
  final CartBubblePosition position;

  /// The visual style of the bubble.
  final CartBubbleStyle style;

  @override
  State<CartBubbleAdvanced> createState() => CartBubbleAdvancedState();
}

class CartBubbleAdvancedState extends State<CartBubbleAdvanced> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _badgeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _badgeScaleAnimation;

  int _previousItemCount = 0;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // Note: Animation durations will be set in _handleCartChange from the theme.
    _bounceController = AnimationController(vsync: this);
    _badgeController = AnimationController(vsync: this);

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut));
    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut));

    _calculateTotals();
    _previousItemCount = widget.cartItems.length;
    if (widget.cartItems.isNotEmpty) {
      _badgeController.value = 1.0; // Start visible if not empty
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CartBubbleAdvanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems) {
      _handleCartChange();
    }
  }

  void _calculateTotals() {
    _totalPrice = widget.cartItems.fold(0.0, (total, item) {
      return total + (item.pricePerItem * item.quantity);
    });
  }

  void _handleCartChange() {
    final currentItemCount = widget.cartItems.length;
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
  _badgeController.duration = shopKitTheme?.fastAnimation ?? const Duration(milliseconds: 150);

    if (widget.animateOnChange && currentItemCount != _previousItemCount) {
      if (currentItemCount > _previousItemCount && widget.enableAnimations) {
  _bounceController.duration = shopKitTheme?.bounceDuration ?? const Duration(milliseconds: 600);
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
        if (widget.enableHaptics) HapticFeedback.lightImpact();
      }

      if (currentItemCount > 0 && _previousItemCount == 0) {
        _badgeController.forward();
      } else if (currentItemCount == 0 && _previousItemCount > 0) {
        _badgeController.reverse();
      }
    }

    _previousItemCount = currentItemCount;
    if(mounted) setState(_calculateTotals);
  }

  void _handleTap() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    if (widget.enableAnimations) {
  _bounceController.duration = shopKitTheme?.bounceDuration ?? const Duration(milliseconds: 600);
      _bounceController.forward().then((_) => _bounceController.reverse());
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.cartItems, this);
    }
    
    Widget bubble = _buildBubbleContent();

    if (widget.enableAnimations) {
      bubble = ScaleTransition(
        scale: _bounceAnimation,
        child: bubble,
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      child: bubble,
    );
  }

  Widget _buildBubbleContent() {
    switch (widget.style) {
      case CartBubbleStyle.minimal:
        return _buildMinimalBubble();
      case CartBubbleStyle.badge:
        return _buildBadgeBubble();
      case CartBubbleStyle.extended:
        return _buildExtendedBubble();
      case CartBubbleStyle.fab:
        return _buildFabBubble();
      case CartBubbleStyle.floating:
        return _buildFloatingBubble();
    }
  }

  Widget _buildFloatingBubble() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;

    return Container(
      width: bubbleTheme?.size ?? 56.0,
      height: bubbleTheme?.size ?? 56.0,
      decoration: BoxDecoration(
        color: bubbleTheme?.backgroundColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: bubbleTheme?.boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _buildIcon(),
          if (widget.showItemCount) _buildBadge(),
        ],
      ),
    );
  }

  Widget _buildMinimalBubble() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _buildIcon(),
          if (widget.showItemCount) _buildBadge(),
        ],
      ),
    );
  }

  Widget _buildBadgeBubble() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;

    return Badge(
      label: Text(
        _formatBadgeText(),
        style: TextStyle(
          color: bubbleTheme?.badgeTextColor ?? shopKitTheme?.colors.onPrimary ?? theme.colorScheme.onPrimary,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: bubbleTheme?.badgeColor ?? shopKitTheme?.colors.secondary ?? theme.colorScheme.secondary,
      isLabelVisible: widget.cartItems.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildIcon(),
      ),
    );
  }

  Widget _buildExtendedBubble() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: bubbleTheme?.backgroundColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
        borderRadius: bubbleTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
        boxShadow: bubbleTheme?.boxShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
          if (widget.showItemCount)
            Text(
              widget.cartItems.length.toString(),
              style: shopKitTheme?.typography.button.copyWith(color: bubbleTheme?.iconColor ?? shopKitTheme.colors.onPrimary),
            ),
          if (widget.showTotalPrice && widget.showItemCount)
            Text(" / ", style: TextStyle(color: bubbleTheme?.iconColor?.withOpacity(0.8) ?? shopKitTheme?.colors.onPrimary.withOpacity(0.8))),
          if (widget.showTotalPrice)
            Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: shopKitTheme?.typography.body2.copyWith(color: bubbleTheme?.iconColor ?? shopKitTheme.colors.onPrimary),
            ),
        ],
      ),
    );
  }

  Widget _buildFabBubble() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;
    
    return SizedBox(
      width: bubbleTheme?.size ?? 56.0,
      height: bubbleTheme?.size ?? 56.0,
      child: FloatingActionButton(
        onPressed: _handleTap,
        backgroundColor: bubbleTheme?.backgroundColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
        elevation: bubbleTheme?.boxShadow?.first.blurRadius ?? 4.0,
        shape: RoundedRectangleBorder(borderRadius: bubbleTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.md ?? 12.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildIcon(),
            if (widget.showItemCount) _buildBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.customIconBuilder != null) {
      return widget.customIconBuilder!(context, widget.cartItems);
    }
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;
    return Icon(
      Icons.shopping_cart_outlined,
      color: bubbleTheme?.iconColor ?? shopKitTheme?.colors.onPrimary ?? theme.colorScheme.onPrimary,
      size: bubbleTheme?.iconSize ?? 24.0,
    );
  }
  
  Widget _buildBadge() {
    if (widget.customBadgeBuilder != null) {
      return widget.customBadgeBuilder!(context, widget.cartItems.length, _totalPrice);
    }
    
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final bubbleTheme = shopKitTheme?.cartBubbleTheme;

    return Positioned(
      top: -4,
      right: -4,
      child: ScaleTransition(
        scale: _badgeScaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          decoration: BoxDecoration(
            color: bubbleTheme?.badgeColor ?? shopKitTheme?.colors.secondary ?? theme.colorScheme.secondary,
            shape: BoxShape.circle,
            border: Border.all(
              color: bubbleTheme?.backgroundColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary, 
              width: 1.5
            ),
          ),
          child: Center(
            child: Text(
              _formatBadgeText(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: bubbleTheme?.badgeTextColor ?? shopKitTheme?.colors.onSecondary ?? theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  String _formatBadgeText() {
    final itemCount = widget.cartItems.length;
    return itemCount > 99 ? '99+' : itemCount.toString();
  }

  // --- Public API for external control ---
  int get itemCount => widget.cartItems.length;
  double get totalPrice => _totalPrice;
  bool get hasItems => widget.cartItems.isNotEmpty;

  void triggerBounce() {
    if (widget.enableAnimations) {
      final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
  _bounceController.duration = shopKitTheme?.bounceDuration ?? const Duration(milliseconds: 600);
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
  }
}

/// Defines the screen position for the `CartBubble`.
enum CartBubblePosition { topLeft, topRight, bottomLeft, bottomRight, center }

/// Defines the visual style of the `CartBubble`.
enum CartBubbleStyle { floating, minimal, badge, extended, fab }