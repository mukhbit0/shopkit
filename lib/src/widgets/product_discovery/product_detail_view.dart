import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopkit/shopkit.dart';

import '../../theme/shopkit_theme_styles.dart';

/// A comprehensive product detail view widget with advanced features and unlimited customization
/// Features: Multiple layouts, image galleries, variant selection, reviews, recommendations, and extensive theming
class ProductDetailViewNew extends StatefulWidget {
  const ProductDetailViewNew({
    super.key,
    required this.product,
    this.config,
    this.customBuilder,
    this.customHeaderBuilder,
    this.customImageBuilder,
    this.customInfoBuilder,
    this.customDescriptionBuilder,
    this.customVariantBuilder,
    this.customReviewBuilder,
    this.customActionBuilder,
    this.customFooterBuilder,
    this.onVariantChanged,
    this.onAddToCart,
    this.onBuyNow,
    this.onWishlistToggle,
    this.onShare,
    this.onReviewTap,
    this.onImageTap,
    this.relatedProducts = const [],
    this.reviews = const [],
    this.enableImageZoom = true,
    this.enableVariantSelection = true,
    this.enableReviews = true,
    this.enableRecommendations = true,
    this.enableSocialSharing = true,
    this.enableWishlist = true,
    this.enableQuantitySelector = true,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.style = ProductDetailStyle.standard,
    this.layout = ProductDetailLayout.scrollable,
    this.imageStyle = ProductDetailImageStyle.carousel,
    this.themeStyle, // NEW: Built-in theme styling support
  });

  /// Product to display
  final ProductModel product;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, ProductModel, ProductDetailViewNewState)?
      customBuilder;

  /// Custom builders for sections
  final Widget Function(BuildContext, ProductModel)? customHeaderBuilder;
  final Widget Function(BuildContext, ProductModel, int)? customImageBuilder;
  final Widget Function(BuildContext, ProductModel)? customInfoBuilder;
  final Widget Function(BuildContext, ProductModel)? customDescriptionBuilder;
  final Widget Function(BuildContext, ProductModel, VariantModel?)?
      customVariantBuilder;
  final Widget Function(BuildContext, List<ReviewModel>)? customReviewBuilder;
  final Widget Function(BuildContext, ProductModel, VariantModel?)?
      customActionBuilder;
  final Widget Function(BuildContext, ProductModel, List<ProductModel>)?
      customFooterBuilder;

  /// Callbacks
  final Function(VariantModel)? onVariantChanged;
  final Function(ProductModel, VariantModel?, int)? onAddToCart;
  final Function(ProductModel, VariantModel?, int)? onBuyNow;
  final Function(ProductModel, bool)? onWishlistToggle;
  final Function(ProductModel)? onShare;
  final Function(ReviewModel)? onReviewTap;
  final Function(String, int)? onImageTap;

  /// Related products for recommendations
  final List<ProductModel> relatedProducts;

  /// Product reviews
  final List<ReviewModel> reviews;

  /// Feature toggles
  final bool enableImageZoom;
  final bool enableVariantSelection;
  final bool enableReviews;
  final bool enableRecommendations;
  final bool enableSocialSharing;
  final bool enableWishlist;
  final bool enableQuantitySelector;
  final bool enableAnimations;
  final bool enableHaptics;

  /// Style options
  final ProductDetailStyle style;
  final ProductDetailLayout layout;
  final ProductDetailImageStyle imageStyle;
  
  /// Built-in theme styling support - just pass a string!
  /// Supported values: 'material3', 'materialYou', 'neumorphism', 'glassmorphism', 'cupertino', 'minimal', 'retro', 'neon'
  final String? themeStyle;

  @override
  State<ProductDetailViewNew> createState() => ProductDetailViewNewState();
}

