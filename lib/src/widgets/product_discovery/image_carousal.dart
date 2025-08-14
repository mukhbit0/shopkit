import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../models/image_model.dart';

/// A comprehensive image carousel widget with unlimited customization options
/// Features: Multiple layouts, zoom functionality, thumbnails, indicators, and advanced theming
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.onImageTap,
    this.onImageChange,
    this.initialIndex = 0,
    this.config,
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
    this.autoPlayInterval,
    this.themeStyle,
  });

  /// List of images to display
  final List<ImageModel> images;

  /// Callback when an image is tapped
  final void Function(ImageModel, int)? onImageTap;

  /// Callback when current image changes
  final void Function(ImageModel, int)? onImageChange;

  /// Initial image index to display
  final int initialIndex;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<ImageModel>, ImageCarouselState)? customBuilder;

  /// Custom image item builder
  final Widget Function(BuildContext, ImageModel, int, bool)? customImageBuilder;

  /// Custom thumbnail builder
  final Widget Function(BuildContext, ImageModel, int, bool)? customThumbnailBuilder;

  /// Custom indicator builder
  final Widget Function(BuildContext, int, int)? customIndicatorBuilder;

  /// Layout style for the carousel
  final CarouselLayout layout;

  /// Custom carousel height
  final double? height;

  /// Aspect ratio for the carousel
  final double aspectRatio;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to enable pinch-to-zoom
  final bool enableZoom;

  /// Whether to enable fullscreen mode
  final bool enableFullscreen;

  /// Whether to show thumbnail navigation
  final bool showThumbnails;

  /// Whether to show page indicators
  final bool showIndicators;

  /// Whether to show zoom button
  final bool showZoomButton;

  /// Whether to auto-play the carousel
  final bool autoPlay;

  /// Auto-play interval duration
  final Duration? autoPlayInterval;

  /// Built-in theme style support - pass theme name as string
  final String? themeStyle;

  @override
  State<ImageCarousel> createState() => ImageCarouselState();
}

