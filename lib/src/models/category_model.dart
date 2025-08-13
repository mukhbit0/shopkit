import 'package:equatable/equatable.dart';

/// Model representing a product category
class CategoryModel extends Equatable {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.itemCount,
    this.description,
    this.iconUrl,
    this.imageUrl,
    this.parentId,
    this.childIds,
    this.isActive = true,
    this.sortOrder = 0,
    this.slug,
    this.metadata,
  });

  /// Create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        itemCount: json['itemCount'] as int? ?? 0,
        iconUrl: json['iconUrl'] as String?,
        imageUrl: json['imageUrl'] as String?,
        parentId: json['parentId'] as String?,
        childIds: (json['childIds'] as List<dynamic>?)?.cast<String>(),
        isActive: json['isActive'] as bool? ?? true,
        sortOrder: json['sortOrder'] as int? ?? 0,
        slug: json['slug'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique category identifier
  final String id;

  /// Category display name
  final String name;

  /// Category description
  final String? description;

  /// Number of products in this category
  final int itemCount;

  /// Category icon URL or asset path
  final String? iconUrl;

  /// Category banner/hero image URL
  final String? imageUrl;

  /// Parent category ID (for nested categories)
  final String? parentId;

  /// Child category IDs
  final List<String>? childIds;

  /// Whether category is active/visible
  final bool isActive;

  /// Sort order for display
  final int sortOrder;

  /// SEO-friendly URL slug
  final String? slug;

  /// Category metadata for filtering
  final Map<String, dynamic>? metadata;

  /// Check if category has child categories
  bool get hasChildren => childIds != null && childIds!.isNotEmpty;

  /// Check if category is a root category (no parent)
  bool get isRootCategory => parentId == null;

  /// Check if category is a leaf category (no children)
  bool get isLeafCategory => !hasChildren;

  /// Convert CategoryModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'itemCount': itemCount,
        'iconUrl': iconUrl,
        'imageUrl': imageUrl,
        'parentId': parentId,
        'childIds': childIds,
        'isActive': isActive,
        'sortOrder': sortOrder,
        'slug': slug,
        'metadata': metadata,
      };

  /// Create a copy with modified properties
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    int? itemCount,
    String? iconUrl,
    String? imageUrl,
    String? parentId,
    List<String>? childIds,
    bool? isActive,
    int? sortOrder,
    String? slug,
    Map<String, dynamic>? metadata,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        itemCount: itemCount ?? this.itemCount,
        iconUrl: iconUrl ?? this.iconUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        parentId: parentId ?? this.parentId,
        childIds: childIds ?? this.childIds,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        slug: slug ?? this.slug,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        description,
        itemCount,
        iconUrl,
        imageUrl,
        parentId,
        childIds,
        isActive,
        sortOrder,
        slug,
        metadata,
      ];
}
