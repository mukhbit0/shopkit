import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../models/product_model.dart';
import 'product_grid_types.dart';
import 'components/product_grid_image.dart';
import 'components/product_grid_badges.dart';
import 'components/product_grid_action_button.dart';

/// A comprehensive product grid widget with advanced features and unlimited customization
/// Features: Multiple layouts, infinite scroll, search/filter, animations, and extensive theming
class ProductGrid extends StatefulWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.config,
    this.customBuilder,
    this.customItemBuilder,
    this.customEmptyBuilder,
    this.customLoadingBuilder,
    this.customErrorBuilder,
    this.onProductTap,
    this.onProductLongPress,
    this.onProductFavorite,
    this.onProductAddToCart,
    this.onLoadMore,
    this.onRefresh,
    this.onSelectionChanged,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.canLoadMore = false,
    this.enableInfiniteScroll = false,
    this.enableRefresh = false,
    this.enableSelection = false,
    this.enableSearch = false,
    this.enableFilter = false,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showFavoriteButton = true,
    this.showAddToCartButton = true,
    this.showPricing = true,
    this.showRating = true,
    this.showBadges = true,
    this.style = ProductGridStyle.card,
    this.layout = ProductGridLayout.grid,
    this.imageStyle = ProductGridImageStyle.cover,
    this.animationType = ProductGridAnimationType.fadeIn,
    this.enableResponsive = true,
    this.themeStyle,
  });

  /// List of products to display
  final List<ProductModel> products;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<ProductModel>, ProductGridState)? customBuilder;

  /// Custom item builder for product cards
  final Widget Function(BuildContext, ProductModel, int, ProductGridState)? customItemBuilder;

  /// Custom empty state builder
  final Widget Function(BuildContext)? customEmptyBuilder;

  /// Custom loading state builder
  final Widget Function(BuildContext)? customLoadingBuilder;

  /// Custom error state builder
  final Widget Function(BuildContext, String?)? customErrorBuilder;

  /// Callback when product is tapped
  final Function(ProductModel product, int index)? onProductTap;

  /// Callback when product is long pressed
  final Function(ProductModel product, int index)? onProductLongPress;

  /// Callback when product is favorited
  final Function(ProductModel product, bool isFavorite)? onProductFavorite;

  /// Callback when product is added to cart
  final Function(ProductModel product, int quantity)? onProductAddToCart;

  /// Callback to load more products
  final VoidCallback? onLoadMore;

  /// Callback for pull to refresh
  final Future<void> Function()? onRefresh;

  /// Callback when selection changes
  final Function(List<ProductModel> selectedProducts)? onSelectionChanged;

  /// Number of columns in grid
  final int crossAxisCount;

  /// Aspect ratio of grid items
  final double childAspectRatio;

  /// Spacing between columns
  final double crossAxisSpacing;

  /// Spacing between rows
  final double mainAxisSpacing;

  /// Whether currently loading
  final bool isLoading;

  /// Whether has error
  final bool hasError;

  /// Error message to display
  final String? errorMessage;

  /// Whether can load more items
  final bool canLoadMore;

  /// Whether to enable infinite scroll
  final bool enableInfiniteScroll;

  /// Whether to enable pull to refresh
  final bool enableRefresh;

  /// Whether to enable multi-selection
  final bool enableSelection;

  /// Whether to enable search
  final bool enableSearch;

  /// Whether to enable filtering
  final bool enableFilter;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show favorite button
  final bool showFavoriteButton;

  /// Whether to show add to cart button
  final bool showAddToCartButton;

  /// Whether to show pricing
  final bool showPricing;

  /// Whether to show rating
  final bool showRating;

  /// Whether to show badges
  final bool showBadges;

  /// Style of the product grid
  final ProductGridStyle style;

  /// Layout type
  final ProductGridLayout layout;

  /// Image style
  final ProductGridImageStyle imageStyle;

  /// Animation type
  final ProductGridAnimationType animationType;

  /// Whether to adapt crossAxisCount based on available width breakpoints
  final bool enableResponsive;

  /// Theme style for consistent visual styling (material3, neumorphism, glassmorphism, etc.)
  final String? themeStyle;

  @override
  State<ProductGrid> createState() => ProductGridState();
}

