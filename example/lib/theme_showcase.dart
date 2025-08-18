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
            
            // Category Tabs
            Text(
              'Category Tabs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildCategoryTabsShowcase(),
            SizedBox(height: 32.h),

            // Product Search Bars
            Text(
              'Product Search Bars',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildSearchBarsShowcase(),
            SizedBox(height: 32.h),

            // Announcement Bars
            Text(
              'Announcement Bars',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildAnnouncementBarsShowcase(),
            SizedBox(height: 32.h),

            // Variant Picker
            Text(
              'Variant Pickers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildVariantPickersShowcase(),
            SizedBox(height: 32.h),

            // Image Carousel
            Text(
              'Image Carousels',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildImageCarouselsShowcase(),
            SizedBox(height: 32.h),

            // Cart Bubble
            Text(
              'Cart Bubbles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildCartBubblesShowcase(),
            SizedBox(height: 32.h),

            // Sticky Add To Cart
            Text(
              'Sticky Add To Cart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildStickyAddToCartShowcase(),
            SizedBox(height: 32.h),

            // Cart Summary
            Text(
              'Cart Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildCartSummaryShowcase(),
            SizedBox(height: 48.h),

            Text(
              'All core widgets now accept themeStyle for instant styling.',
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
              width: 160.w,
              height: 44.h,
              onAddToCart: (cartItem) {},
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryTabsShowcase() {
    final themes = _themes;
    const categories = [
      CategoryModel(id: '1', name: 'Shoes', itemCount: 42),
      CategoryModel(id: '2', name: 'Hats', itemCount: 18),
      CategoryModel(id: '3', name: 'Bags', itemCount: 27),
      CategoryModel(id: '4', name: 'Watches', itemCount: 9),
    ];
    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        separatorBuilder: (_, __) => SizedBox(width: 20.w),
        itemBuilder: (context, index) {
          final theme = themes[index];
          return SizedBox(
            width: 220.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(theme, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Expanded(
                  child: CategoryTabs(
                    categories: categories,
                    onCategorySelected: (_) {},
                    themeStyle: theme,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBarsShowcase() {
    final themes = _themes;
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ProductSearchBarAdvanced(
            onSearch: (q) {},
            themeStyle: theme,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnnouncementBarsShowcase() {
    final themes = _themes;
    const model = AnnouncementModel(
      id: 'ann1',
      title: 'Summer Sale',
      message: 'Up to 50% off select items!',
      actionText: 'Shop Now',
      actionUrl: 'https://example.com',
    );
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: AnnouncementBar(
            announcement: model,
            themeStyle: theme,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVariantPickersShowcase() {
    final themes = _themes;
    final variants = [
      const VariantModel(id: 's', name: 'Small', type: 'size', value: 'S', stockQuantity: 10),
      const VariantModel(id: 'm', name: 'Medium', type: 'size', value: 'M', stockQuantity: 5),
      const VariantModel(id: 'l', name: 'Large', type: 'size', value: 'L', stockQuantity: 0),
    ];
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: VariantPicker(
            variants: variants,
            themeStyle: theme,
            onVariantSelected: (_) {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageCarouselsShowcase() {
    final themes = _themes;
    final images = List.generate(4, (i) => ImageModel(id: '$i', url: 'https://picsum.photos/seed/car$i/400/400'));
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: ImageCarousel(
            images: images,
            height: 220.h,
            aspectRatio: 1.2,
            themeStyle: theme,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCartBubblesShowcase() {
    final themes = _themes;
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: themes.map((theme) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(theme, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            CartBubbleAdvanced(
              cartItems: _sampleCartItems(),
              themeStyle: theme,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStickyAddToCartShowcase() {
    final themes = _themes;
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: StickyAddToCart(
            product: _getSampleProduct(),
            onAddToCart: (_) {},
            themeStyle: theme,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCartSummaryShowcase() {
    final themes = _themes;
    final items = _sampleCartItems();
    return Column(
      children: themes.map((theme) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: CartSummaryAdvanced(
            cartItems: items,
            themeStyle: theme,
          ),
        );
      }).toList(),
    );
  }

  List<CartItemModel> _sampleCartItems() {
    final product = _getSampleProduct();
    return [
  CartItemModel.createSafe(product: product, quantity: 1, pricePerItem: product.price),
  CartItemModel.createSafe(product: product.copyWith(id: 'p2', name: 'Another Product'), quantity: 2, pricePerItem: product.price),
    ];
  }

  List<String> get _themes => const [
    'material3',
    'materialYou',
    'neumorphism',
    'glassmorphism',
    'cupertino',
    'minimal',
    'retro',
    'neon',
  ];

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
