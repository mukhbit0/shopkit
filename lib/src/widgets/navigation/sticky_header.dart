import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system

/// A comprehensive sticky header widget, styled via ShopKitTheme.
///
/// Features multiple styles, scroll effects like parallax, and smooth animations.
/// The appearance is now controlled centrally through the `StickyHeaderTheme`.
class StickyHeader extends StatefulWidget {
  /// Creates a Sticky Header widget.
  /// The constructor is now clean, focusing on content and behavior.
  const StickyHeader({
    super.key,
    required this.headerChild,
    required this.contentChild,
    this.customBuilder,
    this.customHeaderBuilder,
    this.onHeaderTap,
    this.onScrollChanged,
    this.onVisibilityChanged,
    this.minHeaderHeight = 60.0,
    this.maxHeaderHeight = 200.0,
    this.enableParallax = false,
    this.enableFadeEffect = false,
    this.enableScaleEffect = false,
    this.enableColorTransition = false,
    this.enableElevationChange = false,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showShadow = true,
    this.behavior = StickyHeaderBehavior.pinned,
  });

  /// The widget to display inside the header.
  final Widget headerChild;

  /// The main content that scrolls beneath the header.
  final Widget contentChild;

  /// A custom builder for rendering the entire widget, offering complete control.
  final Widget Function(BuildContext, Widget, Widget, StickyHeaderState)? customBuilder;

  /// A custom header builder that provides the scroll progress (0.0 to 1.0).
  final Widget Function(BuildContext, Widget, double)? customHeaderBuilder;

  /// A callback triggered when the header is tapped.
  final VoidCallback? onHeaderTap;

  /// A callback that fires as the header collapses or expands.
  final Function(double progress, double offset)? onScrollChanged;

  /// A callback that fires when the header's visibility changes.
  final Function(bool isVisible)? onVisibilityChanged;

  /// The minimum height of the header when fully collapsed.
  final double minHeaderHeight;

  /// The maximum height of the header when fully expanded.
  final double maxHeaderHeight;

  /// Enables a parallax effect on the header's content as it collapses.
  final bool enableParallax;
  final bool enableFadeEffect;
  final bool enableScaleEffect;
  final bool enableColorTransition;
  final bool enableElevationChange;
  final bool enableAnimations;
  final bool enableHaptics;

  /// If true, a shadow will appear as the header collapses.
  final bool showShadow;

  /// Defines how the header behaves during scrolling.
  final StickyHeaderBehavior behavior;

  @override
  State<StickyHeader> createState() => StickyHeaderState();
}

class StickyHeaderState extends State<StickyHeader> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _scaleController;
  late final AnimationController _colorController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  double _scrollProgress = 0.0;
  double _headerOpacity = 1.0;
  double _headerScale = 1.0;
  double _currentElevation = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    
    // Animations are configured in the first build frame to access the theme.
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAnimations());
  }
  
  void _setupAnimations() {
    if (!mounted) return;
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    
    _scaleController = AnimationController(
      duration: shopKitTheme?.animations.fast ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    final stickyHeaderTheme = shopKitTheme?.stickyHeaderTheme;
    final theme = Theme.of(context);
    _colorAnimation = ColorTween(
      begin: stickyHeaderTheme?.backgroundColor ?? shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
      end: shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
    ).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _scaleController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    final maxScroll = widget.maxHeaderHeight - widget.minHeaderHeight;
    if (maxScroll <= 0) return;

    final progress = (offset / maxScroll).clamp(0.0, 1.0);

    if (mounted) {
      setState(() {
        _scrollProgress = progress;
        _updateScrollEffects(progress);
      });
    }
    widget.onScrollChanged?.call(progress, offset);
  }

  void _updateScrollEffects(double progress) {
    if (widget.enableFadeEffect) _headerOpacity = (1.0 - progress).clamp(0.0, 1.0);
    if (widget.enableScaleEffect) _headerScale = (1.0 - progress * 0.1).clamp(0.9, 1.0);
    if (widget.enableElevationChange) _currentElevation = progress * 4.0;
    if (widget.enableColorTransition && widget.enableAnimations) _colorController.value = progress;
  }

  void _handleHeaderTap() {
    if (widget.enableHaptics) HapticFeedback.lightImpact();
    if (widget.enableAnimations) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    }
    widget.onHeaderTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.headerChild, widget.contentChild, this);
    }

    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final stickyHeaderTheme = shopKitTheme?.stickyHeaderTheme;

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: widget.maxHeaderHeight,
            collapsedHeight: widget.minHeaderHeight,
            pinned: widget.behavior == StickyHeaderBehavior.pinned,
            floating: widget.behavior == StickyHeaderBehavior.floating,
            snap: widget.behavior == StickyHeaderBehavior.floating,
            elevation: widget.showShadow ? (stickyHeaderTheme?.elevation ?? _currentElevation) : 0,
            backgroundColor: widget.enableColorTransition
                ? _colorAnimation.value
                : stickyHeaderTheme?.backgroundColor ?? shopKitTheme?.colors.surface ?? theme.colorScheme.surface,
            flexibleSpace: _buildFlexibleSpace(context, shopKitTheme),
          ),
        ];
      },
      body: widget.contentChild,
    );
  }

  Widget _buildFlexibleSpace(BuildContext context, ShopKitTheme? shopKitTheme) {
    return FlexibleSpaceBar(
      background: _buildHeaderContent(context, shopKitTheme),
      collapseMode: widget.enableParallax ? CollapseMode.parallax : CollapseMode.pin,
    );
  }

  Widget _buildHeaderContent(BuildContext context, ShopKitTheme? shopKitTheme) {
    Widget header = widget.customHeaderBuilder?.call(context, widget.headerChild, _scrollProgress) ?? widget.headerChild;

    if (widget.enableFadeEffect) header = Opacity(opacity: _headerOpacity, child: header);
    if (widget.enableScaleEffect) header = Transform.scale(scale: _headerScale, child: header);
    if (widget.enableAnimations) {
      header = ScaleTransition(scale: _scaleAnimation, child: header);
    }

    return GestureDetector(
      onTap: _handleHeaderTap,
      child: Padding(
        padding: EdgeInsets.all(shopKitTheme?.spacing.md ?? 16.0),
        child: header,
      ),
    );
  }
  
  // --- Public API for external control ---
  void scrollToTop({bool animate = true}) {
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    if (animate) {
      _scrollController.animateTo(
        0,
        duration: shopKitTheme?.animations.normal ?? const Duration(milliseconds: 500),
        curve: shopKitTheme?.animations.easeOut ?? Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }
}

/// Defines how the sticky header behaves during scrolling.
enum StickyHeaderBehavior {
  /// The header shrinks as you scroll down and stays pinned at its minimum height.
  pinned,
  /// The header scrolls off-screen and reappears when you scroll up.
  floating,
  /// The header shrinks as you scroll down but does not stay pinned.
  expandable,
}

// Enums for style and scroll effects can be added here if needed,
// but often it's cleaner to control these effects via boolean flags as done above.
