import 'package:equatable/equatable.dart';

import 'category_model.dart';
import 'product_model.dart';

/// Model representing a search suggestion
class SearchSuggestionModel extends Equatable {
  const SearchSuggestionModel({
    required this.id,
    required this.title,
    required this.type,
    this.thumbnailUrl,
    this.resultCount,
    this.relevanceScore,
    this.metadata,
  });

  /// Create SearchSuggestionModel from JSON
  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        resultCount: json['resultCount'] as int?,
        relevanceScore: (json['relevanceScore'] as num?)?.toDouble(),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique suggestion identifier
  final String id;

  /// Suggestion text to display
  final String title;

  /// Type of suggestion (product, category, brand, etc.)
  final String type;

  /// Optional thumbnail image URL
  final String? thumbnailUrl;

  /// Number of results for this suggestion
  final int? resultCount;

  /// Relevance score for ranking
  final double? relevanceScore;

  /// Associated data (product ID, category ID, etc.)
  final Map<String, dynamic>? metadata;

  /// Check if suggestion has thumbnail
  bool get hasThumbnail => thumbnailUrl != null;

  /// Check if suggestion shows result count
  bool get hasResultCount => resultCount != null && resultCount! > 0;

  /// Convert SearchSuggestionModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'type': type,
        'thumbnailUrl': thumbnailUrl,
        'resultCount': resultCount,
        'relevanceScore': relevanceScore,
        'metadata': metadata,
      };

  /// Create a copy with modified properties
  SearchSuggestionModel copyWith({
    String? id,
    String? title,
    String? type,
    String? thumbnailUrl,
    int? resultCount,
    double? relevanceScore,
    Map<String, dynamic>? metadata,
  }) =>
      SearchSuggestionModel(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        resultCount: resultCount ?? this.resultCount,
        relevanceScore: relevanceScore ?? this.relevanceScore,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        type,
        thumbnailUrl,
        resultCount,
        relevanceScore,
        metadata,
      ];
}

/// Model representing search results
class SearchResultModel extends Equatable {
  const SearchResultModel({
    required this.query,
    required this.totalResults,
    required this.products,
    required this.categories,
    required this.suggestions,
    this.searchTime,
    this.wasAutoCorrected = false,
    this.originalQuery,
    this.appliedFilters,
    this.metadata,
  });

  /// Create SearchResultModel from JSON
  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        query: json['query'] as String,
        totalResults: json['totalResults'] as int,
        products: (json['products'] as List<dynamic>)
            .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
            .toList(),
        categories: (json['categories'] as List<dynamic>)
            .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList(),
        suggestions: (json['suggestions'] as List<dynamic>)
            .map((s) =>
                SearchSuggestionModel.fromJson(s as Map<String, dynamic>))
            .toList(),
        searchTime: json['searchTime'] as int?,
        wasAutoCorrected: json['wasAutoCorrected'] as bool? ?? false,
        originalQuery: json['originalQuery'] as String?,
        appliedFilters: json['appliedFilters'] as Map<String, dynamic>?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Search query that was executed
  final String query;

  /// Total number of results found
  final int totalResults;

  /// Products matching the search
  final List<ProductModel> products;

  /// Categories matching the search
  final List<CategoryModel> categories;

  /// Search suggestions for autocomplete
  final List<SearchSuggestionModel> suggestions;

  /// Time taken to execute search (in milliseconds)
  final int? searchTime;

  /// Whether search was corrected (spell check)
  final bool wasAutoCorrected;

  /// Original query before correction
  final String? originalQuery;

  /// Applied filters during search
  final Map<String, dynamic>? appliedFilters;

  /// Search metadata (facets, aggregations, etc.)
  final Map<String, dynamic>? metadata;

  /// Check if search returned any results
  bool get hasResults => totalResults > 0;

  /// Check if search found products
  bool get hasProducts => products.isNotEmpty;

  /// Check if search found categories
  bool get hasCategories => categories.isNotEmpty;

  /// Check if search has suggestions
  bool get hasSuggestions => suggestions.isNotEmpty;

  /// Get formatted search time
  String get formattedSearchTime {
    if (searchTime == null) return '';
    if (searchTime! < 1000) {
      return '${searchTime}ms';
    } else {
      return '${(searchTime! / 1000).toStringAsFixed(2)}s';
    }
  }

  /// Convert SearchResultModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'query': query,
        'totalResults': totalResults,
        'products': products.map((ProductModel p) => p.toJson()).toList(),
        'categories': categories.map((CategoryModel c) => c.toJson()).toList(),
        'suggestions':
            suggestions.map((SearchSuggestionModel s) => s.toJson()).toList(),
        'searchTime': searchTime,
        'wasAutoCorrected': wasAutoCorrected,
        'originalQuery': originalQuery,
        'appliedFilters': appliedFilters,
        'metadata': metadata,
      };

  /// Create a copy with modified properties
  SearchResultModel copyWith({
    String? query,
    int? totalResults,
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    List<SearchSuggestionModel>? suggestions,
    int? searchTime,
    bool? wasAutoCorrected,
    String? originalQuery,
    Map<String, dynamic>? appliedFilters,
    Map<String, dynamic>? metadata,
  }) =>
      SearchResultModel(
        query: query ?? this.query,
        totalResults: totalResults ?? this.totalResults,
        products: products ?? this.products,
        categories: categories ?? this.categories,
        suggestions: suggestions ?? this.suggestions,
        searchTime: searchTime ?? this.searchTime,
        wasAutoCorrected: wasAutoCorrected ?? this.wasAutoCorrected,
        originalQuery: originalQuery ?? this.originalQuery,
        appliedFilters: appliedFilters ?? this.appliedFilters,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => <Object?>[
        query,
        totalResults,
        products,
        categories,
        suggestions,
        searchTime,
        wasAutoCorrected,
        originalQuery,
        appliedFilters,
        metadata,
      ];
}
