import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

import 'new_architecture_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'E-Commerce Widgets Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          extensions: const <ThemeExtension>[
            ECommerceTheme.light, // Add e-commerce theme
          ],
        ),
        home: const ShopKitNewArchitectureDemo(),
      );
}

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  late CartController _cartController;
  final Set<String> _wishlistIds = <String>{};

  @override
  void initState() {
    super.initState();
    _cartController = CartController();
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  // Sample product data
  List<ProductModel> get sampleProducts => <ProductModel>[
        const ProductModel(
          id: '1',
          name: 'Wireless Bluetooth Headphones',
          price: 99.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
          rating: 4.5,
          reviewCount: 128,
          discountPercentage: 15,
          tags: <String>['electronics', 'audio'],
        ),
        const ProductModel(
          id: '2',
          name: 'Smart Fitness Watch',
          price: 249.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
          rating: 4.3,
          reviewCount: 89,
          tags: <String>['electronics', 'fitness'],
        ),
        const ProductModel(
          id: '3',
          name: 'Premium Coffee Maker',
          price: 179.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400',
          rating: 4.7,
          reviewCount: 203,
          discountPercentage: 25,
          tags: <String>['kitchen', 'appliances'],
        ),
        const ProductModel(
          id: '4',
          name: 'Ergonomic Office Chair',
          price: 299.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
          rating: 4.2,
          reviewCount: 156,
          tags: <String>['furniture', 'office'],
        ),
        const ProductModel(
          id: '5',
          name: 'Smartphone Case',
          price: 24.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?w=400',
          rating: 4.1,
          reviewCount: 67,
          discountPercentage: 30,
          tags: <String>['accessories', 'phone'],
        ),
        const ProductModel(
          id: '6',
          name: 'Gaming Keyboard',
          price: 149.99,
          currency: 'USD',
          imageUrl:
              'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=400',
          rating: 4.6,
          reviewCount: 284,
          tags: <String>['electronics', 'gaming'],
        ),
      ];

  void onProductTap(ProductModel product) {
    // Navigate to product detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ProductDetailPage(product: product),
      ),
    );
  }

  void onAddToCart(CartItemModel cartItem) {
    _cartController.addToCart(
      cartItem.product,
      variant: cartItem.variant,
      quantity: cartItem.quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${cartItem.product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: _showCartBottomSheet,
        ),
      ),
    );
  }

  void onAddToWishlist(ProductModel product) {
    setState(() {
      if (_wishlistIds.contains(product.id)) {
        _wishlistIds.remove(product.id);
      } else {
        _wishlistIds.add(product.id);
      }
    });

    final message = _wishlistIds.contains(product.id)
        ? '${product.name} added to wishlist'
        : '${product.name} removed from wishlist';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          CartBottomSheet(controller: _cartController),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('E-Commerce Demo'),
          elevation: 0,
          actions: <Widget>[
            ListenableBuilder(
              listenable: _cartController,
              builder: (BuildContext context, Widget? child) => Badge(
                label: Text('${_cartController.totalItems}'),
                isLabelVisible: _cartController.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _showCartBottomSheet,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListenableBuilder(
          listenable: _cartController,
          builder: (BuildContext context, Widget? child) => ProductGrid(
            products: sampleProducts,
          ),
        ),
      );
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.product, super.key});
  final ProductModel product;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Product Image
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported, size: 64),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.image, size: 64),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Product Info
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              Row(
                children: <Widget>[
                  Text(
                    product.formattedPrice,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (product.hasDiscount) ...<Widget>[
                    const SizedBox(width: 8),
                    Text(
                      product.formattedOriginalPrice,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ],
                ],
              ),

              if (product.rating != null) ...<Widget>[
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      product.rating!.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (product.reviewCount != null) ...<Widget>[
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 24),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description ??
                    'No description available for this product.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart logic here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({required this.controller, super.key});
  final CartController controller;

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: <Widget>[
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Shopping Cart',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Cart items
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child) {
                  if (controller.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.shopping_cart_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Your cart is empty',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.cart.items.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      final item = controller.cart.items[index];
                      return ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                          ),
                          child: item.product.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                                  ),
                                )
                              : const Icon(Icons.image),
                        ),
                        title: Text(item.displayName),
                        subtitle: Text(item
                            .getFormattedUnitPrice(controller.cart.currency)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => controller.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              ),
                              icon: const Icon(Icons.remove),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () => controller.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              ),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Total and checkout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child) => Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          controller.cart.formattedTotal,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isEmpty
                            ? null
                            : () {
                                // Checkout logic here
                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
