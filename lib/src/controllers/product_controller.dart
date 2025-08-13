import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/filter_model.dart';
import '../models/search_model.dart';

/// Controller for managing product catalog state in a headless architecture
///
/// This controller handles product loading, filtering, searching, and pagination
/// while remaining UI-agnostic for flexible state management integration
class ProductController extends ChangeNotifier {
  List<ProductModel> _allProducts = <ProductModel>[];
  List<ProductModel> _filteredProducts = <ProductModel>[];
  List<CategoryModel> _categories = <CategoryModel>[];
  List<FilterModel> _availableFilters = <FilterModel>[];
  SearchResultModel? _lastSearchResult;

  bool _isLoading = false;
  bool _isSearching = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int _pageSize = 20;
  String? _currentQuery;
  String? _selectedCategoryId;
  String _sortBy = 'name';
  bool _sortAscending = true;

  /// All loaded products
  List<ProductModel> get allProducts => List.unmodifiable(_allProducts);

  /// Currently filtered/displayed products
  List<ProductModel> get products => List.unmodifiable(_filteredProducts);

  /// Available categories
  List<CategoryModel> get categories => List.unmodifiable(_categories);

  /// Available filters
  List<FilterModel> get filters => List.unmodifiable(_availableFilters);

  /// Last search result
  SearchResultModel? get lastSearchResult => _lastSearchResult;

  /// Whether products are currently loading
  bool get isLoading => _isLoading;

  /// Whether search is in progress
  bool get isSearching => _isSearching;

  /// Whether more products can be loaded
  bool get hasMore => _hasMore;

  /// Current page number
  int get currentPage => _currentPage;

  /// Page size for pagination
  int get pageSize => _pageSize;

  /// Current search query
  String? get currentQuery => _currentQuery;

  /// Currently selected category
  String? get selectedCategoryId => _selectedCategoryId;

  /// Current sort field
  String get sortBy => _sortBy;

  /// Whether sorting is ascending
  bool get sortAscending => _sortAscending;

  /// Total number of products
  int get totalProducts => _allProducts.length;

  /// Number of filtered products
  int get filteredProductCount => _filteredProducts.length;

  /// Initialize controller with products and categories
  void initialize({
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    List<FilterModel>? filters,
  }) {
    _allProducts = products ?? <ProductModel>[];
    _categories = categories ?? <CategoryModel>[];
    _availableFilters = filters ?? <FilterModel>[];
    _filteredProducts = List.from(_allProducts);
    _applyCurrentFilters();
    notifyListeners();
  }

