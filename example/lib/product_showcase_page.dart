import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';
import 'demo_data.dart';

class ProductShowcasePage extends StatefulWidget {
  const ProductShowcasePage({super.key});

  @override
  State<ProductShowcasePage> createState() => _ProductShowcasePageState();
}

class _ProductShowcasePageState extends State<ProductShowcasePage> {
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    final filteredProducts = DemoData.products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('ShopKit Demo'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProductSearchBarAdvanced(
                onSearch: (query) => setState(() => _searchQuery = query),
                suggestions: const ['Headphones', 'Watch', 'Backpack', 'Coffee'],
                enableVoiceSearch: true,
                enableFilters: true,
              ),
            ),
          ),

          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _showProductDetail(context, product),
                    onAddToCart: (cartItem) => _showAddedToCart(cartItem),
                  );
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  void _showAddedToCart(CartItemModel cartItem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cartItem.product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Create ImageModel list from product images
    final imageUrls = product.imageUrls ?? (product.imageUrl != null ? [product.imageUrl!] : <String>[]);
    final images = imageUrls
        .map((url) => ImageModel(id: url, url: url))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: images.isNotEmpty 
                ? ImageCarousel(
                    images: images,
                    enableZoom: true,
                    height: 400,
                  )
                : Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          product.formattedOriginalPrice,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (product.rating != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating?.toStringAsFixed(1)} (${product.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (product.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (product.variants?.isNotEmpty == true) ...[
                    VariantPicker(
                      variants: product.variants!,
                      onVariantSelected: (variant) {},
                    ),
                    const SizedBox(height: 24),
                  ],
                  ReviewWidget(
                    reviews: DemoData.reviews.where((r) => r.productId == product.id).toList(),
                  ),
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AddToCartButton(
        product: product,
        onAddToCart: (cartItem) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${cartItem.product.name} added to cart'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
