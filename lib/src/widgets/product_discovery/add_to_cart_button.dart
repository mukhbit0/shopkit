import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../models/product_model.dart';

/// A comprehensive add to cart button widget with advanced features and unlimited customization
/// Features: Multiple styles, quantity selector, animations, loading states, and extensive theming
class AddToCartButtonNew extends StatefulWidget {
  const AddToCartButtonNew({
    super.key,
    this.product,
    this.config,
    this.customBuilder,
    this.customIconBuilder,
    this.customTextBuilder,
    this.customQuantityBuilder,
    this.onAddToCart,
    this.onQuantityChanged,
    this.onPressed,
    this.text,
    this.icon,
    this.quantity = 1,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.isLoading = false,
    this.isEnabled = true,
    this.showQuantitySelector = false,
    this.showIcon = true,
    this.showText = true,
    this.showSuccessAnimation = true,
    this.enableHaptics = true,
    this.enableAnimations = true,
    this.style = AddToCartButtonStyle.filled,
    this.size = AddToCartButtonSize.medium,
    this.quantityStyle = QuantitySelectorStyle.inline,
    this.animationType = AddToCartAnimationType.scale,
  });

  /// Product to add to cart
  final ProductModel? product;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, AddToCartButtonNewState)? customBuilder;

  /// Custom icon builder
  final Widget Function(BuildContext, bool isLoading, bool wasAdded)? customIconBuilder;

  /// Custom text builder
  final Widget Function(BuildContext, String text, bool isLoading, bool wasAdded)? customTextBuilder;

  /// Custom quantity selector builder
  final Widget Function(BuildContext, int quantity, AddToCartButtonNewState)? customQuantityBuilder;

  /// Callback when product is added to cart
  final Function(ProductModel? product, int quantity)? onAddToCart;

  /// Callback when quantity changes
  final Function(int newQuantity)? onQuantityChanged;

  /// General press callback
  final VoidCallback? onPressed;

  /// Button text
  final String? text;

  /// Button icon
  final IconData? icon;

  /// Current quantity
  final int quantity;

  /// Minimum quantity
  final int minQuantity;

  /// Maximum quantity
  final int maxQuantity;

  /// Whether button is in loading state
  final bool isLoading;

  /// Whether button is enabled
  final bool isEnabled;

  /// Whether to show quantity selector
  final bool showQuantitySelector;

  /// Whether to show icon
  final bool showIcon;

  /// Whether to show text
  final bool showText;

  /// Whether to show success animation
  final bool showSuccessAnimation;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Style of the button
  final AddToCartButtonStyle style;

  /// Size of the button
  final AddToCartButtonSize size;

  /// Style of quantity selector
  final QuantitySelectorStyle quantityStyle;

  /// Animation type
  final AddToCartAnimationType animationType;

  @override
  State<AddToCartButtonNew> createState() => AddToCartButtonNewState();
}