class ImageCarouselState extends State<ImageCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _zoomController;
  late AnimationController _thumbnailController;
  late TransformationController _transformationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  bool _isZoomed = false;
  FlexibleWidgetConfig? _config;
  
  // Auto-play functionality
  Timer? _autoPlayTimer;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('image_carousel', context: context);
    _currentIndex = widget.initialIndex.clamp(0, widget.images.length - 1);
    _setupControllers();
    _setupAnimations();
    _setupAutoPlay();
  }

  void _setupControllers() {
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: _getConfig('viewportFraction', 1.0),
    );
    _transformationController = TransformationController();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: _getConfig('containerAnimationDuration', 500)),
      vsync: this,
    );

    _zoomController = AnimationController(
      duration: Duration(milliseconds: _getConfig('zoomAnimationDuration', 300)),
      vsync: this,
    );

    _thumbnailController = AnimationController(
      duration: Duration(milliseconds: _getConfig('thumbnailAnimationDuration', 400)),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _config?.getCurve('fadeAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, _getConfig('slideAnimationOffset', 0.1)),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
    ));

    if (widget.enableAnimations) {
      _animationController.forward();
      _thumbnailController.forward();
    }
  }

  void _setupAutoPlay() {
    if (widget.autoPlay && widget.images.length > 1) {
      final interval = widget.autoPlayInterval ?? 
        Duration(milliseconds: _getConfig('autoPlayInterval', 3000));
      
      _autoPlayTimer = Timer.periodic(interval, (timer) {
        if (mounted && !_isZoomed) {
          _nextImage();
        }
      });
    }
  }

  void _nextImage() {
    final nextIndex = (_currentIndex + 1) % widget.images.length;
    _pageController.animateToPage(
      nextIndex,
      duration: Duration(milliseconds: _getConfig('pageTransitionDuration', 300)),
      curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );
  }

  void _previousImage() {
    final previousIndex = (_currentIndex - 1 + widget.images.length) % widget.images.length;
    _pageController.animateToPage(
      previousIndex,
      duration: Duration(milliseconds: _getConfig('pageTransitionDuration', 300)),
      curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    if (widget.enableHaptics && _getConfig('enablePageChangeHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    setState(() => _currentIndex = index);
    
    final currentImage = widget.images[index];
    widget.onImageChange?.call(currentImage, index);
  }

  void _onImageTap(ImageModel image, int index) {
    if (widget.enableHaptics && _getConfig('enableTapHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    widget.onImageTap?.call(image, index);

    if (widget.enableFullscreen && _getConfig('tapToFullscreen', true)) {
      _showFullscreenImage(image, index);
    }
  }

  void _onThumbnailTap(int index) {
    if (widget.enableHaptics && _getConfig('enableThumbnailHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: _getConfig('thumbnailTransitionDuration', 300)),
      curve: _config?.getCurve('thumbnailTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );
  }

  void _toggleZoom() {
    setState(() => _isZoomed = !_isZoomed);
    
    if (_isZoomed) {
      _zoomController.forward();
      _transformationController.value = Matrix4.identity()..scale(2.0);
    } else {
      _zoomController.reverse();
      _transformationController.value = Matrix4.identity();
    }
  }

  void _showFullscreenImage(ImageModel image, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenImageView(
          images: widget.images,
          initialIndex: index,
          config: _config,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void didUpdateWidget(ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update config
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('image_carousel', context: context);
    
    // Update auto-play
    if (widget.autoPlay != oldWidget.autoPlay) {
      _autoPlayTimer?.cancel();
      if (widget.autoPlay) {
        _setupAutoPlay();
      }
    }
    
    // Update current index if images changed
    if (widget.images != oldWidget.images) {
      _currentIndex = _currentIndex.clamp(0, widget.images.length - 1);
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    _zoomController.dispose();
    _thumbnailController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.images, this);
    }

    final useNewTheme = widget.themeStyle != null;
    ShopKitThemeConfig? cfg;
    if (useNewTheme) {
      final style = ShopKitThemeStyleExtension.fromString(widget.themeStyle!);
      cfg = ShopKitThemeConfig.forStyle(style, context);
    }

    final legacyTheme = ShopKitThemeProvider.of(context);

    if (widget.images.isEmpty) {
      return useNewTheme ? _buildThemedEmptyState(context, cfg!) : _buildEmptyState(context, legacyTheme);
    }

    final child = useNewTheme
        ? _buildThemedCarousel(context, cfg!)
        : _buildCarousel(context, legacyTheme);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: child),
    );
  }

  // ===================== New Themed Implementation =====================
  Widget _buildThemedCarousel(BuildContext context, ShopKitThemeConfig cfg) {
    switch (widget.layout) {
      case CarouselLayout.stack:
        return _buildThemedStackLayout(context, cfg);
      case CarouselLayout.page:
        return _buildThemedPageLayout(context, cfg);
      case CarouselLayout.grid:
        return _buildThemedGridLayout(context, cfg);
      case CarouselLayout.list:
        return _buildThemedListLayout(context, cfg);
    }
  }

  Widget _buildThemedStackLayout(BuildContext context, ShopKitThemeConfig cfg) {
    final bg = cfg.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final showBorder = cfg.enableGradients;
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: cfg.enableBlur ? 0.85 : 1.0),
        borderRadius: BorderRadius.circular(cfg.borderRadius),
        boxShadow: cfg.enableShadows ? [
          BoxShadow(
            color: (cfg.shadowColor ?? Colors.black).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ] : null,
        border: showBorder ? Border.all(color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.25)) : null,
        gradient: cfg.enableGradients ? LinearGradient(
          colors: [
            (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.12),
            (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cfg.borderRadius),
        child: Stack(
          children: [
            _buildThemedMainCarousel(context, cfg),
            if (widget.showThumbnails) _buildThemedThumbnailNavigation(context, cfg),
            if (widget.showIndicators && !widget.showThumbnails) _buildThemedIndicators(context, cfg),
            if (widget.showZoomButton) _buildThemedZoomButton(context, cfg),
            if (_getConfig('showNavigationArrows', true)) _buildThemedNavigationArrows(context, cfg),
            if (_getConfig('showImageCounter', true)) _buildThemedImageCounter(context, cfg),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedPageLayout(BuildContext context, ShopKitThemeConfig cfg) {
    return SizedBox(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];
          final isActive = index == _currentIndex;
          return _buildThemedImageItem(context, cfg, image, index, isActive);
        },
      ),
    );
  }

  Widget _buildThemedGridLayout(BuildContext context, ShopKitThemeConfig cfg) {
    final crossAxisCount = _getConfig('gridCrossAxisCount', 2);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getConfig('gridAspectRatio', 1.0),
        crossAxisSpacing: _getConfig('gridCrossAxisSpacing', 8.0),
        mainAxisSpacing: _getConfig('gridMainAxisSpacing', 8.0),
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final image = widget.images[index];
        final isActive = index == _currentIndex;
        return GestureDetector(
          onTap: () => _onImageTap(image, index),
          child: _buildThemedGridItem(context, cfg, image, index, isActive),
        );
      },
    );
  }

  Widget _buildThemedListLayout(BuildContext context, ShopKitThemeConfig cfg) {
    return SizedBox(
      height: widget.height ?? _getConfig('listHeight', 120.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _getConfig('listPadding', 16.0)),
        itemCount: widget.images.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('listSpacing', 12.0)),
        itemBuilder: (context, index) {
          final image = widget.images[index];
            final isActive = index == _currentIndex;
            return GestureDetector(
              onTap: () => _onImageTap(image, index),
              child: _buildThemedListItem(context, cfg, image, index, isActive),
            );
        },
      ),
    );
  }

  Widget _buildThemedMainCarousel(BuildContext context, ShopKitThemeConfig cfg) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final image = widget.images[index];
        final isActive = index == _currentIndex;
        return _buildThemedImageItem(context, cfg, image, index, isActive);
      },
    );
  }

  Widget _buildThemedImageItem(BuildContext context, ShopKitThemeConfig cfg, ImageModel image, int index, bool isActive) {
    final child = _buildThemedImage(context, cfg, image, index, isActive);
    return GestureDetector(
      onTap: () => _onImageTap(image, index),
      child: AnimatedScale(
        scale: isActive ? 1.0 : _getConfig('inactiveImageScale', 0.95),
        duration: Duration(milliseconds: _getConfig('imageScaleAnimationDuration', 200)),
        child: child,
      ),
    );
  }

  Widget _buildThemedImage(BuildContext context, ShopKitThemeConfig cfg, ImageModel image, int index, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.6),
        boxShadow: cfg.enableShadows ? [
          BoxShadow(
            color: (cfg.shadowColor ?? Colors.black).withValues(alpha: 0.18),
            blurRadius: isActive ? 20 : 10,
            offset: const Offset(0, 6),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.6),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _buildThemedImagePlaceholder(context, cfg, progress);
          },
          errorBuilder: (context, error, stack) => _buildThemedImageError(context, cfg, image),
        ),
      ),
    );
  }

  Widget _buildThemedImagePlaceholder(BuildContext context, ShopKitThemeConfig cfg, ImageChunkEvent? loadingProgress) {
    return Container(
      decoration: BoxDecoration(
        gradient: cfg.enableGradients ? LinearGradient(
          colors: [
            (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.15),
            (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        color: (cfg.backgroundColor ?? Colors.grey.shade200).withValues(alpha: 0.6),
      ),
      child: Center(
        child: SizedBox(
          width: 28.w,
          height: 28.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            value: loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
            color: cfg.primaryColor ?? Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildThemedImageError(BuildContext context, ShopKitThemeConfig cfg, ImageModel image) {
    return Container(
      color: (cfg.backgroundColor ?? Colors.grey.shade200).withValues(alpha: 0.7),
      child: Center(
        child: Icon(Icons.broken_image, color: cfg.primaryColor ?? Colors.redAccent, size: 42.sp),
      ),
    );
  }

  Widget _buildThemedGridItem(BuildContext context, ShopKitThemeConfig cfg, ImageModel image, int index, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _getConfig('listItemAnimationDuration', 200)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.5),
        border: isActive ? Border.all(color: (cfg.primaryColor ?? Colors.blue), width: 2) : null,
        boxShadow: isActive && cfg.enableShadows ? [
          BoxShadow(
            color: (cfg.shadowColor ?? Colors.black).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.5),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => _buildThemedImageError(context, cfg, image),
        ),
      ),
    );
  }

  Widget _buildThemedListItem(BuildContext context, ShopKitThemeConfig cfg, ImageModel image, int index, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _getConfig('listItemAnimationDuration', 200)),
      width: _getConfig('listItemWidth', 100.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.5),
        border: isActive ? Border.all(color: (cfg.primaryColor ?? Colors.blue), width: 2) : null,
        boxShadow: isActive && cfg.enableShadows ? [
          BoxShadow(
            color: (cfg.shadowColor ?? Colors.black).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cfg.borderRadius * 0.5),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => _buildThemedImageError(context, cfg, image),
        ),
      ),
    );
  }

  Widget _buildThemedThumbnailNavigation(BuildContext context, ShopKitThemeConfig cfg) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(cfg.borderRadius)),
        child: BackdropFilter(
          filter: cfg.enableBlur ? ImageFilter.blur(sigmaX: 10, sigmaY: 10) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            height: _getConfig('thumbnailNavigationHeight', 80.0),
            padding: EdgeInsets.all(_getConfig('thumbnailNavigationPadding', 8.0)),
            decoration: BoxDecoration(
              color: (cfg.backgroundColor ?? Colors.black).withValues(alpha: 0.55),
            ),
            child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          separatorBuilder: (context, index) => SizedBox(width: _getConfig('thumbnailSpacing', 8.0)),
          itemBuilder: (context, index) {
            final image = widget.images[index];
            final isActive = index == _currentIndex;
            return GestureDetector(
              onTap: () => _onThumbnailTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _getConfig('thumbnailWidth', 60.0),
                height: _getConfig('thumbnailHeight', 60.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cfg.borderRadius * 0.4),
                  border: Border.all(
                    color: isActive ? (cfg.primaryColor ?? Colors.blue) : Colors.transparent,
                    width: isActive ? 2 : 0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(cfg.borderRadius * 0.4),
                  child: Stack(
                    children: [
                      Image.network(
                        image.url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      if (!isActive) Container(color: Colors.black.withValues(alpha: 0.4)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemedIndicators(BuildContext context, ShopKitThemeConfig cfg) {
    if (widget.images.length <= 1) return const SizedBox.shrink();
    return Positioned(
      bottom: 12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.images.length, (index) {
          final isActive = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: isActive ? 22.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: isActive
                  ? (cfg.primaryColor ?? Colors.blue)
                  : (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(40),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildThemedZoomButton(BuildContext context, ShopKitThemeConfig cfg) {
    return Positioned(
      top: 12,
      right: 12,
      child: GestureDetector(
        onTap: _toggleZoom,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.85),
            shape: BoxShape.circle,
            boxShadow: cfg.enableShadows ? [
              BoxShadow(
                color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ] : null,
          ),
          child: Icon(_isZoomed ? Icons.zoom_out : Icons.zoom_in, size: 18.sp, color: cfg.onPrimaryColor ?? Colors.white),
        ),
      ),
    );
  }

  Widget _buildThemedNavigationArrows(BuildContext context, ShopKitThemeConfig cfg) {
    if (widget.images.length <= 1) return const SizedBox.shrink();
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildThemedNavArrow(context, cfg, Icons.arrow_back_ios, _previousImage),
          _buildThemedNavArrow(context, cfg, Icons.arrow_forward_ios, _nextImage),
        ],
      ),
    );
  }

  Widget _buildThemedNavArrow(BuildContext context, ShopKitThemeConfig cfg, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.65),
          shape: BoxShape.circle,
          boxShadow: cfg.enableShadows ? [
            BoxShadow(
              color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Icon(icon, size: 18.sp, color: cfg.onPrimaryColor ?? Colors.white),
      ),
    );
  }

  Widget _buildThemedImageCounter(BuildContext context, ShopKitThemeConfig cfg) {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: (cfg.primaryColor ?? Colors.black).withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: TextStyle(
            color: cfg.onPrimaryColor ?? Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildThemedEmptyState(BuildContext context, ShopKitThemeConfig cfg) {
    final bg = cfg.backgroundColor ?? Theme.of(context).colorScheme.surface;
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: cfg.enableBlur ? 0.9 : 1.0),
        borderRadius: BorderRadius.circular(cfg.borderRadius),
        border: cfg.enableGradients ? Border.all(color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.2)) : null,
        boxShadow: cfg.enableShadows ? [
          BoxShadow(
            color: (cfg.shadowColor ?? Colors.black).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0,8),
          ),
        ] : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 48.sp, color: (cfg.primaryColor ?? Colors.blue).withValues(alpha: 0.7)),
            SizedBox(height: 12.h),
            Text(
              _getConfig('emptyStateTitle', 'No Images'),
              style: TextStyle(
                color: cfg.onPrimaryColor ?? Colors.black87,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              _getConfig('emptyStateSubtitle', 'No images available to display'),
              style: TextStyle(
                color: (cfg.onPrimaryColor ?? Colors.black87).withValues(alpha: 0.7),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, ShopKitTheme theme) {
    switch (widget.layout) {
      case CarouselLayout.stack:
        return _buildStackLayout(context, theme);
      case CarouselLayout.page:
        return _buildPageLayout(context, theme);
      case CarouselLayout.grid:
        return _buildGridLayout(context, theme);
      case CarouselLayout.list:
        return _buildListLayout(context, theme);
    }
  }

  Widget _buildStackLayout(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('borderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        boxShadow: _getConfig('enableShadow', false)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.1)),
                blurRadius: _getConfig('shadowBlurRadius', 8.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: ClipRRect(
        borderRadius: _config?.getBorderRadius('borderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(child: _buildMainCarousel(context, theme)),
            
            if (widget.showThumbnails)
              _buildThumbnailNavigation(context, theme),
            
            if (widget.showIndicators && !widget.showThumbnails)
              _buildIndicators(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPageLayout(BuildContext context, ShopKitTheme theme) {
    return SizedBox(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];
          final isActive = index == _currentIndex;
          
          return widget.customImageBuilder?.call(context, image, index, isActive) ??
            _buildImageItem(context, theme, image, index, isActive);
        },
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, ShopKitTheme theme) {
    final crossAxisCount = _getConfig('gridCrossAxisCount', 2);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getConfig('gridAspectRatio', 1.0),
        crossAxisSpacing: _getConfig('gridCrossAxisSpacing', 8.0),
        mainAxisSpacing: _getConfig('gridMainAxisSpacing', 8.0),
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final image = widget.images[index];
        final isActive = index == _currentIndex;
        
        return GestureDetector(
          onTap: () => _onImageTap(image, index),
          child: widget.customImageBuilder?.call(context, image, index, isActive) ??
            _buildGridItem(context, theme, image, index, isActive),
        );
      },
    );
  }

  Widget _buildListLayout(BuildContext context, ShopKitTheme theme) {
    return SizedBox(
      height: widget.height ?? _getConfig('listHeight', 120.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _getConfig('listPadding', 16.0)),
        itemCount: widget.images.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('listSpacing', 12.0)),
        itemBuilder: (context, index) {
          final image = widget.images[index];
          final isActive = index == _currentIndex;
          
          return GestureDetector(
            onTap: () => _onImageTap(image, index),
            child: widget.customImageBuilder?.call(context, image, index, isActive) ??
              _buildListItem(context, theme, image, index, isActive),
          );
        },
      ),
    );
  }

  Widget _buildMainCarousel(BuildContext context, ShopKitTheme theme) {
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
              _buildImageItem(context, theme, image, index, isActive);
          },
        ),
        
        if (_getConfig('showNavigationArrows', true))
          _buildNavigationArrows(context, theme),
        
        if (widget.showZoomButton)
          _buildZoomButton(context, theme),
        
        if (_getConfig('showImageCounter', true))
          _buildImageCounter(context, theme),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, ShopKitTheme theme, ImageModel image, int index, bool isActive) {
    Widget imageWidget;

    if (widget.enableZoom) {
      imageWidget = InteractiveViewer(
        transformationController: _transformationController,
        minScale: _getConfig('minZoomScale', 0.5),
        maxScale: _getConfig('maxZoomScale', 4.0),
        onInteractionStart: (details) {
          _autoPlayTimer?.cancel();
        },
        onInteractionEnd: (details) {
          if (widget.autoPlay) {
            _setupAutoPlay();
          }
        },
        child: _buildImage(context, theme, image, index, isActive),
      );
    } else {
      imageWidget = _buildImage(context, theme, image, index, isActive);
    }

    return GestureDetector(
      onTap: () => _onImageTap(image, index),
      child: AnimatedScale(
        scale: isActive ? 1.0 : _getConfig('inactiveImageScale', 0.95),
        duration: Duration(milliseconds: _getConfig('imageScaleAnimationDuration', 200)),
        child: imageWidget,
      ),
    );
  }

  Widget _buildImage(BuildContext context, ShopKitTheme theme, ImageModel image, int index, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _config?.getBorderRadius('imageBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: _config?.getBorderRadius('imageBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            
            return _buildImagePlaceholder(context, theme, loadingProgress);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError(context, theme, image);
          },
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, ShopKitTheme theme, ImageChunkEvent? loadingProgress) {
    return Container(
      color: _config?.getColor('placeholderColor', theme.surfaceColor) ?? theme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: loadingProgress?.expectedTotalBytes != null
                ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
              color: _config?.getColor('loadingIndicatorColor', theme.primaryColor) ?? theme.primaryColor,
            ),
            if (_getConfig('showLoadingText', true)) ...[
              SizedBox(height: _getConfig('loadingTextSpacing', 16.0)),
              Text(
                _getConfig('loadingText', 'Loading...'),
                style: TextStyle(
                  color: _config?.getColor('loadingTextColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                  fontSize: _getConfig('loadingTextFontSize', 14.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageError(BuildContext context, ShopKitTheme theme, ImageModel image) {
    return Container(
      color: _config?.getColor('errorBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: _getConfig('errorIconSize', 48.0),
              color: _config?.getColor('errorIconColor', theme.errorColor) ?? theme.errorColor,
            ),
            SizedBox(height: _getConfig('errorTextSpacing', 12.0)),
            Text(
              _getConfig('errorText', 'Failed to load image'),
              style: TextStyle(
                color: _config?.getColor('errorTextColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                fontSize: _getConfig('errorTextFontSize', 14.0),
              ),
              textAlign: TextAlign.center,
            ),
            if (_getConfig('showRetryButton', true)) ...[
              SizedBox(height: _getConfig('retryButtonSpacing', 16.0)),
              ElevatedButton(
                onPressed: () => setState(() {}), // Trigger rebuild to retry
                child: Text(_getConfig('retryButtonText', 'Retry')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, ShopKitTheme theme, ImageModel image, int index, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _config?.getBorderRadius('gridItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        border: isActive
          ? Border.all(
              color: _config?.getColor('activeGridItemBorderColor', theme.primaryColor) ?? theme.primaryColor,
              width: _getConfig('activeGridItemBorderWidth', 2.0),
            )
          : null,
      ),
      child: ClipRRect(
        borderRadius: _config?.getBorderRadius('gridItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildImageError(context, theme, image),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, ShopKitTheme theme, ImageModel image, int index, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _getConfig('listItemAnimationDuration', 200)),
      width: _getConfig('listItemWidth', 100.0),
      decoration: BoxDecoration(
        borderRadius: _config?.getBorderRadius('listItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        border: isActive
          ? Border.all(
              color: _config?.getColor('activeListItemBorderColor', theme.primaryColor) ?? theme.primaryColor,
              width: _getConfig('activeListItemBorderWidth', 2.0),
            )
          : null,
        boxShadow: isActive && _getConfig('enableActiveListItemShadow', true)
          ? [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: _getConfig('activeListItemShadowOpacity', 0.3)),
                blurRadius: _getConfig('activeListItemShadowBlur', 8.0),
                offset: Offset(0, _getConfig('activeListItemShadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: ClipRRect(
        borderRadius: _config?.getBorderRadius('listItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
        child: Image.network(
          image.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildImageError(context, theme, image),
        ),
      ),
    );
  }

  Widget _buildNavigationArrows(BuildContext context, ShopKitTheme theme) {
    if (widget.images.length <= 1) return const SizedBox.shrink();

    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationArrow(
            context,
            theme,
            Icons.arrow_back_ios,
            () => _previousImage(),
            'previous',
          ),
          _buildNavigationArrow(
            context,
            theme,
            Icons.arrow_forward_ios,
            () => _nextImage(),
            'next',
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationArrow(BuildContext context, ShopKitTheme theme, IconData icon, VoidCallback onPressed, String type) {
    return Container(
      margin: EdgeInsets.all(_getConfig('${type}ArrowMargin', 16.0)),
      child: Material(
        color: _config?.getColor('${type}ArrowBackgroundColor', Colors.black.withValues(alpha: 0.5)) ?? Colors.black.withValues(alpha: 0.5),
        borderRadius: _config?.getBorderRadius('${type}ArrowBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
        child: InkWell(
          onTap: onPressed,
          borderRadius: _config?.getBorderRadius('${type}ArrowBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(_getConfig('${type}ArrowPadding', 8.0)),
            child: Icon(
              icon,
              color: _config?.getColor('${type}ArrowIconColor', Colors.white) ?? Colors.white,
              size: _getConfig('${type}ArrowIconSize', 20.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton(BuildContext context, ShopKitTheme theme) {
    return Positioned(
      top: _getConfig('zoomButtonTop', 16.0),
      right: _getConfig('zoomButtonRight', 16.0),
      child: Material(
        color: _config?.getColor('zoomButtonBackgroundColor', Colors.black.withValues(alpha: 0.5)) ?? Colors.black.withValues(alpha: 0.5),
        borderRadius: _config?.getBorderRadius('zoomButtonBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
        child: InkWell(
          onTap: _toggleZoom,
          borderRadius: _config?.getBorderRadius('zoomButtonBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(_getConfig('zoomButtonPadding', 8.0)),
            child: Icon(
              _isZoomed ? Icons.zoom_out : Icons.zoom_in,
              color: _config?.getColor('zoomButtonIconColor', Colors.white) ?? Colors.white,
              size: _getConfig('zoomButtonIconSize', 20.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCounter(BuildContext context, ShopKitTheme theme) {
    return Positioned(
      top: _getConfig('imageCounterTop', 16.0),
      left: _getConfig('imageCounterLeft', 16.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getConfig('imageCounterHorizontalPadding', 12.0),
          vertical: _getConfig('imageCounterVerticalPadding', 6.0),
        ),
        decoration: BoxDecoration(
          color: _config?.getColor('imageCounterBackgroundColor', Colors.black.withValues(alpha: 0.7)) ?? Colors.black.withValues(alpha: 0.7),
          borderRadius: _config?.getBorderRadius('imageCounterBorderRadius', BorderRadius.circular(16)) ?? BorderRadius.circular(16),
        ),
        child: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: TextStyle(
            color: _config?.getColor('imageCounterTextColor', Colors.white) ?? Colors.white,
            fontSize: _getConfig('imageCounterFontSize', 12.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailNavigation(BuildContext context, ShopKitTheme theme) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_thumbnailController),
      child: Container(
        height: _getConfig('thumbnailNavigationHeight', 80.0),
        padding: EdgeInsets.all(_getConfig('thumbnailNavigationPadding', 8.0)),
        decoration: BoxDecoration(
          color: _config?.getColor('thumbnailNavigationBackgroundColor', theme.surfaceColor.withValues(alpha: 0.9)) ?? theme.surfaceColor.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(
              color: _config?.getColor('thumbnailNavigationBorderColor', theme.onSurfaceColor.withValues(alpha: 0.1)) ?? theme.onSurfaceColor.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images.length,
          separatorBuilder: (context, index) => SizedBox(width: _getConfig('thumbnailSpacing', 8.0)),
          itemBuilder: (context, index) {
            final image = widget.images[index];
            final isActive = index == _currentIndex;
            
            return widget.customThumbnailBuilder?.call(context, image, index, isActive) ??
              _buildThumbnailItem(context, theme, image, index, isActive);
          },
        ),
      ),
    );
  }

  Widget _buildThumbnailItem(BuildContext context, ShopKitTheme theme, ImageModel image, int index, bool isActive) {
    return GestureDetector(
      onTap: () => _onThumbnailTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _getConfig('thumbnailAnimationDuration', 200)),
        width: _getConfig('thumbnailWidth', 60.0),
        height: _getConfig('thumbnailHeight', 60.0),
        decoration: BoxDecoration(
          borderRadius: _config?.getBorderRadius('thumbnailBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          border: Border.all(
            color: isActive
              ? (_config?.getColor('activeThumbnailBorderColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('inactiveThumbnailBorderColor', Colors.transparent) ?? Colors.transparent),
            width: isActive ? _getConfig('activeThumbnailBorderWidth', 2.0) : _getConfig('inactiveThumbnailBorderWidth', 0.0),
          ),
          boxShadow: isActive && _getConfig('enableActiveThumbnailShadow', true)
            ? [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: _getConfig('activeThumbnailShadowOpacity', 0.3)),
                  blurRadius: _getConfig('activeThumbnailShadowBlur', 4.0),
                  offset: Offset(0, _getConfig('activeThumbnailShadowOffsetY', 2.0)),
                ),
              ]
            : null,
        ),
        child: ClipRRect(
          borderRadius: _config?.getBorderRadius('thumbnailBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                image.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: _config?.getColor('thumbnailErrorColor', theme.surfaceColor) ?? theme.surfaceColor,
                  child: Icon(
                    Icons.image,
                    color: _config?.getColor('thumbnailErrorIconColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5),
                    size: _getConfig('thumbnailErrorIconSize', 24.0),
                  ),
                ),
              ),
              
              if (!isActive)
                Container(
                  color: _config?.getColor('inactiveThumbnailOverlayColor', Colors.black.withValues(alpha: 0.3)) ?? Colors.black.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators(BuildContext context, ShopKitTheme theme) {
    if (widget.images.length <= 1) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(_getConfig('indicatorsPadding', 16.0)),
      child: widget.customIndicatorBuilder?.call(context, _currentIndex, widget.images.length) ??
        _buildDefaultIndicators(context, theme),
    );
  }

  Widget _buildDefaultIndicators(BuildContext context, ShopKitTheme theme) {
    final indicatorType = _getConfig('indicatorType', 'dots');
    
    switch (indicatorType) {
      case 'bars':
        return _buildBarIndicators(context, theme);
      case 'numbers':
        return _buildNumberIndicators(context, theme);
      default:
        return _buildDotIndicators(context, theme);
    }
  }

  Widget _buildDotIndicators(BuildContext context, ShopKitTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.images.length, (index) {
        final isActive = index == _currentIndex;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: _getConfig('indicatorAnimationDuration', 200)),
          margin: EdgeInsets.symmetric(horizontal: _getConfig('indicatorSpacing', 4.0)),
          width: isActive ? _getConfig('activeIndicatorWidth', 20.0) : _getConfig('inactiveIndicatorWidth', 8.0),
          height: _getConfig('indicatorHeight', 8.0),
          decoration: BoxDecoration(
            color: isActive
              ? (_config?.getColor('activeIndicatorColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('inactiveIndicatorColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(_getConfig('indicatorBorderRadius', 4.0)),
          ),
        );
      }),
    );
  }

  Widget _buildBarIndicators(BuildContext context, ShopKitTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.images.length, (index) {
        final isActive = index == _currentIndex;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: _getConfig('indicatorAnimationDuration', 200)),
          margin: EdgeInsets.symmetric(horizontal: _getConfig('indicatorSpacing', 2.0)),
          width: _getConfig('barIndicatorWidth', 20.0),
          height: _getConfig('barIndicatorHeight', 4.0),
          decoration: BoxDecoration(
            color: isActive
              ? (_config?.getColor('activeIndicatorColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('inactiveIndicatorColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(_getConfig('barIndicatorBorderRadius', 2.0)),
          ),
        );
      }),
    );
  }

  Widget _buildNumberIndicators(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('numberIndicatorHorizontalPadding', 12.0),
        vertical: _getConfig('numberIndicatorVerticalPadding', 6.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('numberIndicatorBackgroundColor', Colors.black.withValues(alpha: 0.7)) ?? Colors.black.withValues(alpha: 0.7),
        borderRadius: _config?.getBorderRadius('numberIndicatorBorderRadius', BorderRadius.circular(16)) ?? BorderRadius.circular(16),
      ),
      child: Text(
        '${_currentIndex + 1} / ${widget.images.length}',
        style: TextStyle(
          color: _config?.getColor('numberIndicatorTextColor', Colors.white) ?? Colors.white,
          fontSize: _getConfig('numberIndicatorFontSize', 12.0),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.width * widget.aspectRatio,
      decoration: BoxDecoration(
        color: _config?.getColor('emptyStateBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('emptyStateBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        border: Border.all(
          color: _config?.getColor('emptyStateBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: _getConfig('emptyStateIconSize', 64.0),
              color: _config?.getColor('emptyStateIconColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: _getConfig('emptyStateSpacing', 16.0)),
            Text(
              _getConfig('emptyStateTitle', 'No Images'),
              style: TextStyle(
                color: _config?.getColor('emptyStateTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                fontSize: _getConfig('emptyStateTitleFontSize', 18.0),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_getConfig('showEmptyStateSubtitle', true)) ...[
              SizedBox(height: _getConfig('emptyStateSubtitleSpacing', 8.0)),
              Text(
                _getConfig('emptyStateSubtitle', 'No images available to display'),
                style: TextStyle(
                  color: _config?.getColor('emptyStateSubtitleColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                  fontSize: _getConfig('emptyStateSubtitleFontSize', 14.0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Public API for external control
  void goToImage(int index) {
    if (index >= 0 && index < widget.images.length) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: _getConfig('programmaticTransitionDuration', 300)),
        curve: _config?.getCurve('programmaticTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
      );
    }
  }

  void nextImage() => _nextImage();
  void previousImage() => _previousImage();

  int get currentIndex => _currentIndex;
  ImageModel? get currentImage => widget.images.isNotEmpty ? widget.images[_currentIndex] : null;
  
  bool get isZoomed => _isZoomed;
  bool get isAutoPlaying => _autoPlayTimer?.isActive ?? false;

  void startAutoPlay() {
    if (!widget.autoPlay) return;
    _autoPlayTimer?.cancel();
    _setupAutoPlay();
  }

  void stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }
}

/// Layout options for image carousel
enum CarouselLayout {
  stack,
  page,
  grid,
  list,
}

/// Fullscreen image viewer
class _FullscreenImageView extends StatefulWidget {
  final List<ImageModel> images;
  final int initialIndex;
  final FlexibleWidgetConfig? config;

  const _FullscreenImageView({
    required this.images,
    required this.initialIndex,
    this.config,
  });

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
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];
          
          return InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                image.url,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


