import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopkit/shopkit.dart';

class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopKit Theme Styles'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Style Showcase',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'See how easy it is to change themes with just a parameter!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24.h),
            
            // Product Cards with Different Themes
            Text(
              'Product Cards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildProductCardsGrid(),
            
            SizedBox(height: 32.h),
            
            // Add to Cart Buttons with Different Themes
            Text(
              'Add to Cart Buttons',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildAddToCartButtons(),
            
            SizedBox(height: 32.h),
            
            // More widgets will support themeStyle soon!
            Text(
              'More themed widgets coming soon...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardsGrid() {
    final themes = [
      'material3',
      'materialYou',
      'neumorphism',
      'glassmorphism',
      'cupertino',
      'minimal',
      'retro',
      'neon',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.7,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return Column(
          children: [
            Text(
              theme,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ProductCard(
                product: _getSampleProduct(),
                themeStyle: theme, // This is the magic! Just pass theme name
                onTap: () {
                  // Handle product tap
                },
                onAddToCart: (cartItem) {
                  // Handle add to cart
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddToCartButtons() {
    final themes = [
      'material3',
      'materialYou',
      'neumorphism',
      'glassmorphism',
      'cupertino',
      'minimal',
      'retro',
      'neon',
    ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: themes.map((theme) {
        return Column(
          children: [
            Text(
              theme,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            AddToCartButton(
              product: _getSampleProduct(),
              text: 'Add to Cart',
              onAddToCart: (cartItem) {
                // Handle add to cart
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  ProductModel _getSampleProduct() {
    return const ProductModel(
      id: 'sample-1',
      name: 'Awesome Product',
      description: 'This is a sample product for demo',
      price: 29.99,
      currency: 'USD',
      imageUrl: 'https://picsum.photos/400/400?random=1',
      categoryId: 'electronics',
      brand: 'ShopKit',
      isInStock: true,
      tags: ['sample', 'demo'],
    );
  }
}
