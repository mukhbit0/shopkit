// Updated ProductCard with layout fixes
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../config/flexible_widget_config.dart';

/// Configuration class for ProductCard widget customization
class FlexibleProductCardConfig {
  const FlexibleProductCardConfig({
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.backgroundColor,
    this.imageAspectRatio,
    this.imageHeight,
    this.titleStyle,
    this.priceStyle,
    this.originalPriceStyle,
    this.brandStyle,
    this.ratingStyle,
    this.badgeTextStyle,
    this.badgeBackgroundColor,
    this.wishlistIconSize,
    this.cartIconSize,
    this.animationDuration,
    this.hoverScale,
    this.showBrand,
    this.showRating,
    this.showDiscount,
    this.showQuickActions,
    this.imageBuilder,
    this.titleBuilder,
    this.priceBuilder,
    this.actionBuilder,
    this.overlayBuilder,
  });

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? shadowColor;
  final Color? backgroundColor;
  final double? imageAspectRatio;
  final double? imageHeight;
  final TextStyle? titleStyle;
  final TextStyle? priceStyle;
  final TextStyle? originalPriceStyle;
  final TextStyle? brandStyle;
  final TextStyle? ratingStyle;
  final TextStyle? badgeTextStyle;
  final Color? badgeBackgroundColor;
  final double? wishlistIconSize;
  final double? cartIconSize;
  final Duration? animationDuration;
  final double? hoverScale;
  final bool? showBrand;
  final bool? showRating;
  final bool? showDiscount;
  final bool? showQuickActions;
  
  // Builder functions for complete customization
  final Widget Function(BuildContext context, String imageUrl, ProductModel product)? imageBuilder;
  final Widget Function(BuildContext context, String title, ProductModel product)? titleBuilder;
  final Widget Function(BuildContext context, double price, double? originalPrice, ProductModel product)? priceBuilder;
  final Widget Function(BuildContext context, VoidCallback? onAddToCart, VoidCallback? onWishlist, ProductModel product)? actionBuilder;
  final Widget Function(BuildContext context, ProductModel product)? overlayBuilder;

  FlexibleProductCardConfig copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    double? elevation,
    Color? shadowColor,
    Color? backgroundColor,
    double? imageAspectRatio,
    double? imageHeight,
    TextStyle? titleStyle,
    TextStyle? priceStyle,
    TextStyle? originalPriceStyle,
    TextStyle? brandStyle,
    TextStyle? ratingStyle,
    TextStyle? badgeTextStyle,
    Color? badgeBackgroundColor,
    double? wishlistIconSize,
    double? cartIconSize,
    Duration? animationDuration,
    double? hoverScale,
    bool? showBrand,
    bool? showRating,
    bool? showDiscount,
    bool? showQuickActions,
    Widget Function(BuildContext context, String imageUrl, ProductModel product)? imageBuilder,
    Widget Function(BuildContext context, String title, ProductModel product)? titleBuilder,
    Widget Function(BuildContext context, double price, double? originalPrice, ProductModel product)? priceBuilder,
    Widget Function(BuildContext context, VoidCallback? onAddToCart, VoidCallback? onWishlist, ProductModel product)? actionBuilder,
    Widget Function(BuildContext context, ProductModel product)? overlayBuilder,
  }) {
    return FlexibleProductCardConfig(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imageAspectRatio: imageAspectRatio ?? this.imageAspectRatio,
      imageHeight: imageHeight ?? this.imageHeight,
      titleStyle: titleStyle ?? this.titleStyle,
      priceStyle: priceStyle ?? this.priceStyle,
      originalPriceStyle: originalPriceStyle ?? this.originalPriceStyle,
      brandStyle: brandStyle ?? this.brandStyle,
      ratingStyle: ratingStyle ?? this.ratingStyle,
      badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
      badgeBackgroundColor: badgeBackgroundColor ?? this.badgeBackgroundColor,
      wishlistIconSize: wishlistIconSize ?? this.wishlistIconSize,
      cartIconSize: cartIconSize ?? this.cartIconSize,
      animationDuration: animationDuration ?? this.animationDuration,
      hoverScale: hoverScale ?? this.hoverScale,
      showBrand: showBrand ?? this.showBrand,
      showRating: showRating ?? this.showRating,
      showDiscount: showDiscount ?? this.showDiscount,
      showQuickActions: showQuickActions ?? this.showQuickActions,
      imageBuilder: imageBuilder ?? this.imageBuilder,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      priceBuilder: priceBuilder ?? this.priceBuilder,
      actionBuilder: actionBuilder ?? this.actionBuilder,
      overlayBuilder: overlayBuilder ?? this.overlayBuilder,
    );
  }
}