  /// Load products with pagination
  Future<void> loadProducts({
    bool refresh = false,
    String? categoryId,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allProducts.clear();
      _filteredProducts.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock product loading
      final newProducts = _generateMockProducts(
        page: _currentPage,
        pageSize: _pageSize,
        categoryId: categoryId,
      );

      if (refresh) {
        _allProducts = newProducts;
      } else {
        _allProducts.addAll(newProducts);
      }

      _hasMore = newProducts.length == _pageSize;
      _currentPage++;

      _applyCurrentFilters();
    } catch (e) {
      debugPrint('Failed to load products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    if (_isSearching) return;

    _currentQuery = query.trim();
    if (_currentQuery!.isEmpty) {
      _filteredProducts = List.from(_allProducts);
      _lastSearchResult = null;
      _applyCurrentFilters();
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      // Simulate search API call
      await Future.delayed(const Duration(milliseconds: 600));

      final searchResults = _performSearch(query);
      _lastSearchResult = searchResults;
      _filteredProducts = searchResults.products;
    } catch (e) {
      debugPrint('Search failed: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search and show all products
  void clearSearch() {
    _currentQuery = null;
    _lastSearchResult = null;
    _filteredProducts = List.from(_allProducts);
    _applyCurrentFilters();
    notifyListeners();
  }

  /// Apply category filter
  void filterByCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _applyCurrentFilters();
    notifyListeners();
  }

  /// Update filter selection
  void updateFilter(String filterId, value) {
    final filterIndex =
        _availableFilters.indexWhere((FilterModel f) => f.id == filterId);
    if (filterIndex == -1) return;

    final filter = _availableFilters[filterIndex];
    FilterModel updatedFilter;

    switch (filter.type) {
      case FilterType.multiSelect:
        final currentValues = List<dynamic>.from(filter.selectedValues);
        if (currentValues.contains(value)) {
          currentValues.remove(value);
        } else {
          currentValues.add(value);
        }
        updatedFilter = filter.copyWith(selectedValues: currentValues);
        break;

      case FilterType.singleSelect:
        updatedFilter = filter.copyWith(selectedValues: <dynamic>[value]);
        break;

      case FilterType.range:
      case FilterType.price:
        updatedFilter = filter.copyWith(currentRange: value as List<double>);
        break;

      case FilterType.boolean:
        updatedFilter = filter.copyWith(selectedValues: <dynamic>[value]);
        break;

      case FilterType.rating:
        updatedFilter = filter.copyWith(selectedValues: <dynamic>[value]);
        break;
    }

    _availableFilters[filterIndex] = updatedFilter;
    _applyCurrentFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _availableFilters = _availableFilters
        .map((FilterModel filter) => filter.copyWith(
              selectedValues: <dynamic>[],
            ))
        .toList();
    _selectedCategoryId = null;
    _applyCurrentFilters();
    notifyListeners();
  }

  /// Change sort order
  void sortProducts(String sortBy, {bool ascending = true}) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    _applySorting();
    notifyListeners();
  }

  /// Get products by category
  List<ProductModel> getProductsByCategory(String categoryId) => _allProducts
      .where((ProductModel p) => p.categoryId == categoryId)
      .toList();

  /// Get related products (same category, excluding current product)
  List<ProductModel> getRelatedProducts(ProductModel product,
          {int limit = 4}) =>
      _allProducts
          .where((ProductModel p) =>
              p.id != product.id && p.categoryId == product.categoryId)
          .take(limit)
          .toList();

  /// Get recommended products (mock implementation)
  List<ProductModel> getRecommendedProducts(ProductModel product,
      {int limit = 4}) {
    // Simple recommendation: same category + high rating
    return _allProducts
        .where((ProductModel p) =>
            p.id != product.id &&
            p.categoryId == product.categoryId &&
            (p.rating ?? 0) >= 4.0)
        .take(limit)
        .toList();
  }

  /// Apply current filters to product list
  void _applyCurrentFilters() {
    List<ProductModel> filtered = List<ProductModel>.from(_allProducts);

    // Apply category filter
    if (_selectedCategoryId != null) {
      filtered = filtered
          .where((ProductModel p) => p.categoryId == _selectedCategoryId)
          .toList();
    }

    // Apply each filter
    for (final filter in _availableFilters) {
      if (filter.hasSelection) {
        filtered = filter.applyToProducts(filtered);
      }
    }

    _filteredProducts = filtered;
    _applySorting();
  }

  /// Apply current sorting
  void _applySorting() {
    switch (_sortBy.toLowerCase()) {
      case 'name':
        _filteredProducts.sort((ProductModel a, ProductModel b) =>
            _sortAscending
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name));
        break;
      case 'price':
        _filteredProducts.sort((ProductModel a, ProductModel b) =>
            _sortAscending
                ? a.discountedPrice.compareTo(b.discountedPrice)
                : b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case 'rating':
        _filteredProducts.sort((ProductModel a, ProductModel b) {
          final ratingA = a.rating ?? 0;
          final ratingB = b.rating ?? 0;
          return _sortAscending
              ? ratingA.compareTo(ratingB)
              : ratingB.compareTo(ratingA);
        });
        break;
      case 'newest':
        // Sort by ID as proxy for newest (in real app, use createdAt)
        _filteredProducts.sort((ProductModel a, ProductModel b) =>
            _sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
        break;
    }
  }

  /// Mock search implementation
  SearchResultModel _performSearch(String query) {
    final lowercaseQuery = query.toLowerCase();

    final matchingProducts = _allProducts
        .where((ProductModel product) =>
            product.name.toLowerCase().contains(lowercaseQuery) ||
            (product.description?.toLowerCase().contains(lowercaseQuery) ??
                false) ||
            (product.brand?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (product.tags?.any((String tag) =>
                    tag.toLowerCase().contains(lowercaseQuery)) ??
                false))
        .toList();

    final matchingCategories = _categories
        .where((CategoryModel category) =>
            category.name.toLowerCase().contains(lowercaseQuery))
        .toList();

    final suggestions = _generateSearchSuggestions(query);

    return SearchResultModel(
      query: query,
      totalResults: matchingProducts.length + matchingCategories.length,
      products: matchingProducts,
      categories: matchingCategories,
      suggestions: suggestions,
      searchTime: 250 + (query.length * 10), // Mock search time
    );
  }

  /// Generate search suggestions
  List<SearchSuggestionModel> _generateSearchSuggestions(String query) {
    final suggestions = <SearchSuggestionModel>[];
    final lowercaseQuery = query.toLowerCase();

    // Product name suggestions
    final productSuggestions = _allProducts
        .where(
            (ProductModel p) => p.name.toLowerCase().contains(lowercaseQuery))
        .take(3)
        .map((ProductModel p) => SearchSuggestionModel(
              id: 'product_${p.id}',
              title: p.name,
              type: 'product',
              thumbnailUrl: p.imageUrl,
              resultCount: 1,
            ));

    suggestions.addAll(productSuggestions);

    // Category suggestions
    final categorySuggestions = _categories
        .where(
            (CategoryModel c) => c.name.toLowerCase().contains(lowercaseQuery))
        .take(2)
        .map((CategoryModel c) => SearchSuggestionModel(
              id: 'category_${c.id}',
              title: c.name,
              type: 'category',
              thumbnailUrl: c.iconUrl,
              resultCount: c.itemCount,
            ));

    suggestions.addAll(categorySuggestions);

    return suggestions;
  }

  /// Mock product generation for demo
  List<ProductModel> _generateMockProducts({
    required int page,
    required int pageSize,
    String? categoryId,
  }) {
    // This would be replaced with actual API call
    final products = <ProductModel>[];

    for (int i = 0; i < pageSize; i++) {
      final id = 'product_${page}_$i';
      products.add(ProductModel(
        id: id,
        name: 'Product ${page * pageSize + i + 1}',
        price: 29.99 + (i * 10),
        currency: 'USD',
        imageUrl: 'https://picsum.photos/300/300?random=$id',
        rating: 3.5 + (i % 3) * 0.5,
        reviewCount: 10 + (i * 5),
        isInStock: i % 7 != 0, // Some out of stock
        discountPercentage: i % 3 == 0 ? 15.0 : null,
        categoryId: categoryId ?? 'category_${i % 4}',
        brand: 'Brand ${String.fromCharCode(65 + (i % 5))}',
        tags: <String>['tag${i % 3}', 'popular'],
      ));
    }

    return products;
  }

  /// Update page size
  void setPageSize(int newPageSize) {
    if (newPageSize != _pageSize) {
      _pageSize = newPageSize;
      // Optionally reload products with new page size
    }
  }

  /// Reset pagination
  void resetPagination() {
    _currentPage = 1;
    _hasMore = true;
  }

  /// Get filter by ID
  FilterModel? getFilter(String filterId) {
    try {
      return _availableFilters.firstWhere((FilterModel f) => f.id == filterId);
    } catch (e) {
      return null;
    }
  }

  /// Get active filters (filters with selections)
  List<FilterModel> get activeFilters =>
      _availableFilters.where((FilterModel f) => f.hasSelection).toList();

  /// Get category by ID
  CategoryModel? getCategory(String categoryId) {
    try {
      return _categories.firstWhere((CategoryModel c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Export current state for analytics
  Map<String, dynamic> exportState() => <String, dynamic>{
        'total_products': _allProducts.length,
        'filtered_products': _filteredProducts.length,
        'current_query': _currentQuery,
        'selected_category': _selectedCategoryId,
        'active_filters': activeFilters.length,
        'sort_by': _sortBy,
        'sort_ascending': _sortAscending,
        'current_page': _currentPage,
        'has_more': _hasMore,
      };
}
