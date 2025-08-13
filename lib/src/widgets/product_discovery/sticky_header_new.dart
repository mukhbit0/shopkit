import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';

/// A comprehensive sticky header widget with advanced features and unlimited customization
/// Features: Multiple styles, scroll effects, parallax, animations, and extensive theming
class StickyHeaderNew extends StatefulWidget {
  const StickyHeaderNew({
    super.key,
    required this.headerChild,
    required this.contentChild,
    this.config,
    this.customBuilder,
    this.customHeaderBuilder,
    this.customContentBuilder,
    this.onHeaderTap,
    this.onScrollChanged,
    this.onVisibilityChanged,
    this.minHeaderHeight = 60.0,
    this.maxHeaderHeight = 200.0,
    this.enableParallax = false,
    this.enableFadeEffect = false,
    this.enableScaleEffect = false,
    this.enableBlurEffect = false,
    this.enableColorTransition = false,
    this.enableElevationChange = false,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showShadow = true,
    this.style = StickyHeaderStyle.standard,
    this.scrollEffect = StickyHeaderScrollEffect.fade,
    this.behavior = StickyHeaderBehavior.pinned,
  });

  /// Header widget
  final Widget headerChild;

  /// Content widget
  final Widget contentChild;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, Widget, Widget, StickyHeaderNewState)? customBuilder;

  /// Custom header builder with scroll progress
  final Widget Function(BuildContext, Widget, double)? customHeaderBuilder;

  /// Custom content builder
  final Widget Function(BuildContext, Widget)? customContentBuilder;

  /// Callback when header is tapped
  final VoidCallback? onHeaderTap;

  /// Callback when scroll position changes
  final Function(double progress, double offset)? onScrollChanged;

  /// Callback when header visibility changes
  final Function(bool isVisible)? onVisibilityChanged;

  /// Minimum header height when collapsed
  final double minHeaderHeight;

  /// Maximum header height when expanded
  final double maxHeaderHeight;

  /// Whether to enable parallax effect
  final bool enableParallax;

  /// Whether to enable fade effect
  final bool enableFadeEffect;

  /// Whether to enable scale effect
  final bool enableScaleEffect;

  /// Whether to enable blur effect
  final bool enableBlurEffect;

  /// Whether to enable color transition
  final bool enableColorTransition;

  /// Whether to enable elevation change
  final bool enableElevationChange;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show shadow
  final bool showShadow;

  /// Style of the sticky header
  final StickyHeaderStyle style;

  /// Scroll effect type
  final StickyHeaderScrollEffect scrollEffect;

  /// Behavior of the sticky header
  final StickyHeaderBehavior behavior;

  @override
  State<StickyHeaderNew> createState() => StickyHeaderNewState();
}

