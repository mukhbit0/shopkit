import 'package:equatable/equatable.dart';
import 'variant_model.dart';

/// Model representing a product in the e-commerce system
class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    this.imageUrl,
    this.imageUrls,
    this.description,
    this.rating,
    this.reviewCount,
    this.isInStock = true,
    this.discountPercentage,
    this.tags,
    this.variants,
    this.categoryId,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
  });

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        imageUrl: json['imageUrl'] as String?,
        imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>(),
        description: json['description'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        reviewCount: json['reviewCount'] as int?,
        isInStock: json['isInStock'] as bool? ?? true,
        discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
        tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
        variants: (json['variants'] as List<dynamic>?)
            ?.map((v) => VariantModel.fromJson(v as Map<String, dynamic>))
            .toList(),
        categoryId: json['categoryId'] as String?,
        brand: json['brand'] as String?,
        sku: json['sku'] as String?,
        weight: (json['weight'] as num?)?.toDouble(),
        dimensions: json['dimensions'] as String?,
      );

  /// Unique product identifier
  final String id;

  /// Product name/title
  final String name;

  /// Base price before any discounts
  final double price;

  /// Currency code (USD, EUR, GBP, etc.)
  final String currency;

  /// Main product image URL
  final String? imageUrl;

  /// Additional product images
  final List<String>? imageUrls;

  /// Product description
  final String? description;

  /// Average rating (0-5 scale)
  final double? rating;

  /// Number of reviews
  final int? reviewCount;

  /// Stock availability flag
  final bool isInStock;

  /// Discount percentage (0-100)
  final double? discountPercentage;

  /// Product tags for filtering/search
  final List<String>? tags;

  /// Available product variants (size, color, etc.)
  final List<VariantModel>? variants;

  /// Product category ID
  final String? categoryId;

  /// Product brand
  final String? brand;

  /// SKU (Stock Keeping Unit)
  final String? sku;

  /// Product weight in grams
  final double? weight;

  /// Product dimensions (W x H x D in cm)
  final String? dimensions;

  /// Calculate discounted price
  double get discountedPrice {
    if (discountPercentage == null || discountPercentage! <= 0) {
      return price;
    }
    return price * (1 - discountPercentage! / 100);
  }

  /// Check if product has an active discount
  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  /// Get formatted price string with currency symbol
  String get formattedPrice => _formatPrice(discountedPrice);

  /// Get formatted original price (for strikethrough display)
  String get formattedOriginalPrice => _formatPrice(price);

  /// Get all product images (main + additional)
  List<String> get allImages {
    final images = <String>[];
    if (imageUrl != null) images.add(imageUrl!);
    if (imageUrls != null) images.addAll(imageUrls!);
    return images;
  }

  /// Check if product has variants
  bool get hasVariants => variants != null && variants!.isNotEmpty;

  /// Get available variants by type (e.g., 'color', 'size')
  List<VariantModel> getVariantsByType(String type) {
    if (!hasVariants) return <VariantModel>[];
    return variants!
        .where((VariantModel v) => v.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Convenience getter for category name (fallback to categoryId)
  String? get categoryName => categoryId;

  /// Convenience getter for main image URL
  String? get mainImageUrl {
    if (imageUrls != null && imageUrls!.isNotEmpty) {
      return imageUrls!.first;
    }
    return imageUrl;
  }

  /// Convenience getter for images list
  List<String>? get images => imageUrls;

  /// Convenience getters for widget compatibility
  int? get stockQuantity => isInStock ? 100 : 0; // Default stock level
  String? get shortDescription =>
      description?.length != null && description!.length > 100
          ? '${description!.substring(0, 100)}...'
          : description;
  List<String>? get features => null; // Could be extracted from description
  Map<String, String>? get specifications => null; // Could be structured data

  /// Format price with currency symbol
  String _formatPrice(double amount) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toStringAsFixed(0)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'description': description,
        'rating': rating,
        'reviewCount': reviewCount,
        'isInStock': isInStock,
        'discountPercentage': discountPercentage,
        'tags': tags,
        'variants': variants?.map((VariantModel v) => v.toJson()).toList(),
        'categoryId': categoryId,
        'brand': brand,
        'sku': sku,
        'weight': weight,
        'dimensions': dimensions,
      };

  /// Create a copy with modified properties
  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? imageUrl,
    List<String>? imageUrls,
    String? description,
    double? rating,
    int? reviewCount,
    bool? isInStock,
    double? discountPercentage,
    List<String>? tags,
    List<VariantModel>? variants,
    String? categoryId,
    String? brand,
    String? sku,
    double? weight,
    String? dimensions,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        imageUrl: imageUrl ?? this.imageUrl,
        imageUrls: imageUrls ?? this.imageUrls,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        isInStock: isInStock ?? this.isInStock,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        tags: tags ?? this.tags,
        variants: variants ?? this.variants,
        categoryId: categoryId ?? this.categoryId,
        brand: brand ?? this.brand,
        sku: sku ?? this.sku,
        weight: weight ?? this.weight,
        dimensions: dimensions ?? this.dimensions,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        price,
        currency,
        imageUrl,
        imageUrls,
        description,
        rating,
        reviewCount,
        isInStock,
        discountPercentage,
        tags,
        variants,
        categoryId,
        brand,
        sku,
        weight,
        dimensions,
      ];
}
