import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';
import 'product_card.dart';

/// Modern product grid built with shadcn/ui components
class ProductGrid extends StatefulWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
    this.onToggleWishlist,
    this.crossAxisCount,
    this.childAspectRatio = 0.75,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.padding = const EdgeInsets.all(16),
    this.isLoading = false,
    this.emptyBuilder,
    this.loadingBuilder,
    this.showQuickActions = true,
    this.showDiscount = true,
    this.showRating = true,
    this.showBrand = true,
    this.enableRefresh = false,
    this.onRefresh,
  });

  final List<ProductModel> products;
  final Function(ProductModel)? onProductTap;
  final Function(CartItemModel)? onAddToCart;
  final Function(ProductModel)? onToggleWishlist;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets padding;
  final bool isLoading;
  final Widget Function(BuildContext)? emptyBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final bool showQuickActions;
  final bool showDiscount;
  final bool showRating;
  final bool showBrand;
  final bool enableRefresh;
  final Future<void> Function()? onRefresh;

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final Set<String> _wishlistedProducts = <String>{};

  int _getCrossAxisCount(BuildContext context) {
    if (widget.crossAxisCount != null) return widget.crossAxisCount!;
    
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  bool _isWishlisted(ProductModel product) {
    return _wishlistedProducts.contains(product.id);
  }

  void _handleToggleWishlist(ProductModel product) {
    setState(() {
      if (_wishlistedProducts.contains(product.id)) {
        _wishlistedProducts.remove(product.id);
      } else {
        _wishlistedProducts.add(product.id);
      }
    });
    widget.onToggleWishlist?.call(product);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return widget.loadingBuilder?.call(context) ?? _buildLoadingState();
    }

    if (widget.products.isEmpty) {
      return widget.emptyBuilder?.call(context) ?? _buildEmptyState();
    }

    Widget gridView = GridView.builder(
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: widget.childAspectRatio,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return ProductCard(
          product: product,
          onTap: () => widget.onProductTap?.call(product),
          onAddToCart: widget.onAddToCart,
          onToggleWishlist: () => _handleToggleWishlist(product),
          isInWishlist: _isWishlisted(product),
          showQuickActions: widget.showQuickActions,
          showDiscount: widget.showDiscount,
          showRating: widget.showRating,
          showBrand: widget.showBrand,
        );
      },
    );

    if (widget.enableRefresh && widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: gridView,
      );
    }

    return gridView;
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: widget.childAspectRatio,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
      ),
      itemCount: 6, // Show 6 skeleton cards
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return ShadCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price skeleton
                  Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Button skeleton
                  Container(
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
