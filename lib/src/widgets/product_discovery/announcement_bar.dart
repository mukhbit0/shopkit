import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../models/announcement_model.dart';

/// A comprehensive announcement bar widget with advanced features and unlimited customization
/// Features: Multiple styles, animations, auto-scroll, actions, dismissible, and extensive theming
class AnnouncementBarNew extends StatefulWidget {
  const AnnouncementBarNew({
    super.key,
    required this.announcements,
    this.config,
    this.customBuilder,
    this.customItemBuilder,
    this.customActionBuilder,
    this.onAnnouncementTap,
    this.onActionTap,
    this.onDismiss,
    this.enableAutoScroll = true,
    this.enableDismiss = true,
    this.enableActions = true,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showProgress = false,
    this.showCounter = false,
    this.style = AnnouncementBarStyle.banner,
    this.position = AnnouncementBarPosition.top,
    this.behavior = AnnouncementBarBehavior.scroll,
    this.autoScrollInterval = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 300),
    this.themeStyle,
  });

  /// List of announcements to display
  final List<AnnouncementModel> announcements;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<AnnouncementModel>, AnnouncementBarNewState)? customBuilder;

  /// Custom item builder
  final Widget Function(BuildContext, AnnouncementModel, int)? customItemBuilder;

  /// Custom action builder
  final Widget Function(BuildContext, AnnouncementModel)? customActionBuilder;

  /// Callback when announcement is tapped
  final Function(AnnouncementModel, int)? onAnnouncementTap;

  /// Callback when action is tapped
  final Function(AnnouncementModel, String)? onActionTap;

  /// Callback when announcement is dismissed
  final Function(AnnouncementModel, int)? onDismiss;

  /// Whether to enable auto-scroll
  final bool enableAutoScroll;

  /// Whether to enable dismiss
  final bool enableDismiss;

  /// Whether to enable actions
  final bool enableActions;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Whether to show counter
  final bool showCounter;

  /// Style of the announcement bar
  final AnnouncementBarStyle style;

  /// Position of the announcement bar
  final AnnouncementBarPosition position;

  /// Behavior of the announcement bar
  final AnnouncementBarBehavior behavior;

  /// Auto-scroll interval
  final Duration autoScrollInterval;

  /// Animation duration
  final Duration animationDuration;

  /// Built-in theme style support - pass theme name as string
  final String? themeStyle;

  @override
  State<AnnouncementBarNew> createState() => AnnouncementBarNewState();
}

