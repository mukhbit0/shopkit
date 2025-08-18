import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

class SampleData {
  // Sample Products
  static final List<ProductModel> products = [
    const ProductModel(
      id: '1',
      name: 'Wireless Bluetooth Headphones',
      description: 'Premium quality wireless headphones with noise cancellation',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      imageUrls: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
      ],
      categoryId: 'electronics',
      variants: [
        VariantModel(id: 'v1', name: 'Black', type: 'color', value: 'Black', stockQuantity: 15),
        VariantModel(id: 'v2', name: 'White', type: 'color', value: 'White', stockQuantity: 20),
      ],
      isInStock: true,
      rating: 4.5,
      reviewCount: 125,
    ),
    const ProductModel(
      id: '2',
      name: 'Smartphone Pro Max',
      description: 'Latest flagship smartphone with advanced camera system',
      price: 1199.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      categoryId: 'electronics',
      isInStock: true,
      rating: 4.8,
      reviewCount: 89,
    ),
    const ProductModel(
      id: '3',
      name: 'Premium Coffee Beans',
      description: 'Artisan roasted coffee beans from sustainable farms',
      price: 24.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400',
      categoryId: 'food',
      isInStock: true,
      rating: 4.3,
      reviewCount: 67,
    ),
    const ProductModel(
      id: '4',
      name: 'Designer Sunglasses',
      description: 'Luxury sunglasses with UV protection',
      price: 189.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
      categoryId: 'fashion',
      isInStock: true,
      rating: 4.6,
      reviewCount: 42,
    ),
    const ProductModel(
      id: '5',
      name: 'Fitness Tracker Watch',
      description: 'Advanced fitness tracking with heart rate monitor',
      price: 249.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      categoryId: 'sports',
      variants: [
        VariantModel(id: 'v3', name: 'Small', type: 'size', value: 'S', stockQuantity: 20),
        VariantModel(id: 'v4', name: 'Medium', type: 'size', value: 'M', stockQuantity: 30),
        VariantModel(id: 'v5', name: 'Large', type: 'size', value: 'L', stockQuantity: 25),
      ],
      isInStock: true,
      rating: 4.4,
      reviewCount: 156,
    ),
  ];

  // Sample Categories
  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'electronics',
      name: 'Electronics',
      itemCount: 15,
      description: 'Electronic devices and accessories',
    ),
    const CategoryModel(
      id: 'fashion',
      name: 'Fashion',
      itemCount: 25,
      description: 'Clothing and accessories',
    ),
    const CategoryModel(
      id: 'home',
      name: 'Home & Garden',
      itemCount: 12,
      description: 'Home improvement and garden supplies',
    ),
    const CategoryModel(
      id: 'sports',
      name: 'Sports & Fitness',
      itemCount: 18,
      description: 'Sports equipment and fitness gear',
    ),
    const CategoryModel(
      id: 'food',
      name: 'Food & Beverages',
      itemCount: 8,
      description: 'Fresh food and beverages',
    ),
  ];

  // Sample Search Suggestions
  static final List<String> searchSuggestions = [
    'wireless headphones',
    'smartphone',
    'laptop',
    'coffee',
    'sunglasses',
    'fitness tracker',
    'camera',
    'tablet',
    'speakers',
    'watch',
  ];

  // Sample Cart Item  
  static CartModel get sampleCartItem => CartModel(
    id: 'cart1',
    items: [
      CartItemModel.createSafe(
        product: products[0],
        quantity: 2,
        pricePerItem: products[0].price,
      ),
    ],
    currency: 'USD',
  );

  // Sample User
  static final UserModel sampleUser = UserModel(
    id: 'user123',
    email: 'demo@shopkit.com',
    firstName: 'Demo',
    lastName: 'User',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  // Widget Configuration Presets
  // Widget Configuration Presets (LEGACY)
  // These presets use the legacy `FlexibleWidgetConfig` for the example
  // playground. Prefer `ShopKitTheme` and component ThemeExtensions in
  // production code. The presets are kept here for demonstration only.
  @deprecated
  static FlexibleWidgetConfig get materialConfig => const FlexibleWidgetConfig(
        config: {
          'borderRadius': 8.0,
          'elevation': 2.0,
          'padding': 16.0,
        },
      );

  @deprecated
  static FlexibleWidgetConfig get neumorphicConfig => FlexibleWidgetConfig(
        config: {
          'borderRadius': 16.0,
          'elevation': 0.0,
          'shadowColor': Colors.grey.shade300,
          'padding': 20.0,
        },
      );

  @deprecated
  static FlexibleWidgetConfig get glassmorphicConfig => FlexibleWidgetConfig(
        config: {
          'borderRadius': 20.0,
          'elevation': 0.0,
          'backgroundColor': Colors.white.withValues(alpha: 0.1),
          'padding': 24.0,
        },
      );
}
