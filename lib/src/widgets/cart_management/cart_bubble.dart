import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../models/cart_model.dart';

/// A comprehensive cart bubble widget with advanced features and unlimited customization
/// Features: Animations, badges, counters, custom shapes, themes, and extensive configuration
class CartBubbleAdvanced extends StatefulWidget {
  const CartBubbleAdvanced({
    super.key,
    this.cartItems = const [],
    this.onTap,
    this.config,
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
  this.themeStyle,
  });

  /// List of cart items
  final List<CartItemModel> cartItems;

  /// Callback when bubble is tapped
  final VoidCallback? onTap;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<CartItemModel>, CartBubbleAdvancedState)? customBuilder;

  /// Custom badge builder
  final Widget Function(BuildContext, int, double)? customBadgeBuilder;

  /// Custom icon builder
  final Widget Function(BuildContext, List<CartItemModel>)? customIconBuilder;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show item count
  final bool showItemCount;

  /// Whether to show total price
  final bool showTotalPrice;

  /// Whether to animate when cart changes
  final bool animateOnChange;

  /// Position of the bubble
  final CartBubblePosition position;

  /// Style of the bubble
  final CartBubbleStyle style;

  /// New theming system style name (material3, glassmorphism, etc.)
  final String? themeStyle;

  @override
  State<CartBubbleAdvanced> createState() => CartBubbleAdvancedState();
}

