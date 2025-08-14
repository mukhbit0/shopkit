import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';
import '../themes/theme_animated_widgets.dart';
import 'dart:ui';

class CartManagementScreen extends StatefulWidget {
  const CartManagementScreen({
    super.key,
    required this.themeStyle,
  });

  final String themeStyle;

  @override
  State<CartManagementScreen> createState() => _CartManagementScreenState();
}

class _CartManagementScreenState extends State<CartManagementScreen> {
  int _cartItemCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Management - ${widget.themeStyle.toUpperCase()}'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Cart Bubble Variations'),
            const SizedBox(height: 16),
            
            // Default Cart Bubble
            _buildStyleSubheader('Default Style'),
            Row(
              children: [
                _buildCartBubbleExample('default'),
                const SizedBox(width: 16),
                Text('Items in cart: $_cartItemCount'),
              ],
            ),
            const SizedBox(height: 24),
            
            // Minimalist Cart Bubble
            _buildStyleSubheader('Minimalist Style'),
            Row(
              children: [
                _buildCartBubbleExample('minimal'),
                const SizedBox(width: 16),
                const Text('Minimal design'),
              ],
            ),
            const SizedBox(height: 24),
            
            // Add/Remove Cart Items Demo
            _buildSectionHeader('Cart Controls'),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Cart Items: $_cartItemCount',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => _cartItemCount++),
                          child: const Text('Add Item'),
                        ),
                        ElevatedButton(
                          onPressed: _cartItemCount > 0 
                            ? () => setState(() => _cartItemCount--)
                            : null,
                          child: const Text('Remove Item'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Theme-specific styling demo
            _buildSectionHeader('Theme-Specific Styling'),
            const SizedBox(height: 16),
            _buildThemeDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBubbleExample(String style) {
    try {
      // Create sample cart items based on current count
      final cartItems = List.generate(_cartItemCount, (index) => 
        CartItemModel(
          id: 'item_$index',
          product: ProductModel(
            id: 'product_$index',
            name: 'Sample Product $index',
            price: 29.99,
            currency: 'USD',
            imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
            categoryId: 'electronics',
            isInStock: true,
            rating: 4.5,
            reviewCount: 100,
          ),
          quantity: 1,
          pricePerItem: 29.99,
        )
      );

      return _buildThemedCartBubble(cartItems, style);
    } catch (e) {
      // Fallback UI with themed styling
      return _buildThemedCartFallback();
    }
  }

  Widget _buildThemedCartBubble(List<CartItemModel> cartItems, String style) {
    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                offset: const Offset(-3, -3),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(3, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: CartBubbleAdvanced(
            cartItems: cartItems,
            onTap: () => _showSnackBar('Cart tapped - Neumorphic style'),
            config: FlexibleWidgetConfig(config: {
              'backgroundColor': Theme.of(context).colorScheme.surface,
              'borderRadius': 20.0,
              'padding': 8.0,
              'enableAnimations': true,
            }),
          ),
        );
      case 'glassmorphic':
        return ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: CartBubbleAdvanced(
                cartItems: cartItems,
                onTap: () => _showSnackBar('Cart tapped - Glassmorphic style'),
                config: FlexibleWidgetConfig(config: {
                  'backgroundColor': Colors.white.withValues(alpha: 0.15),
                  'borderRadius': 24.0,
                  'padding': 8.0,
                  'enableAnimations': true,
                }),
              ),
            ),
          ),
        );
      default: // Material 3
        return CartBubbleAdvanced(
          cartItems: cartItems,
          onTap: () => _showSnackBar('Cart tapped - Material 3 style'),
          config: FlexibleWidgetConfig(config: {
            'backgroundColor': Theme.of(context).colorScheme.primary,
            'borderRadius': 12.0,
            'padding': 8.0,
            'enableAnimations': true,
          }),
        );
    }
  }

  Widget _buildThemedCartFallback() {
    final cartIcon = Stack(
      children: [
        IconButton(
          onPressed: () => _showSnackBar('Cart tapped'),
          icon: const Icon(Icons.shopping_cart),
          iconSize: 24,
        ),
        if (_cartItemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_cartItemCount',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );

    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                offset: const Offset(-4, -4),
                blurRadius: 8,
              ),
              BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(4, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: cartIcon,
        );
      case 'glassmorphic':
        return ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: cartIcon,
            ),
          ),
        );
      default: // Material 3
        return cartIcon;
    }
  }

  Widget _buildThemeDemo() {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Theme: ${widget.themeStyle}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _getThemeDescription(),
          ],
        ),
      ),
    );
  }

  Widget _getThemeDescription() {
    final theme = Theme.of(context);
    
    switch (widget.themeStyle) {
      case 'material3':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Material 3 Design System', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              '• Dynamic color theming\n• Rounded corners\n• Elevated surfaces',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      case 'neumorphism':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Neumorphic Design', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              '• Soft shadows\n• Subtle depth\n• Monochromatic colors',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      case 'glassmorphism':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Glassmorphic Design', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              '• Transparent backgrounds\n• Blur effects\n• Glowing borders',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      default:
        return const Text('Unknown theme style');
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildStyleSubheader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
