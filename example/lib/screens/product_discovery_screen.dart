import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';
import '../themes/theme_animated_widgets.dart';
import 'dart:ui';

class ProductDiscoveryScreen extends StatefulWidget {
  const ProductDiscoveryScreen({
    super.key,
    required this.themeStyle,
  });

  final String themeStyle;

  @override
  State<ProductDiscoveryScreen> createState() => _ProductDiscoveryScreenState();
}

class _ProductDiscoveryScreenState extends State<ProductDiscoveryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _tabs = [
    'Product Cards',
    'Product Grid', 
    'Search Bar',
    'Add to Cart',
  ];

  // Sample data
  final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium quality wireless headphones',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      isInStock: true,
      rating: 4.5,
      reviewCount: 125,
    ),
    const ProductModel(
      id: '2',
      name: 'Smartphone Pro',
      description: 'Latest flagship smartphone',
      price: 1199.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      isInStock: true,
      rating: 4.8,
      reviewCount: 89,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Discovery - ${widget.themeStyle.toUpperCase()}'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: theme.colorScheme.onPrimary,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductCardsDemo(),
          _buildProductGridDemo(),
          _buildSearchBarDemo(),
          _buildAddToCartDemo(),
        ],
      ),
    );
  }

  Widget _buildProductCardsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Product Card Variations'),
          const SizedBox(height: 16),
          
          // Style 1: Default Material 3
          _buildStyleSubheader('Default Material 3'),
          _buildProductCardExample(_products[0].copyWith(id: '${_products[0].id}_default'), _getThemeConfig('default')),
          const SizedBox(height: 24),
          
          // Style 2: Elevated Card
          _buildStyleSubheader('Elevated Card'),
          _buildProductCardExample(_products[1].copyWith(id: '${_products[1].id}_elevated'), _getThemeConfig('elevated')),
          const SizedBox(height: 24),
          
          // Style 3: Outlined Card
          _buildStyleSubheader('Outlined Card'),
          _buildProductCardExample(_products[0].copyWith(id: '${_products[0].id}_outlined'), _getThemeConfig('outlined')),
        ],
      ),
    );
  }

  Widget _buildProductGridDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Product Grid Layouts'),
          const SizedBox(height: 16),
          
          // 2 Column Grid
          _buildStyleSubheader('2 Column Grid'),
          SizedBox(
            height: 400,
            child: _buildProductGridExample(2),
          ),
          const SizedBox(height: 24),
          
          // 3 Column Grid (Compact)
          _buildStyleSubheader('3 Column Grid (Compact)'),
          SizedBox(
            height: 300,
            child: _buildProductGridExample(3),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBarDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Search Bar Variations'),
          const SizedBox(height: 16),
          
          // Basic Search
          _buildStyleSubheader('Basic Search'),
          _buildSearchBarExample('basic'),
          const SizedBox(height: 24),
          
          // Search with Filters
          _buildStyleSubheader('Search with Filters'),
          _buildSearchBarExample('filters'),
          const SizedBox(height: 24),
          
          // Pill Style Search
          _buildStyleSubheader('Pill Style'),
          _buildSearchBarExample('pill'),
        ],
      ),
    );
  }

  Widget _buildAddToCartDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Add to Cart Buttons'),
          const SizedBox(height: 16),
          
          // Default Button
          _buildStyleSubheader('Default Style'),
          _buildAddToCartExample('default'),
          const SizedBox(height: 24),
          
          // Icon Button
          _buildStyleSubheader('Icon Style'),
          _buildAddToCartExample('icon'),
          const SizedBox(height: 24),
          
          // Loading State
          _buildStyleSubheader('Loading State'),
          _buildAddToCartExample('loading'),
        ],
      ),
    );
  }

  Widget _buildProductCardExample(ProductModel product, FlexibleWidgetConfig config) {
    try {
      return ThemeAnimatedCard(
        themeStyle: widget.themeStyle,
        margin: EdgeInsets.zero,
        child: ProductCard(
          product: product,
          onAddToCart: (item) => _showSnackBar('Added ${item.product.name} to cart'),
          onTap: () => _showSnackBar('Product tapped'),
          flexibleConfig: config,
        ),
      );
    } catch (e) {
      return ThemeAnimatedCard(
        themeStyle: widget.themeStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemedImage(product),
            const SizedBox(height: 12),
            Text(
              product.name,
              style: TextStyle(
                fontSize: _getThemeFontSize('title'),
                fontWeight: FontWeight.bold,
                color: _getThemeTextColor(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? '',
              style: TextStyle(
                fontSize: _getThemeFontSize('body'),
                color: _getThemeTextColor().withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: _getThemeFontSize('price'),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ThemeAnimatedButton(
                themeStyle: widget.themeStyle,
                onPressed: () => _showSnackBar('Added ${product.name} to cart'),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildThemedImage(ProductModel product) {
    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: product.imageUrl != null
              ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
          ),
        );
      case 'glassmorphic':
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
            ),
          ),
        );
      default: // Material 3
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.imageUrl != null
              ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
          ),
        );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Icon(
        Icons.image,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  double _getThemeFontSize(String type) {
    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        switch (type) {
          case 'title': return 18;
          case 'body': return 14;
          case 'price': return 20;
          default: return 16;
        }
      case 'glassmorphic':
        switch (type) {
          case 'title': return 20;
          case 'body': return 16;
          case 'price': return 24;
          default: return 18;
        }
      default: // Material 3
        switch (type) {
          case 'title': return 16;
          case 'body': return 14;
          case 'price': return 18;
          default: return 16;
        }
    }
  }

  Color _getThemeTextColor() {
    return Theme.of(context).colorScheme.onSurface;
  }

  Widget _buildProductGridExample(int columns) {
    try {
      // Create unique products for grid to avoid Hero tag conflicts
      final uniqueProducts = _products.asMap().entries.map((entry) {
        return entry.value.copyWith(id: '${entry.value.id}_grid_${columns}col_${entry.key}');
      }).toList();
      
      return ProductGrid(
        products: uniqueProducts,
        onProductTap: (product, index) => _showSnackBar('Tapped ${product.name}'),
        config: const FlexibleWidgetConfig(),
      );
    } catch (e) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) => _buildProductCardExample(
          _products[index].copyWith(id: '${_products[index].id}_fallback_grid_${columns}col_$index'),
          _getThemeConfig('default'),
        ),
      );
    }
  }

  Widget _buildSearchBarExample(String style) {
    try {
      return ProductSearchBarAdvanced(
        onSearch: (query) => _showSnackBar('Searching: $query'),
        config: const FlexibleWidgetConfig(),
      );
    } catch (e) {
      return TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(style == 'pill' ? 25 : 8),
          ),
        ),
        onChanged: (query) => _showSnackBar('Searching: $query'),
      );
    }
  }

  Widget _buildAddToCartExample(String style) {
    try {
      return AddToCartButton(
        product: _products[0],
        onAddToCart: (product, qty) => _showSnackBar('Added ${product?.name} (x$qty) to cart'),
        config: const FlexibleWidgetConfig(
          config: {
            'width': 200.0,
            'height': 48.0,
            'borderRadius': 8.0,
            'enableAnimations': true,
            'animationDuration': 300,
          },
        ),
      );
    } catch (e) {
      return ElevatedButton.icon(
        onPressed: () => _showSnackBar('Added ${_products[0].name} to cart'),
        icon: style == 'loading' 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.add_shopping_cart),
        label: Text(style == 'loading' ? 'Adding...' : 'Add to Cart'),
      );
    }
  }

  FlexibleWidgetConfig _getThemeConfig(String style) {
    final baseConfig = <String, dynamic>{
      'borderRadius': widget.themeStyle == 'neumorphism' ? 16.0 : 8.0,
      'elevation': widget.themeStyle == 'glassmorphism' ? 0.0 : 2.0,
      'width': 200.0,
      'height': 48.0,
      'enableAnimations': true,
      'animationDuration': 300,
      'padding': 16.0,
      'margin': 8.0,
    };

    switch (style) {
      case 'elevated':
        baseConfig['elevation'] = 8.0;
        break;
      case 'outlined':
        baseConfig['elevation'] = 0.0;
        baseConfig['border'] = true;
        break;
    }

    return FlexibleWidgetConfig(config: baseConfig);
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