class CartBubbleAdvancedState extends State<CartBubbleAdvanced>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _badgeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _badgeScaleAnimation;
  late Animation<double> _badgeOpacityAnimation;

  FlexibleWidgetConfig? _config;
  int _previousItemCount = 0;
  double _totalPrice = 0.0;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('cart_bubble', context: context);
    _setupAnimations();
    _calculateTotals();
    _previousItemCount = widget.cartItems.length;
  }

  void _setupAnimations() {
    _bounceController = AnimationController(
      duration: Duration(milliseconds: _getConfig('bounceAnimationDuration', 600)),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: _getConfig('pulseAnimationDuration', 1000)),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: Duration(milliseconds: _getConfig('badgeAnimationDuration', 300)),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: _getConfig('bounceAnimationScale', 1.2),
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: _config?.getCurve('bounceAnimationCurve', Curves.elasticOut) ?? Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: _getConfig('pulseAnimationScale', 1.1),
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _badgeScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: _config?.getCurve('badgeScaleAnimationCurve', Curves.elasticOut) ?? Curves.elasticOut,
    ));

    _badgeOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.easeIn,
    ));

    if (widget.cartItems.isNotEmpty) {
      _badgeController.forward();
    }

    if (_getConfig('enablePulsing', false)) {
      _startPulsing();
    }
  }

  void _startPulsing() {
    _pulseController.repeat(reverse: true);
  }

  void _stopPulsing() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _calculateTotals() {
    _totalPrice = widget.cartItems.fold(0.0, (total, item) {
      return total + (item.pricePerItem * item.quantity);
    });
  }

  void _handleCartChange() {
    final currentItemCount = widget.cartItems.length;
    
    if (widget.animateOnChange && currentItemCount != _previousItemCount) {
      if (currentItemCount > _previousItemCount) {
        // Item added - bounce animation
        if (widget.enableAnimations) {
          _bounceController.forward().then((_) {
            _bounceController.reverse();
          });
        }

        if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
          HapticFeedback.lightImpact();
        }
      }

      // Update badge visibility
      if (currentItemCount > 0 && _previousItemCount == 0) {
        _badgeController.forward();
      } else if (currentItemCount == 0 && _previousItemCount > 0) {
        _badgeController.reverse();
      }
    }

    _previousItemCount = currentItemCount;
    _calculateTotals();
  }

  void _handleTap() {
    if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
      HapticFeedback.lightImpact();
    }

    if (widget.enableAnimations && _getConfig('animateOnTap', true)) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }

    widget.onTap?.call();
  }

  @override
  void didUpdateWidget(CartBubbleAdvanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update config
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('cart_bubble', context: context);
    
    // Handle cart changes
    if (widget.cartItems != oldWidget.cartItems) {
      _handleCartChange();
    }

    // Handle pulsing
    if (_getConfig('enablePulsing', false) && !_pulseController.isAnimating) {
      _startPulsing();
    } else if (!_getConfig('enablePulsing', false) && _pulseController.isAnimating) {
      _stopPulsing();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.cartItems, this);
    }

    final legacyTheme = ShopKitThemeProvider.of(context);
  final useNewTheme = widget.themeStyle != null;
    ShopKitThemeConfig? themeCfg;
    if (useNewTheme) {
      final styleName = widget.themeStyle ?? 'material3';
      final style = ShopKitThemeStyleExtension.fromString(styleName);
      themeCfg = ShopKitThemeConfig.forStyle(style, context);
    }

    return _buildCartBubble(context, legacyTheme, themeCfg);
  }

  Widget _buildCartBubble(BuildContext context, ShopKitTheme theme, ShopKitThemeConfig? themeCfg) {
    Widget bubble = _buildBubbleContent(context, theme);

    // Apply animations
    if (widget.enableAnimations) {
      bubble = AnimatedBuilder(
        animation: Listenable.merge([_bounceController, _pulseController]),
        builder: (context, child) {
          double scale = _bounceAnimation.value;
          if (_pulseController.isAnimating) {
            scale *= _pulseAnimation.value;
          }
          
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: bubble,
      );
    }

    // Apply themed wrapper if new theme in use (e.g., add blur/gradient container)
    if (themeCfg != null) {
      bubble = Container(
        decoration: BoxDecoration(
          color: themeCfg.enableBlur ? (themeCfg.primaryColor ?? theme.primaryColor).withValues(alpha: 0.15) : themeCfg.primaryColor ?? theme.primaryColor,
          gradient: themeCfg.enableGradients
              ? LinearGradient(
                  colors: [
                    (themeCfg.primaryColor ?? theme.primaryColor).withValues(alpha: 0.9),
                    (themeCfg.primaryColor ?? theme.primaryColor).withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(themeCfg.borderRadius),
          boxShadow: themeCfg.enableShadows
              ? [
                  BoxShadow(
                    color: (themeCfg.shadowColor ?? Colors.black).withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(4),
        child: bubble,
      );
    }

    return GestureDetector(
      onTap: _handleTap,
      child: bubble,
    );
  }

  Widget _buildBubbleContent(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case CartBubbleStyle.minimal:
        return _buildMinimalBubble(context, theme);
      case CartBubbleStyle.badge:
        return _buildBadgeBubble(context, theme);
      case CartBubbleStyle.extended:
        return _buildExtendedBubble(context, theme);
      case CartBubbleStyle.fab:
        return _buildFabBubble(context, theme);
      case CartBubbleStyle.floating:
        return _buildFloatingBubble(context, theme);
    }
  }

  Widget _buildFloatingBubble(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: _getConfig('bubbleSize', 56.0),
      height: _getConfig('bubbleSize', 56.0),
      decoration: BoxDecoration(
        color: _config?.getColor('bubbleBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
        shape: _getConfig('bubbleShape', 'circle') == 'circle' ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: _getConfig('bubbleShape', 'circle') == 'circle' 
          ? null 
          : _config?.getBorderRadius('bubbleBorderRadius', BorderRadius.circular(16)) ?? BorderRadius.circular(16),
        boxShadow: _getConfig('enableShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.15)),
                blurRadius: _getConfig('shadowBlurRadius', 12.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 4.0)),
              ),
            ]
          : null,
      ),
      child: Stack(
        children: [
          Center(
            child: widget.customIconBuilder?.call(context, widget.cartItems) ??
              Icon(
                Icons.shopping_cart,
                color: _config?.getColor('iconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                size: _getConfig('iconSize', 24.0),
              ),
          ),
          
          if (widget.showItemCount && widget.cartItems.isNotEmpty)
            _buildBadge(context, theme),
        ],
      ),
    );
  }

  Widget _buildMinimalBubble(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('minimalPadding', 8.0)),
      child: Stack(
        children: [
          widget.customIconBuilder?.call(context, widget.cartItems) ??
            Icon(
              Icons.shopping_cart_outlined,
              color: _config?.getColor('iconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              size: _getConfig('iconSize', 24.0),
            ),
          
          if (widget.showItemCount && widget.cartItems.isNotEmpty)
            _buildBadge(context, theme),
        ],
      ),
    );
  }

  Widget _buildBadgeBubble(BuildContext context, ShopKitTheme theme) {
    return Badge(
      label: Text(
        widget.cartItems.length.toString(),
        style: TextStyle(
          color: _config?.getColor('badgeTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
          fontSize: _getConfig('badgeFontSize', 12.0),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _config?.getColor('badgeBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
      child: widget.customIconBuilder?.call(context, widget.cartItems) ??
        Icon(
          Icons.shopping_cart_outlined,
          color: _config?.getColor('iconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
          size: _getConfig('iconSize', 24.0),
        ),
    );
  }

  Widget _buildExtendedBubble(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('extendedHorizontalPadding', 16.0),
        vertical: _getConfig('extendedVerticalPadding', 12.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('bubbleBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
        borderRadius: _config?.getBorderRadius('bubbleBorderRadius', BorderRadius.circular(24)) ?? BorderRadius.circular(24),
        boxShadow: _getConfig('enableShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.15)),
                blurRadius: _getConfig('shadowBlurRadius', 8.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.customIconBuilder?.call(context, widget.cartItems) ??
            Icon(
              Icons.shopping_cart,
              color: _config?.getColor('iconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
              size: _getConfig('iconSize', 20.0),
            ),
          
          if (widget.showItemCount || widget.showTotalPrice) ...[
            SizedBox(width: _getConfig('extendedContentSpacing', 8.0)),
            
            if (widget.showItemCount)
              Text(
                widget.cartItems.length.toString(),
                style: TextStyle(
                  color: _config?.getColor('textColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                  fontSize: _getConfig('textFontSize', 16.0),
                  fontWeight: _config?.getFontWeight('textFontWeight', FontWeight.w600) ?? FontWeight.w600,
                ),
              ),
            
            if (widget.showTotalPrice) ...[
              if (widget.showItemCount)
                SizedBox(width: _getConfig('priceSpacing', 4.0)),
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _config?.getColor('priceTextColor', theme.onPrimaryColor.withValues(alpha: 0.9)) ?? theme.onPrimaryColor.withValues(alpha: 0.9),
                  fontSize: _getConfig('priceFontSize', 14.0),
                  fontWeight: _config?.getFontWeight('priceFontWeight', FontWeight.w500) ?? FontWeight.w500,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFabBubble(BuildContext context, ShopKitTheme theme) {
    return FloatingActionButton(
      onPressed: _handleTap,
      backgroundColor: _config?.getColor('fabBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
      foregroundColor: _config?.getColor('fabForegroundColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
      elevation: _getConfig('fabElevation', 6.0),
      shape: _getConfig('fabShape', 'circle') == 'circle'
        ? const CircleBorder()
        : RoundedRectangleBorder(
            borderRadius: _config?.getBorderRadius('fabBorderRadius', BorderRadius.circular(16)) ?? BorderRadius.circular(16),
          ),
      child: Stack(
        children: [
          widget.customIconBuilder?.call(context, widget.cartItems) ??
            Icon(
              Icons.shopping_cart,
              size: _getConfig('iconSize', 24.0),
            ),
          
          if (widget.showItemCount && widget.cartItems.isNotEmpty)
            _buildBadge(context, theme),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, ShopKitTheme theme) {
    return Positioned(
      top: _getConfig('badgeTopOffset', 0.0),
      right: _getConfig('badgeRightOffset', 0.0),
      child: AnimatedBuilder(
        animation: _badgeController,
        builder: (context, child) {
          return Transform.scale(
            scale: _badgeScaleAnimation.value,
            child: Opacity(
              opacity: _badgeOpacityAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.customBadgeBuilder?.call(context, widget.cartItems.length, _totalPrice) ??
          Container(
            padding: EdgeInsets.all(_getConfig('badgePadding', 6.0)),
            constraints: BoxConstraints(
              minWidth: _getConfig('badgeMinSize', 20.0),
              minHeight: _getConfig('badgeMinSize', 20.0),
            ),
            decoration: BoxDecoration(
              color: _config?.getColor('badgeBackgroundColor', theme.errorColor) ?? theme.errorColor,
              shape: _getConfig('badgeShape', 'circle') == 'circle' ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: _getConfig('badgeShape', 'circle') == 'circle' 
                ? null 
                : _config?.getBorderRadius('badgeBorderRadius', BorderRadius.circular(10)) ?? BorderRadius.circular(10),
              border: _getConfig('enableBadgeBorder', true)
                ? Border.all(
                    color: _config?.getColor('badgeBorderColor', theme.surfaceColor) ?? theme.surfaceColor,
                    width: _getConfig('badgeBorderWidth', 2.0),
                  )
                : null,
            ),
            child: Center(
              child: Text(
                _formatBadgeText(),
                style: TextStyle(
                  color: _config?.getColor('badgeTextColor', theme.onErrorColor) ?? theme.onErrorColor,
                  fontSize: _getConfig('badgeFontSize', 12.0),
                  fontWeight: _config?.getFontWeight('badgeFontWeight', FontWeight.bold) ?? FontWeight.bold,
                  height: 1.0,
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
    final maxCount = _getConfig('badgeMaxCount', 99);
    
    if (itemCount > maxCount) {
      return '$maxCount+';
    }
    
    return itemCount.toString();
  }

  /// Public API for external control
  int get itemCount => widget.cartItems.length;
  
  double get totalPrice => _totalPrice;
  
  bool get hasItems => widget.cartItems.isNotEmpty;
  
  void triggerBounce() {
    if (widget.enableAnimations) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
  }
  
  void startPulsing() {
    if (widget.enableAnimations) {
      _startPulsing();
    }
  }
  
  void stopPulsing() {
    _stopPulsing();
  }
}

/// Position options for cart bubble
enum CartBubblePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
}

/// Style options for cart bubble
enum CartBubbleStyle {
  floating,
  minimal,
  badge,
  extended,
  fab,
}
