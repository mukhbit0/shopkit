import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';

/// Modern product card built with shadcn/ui components
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleWishlist,
    this.isInWishlist = false,
    this.width,
    this.height,
    this.aspectRatio,
    this.showQuickActions = true,
    this.showDiscount = true,
    this.showRating = true,
    this.showBrand = true,
    this.imageHeight = 180,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final Function(CartItemModel)? onAddToCart;
  final VoidCallback? onToggleWishlist;
  final bool isInWishlist;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final bool showQuickActions;
  final bool showDiscount;
  final bool showRating;
  final bool showBrand;
  final double imageHeight;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ShadCard(
              width: widget.width,
              height: widget.height,
              padding: EdgeInsets.zero,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    _buildContentSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Product Image
        Container(
          width: double.infinity,
          height: widget.imageHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            color: Colors.grey.shade50,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: widget.product.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: widget.product.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ),

        // Discount Badge
        if (widget.showDiscount && widget.product.hasDiscount)
          Positioned(
            top: 8,
            left: 8,
            child: ShadBadge(
              child: Text('${widget.product.discountPercentage!.round()}% OFF'),
            ),
          ),

        // Quick Actions
        if (widget.showQuickActions)
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                // Wishlist Button
                ShadButton(
                  onPressed: widget.onToggleWishlist,
                  child: Icon(
                    widget.isInWishlist ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: widget.isInWishlist ? Colors.red : null,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Quick View Button (appears on hover)
                AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: ShadButton(
                    onPressed: widget.onTap,
                    child: const Icon(
                      Icons.visibility,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Stock Status
        if (!widget.product.isInStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: ShadBadge(
                  child: Text(
                    'OUT OF STOCK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand
            if (widget.showBrand && widget.product.brand?.isNotEmpty == true) ...[
              Text(
                widget.product.brand!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
            ],

            // Product Name
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Rating
            if (widget.showRating && 
                widget.product.rating != null && 
                widget.product.rating! > 0) ...[
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < widget.product.rating!.floor()
                          ? Icons.star
                          : index < widget.product.rating!
                              ? Icons.star_half
                              : Icons.star_border,
                      size: 12,
                      color: Colors.amber,
                    );
                  }),
                  const SizedBox(width: 4),
                  Text(
                    '(${widget.product.reviewCount ?? 0})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Price Section
            Row(
              children: [
                Text(
                  widget.product.formattedPrice,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (widget.product.hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.product.formattedOriginalPrice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),

            const Spacer(),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: widget.product.isInStock
                    ? () {
                        final cartItem = CartItemModel.createSafe(
                          product: widget.product,
                          quantity: 1,
                          pricePerItem: widget.product.discountedPrice,
                        );
                        widget.onAddToCart?.call(cartItem);
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.isInStock ? 'Add to Cart' : 'Out of Stock',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
