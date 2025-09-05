import 'package:flutter/material.dart' as Material;
import 'package:shopkit/shopkit.dart';

void main() {
  Material.runApp(const MyApp());
}

class MyApp extends Material.StatelessWidget {
  const MyApp({super.key});

  @override
  Material.Widget build(Material.BuildContext context) {
    return Material.MaterialApp(
      title: 'ShopKit Example',
      theme: Material.ThemeData(
        colorScheme: Material.ColorScheme.fromSeed(seedColor: Material.Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShopKitExamplePage(),
    );
  }
}

class ShopKitExamplePage extends Material.StatefulWidget {
  const ShopKitExamplePage({super.key});

  @override
  Material.State<ShopKitExamplePage> createState() => _ShopKitExamplePageState();
}

class _ShopKitExamplePageState extends Material.State<ShopKitExamplePage> {
  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Wireless Headphones',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://via.placeholder.com/200x200/FF6B6B/FFFFFF?text=Headphones',
      description: 'High-quality wireless headphones with noise cancellation',
      rating: 4.5,
      isInStock: true,
      discountPercentage: 16.7,
    ),
    ProductModel(
      id: '2',
      name: 'Smart Watch',
      price: 199.99,
      currency: 'USD',
      imageUrl: 'https://via.placeholder.com/200x200/4ECDC4/FFFFFF?text=Watch',
      description: 'Feature-rich smartwatch with health tracking',
      rating: 4.2,
      isInStock: true,
      discountPercentage: 0,
    ),
    ProductModel(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 89.99,
      currency: 'USD',
      imageUrl: 'https://via.placeholder.com/200x200/45B7D1/FFFFFF?text=Speaker',
      description: 'Portable Bluetooth speaker with excellent sound quality',
      rating: 4.8,
      isInStock: false,
      discountPercentage: 22.2,
    ),
  ];

  final List<CartItemModel> _cartItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Add some sample cart items
    _cartItems.addAll([
      CartItemModel.createSafe(
        product: _products[0],
        quantity: 1,
      ),
      CartItemModel.createSafe(
        product: _products[1],
        quantity: 2,
      ),
    ]);
  }

  @override
  Material.Widget build(Material.BuildContext context) {
    final filteredProducts = _products
        .where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Material.Scaffold(
      appBar: Material.AppBar(
        backgroundColor: Material.Theme.of(context).colorScheme.inversePrimary,
        title: const Material.Text('ShopKit Example'),
      ),
      body: Material.SingleChildScrollView(
        padding: const Material.EdgeInsets.all(16.0),
        child: Material.Column(
          crossAxisAlignment: Material.CrossAxisAlignment.start,
          children: [
            // Title
            const Material.Text(
              'ShopKit shadcn/ui Components',
              style: Material.TextStyle(fontSize: 28, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 8),
            Material.Text(
              'Modern e-commerce widgets built with shadcn/ui',
              style: Material.TextStyle(fontSize: 16, color: Material.Colors.grey[600]),
            ),
            const Material.SizedBox(height: 32),

            // Search Bar Demo
            const Material.Text(
              'Search Products',
              style: Material.TextStyle(fontSize: 24, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 16),
            SearchBar(
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onSuggestionTap: (product) {
                Material.ScaffoldMessenger.of(context).showSnackBar(
                  Material.SnackBar(content: Material.Text('Selected: ${product.name}')),
                );
              },
              suggestions: _products,
            ),
            
            const Material.SizedBox(height: 32),
            
            // Product Grid Demo
            const Material.Text(
              'Product Grid',
              style: Material.TextStyle(fontSize: 24, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 16),
            ProductGrid(
              products: filteredProducts,
              onAddToCart: (cartItem) {
                setState(() {
                  _cartItems.add(cartItem);
                });
                Material.ScaffoldMessenger.of(context).showSnackBar(
                  Material.SnackBar(content: Material.Text('${cartItem.product.name} added to cart')),
                );
              },
            ),
            
            const Material.SizedBox(height: 32),
            
            // Individual Product Card Demo
            const Material.Text(
              'Individual Product Card',
              style: Material.TextStyle(fontSize: 24, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 16),
            if (_products.isNotEmpty)
              Material.SizedBox(
                width: 300,
                child: ProductCard(
                  product: _products.first,
                  onAddToCart: (cartItem) {
                    setState(() {
                      _cartItems.add(cartItem);
                    });
                    Material.ScaffoldMessenger.of(context).showSnackBar(
                      Material.SnackBar(content: Material.Text('${cartItem.product.name} added to cart')),
                    );
                  },
                ),
              ),
            
            const Material.SizedBox(height: 32),
            
            // Cart Items Demo
            Material.Text(
              'Shopping Cart (${_cartItems.length} items)',
              style: const Material.TextStyle(fontSize: 24, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 16),
            if (_cartItems.isEmpty)
              const Material.Center(
                child: Material.Text('Your cart is empty'),
              )
            else
              Material.Column(
                children: [
                  ..._cartItems.map((item) => Material.Padding(
                    padding: const Material.EdgeInsets.only(bottom: 8.0),
                    child: CartItem(
                      cartItem: item,
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
                          if (index != -1) {
                            if (newQuantity <= 0) {
                              _cartItems.removeAt(index);
                            } else {
                              _cartItems[index] = item.copyWith(quantity: newQuantity);
                            }
                          }
                        });
                      },
                      onRemove: () {
                        setState(() {
                          _cartItems.removeWhere((cartItem) => cartItem.id == item.id);
                        });
                        Material.ScaffoldMessenger.of(context).showSnackBar(
                          Material.SnackBar(content: Material.Text('${item.product.name} removed from cart')),
                        );
                      },
                    ),
                  )).toList(),
                  const Material.SizedBox(height: 16),
                  const Material.Divider(),
                  const Material.SizedBox(height: 16),
                  Material.Row(
                    mainAxisAlignment: Material.MainAxisAlignment.spaceBetween,
                    children: [
                      const Material.Text(
                        'Total:',
                        style: Material.TextStyle(
                          fontSize: 18,
                          fontWeight: Material.FontWeight.bold,
                        ),
                      ),
                      Material.Text(
                        _getCartTotal(),
                        style: const Material.TextStyle(
                          fontSize: 18,
                          fontWeight: Material.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            
            const Material.SizedBox(height: 32),
            
            // Add to Cart Button Demo
            const Material.Text(
              'Add to Cart Button',
              style: Material.TextStyle(fontSize: 24, fontWeight: Material.FontWeight.bold),
            ),
            const Material.SizedBox(height: 16),
            if (_products.isNotEmpty)
              AddToCartButton(
                product: _products.first,
                onAddToCart: (cartItem) {
                  setState(() {
                    _cartItems.add(cartItem);
                  });
                  Material.ScaffoldMessenger.of(context).showSnackBar(
                    Material.SnackBar(content: Material.Text('${cartItem.product.name} (x${cartItem.quantity}) added to cart')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String _getCartTotal() {
    final total = _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    return '\$${total.toStringAsFixed(2)}';
  }
}