class AddToCartButtonNewState extends State<AddToCartButtonNew>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _successController;
  late AnimationController _loadingController;
  late AnimationController _quantityController;
  late Animation<double> _pressAnimation;
  late Animation<double> _successAnimation;
  late Animation<double> _loadingAnimation;
  // late Animation<double> _quantityAnimation; // Unused - commented out

  FlexibleWidgetConfig? _config;
  int _currentQuantity = 1;
  bool _wasAdded = false;
  bool _isPressed = false;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('add_to_cart_button', context: context);
    _currentQuantity = widget.quantity;
    
    _setupControllers();
    _setupAnimations();
  }

  void _setupControllers() {
    _pressController = AnimationController(
      duration: Duration(milliseconds: _getConfig('pressAnimationDuration', 100)),
      vsync: this,
    );

    _successController = AnimationController(
      duration: Duration(milliseconds: _getConfig('successAnimationDuration', 600)),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: Duration(milliseconds: _getConfig('loadingAnimationDuration', 1000)),
      vsync: this,
    );

    _quantityController = AnimationController(
      duration: Duration(milliseconds: _getConfig('quantityAnimationDuration', 200)),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: _getConfig('pressScaleValue', 0.95),
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: _config?.getCurve('pressAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: _config?.getCurve('successAnimationCurve', Curves.elasticOut) ?? Curves.elasticOut,
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));

    // _quantityAnimation = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(CurvedAnimation(
    //   parent: _quantityController,
    //   curve: _config?.getCurve('quantityAnimationCurve', Curves.elasticOut) ?? Curves.elasticOut,
    // )); // Unused - commented out

    if (widget.isLoading && widget.enableAnimations) {
      _loadingController.repeat();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled || widget.isLoading) return;
    
    setState(() {
      _isPressed = true;
    });

    if (widget.enableAnimations) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled || widget.isLoading) return;
    
    setState(() {
      _isPressed = false;
    });

    if (widget.enableAnimations) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isEnabled || widget.isLoading) return;
    
    setState(() {
      _isPressed = false;
    });

    if (widget.enableAnimations) {
      _pressController.reverse();
    }
  }

  void _handleTap() {
    if (!widget.isEnabled || widget.isLoading) return;

    if (widget.enableHaptics && _getConfig('enableTapHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    // Trigger add to cart
    widget.onAddToCart?.call(widget.product, _currentQuantity);
    widget.onPressed?.call();

    // Show success animation
    if (widget.showSuccessAnimation && widget.enableAnimations) {
      _showSuccessAnimation();
    }
  }

  void _showSuccessAnimation() {
    setState(() {
      _wasAdded = true;
    });

    _successController.forward().then((_) {
      Future.delayed(Duration(milliseconds: _getConfig('successDisplayDuration', 1500)), () {
        if (mounted) {
          setState(() {
            _wasAdded = false;
          });
          _successController.reverse();
        }
      });
    });
  }

  void _updateQuantity(int newQuantity) {
    final clampedQuantity = newQuantity.clamp(widget.minQuantity, widget.maxQuantity);
    
    if (clampedQuantity != _currentQuantity) {
      setState(() {
        _currentQuantity = clampedQuantity;
      });

      widget.onQuantityChanged?.call(_currentQuantity);

      if (widget.enableAnimations && widget.enableHaptics) {
        HapticFeedback.lightImpact();
      }

      if (widget.enableAnimations) {
        _quantityController.forward().then((_) {
          _quantityController.reverse();
        });
      }
    }
  }

  @override
  void didUpdateWidget(AddToCartButtonNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.quantity != oldWidget.quantity) {
      _currentQuantity = widget.quantity;
    }
    
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading && widget.enableAnimations) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _successController.dispose();
    _loadingController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    return _buildAddToCartButton(context, theme);
  }

  Widget _buildAddToCartButton(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.above)
          _buildQuantitySelector(context, theme),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.above)
          SizedBox(height: _getConfig('quantitySelectorSpacing', 8.0)),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.inline)
              _buildQuantitySelector(context, theme),
            
            if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.inline)
              SizedBox(width: _getConfig('quantitySelectorSpacing', 8.0)),
            
            Flexible(child: _buildButton(context, theme)),
          ],
        ),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.below)
          SizedBox(height: _getConfig('quantitySelectorSpacing', 8.0)),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.below)
          _buildQuantitySelector(context, theme),
      ],
    );
  }

  Widget _buildButton(BuildContext context, ShopKitTheme theme) {
    Widget button = _buildButtonContent(context, theme);

    // Apply animations
    if (widget.enableAnimations) {
      button = _applyAnimations(button);
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: button,
    );
  }

  Widget _buildButtonContent(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case AddToCartButtonStyle.outlined:
        return _buildOutlinedButton(context, theme);
      case AddToCartButtonStyle.text:
        return _buildTextButton(context, theme);
      case AddToCartButtonStyle.icon:
        return _buildIconButton(context, theme);
      case AddToCartButtonStyle.floating:
        return _buildFloatingButton(context, theme);
      case AddToCartButtonStyle.filled:
        return _buildFilledButton(context, theme);
    }
  }

  Widget _buildFilledButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: _getButtonColor(theme),
        borderRadius: _config?.getBorderRadius('buttonBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        boxShadow: _getConfig('showButtonShadow', true) && !widget.isLoading
          ? [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: _getConfig('buttonShadowOpacity', 0.3)),
                blurRadius: _getConfig('buttonShadowBlur', 8.0),
                offset: Offset(0, _getConfig('buttonShadowOffset', 2.0)),
              ),
            ]
          : null,
      ),
      child: _buildButtonChild(context, theme),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: _wasAdded 
          ? _getSuccessColor(theme) 
          : _getConfig('outlinedButtonBackgroundColor', Colors.transparent),
        border: Border.all(
          color: _getButtonColor(theme),
          width: _getConfig('outlinedButtonBorderWidth', 2.0),
        ),
        borderRadius: _config?.getBorderRadius('buttonBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
      ),
      child: _buildButtonChild(context, theme),
    );
  }

  Widget _buildTextButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getButtonHeight(),
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      child: _buildButtonChild(context, theme),
    );
  }

  Widget _buildIconButton(BuildContext context, ShopKitTheme theme) {
    final size = _getButtonHeight();
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getButtonColor(theme),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: _getConfig('showButtonShadow', true) && !widget.isLoading
          ? [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: _getConfig('buttonShadowOpacity', 0.3)),
                blurRadius: _getConfig('buttonShadowBlur', 8.0),
                offset: Offset(0, _getConfig('buttonShadowOffset', 2.0)),
              ),
            ]
          : null,
      ),
      child: Center(
        child: _buildIcon(context, theme),
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context, ShopKitTheme theme) {
    final size = _getButtonHeight();
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getButtonColor(theme),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: theme.onSurfaceColor.withValues(alpha: _getConfig('floatingButtonShadowOpacity', 0.2)),
            blurRadius: _getConfig('floatingButtonShadowBlur', 12.0),
            offset: Offset(0, _getConfig('floatingButtonShadowOffset', 4.0)),
          ),
        ],
      ),
      child: Center(
        child: _buildIcon(context, theme),
      ),
    );
  }

  Widget _buildButtonChild(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showIcon && (widget.showText || widget.style == AddToCartButtonStyle.icon))
            _buildIcon(context, theme),
          
          if (widget.showIcon && widget.showText)
            SizedBox(width: _getConfig('iconTextSpacing', 8.0)),
          
          if (widget.showText && widget.style != AddToCartButtonStyle.icon)
            Flexible(child: _buildText(context, theme)),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ShopKitTheme theme) {
    if (widget.customIconBuilder != null) {
      return widget.customIconBuilder!(context, widget.isLoading, _wasAdded);
    }

    if (widget.isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: _getConfig('loadingIndicatorStrokeWidth', 2.0),
          valueColor: AlwaysStoppedAnimation<Color>(_getIconColor(theme)),
        ),
      );
    }

    if (_wasAdded) {
      return Icon(
        _getConfig('successIcon', Icons.check),
        size: _getIconSize(),
        color: _getIconColor(theme),
      );
    }

    return Icon(
      widget.icon ?? _getConfig('defaultIcon', Icons.add_shopping_cart),
      size: _getIconSize(),
      color: _getIconColor(theme),
    );
  }

  Widget _buildText(BuildContext context, ShopKitTheme theme) {
    if (widget.customTextBuilder != null) {
      return widget.customTextBuilder!(context, _getButtonText(), widget.isLoading, _wasAdded);
    }

    return Text(
      _getButtonText(),
      style: _getTextStyle(theme),
      textAlign: TextAlign.center,
      maxLines: _getConfig('textMaxLines', 1),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildQuantitySelector(BuildContext context, ShopKitTheme theme) {
    if (widget.customQuantityBuilder != null) {
      return widget.customQuantityBuilder!(context, _currentQuantity, this);
    }

    return Container(
      decoration: BoxDecoration(
        color: _config?.getColor('quantitySelectorBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        border: Border.all(
          color: _config?.getColor('quantitySelectorBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
        ),
        borderRadius: _config?.getBorderRadius('quantitySelectorBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            context,
            theme,
            icon: Icons.remove,
            onPressed: _currentQuantity > widget.minQuantity
              ? () => _updateQuantity(_currentQuantity - 1)
              : null,
          ),
          
          Container(
            width: _getConfig('quantityDisplayWidth', 40.0),
            padding: EdgeInsets.symmetric(vertical: _getConfig('quantityDisplayPadding', 8.0)),
            child: Text(
              _currentQuantity.toString(),
              style: TextStyle(
                color: theme.onSurfaceColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          _buildQuantityButton(
            context,
            theme,
            icon: Icons.add,
            onPressed: _currentQuantity < widget.maxQuantity
              ? () => _updateQuantity(_currentQuantity + 1)
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    ShopKitTheme theme, {
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: _getConfig('quantityButtonSize', 32.0),
        height: _getConfig('quantityButtonSize', 32.0),
        decoration: BoxDecoration(
          color: onPressed != null 
            ? _config?.getColor('quantityButtonColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(_getConfig('quantityButtonBorderRadius', 4.0)),
        ),
        child: Icon(
          icon,
          size: _getConfig('quantityButtonIconSize', 16.0),
          color: onPressed != null 
            ? _config?.getColor('quantityButtonIconColor', theme.primaryColor) ?? theme.primaryColor
            : theme.onSurfaceColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _applyAnimations(Widget child) {
    switch (widget.animationType) {
      case AddToCartAnimationType.bounce:
        return AnimatedBuilder(
          animation: _successController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_successAnimation.value * 0.1),
              child: child,
            );
          },
          child: _applyPressAnimation(child),
        );
        
      case AddToCartAnimationType.pulse:
        return AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isLoading ? 1.0 + ((_loadingAnimation.value * 2 - 1).abs() * 0.05) : 1.0,
              child: child,
            );
          },
          child: _applyPressAnimation(child),
        );
        
      case AddToCartAnimationType.scale:
      default:
        return _applyPressAnimation(child);
    }
  }

  Widget _applyPressAnimation(Widget child) {
    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Helper methods
  double _getButtonHeight() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonHeight', 32.0);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonHeight', 56.0);
      case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonHeight', 44.0);
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonHorizontalPadding', 12.0);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonHorizontalPadding', 24.0);
      case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonHorizontalPadding', 16.0);
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonVerticalPadding', 6.0);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonVerticalPadding', 12.0);
      case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonVerticalPadding', 8.0);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonIconSize', 16.0);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonIconSize', 24.0);
      case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonIconSize', 20.0);
    }
  }

  Color _getButtonColor(ShopKitTheme theme) {
    if (!widget.isEnabled) {
      return _config?.getColor('disabledButtonColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3);
    }

    if (_wasAdded) {
      return _getSuccessColor(theme);
    }

    if (widget.style == AddToCartButtonStyle.text) {
      return Colors.transparent;
    }

    return _config?.getColor('buttonColor', theme.primaryColor) ?? theme.primaryColor;
  }

  Color _getIconColor(ShopKitTheme theme) {
    if (!widget.isEnabled) {
      return _config?.getColor('disabledIconColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5);
    }

    if (widget.style == AddToCartButtonStyle.text || widget.style == AddToCartButtonStyle.outlined) {
      return _config?.getColor('iconColor', theme.primaryColor) ?? theme.primaryColor;
    }

    return _config?.getColor('iconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor;
  }

  Color _getSuccessColor(ShopKitTheme theme) {
    return _config?.getColor('successColor', Colors.green) ?? Colors.green;
  }

  String _getButtonText() {
    if (widget.isLoading) {
      return _getConfig('loadingText', 'Adding...');
    }

    if (_wasAdded) {
      return _getConfig('successText', 'Added!');
    }

    return widget.text ?? _getConfig('defaultText', 'Add to Cart');
  }

  TextStyle _getTextStyle(ShopKitTheme theme) {
    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: _getTextSize(),
    );

    Color textColor;
    if (!widget.isEnabled) {
      textColor = _config?.getColor('disabledTextColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5);
    } else if (widget.style == AddToCartButtonStyle.text || widget.style == AddToCartButtonStyle.outlined) {
      textColor = _config?.getColor('textColor', theme.primaryColor) ?? theme.primaryColor;
    } else {
      textColor = _config?.getColor('textColor', theme.onPrimaryColor) ?? theme.onPrimaryColor;
    }

    return baseStyle?.copyWith(color: textColor) ?? TextStyle(color: textColor);
  }

  double _getTextSize() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonTextSize', 12.0);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonTextSize', 16.0);
      case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonTextSize', 14.0);
    }
  }

  /// Public API for external control
  int get currentQuantity => _currentQuantity;
  
  bool get wasAdded => _wasAdded;
  
  bool get isPressed => _isPressed;
  
  void setQuantity(int quantity) {
    _updateQuantity(quantity);
  }
  
  void incrementQuantity() {
    _updateQuantity(_currentQuantity + 1);
  }
  
  void decrementQuantity() {
    _updateQuantity(_currentQuantity - 1);
  }
  
  void triggerPress() {
    _handleTap();
  }
  
  void triggerSuccessAnimation() {
    if (widget.showSuccessAnimation && widget.enableAnimations) {
      _showSuccessAnimation();
    }
  }
  
  void resetState() {
    setState(() {
      _wasAdded = false;
      _isPressed = false;
      _currentQuantity = widget.quantity;
    });
    
    if (widget.enableAnimations) {
      _successController.reset();
      _pressController.reset();
      _quantityController.reset();
    }
  }
}

/// Style options for add to cart button
enum AddToCartButtonStyle {
  filled,
  outlined,
  text,
  icon,
  floating,
}

/// Size options for add to cart button
enum AddToCartButtonSize {
  small,
  medium,
  large,
}

/// Style options for quantity selector
enum QuantitySelectorStyle {
  inline,
  above,
  below,
}

/// Animation type options
enum AddToCartAnimationType {
  none,
  scale,
  bounce,
  pulse,
}
