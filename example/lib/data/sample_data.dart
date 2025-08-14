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
      description: 'Electronic devices and accessories',
      itemCount: 25,
    ),
    const CategoryModel(
      id: 'fashion',
      name: 'Fashion',
      description: 'Clothing and accessories',
      itemCount: 18,
    ),
    const CategoryModel(
      id: 'home',
      name: 'Home & Garden',
      description: 'Home improvement and garden supplies',
      itemCount: 32,
    ),
    const CategoryModel(
      id: 'sports',
      name: 'Sports & Fitness',
      description: 'Sports equipment and fitness gear',
      itemCount: 15,
    ),
    const CategoryModel(
      id: 'food',
      name: 'Food & Beverages',
      description: 'Fresh food and beverages',
      itemCount: 42,
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
}
