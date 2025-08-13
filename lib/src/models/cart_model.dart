import 'package:equatable/equatable.dart';
import 'product_model.dart';
import 'variant_model.dart';

/// Model representing an item in the shopping cart
class CartItemModel extends Equatable {
  CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.pricePerItem,
    this.variant,
    DateTime? addedAt,
    this.notes,
  }) : addedAt = addedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String,
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        variant: json['variant'] != null
            ? VariantModel.fromJson(json['variant'] as Map<String, dynamic>)
            : null,
        quantity: json['quantity'] as int,
        pricePerItem: (json['pricePerItem'] as num).toDouble(),
        addedAt: json['addedAt'] != null
            ? DateTime.parse(json['addedAt'] as String)
            : DateTime.now(),
        notes: json['notes'] as String?,
      );

  /// Unique cart item identifier
  final String id;

  /// Product associated with this cart item
  final ProductModel product;

  /// Selected product variant (if any)
  final VariantModel? variant;

  /// Quantity of items
  final int quantity;

  /// Price per item at the time of adding to cart
  final double pricePerItem;

  /// Timestamp when item was added to cart
  final DateTime addedAt;

  /// Custom notes or instructions for this item
  final String? notes;

  /// Calculate total price for this cart item
  double get totalPrice => quantity * pricePerItem;

  /// Get display name including variant information
  String get displayName {
    if (variant != null) {
      return '${product.name} - ${variant!.value}';
    }
    return product.name;
  }

  /// Check if cart item is valid (product in stock, variant available, etc.)
  bool get isValid {
    if (!product.isInStock) return false;
    if (variant != null && !variant!.isInStock) return false;
    if (variant != null && variant!.stockQuantity < quantity) return false;
    return quantity > 0;
  }

  /// Get formatted total price
  String getFormattedTotal(String currency) =>
      _formatPrice(totalPrice, currency);

  /// Get formatted unit price
  String getFormattedUnitPrice(String currency) =>
      _formatPrice(pricePerItem, currency);

  String _formatPrice(double amount, String currency) {
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

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'product': product.toJson(),
        'variant': variant?.toJson(),
        'quantity': quantity,
        'pricePerItem': pricePerItem,
        'addedAt': addedAt.toIso8601String(),
        'notes': notes,
      };

  /// Create a copy with modified properties
  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    VariantModel? variant,
    int? quantity,
    double? pricePerItem,
    DateTime? addedAt,
    String? notes,
  }) =>
      CartItemModel(
        id: id ?? this.id,
        product: product ?? this.product,
        variant: variant ?? this.variant,
        quantity: quantity ?? this.quantity,
        pricePerItem: pricePerItem ?? this.pricePerItem,
        addedAt: addedAt ?? this.addedAt,
        notes: notes ?? this.notes,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        product,
        variant,
        quantity,
        pricePerItem,
        addedAt,
        notes,
      ];
}

/// Model representing the complete shopping cart
class CartModel extends Equatable {
  CartModel({
    required this.id,
    required this.items,
    required this.currency,
    this.tax,
    this.shipping,
    this.discount,
    this.promoCode,
    DateTime? updatedAt,
    this.userId,
  }) : updatedAt = updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Create empty cart
  factory CartModel.empty({String? id, String currency = 'USD'}) => CartModel(
        id: id ??
            'cart_${DateTime.fromMillisecondsSinceEpoch(0).millisecondsSinceEpoch}',
        items: const <CartItemModel>[],
        currency: currency,
      );

  /// Create CartModel from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'] as String,
        items: (json['items'] as List<dynamic>)
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        tax: (json['tax'] as num?)?.toDouble(),
        shipping: (json['shipping'] as num?)?.toDouble(),
        discount: (json['discount'] as num?)?.toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        promoCode: json['promoCode'] as String?,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
        userId: json['userId'] as String?,
      );

  /// Unique cart identifier
  final String id;

  /// List of items in the cart
  final List<CartItemModel> items;

  /// Tax amount
  final double? tax;

  /// Shipping cost
  final double? shipping;

  /// Applied discount amount
  final double? discount;

  /// Cart currency
  final String currency;

  /// Applied promo code
  final String? promoCode;

  /// Last updated timestamp
  final DateTime updatedAt;

  /// User ID who owns this cart
  final String? userId;

  /// Calculate subtotal (sum of all item totals)
  double get subtotal => items.fold(
      0.0, (double sum, CartItemModel item) => sum + item.totalPrice);

  /// Calculate final total with tax, shipping, and discount
  double get total => subtotal + (tax ?? 0) + (shipping ?? 0) - (discount ?? 0);

  /// Get total number of items in cart
  int get itemCount =>
      items.fold(0, (int sum, CartItemModel item) => sum + item.quantity);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get formatted subtotal
  String get formattedSubtotal => _formatPrice(subtotal);

  /// Get formatted total
  String get formattedTotal => _formatPrice(total);

  /// Get formatted tax
  String get formattedTax => tax != null ? _formatPrice(tax!) : _formatPrice(0);

  /// Get formatted shipping
  String get formattedShipping =>
      shipping != null ? _formatPrice(shipping!) : _formatPrice(0);

  /// Get formatted discount
  String get formattedDiscount =>
      discount != null ? _formatPrice(discount!) : _formatPrice(0);

  String _formatPrice(double amount) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\${amount.toStringAsFixed(2)}';
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

  /// Find cart item by product and variant
  CartItemModel? findItem(String productId, {VariantModel? variant}) =>
      items.cast<CartItemModel?>().firstWhere(
            (CartItemModel? item) =>
                item!.product.id == productId &&
                ((variant == null && item.variant == null) ||
                    (variant != null && item.variant?.id == variant.id)),
            orElse: () => null,
          );

  /// Check if product with variant exists in cart
  bool containsItem(String productId, {VariantModel? variant}) =>
      findItem(productId, variant: variant) != null;

  /// Convert CartModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'items': items.map((CartItemModel item) => item.toJson()).toList(),
        'tax': tax,
        'shipping': shipping,
        'discount': discount,
        'currency': currency,
        'promoCode': promoCode,
        'updatedAt': updatedAt.toIso8601String(),
        'userId': userId,
      };

  /// Create a copy with modified properties
  CartModel copyWith({
    String? id,
    List<CartItemModel>? items,
    double? tax,
    double? shipping,
    double? discount,
    String? currency,
    String? promoCode,
    DateTime? updatedAt,
    String? userId,
  }) =>
      CartModel(
        id: id ?? this.id,
        items: items ?? this.items,
        tax: tax ?? this.tax,
        shipping: shipping ?? this.shipping,
        discount: discount ?? this.discount,
        currency: currency ?? this.currency,
        promoCode: promoCode ?? this.promoCode,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        items,
        tax,
        shipping,
        discount,
        currency,
        promoCode,
        updatedAt,
        userId,
      ];
}
