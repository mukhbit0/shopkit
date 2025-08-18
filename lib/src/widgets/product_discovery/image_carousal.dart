import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system
import '../../models/image_model.dart';

/// A comprehensive image carousel widget, styled via ShopKitTheme.
///
/// Features multiple layouts, zoom functionality, thumbnails, indicators, and advanced theming.
/// The appearance is now controlled centrally through the `ImageCarouselTheme`.
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.onImageTap,
    this.onImageChange,
    this.initialIndex = 0,
    this.customBuilder,
    this.customImageBuilder,
    this.customThumbnailBuilder,
    this.customIndicatorBuilder,
    this.layout = CarouselLayout.stack,
    this.height,
    this.aspectRatio = 1.0,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.enableZoom = true,
    this.enableFullscreen = true,
    this.showThumbnails = true,
    this.showIndicators = true,
    this.showZoomButton = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  final List<ImageModel> images;
  final void Function(ImageModel, int)? onImageTap;
  final void Function(ImageModel, int)? onImageChange;
  final int initialIndex;
  final Widget Function(BuildContext, List<ImageModel>, ImageCarouselState)? customBuilder;
  final Widget Function(BuildContext, ImageModel, int, bool)? customImageBuilder;
  final Widget Function(BuildContext, ImageModel, int, bool)? customThumbnailBuilder;
  final Widget Function(BuildContext, int, int)? customIndicatorBuilder;
  final CarouselLayout layout;
  final double? height;
  final double aspectRatio;
  final bool enableAnimations;
  final bool enableHaptics;
  final bool enableZoom;
  final bool enableFullscreen;
  final bool showThumbnails;
  final bool showIndicators;
  final bool showZoomButton;
  final bool autoPlay;
  final Duration autoPlayInterval;

  @override
  State<ImageCarousel> createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late TransformationController _transformationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.images.isNotEmpty ? widget.images.length - 1 : 0);
    _pageController = PageController(initialPage: _currentIndex);
    _transformationController = TransformationController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAnimations());
    _setupAutoPlay();
  }

  @override
  void didUpdateWidget(ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoPlay != oldWidget.autoPlay) {
      _autoPlayTimer?.cancel();
      if (widget.autoPlay) _setupAutoPlay();
    }
    if (widget.images != oldWidget.images) {
      _currentIndex = _currentIndex.clamp(0, widget.images.isNotEmpty ? widget.images.length - 1 : 0);
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    _animationController = AnimationController(
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: shopKitTheme?.animations.easeIn ?? Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut));

    if (widget.enableAnimations) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  void _setupAutoPlay() {
    if (widget.autoPlay && widget.images.length > 1) {
      _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
        if (mounted) _nextImage();
      });
    }
  }

  void _nextImage() {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final nextIndex = (_currentIndex + 1) % widget.images.length;
    _pageController.animateToPage(
      nextIndex,
      duration: shopKitTheme?.animations.fast ?? const Duration(milliseconds: 300),
      curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    widget.onImageChange?.call(widget.images[index], index);
  }

  void _onImageTap(ImageModel image, int index) {
    if (widget.enableHaptics) HapticFeedback.mediumImpact();
    widget.onImageTap?.call(image, index);
    if (widget.enableFullscreen) _showFullscreenImage(image, index);
  }

  void _onThumbnailTap(int index) {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    _pageController.animateToPage(
      index,
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 300),
      curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut,
    );
  }

  void _showFullscreenImage(ImageModel image, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenImageView(
          images: widget.images,
          initialIndex: index,
        ),
        fullscreenDialog: true,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.images, this);
    }
    
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final carouselTheme = shopKitTheme?.imageCarouselTheme;

    if (widget.images.isEmpty) {
      return _buildEmptyState(theme, shopKitTheme);
    }

    final child = Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: carouselTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.lg ?? 16.0),
      ),
      child: ClipRRect(
        borderRadius: carouselTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.lg ?? 16.0),
        child: _buildCarouselLayout(theme, shopKitTheme),
      ),
    );

    return widget.enableAnimations
        ? FadeTransition(opacity: _fadeAnimation, child: SlideTransition(position: _slideAnimation, child: child))
        : child;
  }

  Widget _buildCarouselLayout(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            final image = widget.images[index];
            final isActive = index == _currentIndex;
            return widget.customImageBuilder?.call(context, image, index, isActive) ??
                _buildImageItem(theme, shopKitTheme, image);
          },
        ),
        if (widget.showThumbnails) _buildThumbnailNavigation(theme, shopKitTheme),
        if (widget.showIndicators && !widget.showThumbnails) _buildIndicators(theme, shopKitTheme),
      ],
    );
  }

  Widget _buildImageItem(ThemeData theme, ShopKitTheme? shopKitTheme, ImageModel image) {
    final imageWidget = Image.network(
      image.url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : Center(child: CircularProgressIndicator(color: shopKitTheme?.colors.primary)),
      errorBuilder: (context, error, stack) =>
          Container(color: theme.colorScheme.surfaceVariant, child: Icon(Icons.broken_image, color: theme.colorScheme.onSurfaceVariant)),
    );

    return GestureDetector(
      onTap: () => _onImageTap(image, _currentIndex),
      child: widget.enableZoom
          ? InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 4.0,
              child: imageWidget,
            )
          : imageWidget,
    );
  }

  Widget _buildThumbnailNavigation(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final carouselTheme = shopKitTheme?.imageCarouselTheme;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80.0,
        color: (carouselTheme?.arrowBackgroundColor ?? Colors.black).withOpacity(0.5),
        padding: EdgeInsets.all(shopKitTheme?.spacing.sm ?? 8.0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          separatorBuilder: (context, index) => SizedBox(width: shopKitTheme?.spacing.sm ?? 8.0),
          itemBuilder: (context, index) {
            final image = widget.images[index];
            final isActive = index == _currentIndex;
            return widget.customThumbnailBuilder?.call(context, image, index, isActive) ??
                _buildThumbnailItem(theme, shopKitTheme, image, index, isActive);
          },
        ),
      ),
    );
  }

  Widget _buildThumbnailItem(ThemeData theme, ShopKitTheme? shopKitTheme, ImageModel image, int index, bool isActive) {
    final carouselTheme = shopKitTheme?.imageCarouselTheme;
    return GestureDetector(
      onTap: () => _onThumbnailTap(index),
      child: AnimatedContainer(
        duration: shopKitTheme?.animations.fast ?? const Duration(milliseconds: 200),
        width: 60,
        decoration: BoxDecoration(
          borderRadius: carouselTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.sm ?? 8.0),
          border: Border.all(
            color: isActive ? (carouselTheme?.activeIndicatorColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary) : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: carouselTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.sm ?? 8.0),
          child: Image.network(image.url, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildIndicators(ThemeData theme, ShopKitTheme? shopKitTheme) {
    if (widget.images.length <= 1) return const SizedBox.shrink();
    return Positioned(
      bottom: shopKitTheme?.spacing.md ?? 16.0,
      left: 0,
      right: 0,
      child: widget.customIndicatorBuilder?.call(context, _currentIndex, widget.images.length) ??
          _buildDefaultIndicators(theme, shopKitTheme),
    );
  }

  Widget _buildDefaultIndicators(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final carouselTheme = shopKitTheme?.imageCarouselTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.images.length, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: shopKitTheme?.animations.fast ?? const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: shopKitTheme?.spacing.xs ?? 4.0),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive 
                ? (carouselTheme?.activeIndicatorColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary)
                : (carouselTheme?.indicatorColor ?? theme.colorScheme.onSurface.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ShopKitTheme? shopKitTheme) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(shopKitTheme?.radii.lg ?? 16.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
            SizedBox(height: shopKitTheme?.spacing.md ?? 16.0),
            Text('No Images Available', style: shopKitTheme?.typography.body1),
          ],
        ),
      ),
    );
  }
}

enum CarouselLayout { stack, page, grid, list }

class _FullscreenImageView extends StatefulWidget {
  final List<ImageModel> images;
  final int initialIndex;
  const _FullscreenImageView({required this.images, required this.initialIndex});

  @override
  State<_FullscreenImageView> createState() => _FullscreenImageViewState();
}

class _FullscreenImageViewState extends State<_FullscreenImageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('${_currentIndex + 1} / ${widget.images.length}', style: const TextStyle(color: Colors.white)),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(child: Image.network(widget.images[index].url, fit: BoxFit.contain)),
          );
        },
      ),
    );
  }
}