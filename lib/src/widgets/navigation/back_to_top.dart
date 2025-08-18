import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../theme/components/back_to_top_theme.dart';

/// A widget that shows a "back to top" button when scrolling
class BackToTop extends StatefulWidget {
  const BackToTop({
    super.key,
    this.scrollController,
    this.showAfterOffset = 200.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.scrollDuration = const Duration(milliseconds: 500),
    this.position = BackToTopPosition.bottomRight,
    this.margin = const EdgeInsets.all(16),
    this.buttonSize = 56.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.foregroundColor,
    this.icon = Icons.keyboard_arrow_up,
    this.tooltip = 'Back to top',
    this.onPressed,
    this.showProgressIndicator = false,
    this.curve = Curves.easeOut,
  this.child,
    this.buttonBuilder,
  });

  final ScrollController? scrollController;
  final double showAfterOffset;
  final Duration animationDuration;
  final Duration scrollDuration;
  final BackToTopPosition position;
  final EdgeInsets margin;
  final double buttonSize;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool showProgressIndicator;
  final Curve curve;
  final Widget? child;
  // No legacy FlexibleWidgetConfig - prefer themed values in `ShopKitTheme`.
  final Widget Function(BuildContext, VoidCallback, double, bool)? buttonBuilder;

  @override
  State<BackToTop> createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  bool _isVisible = false;
  double _scrollProgress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  BackToTopTheme? _theme;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: widget.animationDuration, vsync: this);
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: widget.curve));
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: widget.curve));
  _theme = Theme.of(context).extension<ShopKitTheme>()?.backToTopTheme;
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachScrollController());
  }

  @override
  void didUpdateWidget(covariant BackToTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      _detachScrollController();
      _attachScrollController();
    }
  }

  @override
  void dispose() {
    _detachScrollController();
    _animationController.dispose();
    super.dispose();
  }

  void _attachScrollController() {
    _scrollController = widget.scrollController ?? Scrollable.maybeOf(context)?.widget.controller;
    _scrollController?.addListener(_onScroll);
    _onScroll();
  }

  void _detachScrollController() => _scrollController?.removeListener(_onScroll);

  void _onScroll() {
    if (!mounted || _scrollController == null) return;
    final offset = _scrollController!.offset;
    final max = _scrollController!.position.maxScrollExtent;
    final progress = max > 0 ? (offset / max).clamp(0.0, 1.0) : 0.0;
  final threshold = _theme?.showAfterOffset ?? widget.showAfterOffset;
    final shouldShow = offset > threshold;
    setState(() {
      _scrollProgress = progress;
      if (shouldShow != _isVisible) {
        _isVisible = shouldShow;
        if (_isVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  void _scrollToTop() {
    if (widget.onPressed != null) return widget.onPressed!();
    _scrollController?.animateTo(0, duration: widget.scrollDuration, curve: widget.curve);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return _buildButton(context);
    return Stack(children: [widget.child!, _buildPositionedButton(context)]);
  }

  Widget _buildPositionedButton(BuildContext context) => Positioned(
        top: _getTop(),
        bottom: _getBottom(),
        left: _getLeft(),
        right: _getRight(),
        child: _buildButton(context),
      );

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.buttonBuilder != null) {
      return widget.buttonBuilder!(context, _scrollToTop, _scrollProgress, _isVisible);
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _fadeAnimation.value,
          child: FloatingActionButton(
      onPressed: _scrollToTop,
      backgroundColor: _theme?.backgroundColor ?? widget.backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: _theme?.foregroundColor ?? widget.foregroundColor ?? theme.colorScheme.onPrimary,
      tooltip: _theme?.tooltip ?? widget.tooltip,
      mini: (_theme?.buttonSize ?? widget.buttonSize) < 56,
      child: widget.showProgressIndicator
        ? _buildProgressIndicator(theme)
        : Icon(widget.icon, size: _theme?.iconSize ?? widget.iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: (_theme?.iconSize ?? widget.iconSize) + 8,
            height: (_theme?.iconSize ?? widget.iconSize) + 8,
            child: CircularProgressIndicator(
              value: _scrollProgress,
              strokeWidth: 2,
              backgroundColor: (_theme?.foregroundColor ?? widget.foregroundColor ?? theme.colorScheme.onPrimary).withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(_theme?.foregroundColor ?? widget.foregroundColor ?? theme.colorScheme.onPrimary),
            ),
          ),
          Icon(widget.icon, size: (_theme?.iconSize ?? widget.iconSize) * 0.7),
        ],
      );

  double? _getTop() {
    switch (widget.position) {
      case BackToTopPosition.topLeft:
      case BackToTopPosition.topCenter:
      case BackToTopPosition.topRight:
        return widget.margin.top;
      default:
        return null;
    }
  }

  double? _getBottom() {
    switch (widget.position) {
      case BackToTopPosition.bottomLeft:
      case BackToTopPosition.bottomCenter:
      case BackToTopPosition.bottomRight:
        return widget.margin.bottom;
      default:
        return null;
    }
  }

  double? _getLeft() {
    switch (widget.position) {
      case BackToTopPosition.topLeft:
      case BackToTopPosition.bottomLeft:
        return widget.margin.left;
      default:
        return null;
    }
  }

  double? _getRight() {
    switch (widget.position) {
      case BackToTopPosition.topRight:
      case BackToTopPosition.bottomRight:
        return widget.margin.right;
      default:
        return null;
    }
  }
}

/// Position options for the back to top button
enum BackToTopPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// A customizable back to top button with extended features
class AdvancedBackToTop extends StatefulWidget {
  const AdvancedBackToTop({
    super.key,
    this.scrollController,
    this.showAfterOffset = 200.0,
    this.hideAfterInactivity,
    this.position = BackToTopPosition.bottomRight,
    this.margin = const EdgeInsets.all(16),
    this.style = BackToTopStyle.floating,
    this.showLabel = false,
    this.label = 'Top',
    this.showProgress = false,
    this.smoothScrolling = true,
    this.vibrationEnabled = false,
    this.customBuilder,
    this.onPressed,
  this.child,
  });

  /// Scroll controller to monitor
  final ScrollController? scrollController;

  /// Offset after which to show the button
  final double showAfterOffset;

  /// Duration after which to hide button if inactive
  final Duration? hideAfterInactivity;

  /// Position of the button
  final BackToTopPosition position;

  /// Margin from edges
  final EdgeInsets margin;

  /// Visual style of the button
  final BackToTopStyle style;

  /// Whether to show text label
  final bool showLabel;

  /// Text label to show
  final String label;

  /// Whether to show scroll progress
  final bool showProgress;

  /// Whether to use smooth scrolling
  final bool smoothScrolling;

  /// Whether to provide haptic feedback
  final bool vibrationEnabled;

  /// Custom builder for the button
  final Widget Function(
          BuildContext context, VoidCallback onPressed, double progress)?
      customBuilder;

  /// Custom onPressed callback
  final VoidCallback? onPressed;

  /// Child widget to wrap
  final Widget? child;
  // Legacy FlexibleWidgetConfig removed; prefer ShopKitTheme for styling

  @override
  State<AdvancedBackToTop> createState() => _AdvancedBackToTopState();
}

class _AdvancedBackToTopState extends State<AdvancedBackToTop> with TickerProviderStateMixin {
  ScrollController? _scrollController;
  bool _isVisible = false;
  double _scrollProgress = 0.0;

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  BackToTopTheme? _theme;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

  _theme = Theme.of(context).extension<ShopKitTheme>()?.backToTopTheme;
    WidgetsBinding.instance.addPostFrameCallback((_) => _attachScrollController());
  }

  @override
  void dispose() {
    _detachScrollController();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _attachScrollController() {
    _scrollController = widget.scrollController ??
        Scrollable.maybeOf(context)?.widget.controller;

    if (_scrollController != null) {
      _scrollController!.addListener(_onScroll);
      _onScroll();
    }
  }

  void _detachScrollController() {
    _scrollController?.removeListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController == null || !mounted) return;

    final offset = _scrollController!.offset;
    final maxScroll = _scrollController!.position.maxScrollExtent;

    final progress = maxScroll > 0 ? (offset / maxScroll).clamp(0.0, 1.0) : 0.0;
  final threshold = _theme?.showAfterOffset ?? widget.showAfterOffset;
  final shouldShow = offset > threshold;

    setState(() {
      _scrollProgress = progress;

      if (shouldShow != _isVisible) {
        _isVisible = shouldShow;
        if (_isVisible) {
          _animationController.forward();
          _startPulseAnimation();
        } else {
          _animationController.reverse();
          _pulseController.stop();
        }
      }
    });
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  void _scrollToTop() {
    if (widget.vibrationEnabled) {
      // Add haptic feedback if available
      // HapticFeedback.lightImpact();
    }

    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }

    if (widget.smoothScrolling) {
      _scrollController?.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController?.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) {
      return _buildButton(context);
    }

    return Stack(
      children: [
        widget.child!,
        _buildPositionedButton(context),
      ],
    );
  }

  Widget _buildPositionedButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          bottom: widget.position == BackToTopPosition.bottomRight ||
                  widget.position == BackToTopPosition.bottomCenter ||
                  widget.position == BackToTopPosition.bottomLeft
              ? widget.margin.bottom + _slideAnimation.value
              : null,
          right: widget.position == BackToTopPosition.bottomRight ||
                  widget.position == BackToTopPosition.topRight
              ? widget.margin.right
              : null,
          left: widget.position == BackToTopPosition.bottomLeft ||
                  widget.position == BackToTopPosition.topLeft
              ? widget.margin.left
              : null,
          child: _buildButton(context),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    if (widget.customBuilder != null) {
  return widget.customBuilder!(context, _scrollToTop, _scrollProgress);
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: _buildDefaultButton(context),
        );
      },
    );
  }

  Widget _buildDefaultButton(BuildContext context) {
    final theme = Theme.of(context);

    switch (widget.style) {
      case BackToTopStyle.floating:
        return FloatingActionButton.extended(
          onPressed: _scrollToTop,
          icon: Icon(
            Icons.keyboard_arrow_up,
            color: _theme?.iconColor ?? theme.colorScheme.onPrimary,
          ),
          label: (_theme?.showLabel ?? widget.showLabel) ? Text(_theme?.label ?? widget.label) : const SizedBox.shrink(),
          backgroundColor: _theme?.backgroundColor ?? theme.colorScheme.primary,
        );

      case BackToTopStyle.minimal:
        return Container(
          decoration: BoxDecoration(
            color: _theme?.minimalBackgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
            child: IconButton(
            onPressed: _scrollToTop,
            icon: Icon(Icons.keyboard_arrow_up, color: _theme?.iconColor),
            tooltip: _theme?.tooltip ?? 'Back to top',
          ),
        );

      case BackToTopStyle.pill:
        return Material(
          color: _theme?.pillBackgroundColor ?? theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(25),
          elevation: 4,
          child: InkWell(
            onTap: _scrollToTop,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.keyboard_arrow_up, color: _theme?.pillIconColor ?? theme.colorScheme.onPrimary),
                  if (_theme?.showLabel ?? widget.showLabel) ...[
                    const SizedBox(width: 8),
                    Text(_theme?.label ?? widget.label, style: TextStyle(color: _theme?.pillLabelColor ?? theme.colorScheme.onPrimary, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
          ),
        );
    }
  }
}

/// Style options for the back to top button
enum BackToTopStyle {
  floating,
  minimal,
  pill,
}
