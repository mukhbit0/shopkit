import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import '../../theme/shopkit_theme.dart';
import 'add_to_cart_button.dart';

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
  });

  /// Product data to display
  final ProductModel product;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when add to cart is pressed
  final Function(CartItemModel)? onAddToCart;

  /// Callback when wishlist button is pressed
  final VoidCallback? onToggleWishlist;

  /// Callback when product image is tapped
  final VoidCallback? onImageTap;

  /// Whether product is in wishlist
  final bool isInWishlist;

  /// Whether product is in cart
  final bool isInCart;

  /// Custom builder for complete customization
  final Widget Function(BuildContext, ProductModel, ProductCardState)?
      customBuilder;

  /// Hero tag for image transitions
  final String? heroTag;

  /// Aspect ratio for the card
  final double? aspectRatio;

  /// Fixed height for the image section
  final double? imageHeight;

  /// Fixed width for the card
  final double? width;

  /// Fixed height for the card
  final double? height;

  @override
  State<ProductCard> createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _favoriteController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _favoriteAnimation;

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

    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
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

    final theme = ShopKitTheme.light();

    return Container(
      width: widget.width,
      height: widget.height,
      child: _buildCard(context, theme),
    );
  }

  Widget _buildCard(BuildContext context, ShopKitTheme theme) {
    return _buildDefaultCard(context, theme);
  }

  Widget _buildDefaultCard(BuildContext context, ShopKitTheme theme) {
    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: Material(
            color: theme.surfaceColor,
            borderRadius: BorderRadius.circular(theme.borderRadius),
            elevation: 4,
            child: InkWell(
              onTap: widget.onTap,
              onHover: _onHover,
              borderRadius: BorderRadius.circular(theme.borderRadius),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.borderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildImageSection(context, theme),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildContentSection(context, theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: double.infinity,
      height: widget.imageHeight,
      child: Stack(
        children: [
          // Main product image
          if (widget.product.mainImageUrl != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onImageTap,
                child: Hero(
                  tag: widget.heroTag ?? 'product-${widget.product.id}',
                  child: Image.network(
                    widget.product.mainImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildImagePlaceholder(theme),
                  ),
                ),
              ),
            )
          else
            Positioned.fill(child: _buildImagePlaceholder(theme)),

          // Wishlist button
          if (widget.onToggleWishlist != null)
            Positioned(
              top: 8,
              right: 8,
              child: _buildWishlistButton(context, theme),
            ),

          // Discount badge
          if (widget.product.hasDiscount)
            Positioned(
              top: 8,
              left: 8,
              child: _buildDiscountBadge(context, theme),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ShopKitTheme theme) {
    return Container(
      color: theme.backgroundColor,
      child: Icon(
        Icons.image_not_supported,
        color: theme.onSurfaceColor.withValues(alpha: 0.3),
        size: 48,
      ),
    );
  }

  Widget _buildWishlistButton(BuildContext context, ShopKitTheme theme) {
    return AnimatedBuilder(
      animation: _favoriteAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _favoriteAnimation.value,
          child: Material(
            color: theme.surfaceColor.withValues(alpha: 0.9),
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: () {
                _favoriteController.forward().then((_) {
                  _favoriteController.reverse();
                });
                widget.onToggleWishlist?.call();
              },
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  widget.isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: widget.isInWishlist
                      ? theme.errorColor
                      : theme.onSurfaceColor,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscountBadge(BuildContext context, ShopKitTheme theme) {
    final discount = widget.product.discountPercentage ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.errorColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${discount.toInt()}% OFF',
        style: TextStyle(
          color: theme.onErrorColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, ShopKitTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(context, theme),
          const SizedBox(height: 8),
          _buildPriceRow(context, theme),
          const Spacer(),
          if (widget.onAddToCart != null) _buildActionSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildTitleText(BuildContext context, ShopKitTheme theme) {
    return Text(
      widget.product.name,
      style: TextStyle(
        color: theme.onSurfaceColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(BuildContext context, ShopKitTheme theme) {
    return Row(
      children: [
        Text(
          widget.product.formattedPrice,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.product.hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            widget.product.formattedOriginalPrice,
            style: TextStyle(
              color: theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

 Widget _buildActionSection(BuildContext context, ShopKitTheme theme) {
  return SizedBox(
    width: double.infinity,
    child: AddToCartButtonNew(
      product: widget.product,
      onAddToCart: (product, quantity) {
        final cartItem = CartItemModel(
          id: 'cart_${product?.id}_${DateTime.now().millisecondsSinceEpoch}',
          product: product!,
          quantity: quantity,
          pricePerItem: product.price,
        );
        widget.onAddToCart?.call(cartItem);
      },
    ),
  );
}

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}