class ProductDetailViewNewState extends State<ProductDetailViewNew>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  FlexibleWidgetConfig? _config;
  VariantModel? _selectedVariant;
  int _selectedQuantity = 1;
  int _selectedImageIndex = 0;
  bool _isWishlisted = false;
  bool _showFullDescription = false;
  final ScrollController _scrollController = ScrollController();

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ??
        FlexibleWidgetConfig.forWidget('product_detail', context: context);

    if (widget.product.variants?.isNotEmpty == true) {
      _selectedVariant = widget.product.variants!.first;
    }

    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration:
          Duration(milliseconds: _getConfig('fadeAnimationDuration', 300)),
      vsync: this,
    );

    _slideController = AnimationController(
      duration:
          Duration(milliseconds: _getConfig('slideAnimationDuration', 400)),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration:
          Duration(milliseconds: _getConfig('scaleAnimationDuration', 200)),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: _config?.getCurve('fadeAnimationCurve', Curves.easeInOut) ??
          Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ??
          Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    if (widget.enableAnimations) {
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    } else {
      _fadeController.value = 1.0;
      _slideController.value = 1.0;
      _scaleController.value = 1.0;
    }
  }

  void _handleVariantChanged(VariantModel variant) {
    setState(() {
      _selectedVariant = variant;
    });

    if (widget.enableHaptics &&
        _getConfig('enableVariantChangeHaptics', true)) {
      HapticFeedback.selectionClick();
    }

    widget.onVariantChanged?.call(variant);
  }

  void _handleQuantityChanged(int quantity) {
    setState(() {
      _selectedQuantity = quantity;
    });

    if (widget.enableHaptics &&
        _getConfig('enableQuantityChangeHaptics', true)) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleAddToCart(CartItemModel cartItem) {
    if (widget.enableHaptics && _getConfig('enableAddToCartHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    widget.onAddToCart
        ?.call(widget.product, _selectedVariant, _selectedQuantity);
  }

  void _handleAddToCartSimple() {
    if (widget.enableHaptics && _getConfig('enableAddToCartHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    widget.onAddToCart
        ?.call(widget.product, _selectedVariant, _selectedQuantity);
  }

  void _handleBuyNow() {
    if (widget.enableHaptics && _getConfig('enableBuyNowHaptics', true)) {
      HapticFeedback.heavyImpact();
    }

    widget.onBuyNow?.call(widget.product, _selectedVariant, _selectedQuantity);
  }

  void _handleWishlistToggle() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    if (widget.enableHaptics && _getConfig('enableWishlistHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    widget.onWishlistToggle?.call(widget.product, _isWishlisted);
  }

  void _handleShare() {
    if (widget.enableHaptics && _getConfig('enableShareHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    widget.onShare?.call(widget.product);
  }

  void _handleImageTap(String imageUrl, int index) {
    setState(() {
      _selectedImageIndex = index;
    });

    widget.onImageTap?.call(imageUrl, index);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.product, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    // Apply theme-specific styling if themeStyle is provided
    Widget content;
    if (widget.themeStyle != null) {
      content = _buildThemedProductDetail(context, theme, widget.themeStyle!);
    } else {
      content = _buildProductDetail(context, theme);
    }

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: content,
          ),
        ),
      );
    }

    return content;
  }

  Widget _buildProductDetail(BuildContext context, ShopKitTheme theme) {
    switch (widget.layout) {
      case ProductDetailLayout.tabbed:
        return _buildTabbedLayout(context, theme);
      case ProductDetailLayout.accordion:
        return _buildAccordionLayout(context, theme);
      case ProductDetailLayout.grid:
        return _buildGridLayout(context, theme);
      case ProductDetailLayout.scrollable:
        return _buildScrollableLayout(context, theme);
    }
  }

  Widget _buildScrollableLayout(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      backgroundColor:
          _config?.getColor('backgroundColor', theme.backgroundColor) ??
              theme.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (_getConfig('showAppBar', true))
            _buildSliverAppBar(context, theme),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // CRITICAL FIX
              children: [
                _buildImageSection(context, theme),
                _buildProductInfo(context, theme),
                if (widget.enableVariantSelection &&
                    widget.product.variants?.isNotEmpty == true)
                  _buildVariantSection(context, theme),
                _buildQuantityAndActions(context, theme),
                _buildDescriptionSection(context, theme),
                if (widget.enableReviews && widget.reviews.isNotEmpty)
                  _buildReviewsSection(context, theme),
                if (widget.enableRecommendations &&
                    widget.relatedProducts.isNotEmpty)
                  _buildRecommendationsSection(context, theme),
                SizedBox(height: _getConfig('bottomPadding', 80.0)),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(context, theme),
    );
  }

  Widget _buildTabbedLayout(BuildContext context, ShopKitTheme theme) {
    return DefaultTabController(
      length: _getTabbedSectionCount(),
      child: Scaffold(
        backgroundColor:
            _config?.getColor('backgroundColor', theme.backgroundColor) ??
                theme.backgroundColor,
        appBar: _buildTabAppBar(context, theme),
        body: TabBarView(
          children: [
            _buildOverviewTab(context, theme),
            _buildSpecificationsTab(context, theme),
            if (widget.enableReviews) _buildReviewsTab(context, theme),
            if (widget.enableRecommendations)
              _buildRecommendationsTab(context, theme),
          ],
        ),
        bottomSheet: _buildBottomActions(context, theme),
      ),
    );
  }

  Widget _buildAccordionLayout(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      backgroundColor:
          _config?.getColor('backgroundColor', theme.backgroundColor) ??
              theme.backgroundColor,
      appBar: _buildSimpleAppBar(context, theme),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_getConfig('accordionPadding', 16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
          children: [
            _buildImageSection(context, theme),
            _buildProductInfo(context, theme),
            _buildAccordionSections(context, theme),
          ],
        ),
      ),
      bottomSheet: _buildBottomActions(context, theme),
    );
  }

  Widget _buildGridLayout(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      backgroundColor:
          _config?.getColor('backgroundColor', theme.backgroundColor) ??
              theme.backgroundColor,
      appBar: _buildSimpleAppBar(context, theme),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_getConfig('gridPadding', 16.0)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: _getConfig('imageGridFlex', 1),
                fit: FlexFit.loose,
                child: _buildImageSection(context, theme),
              ),
              SizedBox(width: _getConfig('gridSpacing', 16.0)),
              Flexible(
                flex: _getConfig('infoGridFlex', 1),
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProductInfo(context, theme),
                    if (widget.enableVariantSelection &&
                        widget.product.variants?.isNotEmpty == true)
                      _buildVariantSection(context, theme),
                    _buildQuantityAndActions(context, theme),
                    _buildDescriptionSection(context, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ShopKitTheme theme) {
    return SliverAppBar(
      expandedHeight: _getConfig('sliverAppBarHeight', 200.0),
      floating: _getConfig('sliverAppBarFloating', false),
      pinned: _getConfig('sliverAppBarPinned', true),
      backgroundColor:
          _config?.getColor('appBarBackgroundColor', theme.surfaceColor) ??
              theme.surfaceColor,
      foregroundColor:
          _config?.getColor('appBarForegroundColor', theme.onSurfaceColor) ??
              theme.onSurfaceColor,
      flexibleSpace: FlexibleSpaceBar(
        title: widget.customHeaderBuilder?.call(context, widget.product),
        background: _buildHeaderImage(context, theme),
      ),
      actions: _buildAppBarActions(context, theme),
    );
  }

  PreferredSizeWidget _buildTabAppBar(
      BuildContext context, ShopKitTheme theme) {
    return AppBar(
      backgroundColor:
          _config?.getColor('appBarBackgroundColor', theme.surfaceColor) ??
              theme.surfaceColor,
      foregroundColor:
          _config?.getColor('appBarForegroundColor', theme.onSurfaceColor) ??
              theme.onSurfaceColor,
      title: Text(
        widget.product.name,
        style: TextStyle(
          fontSize: _getConfig('appBarTitleFontSize', 18.0),
          fontWeight: _config?.getFontWeight(
                  'appBarTitleFontWeight', FontWeight.bold) ??
              FontWeight.bold,
        ),
      ),
      actions: _buildAppBarActions(context, theme),
      bottom: TabBar(
        labelColor: _config?.getColor('tabLabelColor', theme.primaryColor) ??
            theme.primaryColor,
        unselectedLabelColor: _config?.getColor('tabUnselectedLabelColor',
                theme.onSurfaceColor.withValues(alpha: 0.6)) ??
            theme.onSurfaceColor.withValues(alpha: 0.6),
        indicatorColor:
            _config?.getColor('tabIndicatorColor', theme.primaryColor) ??
                theme.primaryColor,
        tabs: [
          Tab(text: _getConfig('overviewTabText', 'Overview')),
          Tab(text: _getConfig('specsTabText', 'Specs')),
          if (widget.enableReviews)
            Tab(text: _getConfig('reviewsTabText', 'Reviews')),
          if (widget.enableRecommendations)
            Tab(text: _getConfig('relatedTabText', 'Related')),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSimpleAppBar(
      BuildContext context, ShopKitTheme theme) {
    return AppBar(
      backgroundColor:
          _config?.getColor('appBarBackgroundColor', theme.surfaceColor) ??
              theme.surfaceColor,
      foregroundColor:
          _config?.getColor('appBarForegroundColor', theme.onSurfaceColor) ??
              theme.onSurfaceColor,
      title: Text(
        widget.product.name,
        style: TextStyle(
          fontSize: _getConfig('appBarTitleFontSize', 18.0),
          fontWeight: _config?.getFontWeight(
                  'appBarTitleFontWeight', FontWeight.bold) ??
              FontWeight.bold,
        ),
      ),
      actions: _buildAppBarActions(context, theme),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, ShopKitTheme theme) {
    return [
      if (widget.enableWishlist)
        IconButton(
          onPressed: _handleWishlistToggle,
          icon: Icon(
            _isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: _isWishlisted
                ? _config?.getColor('wishlistActiveColor', theme.errorColor) ??
                    theme.errorColor
                : _config?.getColor(
                        'wishlistInactiveColor', theme.onSurfaceColor) ??
                    theme.onSurfaceColor,
          ),
        ),
      if (widget.enableSocialSharing)
        IconButton(
          onPressed: _handleShare,
          icon: Icon(
            Icons.share,
            color: _config?.getColor('shareIconColor', theme.onSurfaceColor) ??
                theme.onSurfaceColor,
          ),
        ),
      SizedBox(width: _getConfig('appBarActionsSpacing', 8.0)),
    ];
  }

  Widget _buildHeaderImage(BuildContext context, ShopKitTheme theme) {
    if (widget.product.images?.isEmpty != false) {
      return _buildPlaceholderImage(context, theme);
    }

    return Image.network(
      widget.product.images!.first,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _buildPlaceholderImage(context, theme),
    );
  }

  Widget _buildImageSection(BuildContext context, ShopKitTheme theme) {
    if (widget.customImageBuilder != null) {
      return widget.customImageBuilder!(
          context, widget.product, _selectedImageIndex);
    }

    switch (widget.imageStyle) {
      case ProductDetailImageStyle.gallery:
        return _buildImageGallery(context, theme);
      case ProductDetailImageStyle.fullWidth:
        return _buildFullWidthImage(context, theme);
      case ProductDetailImageStyle.aspectRatio:
        return _buildAspectRatioImage(context, theme);
      case ProductDetailImageStyle.carousel:
        return _buildImageCarousel(context, theme);
    }
  }

  Widget _buildImageCarousel(BuildContext context, ShopKitTheme theme) {
    if (widget.product.images?.isEmpty != false) {
      return _buildPlaceholderImage(context, theme);
    }

    return Container(
      margin: EdgeInsets.all(_getConfig('imageCarouselMargin', 16.0)),
      child: ImageCarousel(
        images: widget.product.images!
            .asMap()
            .entries
            .map((entry) => ImageModel(
                  id: 'product_${widget.product.id}_image_${entry.key}',
                  url: entry.value,
                  altText: '${widget.product.name} image ${entry.key + 1}',
                ))
            .toList(),
        enableZoom: widget.enableImageZoom,
        autoPlay: _getConfig('enableImageAutoPlay', false),
        onImageTap: (imageModel, index) =>
            _handleImageTap(imageModel.url, index),
        aspectRatio: _getConfig('imageAspectRatio', 1.0),
        config: _config,
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, ShopKitTheme theme) {
    if (widget.product.images?.isEmpty != false) {
      return _buildPlaceholderImage(context, theme);
    }

    return Container(
      height: _getConfig('imageGalleryHeight', 300.0),
      margin: EdgeInsets.all(_getConfig('imageGalleryMargin', 16.0)),
      child: Row(
        children: [
          Flexible(
            // Fixed: Changed from Expanded to Flexible
            flex: 3,
            fit: FlexFit.loose, // Fixed: Added FlexFit.loose
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  _getConfig('imageGalleryBorderRadius', 12.0)),
              child: Image.network(
                widget.product.images![_selectedImageIndex],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          SizedBox(width: _getConfig('imageGallerySpacing', 8.0)),
          Flexible(
            // Fixed: Changed from Expanded to Flexible
            flex: 1,
            fit: FlexFit.loose, // Fixed: Added FlexFit.loose
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
              children: widget.product.images!.take(4).map((image) {
                final index = widget.product.images!.indexOf(image);
                final isSelected = index == _selectedImageIndex;

                return Flexible(
                  // Fixed: Changed from Expanded to Flexible
                  fit: FlexFit.loose, // Fixed: Added FlexFit.loose
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedImageIndex = index),
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: _getConfig('thumbSpacing', 4.0)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            _getConfig('thumbBorderRadius', 8.0)),
                        border: isSelected
                            ? Border.all(
                                color: _config?.getColor(
                                        'selectedThumbBorderColor',
                                        theme.primaryColor) ??
                                    theme.primaryColor,
                                width:
                                    _getConfig('selectedThumbBorderWidth', 2.0),
                              )
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            _getConfig('thumbBorderRadius', 8.0)),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthImage(BuildContext context, ShopKitTheme theme) {
    if (widget.product.images?.isEmpty != false) {
      return _buildPlaceholderImage(context, theme);
    }

    return Image.network(
      widget.product.images![_selectedImageIndex],
      fit: BoxFit.cover,
      width: double.infinity,
      height: _getConfig('fullWidthImageHeight', 250.0),
    );
  }

  Widget _buildAspectRatioImage(BuildContext context, ShopKitTheme theme) {
    if (widget.product.images?.isEmpty != false) {
      return _buildPlaceholderImage(context, theme);
    }

    return AspectRatio(
      aspectRatio: _getConfig('imageAspectRatio', 16 / 9),
      child: Image.network(
        widget.product.images![_selectedImageIndex],
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getConfig('placeholderImageHeight', 250.0),
      margin: EdgeInsets.all(_getConfig('placeholderImageMargin', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('placeholderImageColor', theme.surfaceColor) ??
            theme.surfaceColor,
        borderRadius: BorderRadius.circular(
            _getConfig('placeholderImageBorderRadius', 12.0)),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: _getConfig('placeholderIconSize', 64.0),
          color: _config?.getColor('placeholderIconColor',
                  theme.onSurfaceColor.withValues(alpha: 0.5)) ??
              theme.onSurfaceColor.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ShopKitTheme theme) {
    if (widget.customInfoBuilder != null) {
      return widget.customInfoBuilder!(context, widget.product);
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('productInfoPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Text(
            widget.product.name,
            style: TextStyle(
              color:
                  _config?.getColor('productNameColor', theme.onSurfaceColor) ??
                      theme.onSurfaceColor,
              fontSize: _getConfig('productNameFontSize', 24.0),
              fontWeight: _config?.getFontWeight(
                      'productNameFontWeight', FontWeight.bold) ??
                  FontWeight.bold,
              height: _getConfig('productNameLineHeight', 1.2),
            ),
          ),
          SizedBox(height: _getConfig('productInfoSpacing', 8.0)),
          Row(
            mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
            children: [
              Text(
                '\$${_getDisplayPrice().toStringAsFixed(2)}',
                style: TextStyle(
                  color: _config?.getColor(
                          'productPriceColor', theme.primaryColor) ??
                      theme.primaryColor,
                  fontSize: _getConfig('productPriceFontSize', 20.0),
                  fontWeight: _config?.getFontWeight(
                          'productPriceFontWeight', FontWeight.bold) ??
                      FontWeight.bold,
                ),
              ),
              if (_hasDiscountPrice()) ...[
                SizedBox(width: _getConfig('priceSpacing', 8.0)),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: _config?.getColor('originalPriceColor',
                            theme.onSurfaceColor.withValues(alpha: 0.6)) ??
                        theme.onSurfaceColor.withValues(alpha: 0.6),
                    fontSize: _getConfig('originalPriceFontSize', 16.0),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (widget.product.rating != null && widget.product.rating! > 0) ...[
            SizedBox(height: _getConfig('ratingSpacing', 8.0)),
            _buildRatingDisplay(context, theme),
          ],
          if (widget.product.description?.isNotEmpty == true) ...[
            SizedBox(height: _getConfig('shortDescriptionSpacing', 16.0)),
            Text(
              widget.product.description!,
              style: TextStyle(
                color: _config?.getColor('shortDescriptionColor',
                        theme.onSurfaceColor.withValues(alpha: 0.8)) ??
                    theme.onSurfaceColor.withValues(alpha: 0.8),
                fontSize: _getConfig('shortDescriptionFontSize', 14.0),
                height: _getConfig('shortDescriptionLineHeight', 1.4),
              ),
              maxLines: _getConfig('shortDescriptionMaxLines', 3),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingDisplay(BuildContext context, ShopKitTheme theme) {
    final rating = widget.product.rating ?? 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star
                : index < rating
                    ? Icons.star_half
                    : Icons.star_border,
            color: _config?.getColor('starColor', Colors.amber) ?? Colors.amber,
            size: _getConfig('starSize', 16.0),
          );
        }),
        SizedBox(width: _getConfig('ratingTextSpacing', 8.0)),
        Text(
          '${rating.toStringAsFixed(1)} (${widget.reviews.length} reviews)',
          style: TextStyle(
            color: _config?.getColor('ratingTextColor',
                    theme.onSurfaceColor.withValues(alpha: 0.7)) ??
                theme.onSurfaceColor.withValues(alpha: 0.7),
            fontSize: _getConfig('ratingTextFontSize', 12.0),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSection(BuildContext context, ShopKitTheme theme) {
    if (widget.customVariantBuilder != null) {
      return widget.customVariantBuilder!(
          context, widget.product, _selectedVariant);
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('variantSectionPadding', 16.0)),
      child: VariantPicker(
        variants: widget.product.variants ?? [],
        selectedVariant: _selectedVariant,
        onVariantSelected: _handleVariantChanged,
        config: _config,
      ),
    );
  }

  Widget _buildQuantityAndActions(BuildContext context, ShopKitTheme theme) {
    if (widget.customActionBuilder != null) {
      return widget.customActionBuilder!(
          context, widget.product, _selectedVariant);
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('quantityActionsPadding', 16.0)),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          if (widget.enableQuantitySelector) ...[
            _buildQuantitySelector(context, theme),
            SizedBox(width: _getConfig('quantityActionsSpacing', 16.0)),
          ],
          Flexible(
            // Fixed: Changed from Expanded to Flexible
            fit: FlexFit.loose, // Fixed: Added FlexFit.loose
            child: AddToCartButton(
              product: widget.product,
              quantity: _selectedQuantity,
              onAddToCart: _handleAddToCart,
              config: _config,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, ShopKitTheme theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _config?.getColor(
                  'quantitySelectorBorderColor', theme.onSurfaceColor) ??
              theme.onSurfaceColor,
        ),
        borderRadius: BorderRadius.circular(
            _getConfig('quantitySelectorBorderRadius', 8.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _selectedQuantity > 1
                ? () => _handleQuantityChanged(_selectedQuantity - 1)
                : null,
            icon: Icon(
              Icons.remove,
              size: _getConfig('quantityIconSize', 16.0),
            ),
            padding: EdgeInsets.all(_getConfig('quantityIconPadding', 8.0)),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: _getConfig('quantityTextPadding', 16.0)),
            child: Text(
              _selectedQuantity.toString(),
              style: TextStyle(
                fontSize: _getConfig('quantityTextFontSize', 16.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _handleQuantityChanged(_selectedQuantity + 1),
            icon: Icon(
              Icons.add,
              size: _getConfig('quantityIconSize', 16.0),
            ),
            padding: EdgeInsets.all(_getConfig('quantityIconPadding', 8.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ShopKitTheme theme) {
    if (widget.customDescriptionBuilder != null) {
      return widget.customDescriptionBuilder!(context, widget.product);
    }

    if (widget.product.description?.isEmpty != false) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('descriptionSectionPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Text(
            _getConfig('descriptionSectionTitle', 'Description'),
            style: TextStyle(
              color: _config?.getColor(
                      'sectionTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('sectionTitleFontSize', 18.0),
              fontWeight: _config?.getFontWeight(
                      'sectionTitleFontWeight', FontWeight.bold) ??
                  FontWeight.bold,
            ),
          ),
          SizedBox(height: _getConfig('sectionTitleSpacing', 12.0)),
          AnimatedCrossFade(
            firstChild: Text(
              widget.product.description ?? '',
              style: TextStyle(
                color: _config?.getColor('descriptionTextColor',
                        theme.onSurfaceColor.withValues(alpha: 0.8)) ??
                    theme.onSurfaceColor.withValues(alpha: 0.8),
                fontSize: _getConfig('descriptionTextFontSize', 14.0),
                height: _getConfig('descriptionLineHeight', 1.5),
              ),
              maxLines: _getConfig('descriptionCollapsedMaxLines', 3),
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.product.description ?? '',
              style: TextStyle(
                color: _config?.getColor('descriptionTextColor',
                        theme.onSurfaceColor.withValues(alpha: 0.8)) ??
                    theme.onSurfaceColor.withValues(alpha: 0.8),
                fontSize: _getConfig('descriptionTextFontSize', 14.0),
                height: _getConfig('descriptionLineHeight', 1.5),
              ),
            ),
            crossFadeState: _showFullDescription
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          if ((widget.product.description?.length ?? 0) >
              _getConfig('descriptionToggleThreshold', 150))
            TextButton(
              onPressed: () =>
                  setState(() => _showFullDescription = !_showFullDescription),
              child: Text(
                _showFullDescription
                    ? _getConfig('showLessText', 'Show less')
                    : _getConfig('showMoreText', 'Show more'),
                style: TextStyle(
                  color: _config?.getColor(
                          'showMoreTextColor', theme.primaryColor) ??
                      theme.primaryColor,
                  fontSize: _getConfig('showMoreTextFontSize', 14.0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, ShopKitTheme theme) {
    if (widget.customReviewBuilder != null) {
      return widget.customReviewBuilder!(context, widget.reviews);
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('reviewsSectionPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getConfig('reviewsSectionTitle', 'Reviews'),
                style: TextStyle(
                  color: _config?.getColor(
                          'sectionTitleColor', theme.onSurfaceColor) ??
                      theme.onSurfaceColor,
                  fontSize: _getConfig('sectionTitleFontSize', 18.0),
                  fontWeight: _config?.getFontWeight(
                          'sectionTitleFontWeight', FontWeight.bold) ??
                      FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all reviews
                },
                child: Text(
                  _getConfig('seeAllReviewsText', 'See all'),
                  style: TextStyle(
                    color: _config?.getColor(
                            'seeAllTextColor', theme.primaryColor) ??
                        theme.primaryColor,
                    fontSize: _getConfig('seeAllTextFontSize', 14.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _getConfig('sectionTitleSpacing', 12.0)),
          ...widget.reviews
              .take(_getConfig('maxReviewsToShow', 3))
              .map((review) {
            return _buildReviewItem(context, theme, review);
          }),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('reviewItemSpacing', 16.0)),
      padding: EdgeInsets.all(_getConfig('reviewItemPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('reviewItemBackgroundColor',
                theme.surfaceColor.withValues(alpha: 0.5)) ??
            theme.surfaceColor.withValues(alpha: 0.5),
        borderRadius:
            BorderRadius.circular(_getConfig('reviewItemBorderRadius', 8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: _config?.getColor('reviewStarColor', Colors.amber) ??
                      Colors.amber,
                  size: _getConfig('reviewStarSize', 14.0),
                );
              }),
              SizedBox(width: _getConfig('reviewRatingSpacing', 8.0)),
              Text(
                review.userName,
                style: TextStyle(
                  color: _config?.getColor(
                          'reviewUserNameColor', theme.onSurfaceColor) ??
                      theme.onSurfaceColor,
                  fontSize: _getConfig('reviewUserNameFontSize', 12.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: _getConfig('reviewContentSpacing', 8.0)),
          Text(
            review.comment,
            style: TextStyle(
              color: _config?.getColor('reviewCommentColor',
                      theme.onSurfaceColor.withValues(alpha: 0.8)) ??
                  theme.onSurfaceColor.withValues(alpha: 0.8),
              fontSize: _getConfig('reviewCommentFontSize', 14.0),
              height: 1.4,
            ),
            maxLines: _getConfig('reviewCommentMaxLines', 3),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(
      BuildContext context, ShopKitTheme theme) {
    if (widget.customFooterBuilder != null) {
      return widget.customFooterBuilder!(
          context, widget.product, widget.relatedProducts);
    }

    return Container(
      padding:
          EdgeInsets.all(_getConfig('recommendationsSectionPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Text(
            _getConfig('recommendationsSectionTitle', 'You might also like'),
            style: TextStyle(
              color: _config?.getColor(
                      'sectionTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('sectionTitleFontSize', 18.0),
              fontWeight: _config?.getFontWeight(
                      'sectionTitleFontWeight', FontWeight.bold) ??
                  FontWeight.bold,
            ),
          ),
          SizedBox(height: _getConfig('sectionTitleSpacing', 12.0)),
          SizedBox(
            height: _getConfig('recommendationsHeight', 200.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.relatedProducts.length,
              itemBuilder: (context, index) {
                final product = widget.relatedProducts[index];
                return _buildRecommendationItem(context, theme, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
      BuildContext context, ShopKitTheme theme, ProductModel product) {
    return Container(
      width: _getConfig('recommendationItemWidth', 140.0),
      margin:
          EdgeInsets.only(right: _getConfig('recommendationItemSpacing', 12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Flexible(
            // Fixed: Changed from Expanded to Flexible
            fit: FlexFit.loose, // Fixed: Added FlexFit.loose
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  _getConfig('recommendationImageBorderRadius', 8.0)),
              child: Image.network(
                (product.images?.isNotEmpty == true)
                    ? product.images!.first
                    : '',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.surfaceColor,
                  child: Icon(
                    Icons.image_not_supported,
                    color: theme.onSurfaceColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: _getConfig('recommendationContentSpacing', 8.0)),
          Text(
            product.name,
            style: TextStyle(
              color: _config?.getColor(
                      'recommendationNameColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('recommendationNameFontSize', 12.0),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '\${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              color: _config?.getColor(
                      'recommendationPriceColor', theme.primaryColor) ??
                  theme.primaryColor,
              fontSize: _getConfig('recommendationPriceFontSize', 12.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('bottomActionsPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor(
                'bottomActionsBackgroundColor', theme.surfaceColor) ??
            theme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: theme.onSurfaceColor.withValues(
                alpha: _getConfig('bottomActionsShadowOpacity', 0.1)),
            blurRadius: _getConfig('bottomActionsShadowBlurRadius', 8.0),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleAddToCartSimple,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _config?.getColor(
                            'addToCartButtonColor', theme.primaryColor) ??
                        theme.primaryColor,
                    foregroundColor: _config?.getColor(
                            'addToCartButtonTextColor', theme.onPrimaryColor) ??
                        theme.onPrimaryColor,
                    padding: EdgeInsets.symmetric(
                        vertical:
                            _getConfig('bottomButtonVerticalPadding', 16.0)),
                  ),
                  child: Text(
                    _getConfig('addToCartButtonText', 'Add to Cart'),
                    style: TextStyle(
                      fontSize: _getConfig('bottomButtonFontSize', 16.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: _getConfig('bottomButtonSpacing', 12.0)),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleBuyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _config?.getColor(
                            'buyNowButtonColor', theme.secondaryColor) ??
                        theme.secondaryColor,
                    foregroundColor: _config?.getColor(
                            'buyNowButtonTextColor', theme.onSecondaryColor) ??
                        theme.onSecondaryColor,
                    padding: EdgeInsets.symmetric(
                        vertical:
                            _getConfig('bottomButtonVerticalPadding', 16.0)),
                  ),
                  child: Text(
                    _getConfig('buyNowButtonText', 'Buy Now'),
                    style: TextStyle(
                      fontSize: _getConfig('bottomButtonFontSize', 16.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab content builders
  Widget _buildOverviewTab(BuildContext context, ShopKitTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_getConfig('tabContentPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          _buildImageSection(context, theme),
          _buildProductInfo(context, theme),
          if (widget.enableVariantSelection &&
              widget.product.variants?.isNotEmpty == true)
            _buildVariantSection(context, theme),
          _buildDescriptionSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTab(BuildContext context, ShopKitTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_getConfig('tabContentPadding', 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Text(
            _getConfig('specificationsTitle', 'Specifications'),
            style: TextStyle(
              color: _config?.getColor(
                      'sectionTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('sectionTitleFontSize', 18.0),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: _getConfig('sectionTitleSpacing', 16.0)),

          // Add specifications content here
          Text(
            _getConfig('noSpecificationsText', 'No specifications available'),
            style: TextStyle(
              color: _config?.getColor('noContentTextColor',
                      theme.onSurfaceColor.withValues(alpha: 0.6)) ??
                  theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('noContentTextFontSize', 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, ShopKitTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_getConfig('tabContentPadding', 16.0)),
      child: widget.reviews.isEmpty
          ? _buildEmptyReviews(context, theme)
          : Column(
              mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
              children: widget.reviews.map((review) {
                return _buildReviewItem(context, theme, review);
              }).toList(),
            ),
    );
  }

  Widget _buildRecommendationsTab(BuildContext context, ShopKitTheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_getConfig('tabContentPadding', 16.0)),
      child: widget.relatedProducts.isEmpty
          ? _buildEmptyRecommendations(context, theme)
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getConfig('recommendationsGridColumns', 2),
                childAspectRatio:
                    _getConfig('recommendationsGridAspectRatio', 0.8),
                mainAxisSpacing:
                    _getConfig('recommendationsGridMainSpacing', 16.0),
                crossAxisSpacing:
                    _getConfig('recommendationsGridCrossSpacing', 16.0),
              ),
              itemCount: widget.relatedProducts.length,
              itemBuilder: (context, index) {
                return _buildRecommendationItem(
                    context, theme, widget.relatedProducts[index]);
              },
            ),
    );
  }

  Widget _buildAccordionSections(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
      children: [
        _buildAccordionSection(
          context,
          theme,
          _getConfig('descriptionAccordionTitle', 'Description'),
          _buildDescriptionContent(context, theme),
        ),
        if (widget.enableVariantSelection &&
            widget.product.variants?.isNotEmpty == true)
          _buildAccordionSection(
            context,
            theme,
            _getConfig('variantsAccordionTitle', 'Options'),
            _buildVariantSection(context, theme),
          ),
        if (widget.enableReviews && widget.reviews.isNotEmpty)
          _buildAccordionSection(
            context,
            theme,
            _getConfig('reviewsAccordionTitle', 'Reviews'),
            _buildReviewsContent(context, theme),
          ),
      ],
    );
  }

  Widget _buildAccordionSection(
      BuildContext context, ShopKitTheme theme, String title, Widget content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color:
              _config?.getColor('accordionTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
          fontSize: _getConfig('accordionTitleFontSize', 16.0),
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [content],
    );
  }

  Widget _buildDescriptionContent(BuildContext context, ShopKitTheme theme) {
    return Padding(
      padding: EdgeInsets.all(_getConfig('accordionContentPadding', 16.0)),
      child: Text(
        widget.product.description ?? '',
        style: TextStyle(
          color: _config?.getColor('descriptionTextColor',
                  theme.onSurfaceColor.withValues(alpha: 0.8)) ??
              theme.onSurfaceColor.withValues(alpha: 0.8),
          fontSize: _getConfig('descriptionTextFontSize', 14.0),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildReviewsContent(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
      children: widget.reviews.map((review) {
        return _buildReviewItem(context, theme, review);
      }).toList(),
    );
  }

  Widget _buildEmptyReviews(BuildContext context, ShopKitTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: _getConfig('emptyStateIconSize', 64.0),
            color: _config?.getColor('emptyStateIconColor',
                    theme.onSurfaceColor.withValues(alpha: 0.4)) ??
                theme.onSurfaceColor.withValues(alpha: 0.4),
          ),
          SizedBox(height: _getConfig('emptyStateSpacing', 16.0)),
          Text(
            _getConfig('noReviewsTitle', 'No reviews yet'),
            style: TextStyle(
              color: _config?.getColor(
                      'emptyStateTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('emptyStateTitleFontSize', 18.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: _getConfig('emptyStateDescSpacing', 8.0)),
          Text(
            _getConfig(
                'noReviewsDescription', 'Be the first to review this product'),
            style: TextStyle(
              color: _config?.getColor('emptyStateDescColor',
                      theme.onSurfaceColor.withValues(alpha: 0.6)) ??
                  theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('emptyStateDescFontSize', 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRecommendations(BuildContext context, ShopKitTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Fixed: Added mainAxisSize.min
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: _getConfig('emptyStateIconSize', 64.0),
            color: _config?.getColor('emptyStateIconColor',
                    theme.onSurfaceColor.withValues(alpha: 0.4)) ??
                theme.onSurfaceColor.withValues(alpha: 0.4),
          ),
          SizedBox(height: _getConfig('emptyStateSpacing', 16.0)),
          Text(
            _getConfig('noRecommendationsTitle', 'No recommendations'),
            style: TextStyle(
              color: _config?.getColor(
                      'emptyStateTitleColor', theme.onSurfaceColor) ??
                  theme.onSurfaceColor,
              fontSize: _getConfig('emptyStateTitleFontSize', 18.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: _getConfig('emptyStateDescSpacing', 8.0)),
          Text(
            _getConfig('noRecommendationsDescription',
                'Check back later for related products'),
            style: TextStyle(
              color: _config?.getColor('emptyStateDescColor',
                      theme.onSurfaceColor.withValues(alpha: 0.6)) ??
                  theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('emptyStateDescFontSize', 14.0),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  double _getDisplayPrice() {
    if (_selectedVariant != null && _selectedVariant!.additionalPrice != null) {
      return widget.product.price + _selectedVariant!.additionalPrice!;
    }
    return widget.product.price;
  }

  bool _hasDiscountPrice() {
    return _selectedVariant?.additionalPrice != null &&
        _selectedVariant!.additionalPrice! < 0;
  }

  int _getTabbedSectionCount() {
    int count = 2; // Overview and Specifications
    if (widget.enableReviews) count++;
    if (widget.enableRecommendations) count++;
    return count;
  }

  /// Build themed product detail with ShopKitThemeConfig
  Widget _buildThemedProductDetail(BuildContext context, ShopKitTheme theme, String themeStyleString) {
    final themeStyle = ShopKitThemeStyleExtension.fromString(themeStyleString);
    final themeConfig = ShopKitThemeConfig.forStyle(themeStyle, context);
    
    // Get themed container decoration
    final decoration = BoxDecoration(
      color: themeConfig.backgroundColor ?? theme.surfaceColor,
      borderRadius: BorderRadius.circular(themeConfig.borderRadius),
      boxShadow: themeConfig.enableShadows ? [
        BoxShadow(
          color: (themeConfig.shadowColor ?? theme.onSurfaceColor).withValues(alpha: 0.1),
          blurRadius: themeConfig.elevation * 2,
          offset: Offset(0, themeConfig.elevation),
        ),
      ] : null,
    );
    
    Widget content = _buildProductDetail(context, theme);
    
    // Apply theme-specific styling
    return Container(
      decoration: decoration,
      child: content,
    );
  }

  /// Public API for external control
  VariantModel? get selectedVariant => _selectedVariant;

  int get selectedQuantity => _selectedQuantity;

  int get selectedImageIndex => _selectedImageIndex;

  bool get isWishlisted => _isWishlisted;

  void selectVariant(VariantModel variant) {
    if (widget.product.variants?.contains(variant) == true) {
      _handleVariantChanged(variant);
    }
  }

  void setQuantity(int quantity) {
    if (quantity > 0) {
      _handleQuantityChanged(quantity);
    }
  }

  void selectImage(int index) {
    if (index >= 0 && index < (widget.product.images?.length ?? 0)) {
      setState(() {
        _selectedImageIndex = index;
      });
    }
  }

  void toggleWishlist() {
    _handleWishlistToggle();
  }

  void scrollToSection(String section) {
    // Implement scroll to section logic
  }
}

/// Style options for product detail view
enum ProductDetailStyle {
  standard,
  minimal,
  card,
  magazine,
}

/// Layout options for product detail view
enum ProductDetailLayout {
  scrollable,
  tabbed,
  accordion,
  grid,
}

/// Image display style options
enum ProductDetailImageStyle {
  carousel,
  gallery,
  fullWidth,
  aspectRatio,
}
