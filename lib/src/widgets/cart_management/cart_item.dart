import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/cart_model.dart';

/// Modern cart item widget built with shadcn/ui components
class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.cartItem,
    this.onQuantityChanged,
    this.onRemove,
    this.showRemoveButton = true,
    this.showQuantityControls = true,
    this.isCompact = false,
  });

  final CartItemModel cartItem;
  final Function(int quantity)? onQuantityChanged;
  final VoidCallback? onRemove;
  final bool showRemoveButton;
  final bool showQuantityControls;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: EdgeInsets.all(isCompact ? 8 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(),
          const SizedBox(width: 12),
          Expanded(child: _buildProductInfo(context)),
          if (showQuantityControls || showRemoveButton)
            _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: isCompact ? 60 : 80,
      height: isCompact ? 60 : 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cartItem.product.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: cartItem.product.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              )
            : const Icon(
                Icons.image,
                color: Colors.grey,
              ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name
        Text(
          cartItem.product.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: isCompact ? 14 : 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Brand (if available)
        if (cartItem.product.brand?.isNotEmpty == true) ...[
          Text(
            cartItem.product.brand!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: isCompact ? 11 : 12,
            ),
          ),
          const SizedBox(height: 4),
        ],

        // Variant info (if any)
        if (cartItem.variant != null) ...[
          Text(
            '${cartItem.variant!.type}: ${cartItem.variant!.value}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: isCompact ? 11 : 12,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Price
        Row(
          children: [
            Text(
              cartItem.product.formattedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 14 : 16,
              ),
            ),
            if (cartItem.product.hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                cartItem.product.formattedOriginalPrice,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey.shade600,
                  fontSize: isCompact ? 11 : 12,
                ),
              ),
            ],
          ],
        ),

        if (!isCompact) ...[
          const SizedBox(height: 8),
          // Total for this item
          Text(
            'Total: ${_formatPrice(cartItem.totalPrice)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Remove button
        if (showRemoveButton)
          ShadButton(
            onPressed: onRemove,
            child: const Icon(
              Icons.close,
              size: 18,
            ),
          ),

        if (showQuantityControls) ...[
          const SizedBox(height: 8),
          
          // Quantity controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton(
                  onPressed: cartItem.quantity > 1
                      ? () => onQuantityChanged?.call(cartItem.quantity - 1)
                      : null,
                  child: const Icon(Icons.remove, size: 16),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    cartItem.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                ShadButton(
                  onPressed: () => onQuantityChanged?.call(cartItem.quantity + 1),
                  child: const Icon(Icons.add, size: 16),
                ),
              ],
            ),
          ),
        ],

        if (isCompact) ...[
          const SizedBox(height: 8),
          Text(
            _formatPrice(cartItem.totalPrice),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  String _formatPrice(double price) {
    final currency = cartItem.product.currency;
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${price.toStringAsFixed(0)}';
      default:
        return '$currency ${price.toStringAsFixed(2)}';
    }
  }
}
