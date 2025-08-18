import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../models/variant_model.dart';

/// Controller for managing cart state in a headless architecture
///
/// This controller provides all the logic for cart operations while
/// remaining UI-agnostic, allowing for flexible state management integration
class CartController extends ChangeNotifier {
  CartModel _cart = CartModel.empty();

  /// Current cart state
  CartModel get cart => _cart;

  /// Whether cart operations are currently loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Set of product IDs currently being added to cart
  final Set<String> _addingToCartProductIds = <String>{};
  Set<String> get addingToCartProductIds => Set.from(_addingToCartProductIds);

  /// Initialize cart with existing data
  void initializeCart(CartModel cart) {
    _cart = cart;
    notifyListeners();
  }

  /// Add item to cart or update quantity if already exists
  Future<void> addToCart(
    ProductModel product, {
    VariantModel? variant,
    int quantity = 1,
    String? notes,
  }) async {
    if (quantity <= 0) return;

    _addingToCartProductIds.add(product.id);
    notifyListeners();

    try {
      // Simulate network delay for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));

      final existingItem = _cart.findItem(product.id, variant: variant);

      if (existingItem != null) {
        // Update existing item
        await updateQuantity(existingItem.id, existingItem.quantity + quantity);
      } else {
        // Add new item
        final newItem = CartItemModel.createSafe(
          product: product,
          variant: variant,
          quantity: quantity,
          pricePerItem: product.discountedPrice + (variant?.additionalPrice ?? 0),
          addedAt: DateTime.now(),
          notes: notes,
        );

        _cart = _cart.copyWith(
          items: <CartItemModel>[..._cart.items, newItem],
          updatedAt: DateTime.now(),
        );
      }
    } finally {
      _addingToCartProductIds.remove(product.id);
      notifyListeners();
    }
  }

  /// Update quantity of specific cart item
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeItem(itemId);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedItems = _cart.items.map((CartItemModel item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();

      _cart = _cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove specific item from cart
  Future<void> removeItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedItems =
          _cart.items.where((CartItemModel item) => item.id != itemId).toList();

      _cart = _cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      _cart = CartModel.empty(
        id: _cart.id,
        currency: _cart.currency,
      ).copyWith(userId: _cart.userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply discount/promo code
  Future<bool> applyPromoCode(String promoCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network request to validate promo code
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock promo code validation
      final discount = _calculateDiscount(promoCode);

      if (discount > 0) {
        _cart = _cart.copyWith(
          promoCode: promoCode,
          discount: discount,
          updatedAt: DateTime.now(),
        );
        return true;
      }

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove applied promo code
  void removePromoCode() {
    _cart = _cart.copyWith(
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update tax amount
  void updateTax(double tax) {
    _cart = _cart.copyWith(
      tax: tax,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update shipping cost
  void updateShipping(double shipping) {
    _cart = _cart.copyWith(
      shipping: shipping,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Get cart item count for specific product and variant
  int getItemQuantity(String productId, {VariantModel? variant}) {
    final item = _cart.findItem(productId, variant: variant);
    return item?.quantity ?? 0;
  }

  /// Check if product with variant is in cart
  bool isInCart(String productId, {VariantModel? variant}) =>
      _cart.containsItem(productId, variant: variant);

  /// Get total number of items in cart
  int get totalItems => _cart.itemCount;

  /// Get cart subtotal
  double get subtotal => _cart.subtotal;

  /// Get cart total
  double get total => _cart.total;

  /// Check if cart is empty
  bool get isEmpty => _cart.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => _cart.isNotEmpty;

  /// Mock discount calculation based on promo code
  double _calculateDiscount(String promoCode) {
    switch (promoCode.toUpperCase()) {
      case 'SAVE10':
        return _cart.subtotal * 0.10; // 10% discount
      case 'SAVE20':
        return _cart.subtotal * 0.20; // 20% discount
      case 'WELCOME':
        return 5.0; // $5 off
      case 'FREESHIP':
        return _cart.shipping ?? 0; // Free shipping
      default:
        return 0.0; // Invalid code
    }
  }

  /// Validate cart items (check stock, availability, etc.)
  List<CartItemModel> getInvalidItems() =>
      _cart.items.where((CartItemModel item) => !item.isValid).toList();

  /// Export cart for analytics or external systems
  Map<String, dynamic> exportCart() => <String, dynamic>{
        'cart_id': _cart.id,
        'items': _cart.items
            .map((CartItemModel item) => <String, Object?>{
                  'product_id': item.product.id,
                  'product_name': item.product.name,
                  'variant_id': item.variant?.id,
                  'quantity': item.quantity,
                  'unit_price': item.pricePerItem,
                  'total_price': item.totalPrice,
                })
            .toList(),
        'subtotal': _cart.subtotal,
        'tax': _cart.tax,
        'shipping': _cart.shipping,
        'discount': _cart.discount,
        'total': _cart.total,
        'currency': _cart.currency,
        'promo_code': _cart.promoCode,
        'updated_at': _cart.updatedAt.toIso8601String(),
      };
}