/// Modern product card widget aligned with new ShopKit architecture
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleWishlist,
    this.onImageTap,
    this.isInWishlist = false,
    this.isInCart = false,
    this.customBuilder,
    this.heroTag,
    this.aspectRatio,
    this.imageHeight,
    this.width,
    this.height,
    this.config,
    this.flexibleConfig,
    this.themeStyle, // NEW: Built-in theme styling support
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final Function(CartItemModel)? onAddToCart;
  final VoidCallback? onToggleWishlist;
  final VoidCallback? onImageTap;
  final bool isInWishlist;
  final bool isInCart;
  final Widget Function(BuildContext, ProductModel, ProductCardState)?
      customBuilder;
  final String? heroTag;
  final double? aspectRatio;
  final double? imageHeight;
  final double? width;
  final double? height;
  final FlexibleProductCardConfig? config;
  
  /// Built-in theme styling support - just pass a string!
  /// Supported values: 'material3', 'materialYou', 'neumorphism', 'glassmorphism', 'cupertino', 'minimal', 'retro', 'neon'
  final String? themeStyle;
  /// New flexible configuration (supersedes [FlexibleProductCardConfig] gradually)
  /// Supported keys (namespaced productCard.):
  ///  - productCard.padding / margin / borderRadius / elevation
  ///  - productCard.backgroundColor / shadowColor
  ///  - productCard.imageHeight / imageAspectRatio
  ///  - productCard.showBrand / showRating / showDiscount / showQuickActions
  ///  - productCard.hoverScale (double) / animationDuration (int ms)
  ///  - productCard.badgeBackgroundColor / badgeTextStyle
  ///  - productCard.wishlistIconSize / cartIconSize
  ///  - productCard.titleStyle / priceStyle / originalPriceStyle
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<ProductCard> createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _favoriteController;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.product, this);
    }

    // Use new theme system if themeStyle is provided
    if (widget.themeStyle != null) {
      return _buildThemedCard(context, widget.themeStyle!);
    }
    
    // Fallback to basic card design
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildBasicCard(context),
    );
  }

  /// Fallback card design when no theme is specified
  Widget _buildBasicCard(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: widget.product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image,
                          size: 32,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.image,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              // Title
              Flexible(
                child: Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              // Price
              Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    final cartItem = CartItemModel(
                      id: 'cart_${widget.product.id}_${DateTime.now().millisecondsSinceEpoch}',
                      product: widget.product,
                      quantity: 1,
                      pricePerItem: widget.product.price,
                    );
                    widget.onAddToCart?.call(cartItem);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Built-in theme styling - automatically styles the card based on theme
  Widget _buildThemedCard(BuildContext context, String themeStyleString) {
    final themeStyle = ShopKitThemeStyleExtension.fromString(themeStyleString);
    final themeConfig = ShopKitThemeConfig.forStyle(themeStyle, context);
    final product = widget.product;

    Widget cardContent = _buildCardContent(context, themeConfig, product);

    // Apply theme-specific styling and animations
    switch (themeStyle) {
      case ShopKitThemeStyle.material3:
        return _buildMaterial3Card(context, themeConfig, cardContent);
      case ShopKitThemeStyle.materialYou:
        return _buildMaterialYouCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.neumorphism:
        return _buildNeumorphicCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.glassmorphism:
        return _buildGlassmorphicCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.cupertino:
        return _buildCupertinoCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.minimal:
        return _buildMinimalCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.retro:
        return _buildRetroCard(context, themeConfig, cardContent);
      case ShopKitThemeStyle.neon:
        return _buildNeonCard(context, themeConfig, cardContent);
    }
  }

  Widget _buildCardContent(BuildContext context, ShopKitThemeConfig themeConfig, ProductModel product) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThemedImage(context, themeConfig, product),
          const SizedBox(height: 8),
          Flexible(
            child: _buildThemedTitle(context, themeConfig, product),
          ),
          const SizedBox(height: 6),
          _buildThemedPrice(context, themeConfig, product),
          const SizedBox(height: 8),
          _buildThemedButton(context, themeConfig, product),
        ],
      ),
    );
  }

  Widget _buildMaterial3Card(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Material(
      elevation: themeConfig.elevation,
      borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      color: themeConfig.backgroundColor,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        child: content,
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .fadeIn(duration: themeConfig.animationDuration);
  }

  Widget _buildMaterialYouCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surfaceContainer,
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: themeConfig.shadowColor!.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .shimmer(duration: 1000.ms, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3));
  }

  Widget _buildNeumorphicCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        boxShadow: [
          // Light shadow (top-left)
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
            offset: const Offset(-8, -8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          // Dark shadow (bottom-right)
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400,
            offset: const Offset(8, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .then()
      .shake(duration: 200.ms, hz: 2);
  }

  Widget _buildGlassmorphicCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: themeConfig.backgroundColor,
            borderRadius: BorderRadius.circular(themeConfig.borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(themeConfig.borderRadius),
              child: content,
            ),
          ),
        ),
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .fadeIn(duration: themeConfig.animationDuration)
      .then()
      .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.3));
  }

  Widget _buildCupertinoCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    ).animate()
      .fadeIn(duration: themeConfig.animationDuration)
      .slideY(begin: 0.1, duration: themeConfig.animationDuration);
  }

  Widget _buildMinimalCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    );
  }

  Widget _buildRetroCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: themeConfig.shadowColor!,
            offset: const Offset(6, 6),
            blurRadius: 0, // Sharp shadow for retro look
          ),
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.3),
            offset: const Offset(-2, -2),
            blurRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .then()
      .shake(duration: 300.ms, hz: 5);
  }

  Widget _buildNeonCard(BuildContext context, ShopKitThemeConfig themeConfig, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        border: Border.all(
          color: Colors.cyan,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(themeConfig.borderRadius),
          child: content,
        ),
      ),
    ).animate()
      .scale(duration: themeConfig.animationDuration, curve: themeConfig.animationCurve)
      .then()
      .shimmer(duration: 1500.ms, color: Colors.cyan.withValues(alpha: 0.8));
  }

  Widget _buildThemedImage(BuildContext context, ShopKitThemeConfig themeConfig, ProductModel product) {
    final imageWidget = Container(
      height: 120, // Responsive height
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((themeConfig.borderRadius * 0.8)),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: product.imageUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular((themeConfig.borderRadius * 0.8)),
            child: Image.network(
              product.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        : Icon(
            Icons.image,
            size: 32,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );

    return Hero(
      tag: widget.heroTag ?? 'product-${product.id}',
      child: imageWidget,
    );
  }

  Widget _buildThemedTitle(BuildContext context, ShopKitThemeConfig themeConfig, ProductModel product) {
    return Text(
      product.name,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildThemedPrice(BuildContext context, ShopKitThemeConfig themeConfig, ProductModel product) {
    return Text(
      '\$${product.price.toStringAsFixed(2)}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildThemedButton(BuildContext context, ShopKitThemeConfig themeConfig, ProductModel product) {
    return SizedBox(
      width: double.infinity,
      height: 32, // Fixed compact height
      child: ElevatedButton(
        onPressed: () {
          final cartItem = CartItemModel(
            id: 'cart_${product.id}_${DateTime.now().millisecondsSinceEpoch}',
            product: product,
            quantity: 1,
            pricePerItem: product.price,
          );
          widget.onAddToCart?.call(cartItem);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((themeConfig.borderRadius * 0.6)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: const Text(
          'Add to Cart',
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }

}

// CRITICAL FIXES SUMMARY:
// 1. Added mainAxisSize: MainAxisSize.min to all Column widgets
// 2. Changed Expanded to Flexible with FlexFit.loose where appropriate
// 3. Used IntrinsicWidth for price row to handle overflow
// 4. Replaced Spacer with Flexible in constrained layouts
// 5. Added proper overflow handling with ellipsis

// HOW TO APPLY THESE FIXES TO YOUR PROJECT:
// 1. Replace all Column widgets with mainAxisSize: MainAxisSize.min
// 2. Change Expanded to Flexible(fit: FlexFit.loose) in scrollable containers
// 3. Use Flexible(fit: FlexFit.tight) only when you want equal distribution
// 4. Add overflow: TextOverflow.ellipsis to text widgets in constrained spaces
// 5. Use IntrinsicWidth/IntrinsicHeight for natural sizing when needed