class StickyHeaderNewState extends State<StickyHeaderNew>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _colorController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  FlexibleWidgetConfig? _config;
  double _scrollProgress = 0.0;
  double _scrollOffset = 0.0;
  bool _isHeaderVisible = true;
  double _headerOpacity = 1.0;
  double _headerScale = 1.0;
  double _currentElevation = 0.0;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('sticky_header', context: context);
    
    _setupControllers();
    _setupAnimations();
  }

  void _setupControllers() {
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);

    _fadeController = AnimationController(
      duration: Duration(milliseconds: _getConfig('fadeAnimationDuration', 300)),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: _getConfig('scaleAnimationDuration', 200)),
      vsync: this,
    );

    _colorController = AnimationController(
      duration: Duration(milliseconds: _getConfig('colorAnimationDuration', 400)),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: _getConfig('scaleAnimationScale', 0.95),
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    final theme = ShopKitThemeProvider.of(context);
    _colorAnimation = ColorTween(
      begin: _config?.getColor('headerStartColor', theme.surfaceColor) ?? theme.surfaceColor,
      end: _config?.getColor('headerEndColor', theme.primaryColor) ?? theme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    if (widget.enableAnimations) {
      _fadeController.forward();
    } else {
      _fadeController.value = 1.0;
    }
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    final maxScroll = widget.maxHeaderHeight - widget.minHeaderHeight;
    final progress = (offset / maxScroll).clamp(0.0, 1.0);

    setState(() {
      _scrollOffset = offset;
      _scrollProgress = progress;
      
      // Update header visibility
      final wasVisible = _isHeaderVisible;
      _isHeaderVisible = widget.behavior == StickyHeaderBehavior.pinned || 
                        widget.behavior == StickyHeaderBehavior.floating ||
                        offset < widget.maxHeaderHeight;
      
      if (wasVisible != _isHeaderVisible) {
        widget.onVisibilityChanged?.call(_isHeaderVisible);
      }
      
      // Update effects based on scroll
      _updateScrollEffects(progress);
    });

    widget.onScrollChanged?.call(progress, offset);
  }

  void _updateScrollEffects(double progress) {
    if (widget.enableFadeEffect) {
      _headerOpacity = (1.0 - progress * _getConfig('fadeEffectIntensity', 0.7)).clamp(0.0, 1.0);
    }

    if (widget.enableScaleEffect) {
      _headerScale = (1.0 - progress * _getConfig('scaleEffectIntensity', 0.1)).clamp(0.8, 1.0);
    }

    if (widget.enableElevationChange) {
      _currentElevation = progress * _getConfig('maxElevation', 8.0);
    }

    if (widget.enableColorTransition && widget.enableAnimations) {
      _colorController.animateTo(progress);
    }
  }

  void _handleHeaderTap() {
    if (widget.enableHaptics && _getConfig('enableHeaderTapHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    if (widget.enableAnimations && _getConfig('animateOnHeaderTap', true)) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
    }

    widget.onHeaderTap?.call();
  }

  double _calculateHeaderHeight() {
    switch (widget.behavior) {
      case StickyHeaderBehavior.floating:
        return widget.minHeaderHeight;
      case StickyHeaderBehavior.expandable:
        final progress = _scrollProgress;
        return widget.maxHeaderHeight - (progress * (widget.maxHeaderHeight - widget.minHeaderHeight));
      case StickyHeaderBehavior.pinned:
        return _scrollOffset < widget.maxHeaderHeight - widget.minHeaderHeight
          ? widget.maxHeaderHeight - _scrollOffset
          : widget.minHeaderHeight;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.headerChild, widget.contentChild, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    return _buildStickyHeader(context, theme);
  }

  Widget _buildStickyHeader(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case StickyHeaderStyle.card:
        return _buildCardHeader(context, theme);
      case StickyHeaderStyle.transparent:
        return _buildTransparentHeader(context, theme);
      case StickyHeaderStyle.gradient:
        return _buildGradientHeader(context, theme);
      case StickyHeaderStyle.blur:
        return _buildBlurHeader(context, theme);
      case StickyHeaderStyle.standard:
        return _buildStandardHeader(context, theme);
    }
  }

  Widget _buildStandardHeader(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: widget.maxHeaderHeight,
              collapsedHeight: widget.minHeaderHeight,
              pinned: widget.behavior == StickyHeaderBehavior.pinned,
              floating: widget.behavior == StickyHeaderBehavior.floating,
              snap: widget.behavior == StickyHeaderBehavior.floating && _getConfig('enableSnap', false),
              elevation: widget.showShadow ? _currentElevation : 0,
              backgroundColor: widget.enableColorTransition
                ? _colorAnimation.value
                : _config?.getColor('headerBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
              flexibleSpace: _buildFlexibleSpace(context, theme),
            ),
          ];
        },
        body: _buildContent(context, theme),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(_getConfig('cardMargin', 16.0)),
              child: Card(
                elevation: widget.showShadow ? _currentElevation : 0,
                color: widget.enableColorTransition
                  ? _colorAnimation.value
                  : _config?.getColor('cardBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: _config?.getBorderRadius('cardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: _config?.getBorderRadius('cardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
                  child: Container(
                    height: _calculateHeaderHeight(),
                    child: _buildHeaderContent(context, theme),
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: _buildContent(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparentHeader(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: widget.maxHeaderHeight,
                  child: _buildContent(context, theme),
                ),
              ),
            ],
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _calculateHeaderHeight(),
              decoration: BoxDecoration(
                color: (widget.enableColorTransition
                  ? _colorAnimation.value
                  : _config?.getColor('transparentHeaderBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor)
                    ?.withValues(alpha: _headerOpacity * _getConfig('transparentHeaderOpacity', 0.9)),
                boxShadow: widget.showShadow && _currentElevation > 0
                  ? [
                      BoxShadow(
                        color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.1)),
                        blurRadius: _currentElevation,
                        offset: Offset(0, _currentElevation / 2),
                      ),
                    ]
                  : null,
              ),
              child: _buildHeaderContent(context, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: widget.maxHeaderHeight,
              collapsedHeight: widget.minHeaderHeight,
              pinned: widget.behavior == StickyHeaderBehavior.pinned,
              floating: widget.behavior == StickyHeaderBehavior.floating,
              elevation: widget.showShadow ? _currentElevation : 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _config?.getColor('gradientStartColor', theme.primaryColor) ?? theme.primaryColor,
                      _config?.getColor('gradientEndColor', theme.secondaryColor) ?? theme.secondaryColor,
                    ],
                    stops: [
                      _getConfig('gradientStartStop', 0.0),
                      _getConfig('gradientEndStop', 1.0),
                    ],
                  ),
                ),
                child: _buildFlexibleSpace(context, theme),
              ),
            ),
          ];
        },
        body: _buildContent(context, theme),
      ),
    );
  }

  Widget _buildBlurHeader(BuildContext context, ShopKitTheme theme) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: widget.maxHeaderHeight,
              collapsedHeight: widget.minHeaderHeight,
              pinned: widget.behavior == StickyHeaderBehavior.pinned,
              floating: widget.behavior == StickyHeaderBehavior.floating,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ColorFilter.mode(
                    Colors.white.withValues(alpha: _scrollProgress * _getConfig('blurEffectIntensity', 0.3)),
                    BlendMode.srcOver,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (widget.enableColorTransition
                        ? _colorAnimation.value
                        : _config?.getColor('blurHeaderBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor)
                          ?.withValues(alpha: _getConfig('blurHeaderOpacity', 0.8)),
                    ),
                    child: _buildFlexibleSpace(context, theme),
                  ),
                ),
              ),
            ),
          ];
        },
        body: _buildContent(context, theme),
      ),
    );
  }

  Widget _buildFlexibleSpace(BuildContext context, ShopKitTheme theme) {
    return FlexibleSpaceBar(
      background: _buildHeaderContent(context, theme),
      collapseMode: widget.enableParallax ? CollapseMode.parallax : CollapseMode.pin,
    );
  }

  Widget _buildHeaderContent(BuildContext context, ShopKitTheme theme) {
    Widget header = widget.customHeaderBuilder?.call(context, widget.headerChild, _scrollProgress) ?? widget.headerChild;

    // Apply scroll effects
    if (widget.enableFadeEffect) {
      header = Opacity(
        opacity: _headerOpacity,
        child: header,
      );
    }

    if (widget.enableScaleEffect) {
      header = Transform.scale(
        scale: _headerScale,
        child: header,
      );
    }

    // Apply animations
    if (widget.enableAnimations) {
      header = AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: header,
      );
    }

    return GestureDetector(
      onTap: _handleHeaderTap,
      child: Container(
        padding: EdgeInsets.all(_getConfig('headerContentPadding', 16.0)),
        child: header,
      ),
    );
  }

  Widget _buildContent(BuildContext context, ShopKitTheme theme) {
    Widget content = widget.customContentBuilder?.call(context, widget.contentChild) ?? widget.contentChild;

    return Container(
      padding: EdgeInsets.all(_getConfig('contentPadding', 0.0)),
      child: content,
    );
  }

  /// Public API for external control
  double get scrollProgress => _scrollProgress;
  
  double get scrollOffset => _scrollOffset;
  
  bool get isHeaderVisible => _isHeaderVisible;
  
  double get headerOpacity => _headerOpacity;
  
  double get headerScale => _headerScale;
  
  double get currentElevation => _currentElevation;
  
  double get headerHeight => _calculateHeaderHeight();
  
  ScrollController get scrollController => _scrollController;
  
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
  
  void scrollToOffset(double offset, {bool animate = true}) {
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
  
  void expandHeader({bool animate = true}) {
    scrollToTop(animate: animate);
  }
  
  void collapseHeader({bool animate = true}) {
    scrollToOffset(widget.maxHeaderHeight, animate: animate);
  }
  
  void triggerHeaderTap() {
    _handleHeaderTap();
  }
  
  void updateHeaderVisibility(bool visible) {
    if (_isHeaderVisible != visible) {
      setState(() {
        _isHeaderVisible = visible;
      });
      widget.onVisibilityChanged?.call(visible);
    }
  }
  
  void resetScrollEffects() {
    setState(() {
      _scrollProgress = 0.0;
      _scrollOffset = 0.0;
      _headerOpacity = 1.0;
      _headerScale = 1.0;
      _currentElevation = 0.0;
    });
    
    if (widget.enableAnimations) {
      _colorController.reset();
      _fadeController.reset();
      _scaleController.reset();
    }
  }
}

/// Style options for sticky header
enum StickyHeaderStyle {
  standard,
  card,
  transparent,
  gradient,
  blur,
}

/// Scroll effect options
enum StickyHeaderScrollEffect {
  none,
  fade,
  scale,
  parallax,
  blur,
  colorTransition,
}

/// Behavior options for sticky header
enum StickyHeaderBehavior {
  pinned,
  floating,
  expandable,
}
