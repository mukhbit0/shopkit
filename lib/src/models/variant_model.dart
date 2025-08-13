import 'package:equatable/equatable.dart';

/// Model representing a product variant (size, color, material, etc.)
class VariantModel extends Equatable {
  const VariantModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.stockQuantity,
    this.additionalPrice,
    this.swatchColor,
    this.imageUrl,
    this.isAvailable = true,
    this.sku,
    this.sortOrder,
  });

  /// Create VariantModel from JSON
  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        value: json['value'] as String,
        additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
        stockQuantity: json['stockQuantity'] as int? ?? 0,
        swatchColor: json['swatchColor'] as String?,
        imageUrl: json['imageUrl'] as String?,
        isAvailable: json['isAvailable'] as bool? ?? true,
        sku: json['sku'] as String?,
        sortOrder: json['sortOrder'] as int?,
      );

  /// Unique variant identifier
  final String id;

  /// Variant display name
  final String name;

  /// Variant type (e.g., 'size', 'color', 'material')
  final String type;

  /// Variant value (e.g., 'Large', 'Red', 'Cotton')
  final String value;

  /// Price adjustment from base product price
  final double? additionalPrice;

  /// Current stock quantity for this variant
  final int stockQuantity;

  /// Hex color code for color swatches
  final String? swatchColor;

  /// Variant-specific image URL
  final String? imageUrl;

  /// Whether this variant is available for purchase
  final bool isAvailable;

  /// Variant-specific SKU
  final String? sku;

  /// Sort order for display
  final int? sortOrder;

  /// Check if variant is currently in stock
  bool get isInStock => stockQuantity > 0 && isAvailable;

  /// Check if this is a color variant
  bool get isColorVariant => type.toLowerCase() == 'color';

  /// Check if this is a size variant
  bool get isSizeVariant => type.toLowerCase() == 'size';

  /// Check if variant has a color swatch
  bool get hasColorSwatch => isColorVariant && swatchColor != null;

  /// Check if variant has additional cost
  bool get hasAdditionalCost => additionalPrice != null && additionalPrice != 0;

  /// Get formatted additional price string
  String getFormattedAdditionalPrice(String currency) {
    if (!hasAdditionalCost) return '';

    final amount = additionalPrice!;
    final prefix = amount > 0 ? '+' : '';
    final absAmount = amount.abs();

    switch (currency.toUpperCase()) {
      case 'USD':
        return '$prefix\$${absAmount.toStringAsFixed(2)}';
      case 'EUR':
        return '$prefix€${absAmount.toStringAsFixed(2)}';
      case 'GBP':
        return '$prefix£${absAmount.toStringAsFixed(2)}';
      case 'JPY':
        return '$prefix¥${absAmount.toStringAsFixed(0)}';
      default:
        return '$prefix$currency ${absAmount.toStringAsFixed(2)}';
    }
  }

  /// Get display label with additional price if applicable
  String getDisplayLabel(String currency) {
    final priceStr = getFormattedAdditionalPrice(currency);
    if (priceStr.isEmpty) {
      return value;
    }
    return '$value ($priceStr)';
  }

  /// Convert VariantModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'type': type,
        'value': value,
        'additionalPrice': additionalPrice,
        'stockQuantity': stockQuantity,
        'swatchColor': swatchColor,
        'imageUrl': imageUrl,
        'isAvailable': isAvailable,
        'sku': sku,
        'sortOrder': sortOrder,
      };

  /// Create a copy with modified properties
  VariantModel copyWith({
    String? id,
    String? name,
    String? type,
    String? value,
    double? additionalPrice,
    int? stockQuantity,
    String? swatchColor,
    String? imageUrl,
    bool? isAvailable,
    String? sku,
    int? sortOrder,
  }) =>
      VariantModel(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        value: value ?? this.value,
        additionalPrice: additionalPrice ?? this.additionalPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        swatchColor: swatchColor ?? this.swatchColor,
        imageUrl: imageUrl ?? this.imageUrl,
        isAvailable: isAvailable ?? this.isAvailable,
        sku: sku ?? this.sku,
        sortOrder: sortOrder ?? this.sortOrder,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        type,
        value,
        additionalPrice,
        stockQuantity,
        swatchColor,
        imageUrl,
        isAvailable,
        sku,
        sortOrder,
      ];
}
