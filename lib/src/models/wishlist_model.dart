import 'package:equatable/equatable.dart';
import 'product_model.dart';

/// Model representing a user's wishlist
class WishlistModel extends Equatable {
  const WishlistModel({
    required this.id,
    required this.userId,
    required this.items,
    this.name = 'My Wishlist',
    this.isPublic = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier for the wishlist
  final String id;

  /// ID of the user who owns the wishlist
  final String userId;

  /// List of products in the wishlist
  final List<ProductModel> items;

  /// Name of the wishlist
  final String name;

  /// Whether the wishlist is public or private
  final bool isPublic;

  /// When the wishlist was created
  final DateTime? createdAt;

  /// When the wishlist was last updated
  final DateTime? updatedAt;

  /// Total number of items in wishlist
  int get itemCount => items.length;

  /// Total value of items in wishlist
  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.discountedPrice);

  /// Check if a product is in the wishlist
  bool contains(String productId) => items.any((item) => item.id == productId);

  /// Create WishlistModel from JSON
  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        items: (json['items'] as List<dynamic>)
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        name: json['name'] as String? ?? 'My Wishlist',
        isPublic: json['isPublic'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );

  /// Convert WishlistModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'name': name,
        'isPublic': isPublic,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// Create a copy with modified properties
  WishlistModel copyWith({
    String? id,
    String? userId,
    List<ProductModel>? items,
    String? name,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      WishlistModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        items: items ?? this.items,
        name: name ?? this.name,
        isPublic: isPublic ?? this.isPublic,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Add a product to the wishlist
  WishlistModel addItem(ProductModel product) {
    if (contains(product.id)) return this;

    final updatedItems = [...items, product];
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove a product from the wishlist
  WishlistModel removeItem(String productId) {
    final updatedItems = items.where((item) => item.id != productId).toList();
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
  }

  /// Clear all items from wishlist
  WishlistModel clear() => copyWith(
        items: [],
        updatedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        name,
        isPublic,
        createdAt,
        updatedAt,
      ];
}
