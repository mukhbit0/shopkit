import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

/// Demo showing the new unified architecture with unlimited customization
class ShopKitNewArchitectureDemo extends StatelessWidget {
  const ShopKitNewArchitectureDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample product
 const product = ProductModel(
      id: '1',
      name: 'Ultra Wireless Headphones Pro Max',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://example.com/headphones.jpg',
      description: 'Premium noise-canceling wireless headphones with spatial audio',
      rating: 4.8,
      reviewCount: 1247,
      discountPercentage: 15,
      isInStock: true,
    );

    return MaterialApp(
      home: ShopKitThemeProvider(
        theme: ShopKitTheme.material3(), // Ultra-modern Material 3 design
        child: Scaffold(
          appBar: AppBar(title: const Text('ShopKit New Architecture Demo')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎨 Material 3 Design System',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Default Material 3 Product Card
                ProductCard(
                  product: product,
                  onAddToCart: (item) => _showSnackBar(context, 'Added to cart!'),
                  onToggleWishlist: () => _showSnackBar(context, 'Added to wishlist!'),
                ),
                
                const SizedBox(height: 32),
                const Text(
                  '✨ Neumorphism Design System',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Neumorphism Product Card
                ShopKitThemeProvider(
                  theme: ShopKitTheme.neumorphic(),
                  child: ProductCard(
                    product: product,
                    onAddToCart: (item) => _showSnackBar(context, 'Added with Neumorphism style!'),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text(
                  '🔮 Glassmorphism Design System',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Glassmorphism Layout
                ShopKitThemeProvider(
                  theme: ShopKitTheme.glassmorphic(),
                  child: ProductCard(
                    product: product,
                    onAddToCart: (item) => _showSnackBar(context, 'Added with Glassmorphism style!'),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text(
                  '🎛️ Add to Cart Buttons',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Custom styled add to cart buttons
                Row(
                  children: [
                    Expanded(
                      child: AddToCartButton(
                        product: product,
                        onAddToCart: (item) => _showSnackBar(context, 'Added to cart!'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AddToCartButton(
                        product: product,
                        onAddToCart: (item) => _showSnackBar(context, 'Added to cart!'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Text(
                  '🎯 Summary: Complete Transformation Achieved!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Zero legacy dependencies\n'
                  '• Unlimited customization\n'
                  '• Multiple design systems\n'
                  '• Enterprise-grade architecture\n'
                  '• All original features preserved',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