class ProductGridState extends State<ProductGrid>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late AnimationController _loadingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  FlexibleWidgetConfig? _config;
  List<ProductModel> _filteredProducts = [];
  List<ProductModel> _selectedProducts = [];
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isLoadingMore = false;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('product_grid', context: context);
    _filteredProducts = List.from(widget.products);
    
    _setupControllers();
    _setupAnimations();
    _setupScrollListener();
  }

  void _setupControllers() {
    _scrollController = ScrollController();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: _getConfig('animationDuration', 300)),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: Duration(milliseconds: _getConfig('loadingAnimationDuration', 1000)),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _config?.getCurve('fadeAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: _getConfig('scaleAnimationStart', 0.8),
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: _getConfig('slideAnimationStart', 50.0),
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.enableAnimations) {
      _animationController.forward();
      _loadingController.repeat();
    } else {
      _animationController.value = 1.0;
    }
  }

  void _setupScrollListener() {
    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >= 
            _scrollController.position.maxScrollExtent - _getConfig('loadMoreThreshold', 200.0)) {
          if (widget.canLoadMore && !_isLoadingMore) {
            _loadMore();
          }
        }
      });
    }
  }

  void _loadMore() {
    if (widget.onLoadMore != null && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      
      widget.onLoadMore!();
      
      // Reset loading state after a delay (would normally be handled by parent)
      Future.delayed(Duration(milliseconds: _getConfig('loadMoreDelay', 1000)), () {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  void _handleProductTap(ProductModel product, int index) {
    if (widget.enableHaptics && _getConfig('enableTapHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    if (widget.enableSelection && _selectedProducts.isNotEmpty) {
      _toggleSelection(product);
    } else {
      widget.onProductTap?.call(product, index);
    }
  }

  void _handleProductLongPress(ProductModel product, int index) {
    if (widget.enableHaptics && _getConfig('enableLongPressHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    if (widget.enableSelection) {
      _toggleSelection(product);
    } else {
      widget.onProductLongPress?.call(product, index);
    }
  }

  void _toggleSelection(ProductModel product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
    
    widget.onSelectionChanged?.call(_selectedProducts);
  }

  void _handleFavorite(ProductModel product) {
    if (widget.enableHaptics && _getConfig('enableFavoriteHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    // Use a placeholder favorite state since ProductModel doesn't have isFavorite
    const isFavorite = true; // This would typically be managed by parent state
    widget.onProductFavorite?.call(product, isFavorite);
  }

  void _handleAddToCart(ProductModel product) {
    if (widget.enableHaptics && _getConfig('enableAddToCartHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    final quantity = _getConfig('defaultAddToCartQuantity', 1);
    widget.onProductAddToCart?.call(product, quantity);
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
      
      if (query.isEmpty) {
        _filteredProducts = List.from(widget.products);
      } else {
        _filteredProducts = widget.products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
                 (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                 (product.categoryName?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  @override
  void didUpdateWidget(ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.products != oldWidget.products) {
      setState(() {
        if (_searchQuery.isEmpty) {
          _filteredProducts = List.from(widget.products);
        } else {
          _search(_searchQuery);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, _filteredProducts, this);
    }

    // Support new theming system
    ShopKitThemeConfig? themeConfig;
    if (widget.themeStyle != null) {
      final style = ShopKitThemeStyleExtension.fromString(widget.themeStyle!);
      themeConfig = ShopKitThemeConfig.forStyle(style, context);
    }

    final theme = ShopKitThemeProvider.of(context);

    return _buildProductGrid(context, theme, themeConfig);
  }

  Widget _buildProductGrid(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    return Column(
      children: [
        if (widget.enableSearch) _buildSearchBar(context, theme, themeConfig),
        if (widget.enableFilter) _buildFilterBar(context, theme, themeConfig),
        if (_selectedProducts.isNotEmpty) _buildSelectionBar(context, theme, themeConfig),
        Expanded(
          child: _buildGridContent(context, theme, themeConfig),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    final backgroundColor = themeConfig?.backgroundColor ?? theme.surfaceColor;
    final borderRadius = BorderRadius.circular(themeConfig?.borderRadius ?? 12.0);
    
    return Container(
      padding: EdgeInsets.all(_getConfig('searchBarPadding', 16.0)),
      child: TextField(
        onChanged: _search,
        decoration: InputDecoration(
          hintText: _getConfig('searchHintText', 'Search products...'),
          prefixIcon: Icon(Icons.search, color: theme.onSurfaceColor.withValues(alpha: 0.6)),
          suffixIcon: _isSearching
            ? IconButton(
                icon: Icon(Icons.clear, color: theme.onSurfaceColor.withValues(alpha: 0.6)),
                onPressed: () => _search(''),
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: theme.onSurfaceColor.withValues(alpha: 0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: theme.onSurfaceColor.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    return Container(
      height: _getConfig('filterBarHeight', 60.0),
      padding: EdgeInsets.symmetric(horizontal: _getConfig('filterBarPadding', 16.0)),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: theme.onSurfaceColor.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Text(
            _getConfig('filterText', 'Filters'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.onSurfaceColor.withValues(alpha: 0.8),
            ),
          ),
          const Spacer(),
          // Add filter chips here based on your filter implementation
        ],
      ),
    );
  }

  Widget _buildSelectionBar(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    return Container(
      padding: EdgeInsets.all(_getConfig('selectionBarPadding', 16.0)),
      color: theme.primaryColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Text(
            '${_selectedProducts.length} selected',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedProducts.clear();
              });
              widget.onSelectionChanged?.call(_selectedProducts);
            },
            child: Text(
              _getConfig('clearSelectionText', 'Clear'),
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    if (widget.hasError) {
      return _buildErrorState(context, theme);
    }

    if (widget.isLoading && _filteredProducts.isEmpty) {
      return _buildLoadingState(context, theme);
    }

    if (_filteredProducts.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    Widget content = _buildGrid(context, theme, themeConfig);

    if (widget.enableRefresh && widget.onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        color: theme.primaryColor,
        child: content,
      );
    }

    return content;
  }

  Widget _buildGrid(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    switch (widget.layout) {
      case ProductGridLayout.list:
        return _buildListLayout(context, theme, themeConfig);
      case ProductGridLayout.staggered:
        return _buildStaggeredLayout(context, theme, themeConfig);
      case ProductGridLayout.grid:
        return _buildGridLayout(context, theme, themeConfig);
    }
  }

  Widget _buildGridLayout(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    final width = MediaQuery.of(context).size.width;
    int crossAxis = widget.crossAxisCount;
    if (widget.enableResponsive) {
      if (width >= 1400) {
        crossAxis = 6;
      } else if (width >= 1100) {
        crossAxis = 5;
      } else if (width >= 900) {
        crossAxis = 4;
      } else if (width >= 600) {
        crossAxis = 3;
      }
    }
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(_getConfig('gridPadding', 16.0)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxis,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      itemCount: _filteredProducts.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredProducts.length) {
          return _buildLoadMoreIndicator(context, theme);
        }
        
        return _buildProductItem(context, theme, _filteredProducts[index], index, themeConfig);
      },
    );
  }

  Widget _buildListLayout(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(_getConfig('listPadding', 16.0)),
      itemCount: _filteredProducts.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _filteredProducts.length) {
          return _buildLoadMoreIndicator(context, theme);
        }
        
        return Container(
          margin: EdgeInsets.only(bottom: _getConfig('listItemSpacing', 16.0)),
          child: _buildProductListItem(context, theme, _filteredProducts[index], index, themeConfig),
        );
      },
    );
  }

  Widget _buildStaggeredLayout(BuildContext context, ShopKitTheme theme, [ShopKitThemeConfig? themeConfig]) {
    // For now, fallback to grid layout
    // In a real implementation, you'd use flutter_staggered_grid_view package
    return _buildGridLayout(context, theme, themeConfig);
  }

  Widget _buildProductItem(BuildContext context, ShopKitTheme theme, ProductModel product, int index, [ShopKitThemeConfig? themeConfig]) {
    if (widget.customItemBuilder != null) {
      return widget.customItemBuilder!(context, product, index, this);
    }

    Widget item = _buildProductCard(context, theme, product, index, themeConfig);

    // Apply animations
    if (widget.enableAnimations) {
      item = _applyAnimation(item, index);
    }

    return item;
  }

  Widget _buildProductCard(BuildContext context, ShopKitTheme theme, ProductModel product, int index, [ShopKitThemeConfig? themeConfig]) {
    final isSelected = _selectedProducts.contains(product);
    
    // Use theme config if available, otherwise fallback to legacy config  
    final borderRadius = themeConfig?.borderRadius != null 
      ? BorderRadius.circular(themeConfig!.borderRadius)
      : (_config?.getBorderRadius('productCardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12));
    final showBorder = _getConfig('showProductCardBorder', false);
    final showShadow = themeConfig?.enableShadows ?? _getConfig('showProductCardShadow', true);
    final shadowOpacity = _getConfig('productCardShadowOpacity', 0.1);
    final shadowBlur = (themeConfig?.elevation ?? _getConfig('productCardShadowBlur', 8.0)) as double;
    final shadowOffset = (themeConfig?.elevation ?? _getConfig('productCardShadowOffset', 2.0)) as double;
    
    return GestureDetector(
      onTap: () => _handleProductTap(product, index),
      onLongPress: widget.enableSelection ? () => _handleProductLongPress(product, index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
            ? theme.primaryColor.withValues(alpha: 0.1) 
            : (themeConfig?.backgroundColor ?? theme.surfaceColor),
          borderRadius: borderRadius,
          border: isSelected 
            ? Border.all(color: theme.primaryColor, width: 2)
            : showBorder 
              ? Border.all(color: theme.onSurfaceColor.withValues(alpha: 0.1))
              : null,
          boxShadow: (showShadow == true)
            ? [
                BoxShadow(
                  color: themeConfig?.shadowColor ?? theme.onSurfaceColor.withValues(alpha: shadowOpacity),
                  blurRadius: shadowBlur,
                  offset: Offset(0, shadowOffset),
                ),
              ]
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(context, theme, product),
            Expanded(
              child: _buildProductInfo(context, theme, product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, ShopKitTheme theme, ProductModel product, int index, [ShopKitThemeConfig? themeConfig]) {
    final isSelected = _selectedProducts.contains(product);
    
    // Use theme config if available, otherwise fallback to legacy config  
    final borderRadius = themeConfig?.borderRadius != null 
      ? BorderRadius.circular(themeConfig!.borderRadius)
      : (_config?.getBorderRadius('listItemBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12));
    final showBorder = _getConfig('showListItemBorder', false);
    final showShadow = themeConfig?.enableShadows ?? _getConfig('showListItemShadow', true);
    final shadowOpacity = _getConfig('listItemShadowOpacity', 0.1);
    final shadowBlur = (themeConfig?.elevation ?? _getConfig('listItemShadowBlur', 8.0)) as double;
    final shadowOffset = (themeConfig?.elevation ?? _getConfig('listItemShadowOffset', 2.0)) as double;
    final itemHeight = _getConfig('listItemHeight', 120.0);
    final imageWidth = _getConfig('listImageWidth', 100.0);
    final itemSpacing = _getConfig('listItemSpacing', 12.0);
    
    return GestureDetector(
      onTap: () => _handleProductTap(product, index),
      onLongPress: widget.enableSelection ? () => _handleProductLongPress(product, index) : null,
      child: Container(
        height: itemHeight,
        decoration: BoxDecoration(
          color: isSelected 
            ? theme.primaryColor.withValues(alpha: 0.1) 
            : (themeConfig?.backgroundColor ?? theme.surfaceColor),
          borderRadius: borderRadius,
          border: isSelected 
            ? Border.all(color: theme.primaryColor, width: 2)
            : showBorder 
              ? Border.all(color: theme.onSurfaceColor.withValues(alpha: 0.1))
              : null,
          boxShadow: (showShadow == true)
            ? [
                BoxShadow(
                  color: themeConfig?.shadowColor ?? theme.onSurfaceColor.withValues(alpha: shadowOpacity),
                  blurRadius: shadowBlur,
                  offset: Offset(0, shadowOffset),
                ),
              ]
            : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: imageWidth,
              height: double.infinity,
              child: _buildProductImage(context, theme, product),
            ),
            SizedBox(width: itemSpacing),
            Expanded(
              child: _buildProductInfo(context, theme, product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, ShopKitTheme theme, ProductModel product) {
    return ProductGridImage(
      product: product,
      theme: theme,
      config: _config,
      showBadges: widget.showBadges,
      showFavoriteButton: widget.showFavoriteButton,
      showAddToCartButton: widget.showAddToCartButton,
      imageStyle: widget.imageStyle,
      layout: widget.layout,
      onFavorite: () => _handleFavorite(product),
      onAddToCart: () => _handleAddToCart(product),
      buildBadges: () => _buildBadges(context, theme, product),
      buildActionButton: ({required IconData icon, required Color color, required VoidCallback onTap, String? semanticsLabel}) => _buildActionButton(
        context,
        theme,
        icon: icon,
        color: color,
        onTap: onTap,
        semanticsLabel: semanticsLabel,
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ShopKitTheme theme, ProductModel product) {
    return Padding(
      padding: EdgeInsets.all(_getConfig('productInfoPadding', 12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.onSurfaceColor,
            ),
            maxLines: _getConfig('productNameMaxLines', 2),
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: _getConfig('productInfoSpacing', 4.0)),
          
          // Product description
          if (product.description != null && _getConfig('showProductDescription', true))
            Text(
              product.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.onSurfaceColor.withValues(alpha: 0.6),
              ),
              maxLines: _getConfig('productDescriptionMaxLines', 1),
              overflow: TextOverflow.ellipsis,
            ),
          
          if (product.description != null && _getConfig('showProductDescription', true))
            SizedBox(height: _getConfig('productInfoSpacing', 4.0)),
          
          // Rating
          if (widget.showRating && product.rating != null && product.rating! > 0)
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: _getConfig('ratingStarSize', 16.0),
                ),
                const SizedBox(width: 4),
                Text(
                  product.rating!.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.onSurfaceColor.withValues(alpha: 0.8),
                  ),
                ),
                if (product.reviewCount != null && product.reviewCount! > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${product.reviewCount!})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.onSurfaceColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          
          const Spacer(),
          
          // Pricing
          if (widget.showPricing)
            Row(
              children: [
                if (product.hasDiscount)
                  Text(
                    product.formattedOriginalPrice,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.onSurfaceColor.withValues(alpha: 0.6),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                
                if (product.hasDiscount)
                  const SizedBox(width: 8),
                
                Text(
                  product.formattedPrice,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildBadges(BuildContext context, ShopKitTheme theme, ProductModel product) {
    return ProductGridBadgesBuilder(_config, theme).build(product);
  }

  Widget _buildActionButton(
    BuildContext context,
    ShopKitTheme theme, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? semanticsLabel,
  }) {
    return ProductGridActionButton(
      icon: icon,
      color: color,
      onTap: onTap,
      semanticsLabel: semanticsLabel,
      theme: theme,
      config: _config,
    );
  }

  Widget _applyAnimation(Widget child, int index) {
    // Remove unused delay variable and fix type issues
    
    switch (widget.animationType) {
      case ProductGridAnimationType.slideUp:
        return AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            );
          },
          child: child,
        );
      
      case ProductGridAnimationType.scale:
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: child,
        );
      
      case ProductGridAnimationType.fadeIn:
      default:
        return AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: child,
        );
    }
  }

  Widget _buildLoadingState(BuildContext context, ShopKitTheme theme) {
    if (widget.customLoadingBuilder != null) {
      return widget.customLoadingBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            _getConfig('loadingText', 'Loading products...'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.onSurfaceColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(BuildContext context, ShopKitTheme theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getConfig('loadMoreIndicatorPadding', 16.0)),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShopKitTheme theme) {
    if (widget.customEmptyBuilder != null) {
      return widget.customEmptyBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.inventory_2_outlined,
            size: _getConfig('emptyStateIconSize', 64.0),
            color: theme.onSurfaceColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching 
              ? _getConfig('noSearchResultsText', 'No products found')
              : _getConfig('emptyStateText', 'No products available'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.onSurfaceColor.withValues(alpha: 0.6),
            ),
          ),
          if (_isSearching) ...[
            const SizedBox(height: 8),
            Text(
              _getConfig('searchSuggestionText', 'Try a different search term'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.onSurfaceColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ShopKitTheme theme) {
    if (widget.customErrorBuilder != null) {
      return widget.customErrorBuilder!(context, widget.errorMessage);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: _getConfig('errorStateIconSize', 64.0),
            color: theme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? _getConfig('errorStateText', 'Something went wrong'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.onSurfaceColor.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Trigger refresh or retry
              widget.onRefresh?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.onPrimaryColor,
            ),
            child: Text(_getConfig('retryButtonText', 'Retry')),
          ),
        ],
      ),
    );
  }

  /// Public API for external control
  List<ProductModel> get filteredProducts => _filteredProducts;
  
  List<ProductModel> get selectedProducts => _selectedProducts;
  
  String get searchQuery => _searchQuery;
  
  bool get isSearching => _isSearching;
  
  bool get isLoadingMore => _isLoadingMore;
  
  ScrollController get scrollController => _scrollController;
  
  void search(String query) {
    _search(query);
  }
  
  void clearSearch() {
    _search('');
  }
  
  void selectAll() {
    setState(() {
      _selectedProducts = List.from(_filteredProducts);
    });
    widget.onSelectionChanged?.call(_selectedProducts);
  }
  
  void clearSelection() {
    setState(() {
      _selectedProducts.clear();
    });
    widget.onSelectionChanged?.call(_selectedProducts);
  }
  
  void selectProduct(ProductModel product) {
    if (!_selectedProducts.contains(product)) {
      setState(() {
        _selectedProducts.add(product);
      });
      widget.onSelectionChanged?.call(_selectedProducts);
    }
  }
  
  void deselectProduct(ProductModel product) {
    if (_selectedProducts.contains(product)) {
      setState(() {
        _selectedProducts.remove(product);
      });
      widget.onSelectionChanged?.call(_selectedProducts);
    }
  }
  
  void scrollToTop({bool animate = true}) {
    if (animate) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: _getConfig('scrollToTopDuration', 500)),
        curve: _config?.getCurve('scrollToTopCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }
  
  void scrollToIndex(int index, {bool animate = true}) {
    // Approximate scroll position based on item height
    final itemHeight = widget.layout == ProductGridLayout.list
      ? _getConfig('listItemHeight', 120.0) + _getConfig('listItemSpacing', 16.0)
      : (MediaQuery.of(context).size.width / widget.crossAxisCount) / widget.childAspectRatio + widget.mainAxisSpacing;
    
    final offset = index * itemHeight;
    
    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: _getConfig('scrollAnimationDuration', 300)),
        curve: _config?.getCurve('scrollAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }
  
  void refreshGrid() {
    setState(() {
      _filteredProducts = List.from(widget.products);
      _selectedProducts.clear();
      _searchQuery = '';
      _isSearching = false;
    });
    
    if (widget.enableAnimations) {
      _animationController.reset();
      _animationController.forward();
    }
  }
  
  void triggerLoadMore() {
    _loadMore();
  }
}

// Enum types moved to product_grid_types.dart
