import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product_model.dart';
import '../../models/variant_model.dart';
import '../../models/review_model.dart';
import '../../models/image_model.dart';
import '../../theme/theme.dart';
import 'image_carousal.dart';
import 'variant_picker.dart';
import '../cart_management/add_to_cart_button.dart';
import 'review_widget.dart'; // Assuming you have a ReviewWidget
import 'product_recommendation.dart'; // Assuming you have a ProductRecommendation widget

/// A comprehensive product detail view widget, styled via ShopKitTheme.
class ProductDetailViewNew extends StatefulWidget {
  const ProductDetailViewNew({
    super.key,
    required this.product,
    this.customBuilder,
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
    this.layout = ProductDetailLayout.scrollable,
    this.imageStyle = ProductDetailImageStyle.carousel,
  });

  final ProductModel product;
  final Widget Function(BuildContext, ProductModel, ProductDetailViewNewState)? customBuilder;
  final Function(VariantModel)? onVariantChanged;
  final Function(ProductModel, VariantModel?, int)? onAddToCart;
  final Function(ProductModel, VariantModel?, int)? onBuyNow;
  final Function(ProductModel, bool)? onWishlistToggle;
  final Function(ProductModel)? onShare;
  final Function(ReviewModel)? onReviewTap;
  final void Function(ImageModel, int)? onImageTap;
  final List<ProductModel> relatedProducts;
  final List<ReviewModel> reviews;
  final bool enableImageZoom;
  final bool enableVariantSelection;
  final bool enableReviews;
  final bool enableRecommendations;
  final bool enableSocialSharing;
  final bool enableWishlist;
  final bool enableQuantitySelector;
  final bool enableAnimations;
  final bool enableHaptics;
  final ProductDetailLayout layout;
  final ProductDetailImageStyle imageStyle;

  @override
  State<ProductDetailViewNew> createState() => ProductDetailViewNewState();
}

