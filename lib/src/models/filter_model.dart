import 'package:equatable/equatable.dart';
import 'package:shopkit/src/models/variant_model.dart';
import 'product_model.dart';

/// Enum representing filter types
enum FilterType { range, multiSelect, singleSelect, boolean, rating, price }

/// Model representing a product filter option
class FilterOptionModel extends Equatable {
  const FilterOptionModel({
    required this.id,
    required this.label,
    required this.value,
    this.count,
    this.isSelected = false,
    this.colorHex,
    this.iconUrl,
  });

  /// Create FilterOptionModel from JSON
  factory FilterOptionModel.fromJson(Map<String, dynamic> json) =>
      FilterOptionModel(
        id: json['id'] as String,
        label: json['label'] as String,
        value: json['value'],
        count: json['count'] as int?,
        isSelected: json['isSelected'] as bool? ?? false,
        colorHex: json['colorHex'] as String?,
        iconUrl: json['iconUrl'] as String?,
      );

  /// Unique option identifier
  final String id;

  /// Display label for the option
  final String label;

  /// Option value
  final dynamic value;

  /// Number of products matching this option
  final int? count;

  /// Whether this option is currently selected
  final bool isSelected;

  /// Optional color swatch for color filters
  final String? colorHex;

  /// Optional icon for the filter option
  final String? iconUrl;

  /// Check if option has color swatch
  bool get hasColorSwatch => colorHex != null;

  /// Check if option has icon
  bool get hasIcon => iconUrl != null;

  /// Check if option shows count
  bool get showCount => count != null && count! > 0;

  /// Convert FilterOptionModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'label': label,
        'value': value,
        'count': count,
        'isSelected': isSelected,
        'colorHex': colorHex,
        'iconUrl': iconUrl,
      };

  /// Create a copy with modified properties
  FilterOptionModel copyWith({
    String? id,
    String? label,
    value,
    int? count,
    bool? isSelected,
    String? colorHex,
    String? iconUrl,
  }) =>
      FilterOptionModel(
        id: id ?? this.id,
        label: label ?? this.label,
        value: value ?? this.value,
        count: count ?? this.count,
        isSelected: isSelected ?? this.isSelected,
        colorHex: colorHex ?? this.colorHex,
        iconUrl: iconUrl ?? this.iconUrl,
      );

  @override
  List<Object?> get props =>
      <Object?>[id, label, value, count, isSelected, colorHex, iconUrl];
}

/// Model representing a product filter
class FilterModel extends Equatable {
  const FilterModel({
    required this.id,
    required this.name,
    required this.type,
    required this.options,
    this.selectedValues = const <dynamic>[],
    this.minValue,
    this.maxValue,
    this.currentRange,
    this.isRequired = false,
    this.isExpanded = true,
    this.sortOrder = 0,
    this.group,
  });

