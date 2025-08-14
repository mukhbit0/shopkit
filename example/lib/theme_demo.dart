import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

class ThemeDemoPage extends StatelessWidget {
  const ThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample product for demonstration
    const sampleProduct = ProductModel(
      id: 'demo_1',
      name: 'Premium Wireless Headphones',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=Product',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopKit Theme Styles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Built-in Theme Styles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Grid of product cards with different themes
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Adjusted ratio for better fit
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                children: [
                  _buildThemeCard('Material 3', 'material3', sampleProduct),
                  _buildThemeCard('Material You', 'materialYou', sampleProduct),
                  _buildThemeCard('Neumorphism', 'neumorphism', sampleProduct),
                  _buildThemeCard('Glassmorphism', 'glassmorphism', sampleProduct),
                  _buildThemeCard('Cupertino', 'cupertino', sampleProduct),
                  _buildThemeCard('Minimal', 'minimal', sampleProduct),
                  _buildThemeCard('Retro', 'retro', sampleProduct),
                  _buildThemeCard('Neon', 'neon', sampleProduct),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Code example
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usage Example:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '''ProductCard(
  product: product,
  themeStyle: 'neumorphism', // Set any theme style
  onTap: () => navigateToProduct(product),
  onAddToCart: (cartItem) => addToCart(cartItem),
)''',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(String title, String themeStyle, ProductModel product) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.75, // Width:Height ratio for consistent card size
            child: ProductCard(
              product: product,
              themeStyle: themeStyle,
              onTap: () {
                // Handle product tap
              },
              onAddToCart: (cartItem) {
                // Handle add to cart
              },
            ),
          ),
        ),
      ],
    );
  }
}
