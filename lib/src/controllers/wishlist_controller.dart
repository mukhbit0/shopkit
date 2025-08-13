import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

/// Controller for managing wishlist state in a headless architecture
///
/// This controller provides all the logic for wishlist operations while
/// remaining UI-agnostic, allowing for flexible state management integration
class WishlistController extends ChangeNotifier {
  List<ProductModel> _items = <ProductModel>[];
  bool _isLoading = false;
  String? _userId;

  /// Current wishlist items
  List<ProductModel> get items => List.unmodifiable(_items);

  /// Whether wishlist operations are currently loading
  bool get isLoading => _isLoading;

  /// Current user ID
  String? get userId => _userId;

  /// Number of items in wishlist
  int get itemCount => _items.length;

  /// Whether wishlist is empty
  bool get isEmpty => _items.isEmpty;

  /// Whether wishlist has items
  bool get isNotEmpty => _items.isNotEmpty;

  /// Set of product IDs in wishlist for quick lookup
  Set<String> get productIds =>
      _items.map((ProductModel item) => item.id).toSet();

  /// Initialize wishlist with existing data
  void initializeWishlist(List<ProductModel> items, {String? userId}) {
    _items = List.from(items);
    _userId = userId;
    notifyListeners();
  }

  /// Add product to wishlist
  Future<bool> addToWishlist(ProductModel product) async {
    if (isInWishlist(product.id)) {
      return false; // Already in wishlist
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _items.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      // Handle error (log, show message, etc.)
      debugPrint('Failed to add to wishlist: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove product from wishlist
  Future<bool> removeFromWishlist(String productId) async {
    if (!isInWishlist(productId)) {
      return false; // Not in wishlist
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _items.removeWhere((ProductModel item) => item.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      // Handle error
      debugPrint('Failed to remove from wishlist: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle product in wishlist (add if not present, remove if present)
  Future<bool> toggleWishlist(ProductModel product) async {
    if (isInWishlist(product.id)) {
      return removeFromWishlist(product.id);
    } else {
      return addToWishlist(product);
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(String productId) =>
      _items.any((ProductModel item) => item.id == productId);

  /// Get product from wishlist by ID
  ProductModel? getProduct(String productId) {
    try {
      return _items.firstWhere((ProductModel item) => item.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Clear entire wishlist
  Future<void> clearWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      _items.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Move all wishlist items to cart (if cart controller provided)
  Future<void> moveAllToCart(
      Future<void> Function(ProductModel) addToCartCallback) async {
    if (_items.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Add each item to cart
      for (final product in List.from(_items)) {
        await addToCartCallback(product);
        await removeFromWishlist(product.id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter wishlist items by category
  List<ProductModel> getItemsByCategory(String categoryId) => _items
      .where((ProductModel item) => item.categoryId == categoryId)
      .toList();

  /// Filter wishlist items by price range
  List<ProductModel> getItemsByPriceRange(double minPrice, double maxPrice) =>
      _items.where((ProductModel item) {
        final double price = item.discountedPrice;
        return price >= minPrice && price <= maxPrice;
      }).toList();

  /// Filter wishlist items by availability
  List<ProductModel> getAvailableItems() =>
      _items.where((ProductModel item) => item.isInStock).toList();

  /// Filter wishlist items by discount
  List<ProductModel> getItemsOnSale() =>
      _items.where((ProductModel item) => item.hasDiscount).toList();

  /// Sort wishlist items by price (ascending or descending)
  List<ProductModel> sortByPrice({bool ascending = true}) {
    final sorted = List<ProductModel>.from(_items);
    sorted.sort((ProductModel a, ProductModel b) {
      final priceA = a.discountedPrice;
      final priceB = b.discountedPrice;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    return sorted;
  }

  /// Sort wishlist items by name
  List<ProductModel> sortByName({bool ascending = true}) {
    final sorted = List<ProductModel>.from(_items);
    sorted.sort((ProductModel a, ProductModel b) =>
        ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return sorted;
  }

  /// Sort wishlist items by rating
  List<ProductModel> sortByRating({bool ascending = false}) {
    final sorted = List<ProductModel>.from(_items);
    sorted.sort((ProductModel a, ProductModel b) {
      final ratingA = a.rating ?? 0;
      final ratingB = b.rating ?? 0;
      return ascending
          ? ratingA.compareTo(ratingB)
          : ratingB.compareTo(ratingA);
    });
    return sorted;
  }

  /// Get wishlist statistics
  Map<String, dynamic> getStatistics() {
    if (_items.isEmpty) {
      return <String, dynamic>{
        'totalItems': 0,
        'totalValue': 0.0,
        'averagePrice': 0.0,
        'inStockItems': 0,
        'onSaleItems': 0,
      };
    }

    final totalValue = _items.fold(
        0.0, (double sum, ProductModel item) => sum + item.discountedPrice);
    final inStockCount =
        _items.where((ProductModel item) => item.isInStock).length;
    final onSaleCount =
        _items.where((ProductModel item) => item.hasDiscount).length;

    return <String, dynamic>{
      'totalItems': _items.length,
      'totalValue': totalValue,
      'averagePrice': totalValue / _items.length,
      'inStockItems': inStockCount,
      'onSaleItems': onSaleCount,
    };
  }

  /// Export wishlist data for analytics or backup
  Map<String, dynamic> exportWishlist() => <String, dynamic>{
        'user_id': _userId,
        'items': _items
            .map((ProductModel item) => <String, Object>{
                  'product_id': item.id,
                  'product_name': item.name,
                  'price': item.price,
                  'discounted_price': item.discountedPrice,
                  'currency': item.currency,
                  'in_stock': item.isInStock,
                  'has_discount': item.hasDiscount,
                })
            .toList(),
        'statistics': getStatistics(),
        'exported_at': DateTime.now().toIso8601String(),
      };

  /// Load wishlist from JSON data
  Future<void> loadFromJson(Map<String, dynamic> json) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userId = json['userId'] as String?;
      final itemsJson = json['items'] as List<dynamic>? ?? <dynamic>[];
      _items = itemsJson
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Convert wishlist to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': _userId,
        'items': _items.map((ProductModel item) => item.toJson()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
}