class AnnouncementBarNewState extends State<AnnouncementBarNew>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _marqueeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _marqueeAnimation;

  FlexibleWidgetConfig? _config;
  PageController? _pageController;
  int _currentIndex = 0;
  bool _isAutoScrolling = false;
  bool _userInteracted = false;
  List<AnnouncementModel> _visibleAnnouncements = [];

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('announcement_bar', context: context);
    _visibleAnnouncements = List.from(widget.announcements);
    
    _setupAnimations();
    _setupPageController();
    
    if (widget.enableAutoScroll && _visibleAnnouncements.length > 1) {
      _startAutoScroll();
    }
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: _getConfig('fadeAnimationDuration', 200)),
      vsync: this,
    );

    _marqueeController = AnimationController(
      duration: Duration(seconds: _getConfig('marqueeAnimationDuration', 10)),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.position == AnnouncementBarPosition.top 
        ? const Offset(0, -1) 
        : const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _marqueeAnimation = Tween<double>(
      begin: 1.0,
      end: -1.0,
    ).animate(CurvedAnimation(
      parent: _marqueeController,
      curve: Curves.linear,
    ));

    if (widget.enableAnimations) {
      _slideController.forward();
      _fadeController.forward();
    } else {
      _slideController.value = 1.0;
      _fadeController.value = 1.0;
    }

    if (widget.behavior == AnnouncementBarBehavior.marquee) {
      _marqueeController.repeat();
    }
  }

  void _setupPageController() {
    if (widget.behavior == AnnouncementBarBehavior.scroll && _visibleAnnouncements.length > 1) {
      _pageController = PageController();
    }
  }

  void _startAutoScroll() {
    if (_visibleAnnouncements.length <= 1) return;
    
    _isAutoScrolling = true;
    
    Future.doWhile(() async {
      if (!_isAutoScrolling || _userInteracted || !mounted) {
        return false;
      }
      
      await Future.delayed(widget.autoScrollInterval);
      
      if (!_isAutoScrolling || _userInteracted || !mounted) {
        return false;
      }
      
      _nextAnnouncement();
      return true;
    });
  }

  void _stopAutoScroll() {
    _isAutoScrolling = false;
  }

  void _resumeAutoScroll() {
    if (widget.enableAutoScroll && !_isAutoScrolling && _visibleAnnouncements.length > 1) {
      _userInteracted = false;
      _startAutoScroll();
    }
  }

  void _nextAnnouncement() {
    if (_visibleAnnouncements.isEmpty) return;
    
    if (widget.behavior == AnnouncementBarBehavior.scroll && _pageController != null) {
      final nextIndex = (_currentIndex + 1) % _visibleAnnouncements.length;
      _pageController!.animateToPage(
        nextIndex,
        duration: widget.animationDuration,
        curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
      );
    } else {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _visibleAnnouncements.length;
      });
    }
  }

  void _previousAnnouncement() {
    if (_visibleAnnouncements.isEmpty) return;
    
    if (widget.behavior == AnnouncementBarBehavior.scroll && _pageController != null) {
      final prevIndex = _currentIndex == 0 ? _visibleAnnouncements.length - 1 : _currentIndex - 1;
      _pageController!.animateToPage(
        prevIndex,
        duration: widget.animationDuration,
        curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
      );
    } else {
      setState(() {
        _currentIndex = _currentIndex == 0 ? _visibleAnnouncements.length - 1 : _currentIndex - 1;
      });
    }
  }

  void _handleAnnouncementTap(AnnouncementModel announcement, int index) {
    if (widget.enableHaptics && _getConfig('enableTapHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    _userInteracted = true;
    _stopAutoScroll();
    
    widget.onAnnouncementTap?.call(announcement, index);
    
    if (widget.enableAutoScroll && _getConfig('resumeAutoScrollAfterInteraction', true)) {
      Future.delayed(Duration(seconds: _getConfig('autoScrollResumeDelay', 3)), () {
        if (mounted) {
          _resumeAutoScroll();
        }
      });
    }
  }

  void _handleActionTap(AnnouncementModel announcement, String action) {
    if (widget.enableHaptics && _getConfig('enableActionHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    widget.onActionTap?.call(announcement, action);
  }

  void _handleDismiss(AnnouncementModel announcement, int index) {
    if (widget.enableHaptics && _getConfig('enableDismissHaptics', true)) {
      HapticFeedback.mediumImpact();
    }
    
    setState(() {
      _visibleAnnouncements.removeAt(index);
      
      // Adjust current index if necessary
      if (_currentIndex >= _visibleAnnouncements.length && _visibleAnnouncements.isNotEmpty) {
        _currentIndex = _visibleAnnouncements.length - 1;
      }
    });
    
    widget.onDismiss?.call(announcement, index);
    
    if (_visibleAnnouncements.isEmpty) {
      _stopAutoScroll();
    }
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  void didUpdateWidget(AnnouncementBarNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('announcement_bar', context: context);
    
    if (widget.announcements != oldWidget.announcements) {
      _visibleAnnouncements = List.from(widget.announcements);
      _currentIndex = _currentIndex.clamp(0, _visibleAnnouncements.length - 1);
      
      if (widget.enableAutoScroll && _visibleAnnouncements.length > 1 && !_isAutoScrolling) {
        _startAutoScroll();
      } else if (!widget.enableAutoScroll || _visibleAnnouncements.length <= 1) {
        _stopAutoScroll();
      }
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _slideController.dispose();
    _fadeController.dispose();
    _marqueeController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleAnnouncements.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, _visibleAnnouncements, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    Widget content = _buildAnnouncementBar(context, theme);

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildAnnouncementBar(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case AnnouncementBarStyle.minimal:
        return _buildMinimalBar(context, theme);
      case AnnouncementBarStyle.card:
        return _buildCardBar(context, theme);
      case AnnouncementBarStyle.gradient:
        return _buildGradientBar(context, theme);
      case AnnouncementBarStyle.outlined:
        return _buildOutlinedBar(context, theme);
      case AnnouncementBarStyle.banner:
        return _buildBannerBar(context, theme);
    }
  }

  Widget _buildBannerBar(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('horizontalPadding', 16.0),
        vertical: _getConfig('verticalPadding', 12.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.primaryColor) ?? theme.primaryColor,
        boxShadow: _getConfig('enableShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.1)),
                blurRadius: _getConfig('shadowBlurRadius', 4.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: _buildContent(context, theme),
    );
  }

  Widget _buildMinimalBar(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('minimalHorizontalPadding', 12.0),
        vertical: _getConfig('minimalVerticalPadding', 8.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('minimalBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: _config?.getColor('minimalBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
            width: _getConfig('minimalBorderWidth', 1.0),
          ),
        ),
      ),
      child: _buildContent(context, theme),
    );
  }

  Widget _buildCardBar(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.all(_getConfig('cardMargin', 16.0)),
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('cardHorizontalPadding', 16.0),
        vertical: _getConfig('cardVerticalPadding', 12.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('cardBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('cardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        border: Border.all(
          color: _config?.getColor('cardBorderColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
          width: _getConfig('cardBorderWidth', 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.onSurfaceColor.withValues(alpha: _getConfig('cardShadowOpacity', 0.08)),
            blurRadius: _getConfig('cardShadowBlurRadius', 8.0),
            offset: Offset(0, _getConfig('cardShadowOffsetY', 2.0)),
          ),
        ],
      ),
      child: _buildContent(context, theme),
    );
  }

  Widget _buildGradientBar(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('gradientHorizontalPadding', 16.0),
        vertical: _getConfig('gradientVerticalPadding', 12.0),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _config?.getColor('gradientStartColor', theme.primaryColor) ?? theme.primaryColor,
            _config?.getColor('gradientEndColor', theme.secondaryColor) ?? theme.secondaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: _getConfig('enableGradientShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('gradientShadowOpacity', 0.15)),
                blurRadius: _getConfig('gradientShadowBlurRadius', 6.0),
                offset: Offset(0, _getConfig('gradientShadowOffsetY', 3.0)),
              ),
            ]
          : null,
      ),
      child: _buildContent(context, theme),
    );
  }

  Widget _buildOutlinedBar(BuildContext context, ShopKitTheme theme) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(_getConfig('outlinedMargin', 8.0)),
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('outlinedHorizontalPadding', 16.0),
        vertical: _getConfig('outlinedVerticalPadding', 12.0),
      ),
      decoration: BoxDecoration(
        color: _config?.getColor('outlinedBackgroundColor', Colors.transparent) ?? Colors.transparent,
        border: Border.all(
          color: _config?.getColor('outlinedBorderColor', theme.primaryColor) ?? theme.primaryColor,
          width: _getConfig('outlinedBorderWidth', 2.0),
        ),
        borderRadius: _config?.getBorderRadius('outlinedBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
      ),
      child: _buildContent(context, theme),
    );
  }

  Widget _buildContent(BuildContext context, ShopKitTheme theme) {
    switch (widget.behavior) {
      case AnnouncementBarBehavior.static:
        return _buildStaticContent(context, theme);
      case AnnouncementBarBehavior.marquee:
        return _buildMarqueeContent(context, theme);
      case AnnouncementBarBehavior.scroll:
        return _buildScrollableContent(context, theme);
    }
  }

  Widget _buildStaticContent(BuildContext context, ShopKitTheme theme) {
    if (_visibleAnnouncements.isEmpty) return const SizedBox.shrink();
    
    return _buildAnnouncementItem(context, theme, _visibleAnnouncements[_currentIndex], _currentIndex);
  }

  Widget _buildScrollableContent(BuildContext context, ShopKitTheme theme) {
    if (_visibleAnnouncements.length == 1) {
      return _buildAnnouncementItem(context, theme, _visibleAnnouncements[0], 0);
    }

    return SizedBox(
      height: _getConfig('scrollableHeight', 40.0),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _handlePageChanged,
            itemCount: _visibleAnnouncements.length,
            itemBuilder: (context, index) {
              return _buildAnnouncementItem(context, theme, _visibleAnnouncements[index], index);
            },
          ),
          
          if (widget.showProgress)
            _buildProgressIndicator(context, theme),
          
          if (widget.showCounter)
            _buildCounter(context, theme),
          
          if (_getConfig('showNavigationButtons', false))
            _buildNavigationButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildMarqueeContent(BuildContext context, ShopKitTheme theme) {
    if (_visibleAnnouncements.isEmpty) return const SizedBox.shrink();
    
    final announcement = _visibleAnnouncements[_currentIndex];
    
    return AnimatedBuilder(
      animation: _marqueeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_marqueeAnimation.value * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
      child: _buildAnnouncementItem(context, theme, announcement, _currentIndex),
    );
  }

  Widget _buildAnnouncementItem(BuildContext context, ShopKitTheme theme, AnnouncementModel announcement, int index) {
    if (widget.customItemBuilder != null) {
      return widget.customItemBuilder!(context, announcement, index);
    }

    return GestureDetector(
      onTap: () => _handleAnnouncementTap(announcement, index),
      child: Row(
        children: [
          // Icon
          if (announcement.iconUrl != null) ...[
            Icon(
              Icons.info,
              color: _config?.getColor('iconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
              size: _getConfig('iconSize', 20.0),
            ),
            SizedBox(width: _getConfig('iconSpacing', 8.0)),
          ],
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  announcement.title,
                  style: TextStyle(
                    color: _config?.getColor('titleColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                    fontSize: _getConfig('titleFontSize', 14.0),
                    fontWeight: _config?.getFontWeight('titleFontWeight', FontWeight.w600) ?? FontWeight.w600,
                  ),
                  maxLines: _getConfig('titleMaxLines', 1),
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Subtitle removed - not available in AnnouncementModel
              ],
            ),
          ),
          
          // Action Button
          if (widget.enableActions && announcement.actionText?.isNotEmpty == true)
            _buildActionButton(context, theme, announcement),
          
          // Dismiss Button
          if (widget.enableDismiss)
            _buildDismissButton(context, theme, announcement, index),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ShopKitTheme theme, AnnouncementModel announcement) {
    if (widget.customActionBuilder != null) {
      return widget.customActionBuilder!(context, announcement);
    }

    return Container(
      margin: EdgeInsets.only(left: _getConfig('actionButtonMargin', 8.0)),
      child: TextButton(
        onPressed: () => _handleActionTap(announcement, announcement.actionText ?? ''),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: _getConfig('actionButtonHorizontalPadding', 12.0),
            vertical: _getConfig('actionButtonVerticalPadding', 4.0),
          ),
          backgroundColor: _config?.getColor('actionButtonBackgroundColor', theme.onPrimaryColor.withValues(alpha: 0.2)) ?? theme.onPrimaryColor.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: _config?.getBorderRadius('actionButtonBorderRadius', BorderRadius.circular(16)) ?? BorderRadius.circular(16),
          ),
        ),
        child: Text(
          announcement.actionText ?? '',
          style: TextStyle(
            color: _config?.getColor('actionButtonTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
            fontSize: _getConfig('actionButtonFontSize', 12.0),
            fontWeight: _config?.getFontWeight('actionButtonFontWeight', FontWeight.w500) ?? FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDismissButton(BuildContext context, ShopKitTheme theme, AnnouncementModel announcement, int index) {
    return Container(
      margin: EdgeInsets.only(left: _getConfig('dismissButtonMargin', 8.0)),
      child: InkWell(
        onTap: () => _handleDismiss(announcement, index),
        borderRadius: BorderRadius.circular(_getConfig('dismissButtonBorderRadius', 16.0)),
        child: Container(
          padding: EdgeInsets.all(_getConfig('dismissButtonPadding', 4.0)),
          child: Icon(
            Icons.close,
            color: _config?.getColor('dismissButtonColor', theme.onPrimaryColor.withValues(alpha: 0.7)) ?? theme.onPrimaryColor.withValues(alpha: 0.7),
            size: _getConfig('dismissButtonSize', 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, ShopKitTheme theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: _visibleAnnouncements.isNotEmpty ? (_currentIndex + 1) / _visibleAnnouncements.length : 0,
        backgroundColor: _config?.getColor('progressBackgroundColor', theme.onPrimaryColor.withValues(alpha: 0.2)) ?? theme.onPrimaryColor.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          _config?.getColor('progressValueColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
        ),
        minHeight: _getConfig('progressHeight', 2.0),
      ),
    );
  }

  Widget _buildCounter(BuildContext context, ShopKitTheme theme) {
    return Positioned(
      top: _getConfig('counterTopOffset', 4.0),
      right: _getConfig('counterRightOffset', 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getConfig('counterHorizontalPadding', 6.0),
          vertical: _getConfig('counterVerticalPadding', 2.0),
        ),
        decoration: BoxDecoration(
          color: _config?.getColor('counterBackgroundColor', theme.onPrimaryColor.withValues(alpha: 0.2)) ?? theme.onPrimaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(_getConfig('counterBorderRadius', 8.0)),
        ),
        child: Text(
          '${_currentIndex + 1}/${_visibleAnnouncements.length}',
          style: TextStyle(
            color: _config?.getColor('counterTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
            fontSize: _getConfig('counterFontSize', 10.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ShopKitTheme theme) {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _previousAnnouncement,
            child: Container(
              padding: EdgeInsets.all(_getConfig('navigationButtonPadding', 8.0)),
              child: Icon(
                Icons.chevron_left,
                color: _config?.getColor('navigationButtonColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                size: _getConfig('navigationButtonSize', 16.0),
              ),
            ),
          ),
          
          InkWell(
            onTap: _nextAnnouncement,
            child: Container(
              padding: EdgeInsets.all(_getConfig('navigationButtonPadding', 8.0)),
              child: Icon(
                Icons.chevron_right,
                color: _config?.getColor('navigationButtonColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                size: _getConfig('navigationButtonSize', 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Public API for external control
  int get currentIndex => _currentIndex;
  
  int get visibleCount => _visibleAnnouncements.length;
  
  bool get isAutoScrolling => _isAutoScrolling;
  
  List<AnnouncementModel> get visibleAnnouncements => List.unmodifiable(_visibleAnnouncements);
  
  void goToIndex(int index) {
    if (index >= 0 && index < _visibleAnnouncements.length) {
      if (widget.behavior == AnnouncementBarBehavior.scroll && _pageController != null) {
        _pageController!.animateToPage(
          index,
          duration: widget.animationDuration,
          curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
        );
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    }
  }
  
  void next() {
    _nextAnnouncement();
  }
  
  void previous() {
    _previousAnnouncement();
  }
  
  void startAutoScroll() {
    if (widget.enableAutoScroll && !_isAutoScrolling) {
      _startAutoScroll();
    }
  }
  
  void stopAutoScroll() {
    _stopAutoScroll();
  }
  
  void pauseAutoScroll() {
    _userInteracted = true;
  }
  
  void resumeAutoScroll() {
    _resumeAutoScroll();
  }
  
  void dismissCurrent() {
    if (_visibleAnnouncements.isNotEmpty) {
      final announcement = _visibleAnnouncements[_currentIndex];
      _handleDismiss(announcement, _currentIndex);
    }
  }
  
  void dismissAll() {
    for (int i = _visibleAnnouncements.length - 1; i >= 0; i--) {
      final announcement = _visibleAnnouncements[i];
      _handleDismiss(announcement, i);
    }
  }
}

/// Style options for announcement bar
enum AnnouncementBarStyle {
  banner,
  minimal,
  card,
  gradient,
  outlined,
}

/// Position options for announcement bar
enum AnnouncementBarPosition {
  top,
  bottom,
}

/// Behavior options for announcement bar
enum AnnouncementBarBehavior {
  static,
  scroll,
  marquee,
}
