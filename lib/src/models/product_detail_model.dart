import 'package:equatable/equatable.dart';
import 'product_model.dart';
import 'review_model.dart';
import 'image_model.dart';

/// Model representing detailed product information for product detail views
class ProductDetailModel extends Equatable {
  const ProductDetailModel({
    required this.product,
    this.reviews = const [],
    this.images = const [],
    this.relatedProducts = const [],
    this.specifications = const {},
    this.shippingInfo,
    this.returnPolicy,
    this.warranty,
    this.availability,
    this.tabs = const [],
  });

  /// Base product information
  final ProductModel product;

  /// Product reviews
  final List<ReviewModel> reviews;

  /// Detailed product images
  final List<ImageModel> images;

  /// Related/recommended products
  final List<ProductModel> relatedProducts;

  /// Product specifications as key-value pairs
  final Map<String, String> specifications;

  /// Shipping information
  final String? shippingInfo;

  /// Return policy information
  final String? returnPolicy;

  /// Warranty information
  final String? warranty;

  /// Detailed availability information
  final ProductAvailability? availability;

  /// Additional tabs for product details
  final List<ProductTabModel> tabs;

  /// Get average rating from reviews
  double get averageRating {
    if (reviews.isEmpty) return product.rating ?? 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  /// Get total review count
  int get totalReviews => reviews.length;

  /// Get primary image URL
  String? get primaryImageUrl {
    if (images.isNotEmpty) return images.first.url;
    return product.imageUrl;
  }

  /// Get all image URLs
  List<String> get allImageUrls {
    final urls = <String>[];
    if (product.imageUrl != null) urls.add(product.imageUrl!);
    if (product.imageUrls != null) urls.addAll(product.imageUrls!);
    urls.addAll(images.map((img) => img.url));
    return urls.toSet().toList(); // Remove duplicates
  }

  /// Create ProductDetailModel from JSON
  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        reviews: (json['reviews'] as List<dynamic>?)
                ?.map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
                .toList() ??
            const [],
        images: (json['images'] as List<dynamic>?)
                ?.map((i) => ImageModel.fromJson(i as Map<String, dynamic>))
                .toList() ??
            const [],
        relatedProducts: (json['relatedProducts'] as List<dynamic>?)
                ?.map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
        specifications: Map<String, String>.from(json['specifications'] ?? {}),
        shippingInfo: json['shippingInfo'] as String?,
        returnPolicy: json['returnPolicy'] as String?,
        warranty: json['warranty'] as String?,
        availability: json['availability'] != null
            ? ProductAvailability.fromJson(
                json['availability'] as Map<String, dynamic>)
            : null,
        tabs: (json['tabs'] as List<dynamic>?)
                ?.map(
                    (t) => ProductTabModel.fromJson(t as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  /// Convert ProductDetailModel to JSON
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'reviews': reviews.map((r) => r.toJson()).toList(),
        'images': images.map((i) => i.toJson()).toList(),
        'relatedProducts': relatedProducts.map((p) => p.toJson()).toList(),
        'specifications': specifications,
        'shippingInfo': shippingInfo,
        'returnPolicy': returnPolicy,
        'warranty': warranty,
        'availability': availability?.toJson(),
        'tabs': tabs.map((t) => t.toJson()).toList(),
      };

  /// Create a copy with modified properties
  ProductDetailModel copyWith({
    ProductModel? product,
    List<ReviewModel>? reviews,
    List<ImageModel>? images,
    List<ProductModel>? relatedProducts,
    Map<String, String>? specifications,
    String? shippingInfo,
    String? returnPolicy,
    String? warranty,
    ProductAvailability? availability,
    List<ProductTabModel>? tabs,
  }) =>
      ProductDetailModel(
        product: product ?? this.product,
        reviews: reviews ?? this.reviews,
        images: images ?? this.images,
        relatedProducts: relatedProducts ?? this.relatedProducts,
        specifications: specifications ?? this.specifications,
        shippingInfo: shippingInfo ?? this.shippingInfo,
        returnPolicy: returnPolicy ?? this.returnPolicy,
        warranty: warranty ?? this.warranty,
        availability: availability ?? this.availability,
        tabs: tabs ?? this.tabs,
      );

  @override
  List<Object?> get props => [
        product,
        reviews,
        images,
        relatedProducts,
        specifications,
        shippingInfo,
        returnPolicy,
        warranty,
        availability,
        tabs,
      ];
}

/// Model representing product availability details
class ProductAvailability extends Equatable {
  const ProductAvailability({
    required this.isInStock,
    this.quantity,
    this.restockDate,
    this.backorderAllowed = false,
    this.preorderAllowed = false,
    this.stockLevel = StockLevel.inStock,
    this.locationAvailability = const {},
  });

  /// Whether the product is in stock
  final bool isInStock;

  /// Available quantity (if disclosed)
  final int? quantity;

  /// Expected restock date
  final DateTime? restockDate;

  /// Whether backorders are allowed
  final bool backorderAllowed;

  /// Whether preorders are allowed
  final bool preorderAllowed;

  /// Stock level indicator
  final StockLevel stockLevel;

  /// Availability by location/warehouse
  final Map<String, bool> locationAvailability;

  /// Create ProductAvailability from JSON
  factory ProductAvailability.fromJson(Map<String, dynamic> json) =>
      ProductAvailability(
        isInStock: json['isInStock'] as bool,
        quantity: json['quantity'] as int?,
        restockDate: json['restockDate'] != null
            ? DateTime.parse(json['restockDate'] as String)
            : null,
        backorderAllowed: json['backorderAllowed'] as bool? ?? false,
        preorderAllowed: json['preorderAllowed'] as bool? ?? false,
        stockLevel: StockLevel.values.firstWhere(
          (e) => e.toString().split('.').last == json['stockLevel'],
          orElse: () => StockLevel.inStock,
        ),
        locationAvailability:
            Map<String, bool>.from(json['locationAvailability'] ?? {}),
      );

  /// Convert ProductAvailability to JSON
  Map<String, dynamic> toJson() => {
        'isInStock': isInStock,
        'quantity': quantity,
        'restockDate': restockDate?.toIso8601String(),
        'backorderAllowed': backorderAllowed,
        'preorderAllowed': preorderAllowed,
        'stockLevel': stockLevel.toString().split('.').last,
        'locationAvailability': locationAvailability,
      };

  @override
  List<Object?> get props => [
        isInStock,
        quantity,
        restockDate,
        backorderAllowed,
        preorderAllowed,
        stockLevel,
        locationAvailability,
      ];
}

/// Stock level indicators
enum StockLevel {
  inStock,
  lowStock,
  outOfStock,
  preorder,
  backorder,
  discontinued,
}

/// Model representing a product detail tab
class ProductTabModel extends Equatable {
  const ProductTabModel({
    required this.id,
    required this.title,
    required this.content,
    this.isActive = false,
    this.order = 0,
    this.icon,
  });

  /// Unique identifier for the tab
  final String id;

  /// Tab title
  final String title;

  /// Tab content (HTML or markdown)
  final String content;

  /// Whether this tab is currently active
  final bool isActive;

  /// Display order of the tab
  final int order;

  /// Optional icon for the tab
  final String? icon;

  /// Create ProductTabModel from JSON
  factory ProductTabModel.fromJson(Map<String, dynamic> json) =>
      ProductTabModel(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        isActive: json['isActive'] as bool? ?? false,
        order: json['order'] as int? ?? 0,
        icon: json['icon'] as String?,
      );

  /// Convert ProductTabModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isActive': isActive,
        'order': order,
        'icon': icon,
      };

  /// Create a copy with modified properties
  ProductTabModel copyWith({
    String? id,
    String? title,
    String? content,
    bool? isActive,
    int? order,
    String? icon,
  }) =>
      ProductTabModel(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        isActive: isActive ?? this.isActive,
        order: order ?? this.order,
        icon: icon ?? this.icon,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        isActive,
        order,
        icon,
      ];
}