  /// Create FilterModel from JSON
  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: FilterType.values.firstWhere(
          (FilterType e) => e.toString().split('.').last == json['type'],
        ),
        options: (json['options'] as List<dynamic>)
            .map((o) => FilterOptionModel.fromJson(o as Map<String, dynamic>))
            .toList(),
        selectedValues: json['selectedValues'] as List<dynamic>? ?? <dynamic>[],
        minValue: (json['minValue'] as num?)?.toDouble(),
        maxValue: (json['maxValue'] as num?)?.toDouble(),
        currentRange: (json['currentRange'] as List<dynamic>?)?.cast<double>(),
        isRequired: json['isRequired'] as bool? ?? false,
        isExpanded: json['isExpanded'] as bool? ?? true,
        sortOrder: json['sortOrder'] as int? ?? 0,
        group: json['group'] as String?,
      );

  /// Unique filter identifier
  final String id;

  /// Filter display name
  final String name;

  /// Filter type
  final FilterType type;

  /// Available filter options
  final List<FilterOptionModel> options;

  /// Current selected values
  final List<dynamic> selectedValues;

  /// Minimum value for range filters
  final double? minValue;

  /// Maximum value for range filters
  final double? maxValue;

  /// Current range values [min, max]
  final List<double>? currentRange;

  /// Whether this filter is required
  final bool isRequired;

  /// Whether this filter is currently expanded in UI
  final bool isExpanded;

  /// Sort order for display
  final int sortOrder;

  /// Filter category/group
  final String? group;

  /// Check if filter has any selected values
  bool get hasSelection =>
      selectedValues.isNotEmpty ||
      (currentRange != null && currentRange!.isNotEmpty);

  /// Check if filter is a range type
  bool get isRangeFilter =>
      type == FilterType.range || type == FilterType.price;

  /// Check if filter allows multiple selections
  bool get allowsMultipleSelection => type == FilterType.multiSelect;

  /// Get selected options
  List<FilterOptionModel> get selectedOptions =>
      options.where((FilterOptionModel option) => option.isSelected).toList();

  /// Get total count of products matching all selected options
  int get totalSelectedCount => selectedOptions.fold(
      0, (int sum, FilterOptionModel option) => sum + (option.count ?? 0));

  /// Apply filter to list of products
  List<ProductModel> applyToProducts(List<ProductModel> products) {
    if (!hasSelection) return products;

    return products.where((ProductModel product) {
      switch (type) {
        case FilterType.price:
          if (currentRange != null && currentRange!.length == 2) {
            return product.discountedPrice >= currentRange![0] &&
                product.discountedPrice <= currentRange![1];
          }
          return true;

        case FilterType.rating:
          if (selectedValues.isNotEmpty) {
            final minRating = selectedValues.first as double;
            return (product.rating ?? 0) >= minRating;
          }
          return true;

        case FilterType.multiSelect:
        case FilterType.singleSelect:
          if (selectedValues.isEmpty) return true;

          // Check against product tags, category, brand, etc.
          return _matchesProductAttributes(product, selectedValues);

        case FilterType.boolean:
          if (selectedValues.isNotEmpty) {
            final boolValue = selectedValues.first as bool;
            return _matchesBooleanFilter(product, boolValue);
          }
          return true;

        case FilterType.range:
          if (currentRange != null && currentRange!.length == 2) {
            return _matchesRangeFilter(
                product, currentRange![0], currentRange![1]);
          }
          return true;
      }
    }).toList();
  }

  bool _matchesProductAttributes(ProductModel product, List<dynamic> values) {
    // Match against various product attributes based on filter ID
    switch (id.toLowerCase()) {
      case 'category':
        return values.contains(product.categoryId);
      case 'brand':
        return values.contains(product.brand);
      case 'color':
        return product.variants?.any((VariantModel v) =>
                v.type.toLowerCase() == 'color' && values.contains(v.value)) ??
            false;
      case 'size':
        return product.variants?.any((VariantModel v) =>
                v.type.toLowerCase() == 'size' && values.contains(v.value)) ??
            false;
      case 'tags':
        return product.tags?.any((String tag) => values.contains(tag)) ?? false;
      default:
        return true;
    }
  }

  bool _matchesBooleanFilter(ProductModel product, bool value) {
    switch (id.toLowerCase()) {
      case 'in_stock':
        return product.isInStock == value;
      case 'on_sale':
        return product.hasDiscount == value;
      default:
        return true;
    }
  }

  bool _matchesRangeFilter(ProductModel product, double min, double max) {
    switch (id.toLowerCase()) {
      case 'weight':
        return product.weight != null &&
            product.weight! >= min &&
            product.weight! <= max;
      default:
        return true;
    }
  }

  /// Convert FilterModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'type': type.toString().split('.').last,
        'options': options.map((FilterOptionModel o) => o.toJson()).toList(),
        'selectedValues': selectedValues,
        'minValue': minValue,
        'maxValue': maxValue,
        'currentRange': currentRange,
        'isRequired': isRequired,
        'isExpanded': isExpanded,
        'sortOrder': sortOrder,
        'group': group,
      };

  /// Create a copy with modified properties
  FilterModel copyWith({
    String? id,
    String? name,
    FilterType? type,
    List<FilterOptionModel>? options,
    List<dynamic>? selectedValues,
    double? minValue,
    double? maxValue,
    List<double>? currentRange,
    bool? isRequired,
    bool? isExpanded,
    int? sortOrder,
    String? group,
  }) =>
      FilterModel(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        options: options ?? this.options,
        selectedValues: selectedValues ?? this.selectedValues,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
        currentRange: currentRange ?? this.currentRange,
        isRequired: isRequired ?? this.isRequired,
        isExpanded: isExpanded ?? this.isExpanded,
        sortOrder: sortOrder ?? this.sortOrder,
        group: group ?? this.group,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        type,
        options,
        selectedValues,
        minValue,
        maxValue,
        currentRange,
        isRequired,
        isExpanded,
        sortOrder,
        group,
      ];
}
