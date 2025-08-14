import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../models/product_model.dart';

/// A comprehensive add to cart button widget with advanced features and unlimited customization
/// Features: Multiple styles, quantity selector, animations, loading states, and extensive theming
// NOTE: This is the new theming-aware implementation. Ultimately we should
// deprecate the legacy cart_management/add_to_cart_button.dart and expose a
// single AddToCartButton API. Temporary name kept unique to avoid export
// collisions – will be renamed to AddToCartButton after migration.
class AddToCartButton extends StatefulWidget {
  const AddToCartButton({
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
    this.themeStyle,
  });

  /// Product to add to cart
  final ProductModel? product;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, AddToCartButtonState)? customBuilder;

  /// Custom icon builder
  final Widget Function(BuildContext, bool isLoading, bool wasAdded)? customIconBuilder;

  /// Custom text builder
  final Widget Function(BuildContext, String text, bool isLoading, bool wasAdded)? customTextBuilder;

  /// Custom quantity selector builder
  final Widget Function(BuildContext, int quantity, AddToCartButtonState)? customQuantityBuilder;

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

  /// Built-in theme style support - pass theme name as string
  final String? themeStyle;

  @override
  State<AddToCartButton> createState() => AddToCartButtonState();
}

class AddToCartButtonState extends State<AddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _successController;
  late AnimationController _loadingController;
  late AnimationController _quantityController;
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
  // Press animation removed for simplification; controller retained for potential external use.

  // Success & loading animations removed; controllers kept for timing (could be re-added later)

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

  // Removed _handleTapDown (unused)

  // Removed unused tap up / cancel handlers

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
  void didUpdateWidget(AddToCartButton oldWidget) {
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

    // Use new theme system if themeStyle is provided
    if (widget.themeStyle != null) {
      return _buildThemedAddToCartButton(context, widget.themeStyle!);
    }

    // Fallback to basic button design
    return _buildBasicAddToCartButton(context);
  }

  /// Built-in theme styling - automatically styles the button based on theme
  Widget _buildThemedAddToCartButton(BuildContext context, String themeStyleString) {
    final themeStyle = ShopKitThemeStyleExtension.fromString(themeStyleString);
    final themeConfig = ShopKitThemeConfig.forStyle(themeStyle, context);
    
    return _buildThemedButton(context, themeConfig, themeStyle);
  }

  Widget _buildThemedButton(BuildContext context, ShopKitThemeConfig themeConfig, ShopKitThemeStyle themeStyle) {
    final buttonText = widget.text ?? 'Add to Cart';
    
    Widget button;
    
    switch (themeStyle) {
      case ShopKitThemeStyle.material3:
        button = _buildMaterial3Button(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.materialYou:
        button = _buildMaterialYouButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.neumorphism:
        button = _buildNeumorphicButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.glassmorphism:
        button = _buildGlassmorphicButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.cupertino:
        button = _buildCupertinoButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.minimal:
        button = _buildMinimalButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.retro:
        button = _buildRetroButton(context, themeConfig, buttonText);
        break;
      case ShopKitThemeStyle.neon:
        button = _buildNeonButton(context, themeConfig, buttonText);
        break;
    }

    return button;
  }

  Widget _buildMaterial3Button(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return SizedBox(
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: widget.isEnabled ? _handleButtonPress : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeConfig.primaryColor,
          foregroundColor: themeConfig.onPrimaryColor,
          elevation: themeConfig.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: _getVerticalPadding(),
          ),
        ),
        child: _buildButtonContent(context, themeConfig, text),
      ),
    );
  }

  Widget _buildMaterialYouButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeConfig.primaryColor!,
            themeConfig.primaryColor!.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: themeConfig.primaryColor!.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400,
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: _getButtonHeight(),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(themeConfig.borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isEnabled ? _handleButtonPress : null,
              borderRadius: BorderRadius.circular(themeConfig.borderRadius),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getHorizontalPadding(),
                  vertical: _getVerticalPadding(),
                ),
                child: _buildButtonContent(context, themeConfig, text),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: themeConfig.primaryColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        border: Border.all(color: themeConfig.primaryColor!),
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildRetroButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: themeConfig.primaryColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        border: Border.all(color: Colors.black87, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Container(
      height: _getButtonHeight(),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        border: Border.all(color: Colors.cyan, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? _handleButtonPress : null,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
            child: _buildButtonContent(context, themeConfig, text),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, ShopKitThemeConfig themeConfig, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.showIcon && widget.icon != null) ...[
          Icon(
            widget.icon,
            size: _getIconSize(),
            color: themeConfig.onPrimaryColor,
          ),
          if (widget.showText) SizedBox(width: 8.w),
        ],
        if (widget.showText)
          Text(
            text,
            style: TextStyle(
              color: themeConfig.onPrimaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  void _handleButtonPress() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
    if (widget.onAddToCart != null && widget.product != null) {
      try {
        // Prefer 2-arg signature (product, quantity). If callback only accepts one,
        // a runtime error would occur; guard via Function.apply introspection not available in Flutter web,
        // so we optimistically call with both then fall back.
        widget.onAddToCart!(widget.product!, _currentQuantity);
      } catch (_) {
        // Fallback to legacy single argument signature.
        // ignore: deprecated_member_use_from_same_package
        // ignore: avoid_dynamic_calls
        // dynamic invocation with one arg
        // Using dynamic cast to silence analyzer for legacy projects.
        (widget.onAddToCart as dynamic).call(widget.product!);
      }
    }
  }

  Widget _buildBasicAddToCartButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.above)
          _buildBasicQuantitySelector(context),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.above)
          SizedBox(height: 8.0.h),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.inline)
              _buildBasicQuantitySelector(context),
            
            if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.inline)
              SizedBox(width: 8.0.w),
            
            Flexible(child: _buildBasicButton(context)),
          ],
        ),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.below)
          SizedBox(height: 8.0.h),
        
        if (widget.showQuantitySelector && widget.quantityStyle == QuantitySelectorStyle.below)
          _buildBasicQuantitySelector(context),
      ],
    );
  }

  Widget _buildBasicButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? _handleTap : null,
      child: Container(
        height: _getButtonHeight(),
        padding: EdgeInsets.symmetric(
          horizontal: _getHorizontalPadding(),
          vertical: _getVerticalPadding(),
        ),
        decoration: BoxDecoration(
          color: widget.isEnabled 
            ? (_wasAdded ? Colors.green : Theme.of(context).primaryColor)
            : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showIcon && widget.isLoading)
              SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else if (widget.showIcon)
              Icon(
                _wasAdded ? Icons.check : (widget.icon ?? Icons.add_shopping_cart),
                size: _getIconSize(),
                color: Colors.white,
              ),
            
            if (widget.showIcon && widget.showText)
              SizedBox(width: 8.0.w),
            
            if (widget.showText && widget.style != AddToCartButtonStyle.icon)
              Text(
                _getButtonText(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: _getTextSize(),
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicQuantitySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _currentQuantity > widget.minQuantity
              ? () => _updateQuantity(_currentQuantity - 1)
              : null,
            child: Container(
              width: 32.0.w,
              height: 32.0.h,
              decoration: BoxDecoration(
                color: _currentQuantity > widget.minQuantity 
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Icon(
                Icons.remove,
                size: 16.0.sp,
                color: _currentQuantity > widget.minQuantity 
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              ),
            ),
          ),
          
          Container(
            width: 40.0.w,
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Text(
              _currentQuantity.toString(),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          GestureDetector(
            onTap: _currentQuantity < widget.maxQuantity
              ? () => _updateQuantity(_currentQuantity + 1)
              : null,
            child: Container(
              width: 32.0.w,
              height: 32.0.h,
              decoration: BoxDecoration(
                color: _currentQuantity < widget.maxQuantity 
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Icon(
                Icons.add,
                size: 16.0.sp,
                color: _currentQuantity < widget.maxQuantity 
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Press animation wrapper removed (handled directly where needed)

  // Helper methods
  double _getButtonHeight() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonHeight', 32.0.h);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonHeight', 56.0.h);
  case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonHeight', 44.0.h);
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonHorizontalPadding', 12.0.w);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonHorizontalPadding', 24.0.w);
  case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonHorizontalPadding', 16.0.w);
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonVerticalPadding', 6.0.h);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonVerticalPadding', 12.0.h);
  case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonVerticalPadding', 8.0.h);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AddToCartButtonSize.small:
        return _getConfig('smallButtonIconSize', 16.0.sp);
      case AddToCartButtonSize.large:
        return _getConfig('largeButtonIconSize', 24.0.sp);
  case AddToCartButtonSize.medium:
        return _getConfig('mediumButtonIconSize', 20.0.sp);
    }
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

/// Public API alias. Use AddToCartButton going forward.

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
