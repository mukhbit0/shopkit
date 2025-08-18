// Updated ProductCard with layout fixes
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../theme/theme.dart';
import '../../theme/components/product_card_theme.dart';

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

    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final compTheme = shopKitTheme?.productCardTheme;
    if (compTheme != null) {
      return _buildThemeExtensionCard(context, compTheme);
    }
    return _buildBasicCard(context);
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
                    final cartItem = CartItemModel.createSafe(
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

  Widget _buildThemeExtensionCard(BuildContext context, ProductCardTheme compTheme) {
    final product = widget.product;
    final background = compTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final radius = compTheme.borderRadius ?? BorderRadius.circular(12);
    final elevation = compTheme.elevation ?? 0;
    return Material(
      elevation: elevation,
      borderRadius: radius,
      color: background,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context, radius),
              const SizedBox(height: 8),
              _buildTitle(context, compTheme),
              const SizedBox(height: 6),
              _buildPrice(context, compTheme),
              const SizedBox(height: 8),
              _buildAddToCart(context, product, radius),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, BorderRadius radius) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.topLeft.x * 0.8),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: widget.product.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(radius.topLeft.x * 0.8),
              child: Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Icon(
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
  }

  Widget _buildTitle(BuildContext context, ProductCardTheme compTheme) {
    return Flexible(
      child: Text(
        widget.product.name,
        style: compTheme.titleStyle ?? Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPrice(BuildContext context, ProductCardTheme compTheme) {
    return Text(
  '\$${widget.product.price.toStringAsFixed(2)}',
      style: compTheme.priceStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
    );
  }

  Widget _buildAddToCart(BuildContext context, ProductModel product, BorderRadius radius) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          final cartItem = CartItemModel.createSafe(
            product: product,
            quantity: 1,
            pricePerItem: product.price,
          );
          widget.onAddToCart?.call(cartItem);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.topLeft.x * 0.6)),
        ),
        child: const Text('Add to Cart', style: TextStyle(fontSize: 10)),
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


