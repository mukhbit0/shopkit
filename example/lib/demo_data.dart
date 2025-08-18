import 'package:shopkit/shopkit.dart';

class DemoData {
  static final List<ProductModel> products = [
    const ProductModel(
      id: '1',
      name: 'Wireless Bluetooth Headphones',
      price: 199.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      imageUrls: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400',
      ],
      description: 'Premium wireless headphones with noise cancellation technology.',
      categoryId: '1',
      brand: 'AudioTech',
      rating: 4.8,
      reviewCount: 1247,
      discountPercentage: 20,
      variants: [
        VariantModel(
          id: 'v1',
          name: 'Black',
          type: 'color',
          value: 'Black',
          stockQuantity: 50,
        ),
        VariantModel(
          id: 'v2',
          name: 'White',
          type: 'color',
          value: 'White',
          stockQuantity: 30,
        ),
      ],
    ),
    const ProductModel(
      id: '2',
      name: 'Smart Fitness Watch',
      price: 299.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      imageUrls: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
      ],
      description: 'Track your fitness goals with this advanced smartwatch.',
      categoryId: '2',
      brand: 'FitTech',
      rating: 4.6,
      reviewCount: 892,
    ),
    const ProductModel(
      id: '3',
      name: 'Premium Coffee Mug',
      price: 24.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=400',
      description: 'Elegant ceramic mug perfect for your morning coffee.',
      categoryId: '3',
      brand: 'BrewCraft',
      rating: 4.4,
      reviewCount: 156,
    ),
    const ProductModel(
      id: '4',
      name: 'Minimalist Backpack',
      price: 89.99,
      currency: 'USD',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
      imageUrls: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        'https://images.unsplash.com/photo-1581605405669-fcdf81165afa?w=400',
      ],
      description: 'Sleek and functional backpack for everyday use.',
      categoryId: '4',
      brand: 'UrbanCarry',
      rating: 4.7,
      reviewCount: 324,
    ),
  ];

  static final List<CategoryModel> categories = [
    const CategoryModel(id: '1', name: 'Electronics', itemCount: 15),
    const CategoryModel(id: '2', name: 'Wearables', itemCount: 8),
    const CategoryModel(id: '3', name: 'Home & Kitchen', itemCount: 23),
    const CategoryModel(id: '4', name: 'Accessories', itemCount: 12),
  ];

  static final List<ReviewModel> reviews = [
    ReviewModel(
      id: '1',
      userId: 'user1',
      productId: '1',
      userName: 'Sarah Johnson',
      rating: 5,
      comment: 'Amazing headphones! The sound quality is incredible and the noise cancellation works perfectly.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isVerifiedPurchase: true,
    ),
    ReviewModel(
      id: '2',
      userId: 'user2',
      productId: '1',
      userName: 'Mike Chen',
      rating: 4,
      comment: 'Great product overall. Battery life could be better but still very satisfied.',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      isVerifiedPurchase: true,
    ),
    ReviewModel(
      id: '3',
      userId: 'user3',
      productId: '2',
      userName: 'Emma Wilson',
      rating: 5,
      comment: 'Perfect fitness companion! Tracks everything I need and the app is intuitive.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isVerifiedPurchase: true,
    ),
  ];

  static final CartController cartController = CartController();
  static final WishlistController wishlistController = WishlistController();
}