class ProductDetailViewNewState extends State<ProductDetailViewNew> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  VariantModel? _selectedVariant;
  int _selectedQuantity = 1;
  // removed unused _selectedImageIndex
  bool _isWishlisted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.product.variants?.isNotEmpty == true) {
      _selectedVariant = widget.product.variants!.first;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAnimations());
  }

  void _setupAnimations() {
    if (!mounted) return;
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    _slideController = AnimationController(
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: shopKitTheme?.animations.easeOut ?? Curves.easeOutCubic));

    if (widget.enableAnimations) {
      _slideController.forward();
    } else {
      _slideController.value = 1.0;
    }
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleVariantChanged(VariantModel variant) {
    setState(() => _selectedVariant = variant);
    if (widget.enableHaptics) HapticFeedback.selectionClick();
    widget.onVariantChanged?.call(variant);
  }

  void _handleQuantityChanged(int quantity) {
    setState(() => _selectedQuantity = quantity);
    if (widget.enableHaptics) HapticFeedback.lightImpact();
  }

  void _handleAddToCart() {
    if (widget.enableHaptics) HapticFeedback.mediumImpact();
    widget.onAddToCart?.call(widget.product, _selectedVariant, _selectedQuantity);
  }

  void _handleBuyNow() {
    if (widget.enableHaptics) HapticFeedback.heavyImpact();
    widget.onBuyNow?.call(widget.product, _selectedVariant, _selectedQuantity);
  }

  void _handleWishlistToggle() {
    setState(() => _isWishlisted = !_isWishlisted);
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    widget.onWishlistToggle?.call(widget.product, _isWishlisted);
  }

  void _handleShare() {
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    widget.onShare?.call(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.product, this);
    }

    Widget content = _buildScrollableLayout();

    return widget.enableAnimations
        ? SlideTransition(position: _slideAnimation, child: content)
        : content;
  }

  Widget _buildScrollableLayout() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;
    
    return Scaffold(
      // prefer surface over deprecated background color
      backgroundColor: detailTheme?.backgroundColor ?? shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(),
                if (widget.enableVariantSelection && widget.product.variants?.isNotEmpty == true)
                  _buildVariantSection(),
                _buildDescriptionSection(),
                if (widget.enableReviews && widget.reviews.isNotEmpty)
                  _buildReviewsSection(),
                if (widget.enableRecommendations && widget.relatedProducts.isNotEmpty)
                  _buildRecommendationsSection(),
                SizedBox(height: 100), // Space for the sticky bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(),
    );
  }

  Widget _buildSliverAppBar() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;

    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: detailTheme?.appBarColor ?? shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
      foregroundColor: detailTheme?.appBarIconColor ?? shopKitTheme?.colors.onSurface ?? theme.colorScheme.onSurface,
      actions: _buildAppBarActions(),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildImageSection(),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;

    return [
      if (widget.enableWishlist)
        IconButton(
          onPressed: _handleWishlistToggle,
          icon: Icon(
            _isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: _isWishlisted ? (shopKitTheme?.colors.error ?? theme.colorScheme.error) : (detailTheme?.appBarIconColor ?? shopKitTheme?.colors.onSurface),
          ),
        ),
      if (widget.enableSocialSharing)
        IconButton(
          onPressed: _handleShare,
          icon: Icon(Icons.share, color: detailTheme?.appBarIconColor ?? shopKitTheme?.colors.onSurface),
        ),
      SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
    ];
  }
  
  Widget _buildImageSection() {
    // This section would contain your ImageCarousel widget
    // Adapter: ImageCarousel expects ImageModel; allow callers to pass a simpler
    // (ImageModel, int) callback by forwarding using the provided ImageModel.url
    // if they previously used a (String, int) signature. We keep the typed
    // public API as ImageModel-based so it's consistent across widgets.
    return ImageCarousel(
      images: widget.product.allImages.map((url) => ImageModel(id: url, url: url)).toList(),
      onImageTap: widget.onImageTap,
      enableZoom: widget.enableImageZoom,
    );
  }
  
  Widget _buildProductInfo() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;

    return Padding(
      padding: EdgeInsets.all(shopKitTheme?.spacing.md ?? 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name, style: detailTheme?.productNameStyle ?? shopKitTheme?.typography.headline1),
          SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
          Row(
            children: [
              Text(
                widget.product.formattedPrice,
                style: detailTheme?.productPriceStyle ?? shopKitTheme?.typography.headline2.copyWith(color: shopKitTheme.colors.primary),
              ),
              if (widget.product.hasDiscount) ...[
                SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
                Text(
                  widget.product.formattedOriginalPrice,
                  style: detailTheme?.originalPriceStyle ?? shopKitTheme?.typography.body1.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round())
                  ),
                ),
              ]
            ],
          ),
           if (widget.product.rating != null) ...[
            SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
            Row(
              children: [
                Icon(Icons.star, color: detailTheme?.starColor ?? Colors.amber, size: 20),
                SizedBox(width: shopKitTheme?.spacing.xs ?? 4.0),
                Text(
                  '${widget.product.rating?.toStringAsFixed(1)} (${widget.reviews.length} reviews)',
                  style: shopKitTheme?.typography.body2.copyWith(color: theme.colorScheme.onSurfaceVariant),
                )
              ],
            )
           ]
        ],
      ),
    );
  }

  Widget _buildVariantSection() {
    return Padding(
      padding: EdgeInsets.all(Theme.of(context).extension<ShopKitTheme>()?.spacing.md ?? 16.0),
      child: VariantPicker(
        variants: widget.product.variants ?? [],
        selectedVariant: _selectedVariant,
        onVariantSelected: _handleVariantChanged,
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;

    return Padding(
      padding: EdgeInsets.all(shopKitTheme?.spacing.md ?? 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: shopKitTheme?.typography.headline2),
          SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
          Text(widget.product.description ?? 'No description available.', style: detailTheme?.descriptionTextStyle ?? shopKitTheme?.typography.body1),
        ],
      ),
    );
  }
  
  Widget _buildReviewsSection() {
    // This would contain your ReviewWidget
    return Padding(
      padding: EdgeInsets.all(Theme.of(context).extension<ShopKitTheme>()?.spacing.md ?? 16.0),
      child: ReviewWidget(reviews: widget.reviews),
    );
  }

  Widget _buildRecommendationsSection() {
    // This would contain your ProductRecommendation widget
    return ProductRecommendation(
      products: widget.relatedProducts,
  title: 'You might also like',
    );
  }

  Widget _buildBottomActions() {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final detailTheme = shopKitTheme?.productDetailViewTheme;
    final spacing = shopKitTheme?.spacing.md ?? 16.0;

    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: detailTheme?.appBarColor ?? shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
  boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).round()), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AddToCartButton(
                product: widget.product,
                quantity: _selectedQuantity,
                onAddToCart: (_) => _handleAddToCart(),
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleBuyNow,
                style: detailTheme?.buyNowButtonStyle ?? ElevatedButton.styleFrom(
                  backgroundColor: shopKitTheme?.colors.secondary ?? theme.colorScheme.secondary,
                  foregroundColor: shopKitTheme?.colors.onSecondary ?? theme.colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(vertical: spacing),
                  textStyle: shopKitTheme?.typography.button,
                ),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Public API for external control ---
  VariantModel? get selectedVariant => _selectedVariant;
  int get selectedQuantity => _selectedQuantity;
  bool get isWishlisted => _isWishlisted;
  void selectVariant(VariantModel variant) => _handleVariantChanged(variant);
  void setQuantity(int quantity) => _handleQuantityChanged(quantity);
  void toggleWishlist() => _handleWishlistToggle();
}

/// Layout options for product detail view
enum ProductDetailLayout { scrollable, tabbed, accordion, grid }
/// Image display style options
enum ProductDetailImageStyle { carousel, gallery, fullWidth, aspectRatio }