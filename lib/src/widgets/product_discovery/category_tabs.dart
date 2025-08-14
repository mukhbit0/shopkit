import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../models/category_model.dart';

/// A comprehensive category tabs widget with advanced customization
/// Features: Unlimited styles, animations, indicators, scrolling, and theming
class CategoryTabs extends StatefulWidget {
  const CategoryTabs({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.config,
    this.customBuilder,
    this.customTabBuilder,
    this.customIndicatorBuilder,
    this.scrollController,
    this.isScrollable = true,
    this.alignment = TabAlignment.start,
    this.enableAnimations = true,
    this.enableHaptics = true,
  });

  /// List of categories to display
  final List<CategoryModel> categories;

  /// Currently selected category ID
  final String? selectedCategoryId;

  /// Callback when category is selected
  final void Function(CategoryModel)? onCategorySelected;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<CategoryModel>, CategoryTabsState)? customBuilder;

  /// Custom tab builder
  final Widget Function(BuildContext, CategoryModel, bool, int)? customTabBuilder;

  /// Custom indicator builder
  final Widget Function(BuildContext, CategoryModel, bool)? customIndicatorBuilder;

  /// Scroll controller for the tabs
  final ScrollController? scrollController;

  /// Whether tabs should be scrollable
  final bool isScrollable;

  /// Tab alignment
  final TabAlignment alignment;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  @override
  State<CategoryTabs> createState() => CategoryTabsState();
}

class CategoryTabsState extends State<CategoryTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedIndex = 0;
  FlexibleWidgetConfig? _config;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('tabs', context: context);
    _setupControllers();
    _setupAnimations();
    _findSelectedIndex();
  }

  void _setupControllers() {
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
      initialIndex: _selectedIndex,
      animationDuration: widget.enableAnimations 
        ? Duration(milliseconds: _getConfig('tabAnimationDuration', 300))
        : Duration.zero,
    );

    _tabController.addListener(_handleTabSelection);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: _getConfig('contentAnimationDuration', 400)),
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
    }
  }

  void _findSelectedIndex() {
    if (widget.selectedCategoryId != null) {
      final index = widget.categories.indexWhere(
        (category) => category.id == widget.selectedCategoryId,
      );
      if (index != -1) {
        _selectedIndex = index;
      }
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) return;

    final newIndex = _tabController.index;
    final category = widget.categories[newIndex];

    if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
      HapticFeedback.lightImpact();
    }

    setState(() => _selectedIndex = newIndex);
    widget.onCategorySelected?.call(category);
  }

  @override
  void didUpdateWidget(CategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update config
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('tabs', context: context);
    
    // Update controller if categories changed
    if (widget.categories.length != oldWidget.categories.length) {
      _tabController.dispose();
      _setupControllers();
    }
    
    // Update selected index
    _findSelectedIndex();
    if (_selectedIndex != _tabController.index) {
      _tabController.animateTo(_selectedIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.categories, this);
    }

    final theme = ShopKitTheme.light();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildTabsContainer(context, theme),
      ),
    );
  }

  Widget _buildTabsContainer(BuildContext context, ShopKitTheme theme) {
    final tabStyle = _getConfig('tabStyle', 'default');
    
    switch (tabStyle) {
      case 'pills':
        return _buildPillTabs(context, theme);
      case 'underline':
        return _buildUnderlineTabs(context, theme);
      case 'background':
        return _buildBackgroundTabs(context, theme);
      case 'card':
        return _buildCardTabs(context, theme);
      case 'chip':
        return _buildChipTabs(context, theme);
      default:
        return _buildDefaultTabs(context, theme);
    }
  }

  Widget _buildDefaultTabs(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getConfig('tabBarHeight', 48.0),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('borderRadius', BorderRadius.zero) ?? BorderRadius.zero,
        boxShadow: _getConfig('enableShadow', false)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('shadowOpacity', 0.1)),
                blurRadius: _getConfig('shadowBlurRadius', 4.0),
                offset: Offset(0, _getConfig('shadowOffsetY', 2.0)),
              ),
            ]
          : null,
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        tabAlignment: widget.alignment,
        padding: _config?.getEdgeInsets('tabBarPadding') ?? EdgeInsets.zero,
        indicator: widget.customIndicatorBuilder != null
          ? null
          : _buildIndicator(theme),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: _config?.getColor('activeTextColor', theme.primaryColor) ?? theme.primaryColor,
        unselectedLabelColor: _config?.getColor('inactiveTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
        labelStyle: TextStyle(
          fontSize: _getConfig('activeFontSize', 16.0),
          fontWeight: _config?.getFontWeight('activeFontWeight', FontWeight.w600) ?? FontWeight.w600,
          fontFamily: _getConfig('fontFamily', null),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: _getConfig('inactiveFontSize', 14.0),
          fontWeight: _config?.getFontWeight('inactiveFontWeight', FontWeight.w400) ?? FontWeight.w400,
          fontFamily: _getConfig('fontFamily', null),
        ),
        tabs: _buildTabs(context, theme),
      ),
    );
  }

  Widget _buildPillTabs(BuildContext context, ShopKitTheme theme) {
    return SizedBox(
      height: _getConfig('tabBarHeight', 48.0),
      child: ListView.separated(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        padding: _config?.getEdgeInsets('tabBarPadding', const EdgeInsets.symmetric(horizontal: 16)) ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('tabSpacing', 8.0)),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == _selectedIndex;
          
          return _buildPillTab(context, theme, category, isSelected, index);
        },
      ),
    );
  }

  Widget _buildPillTab(BuildContext context, ShopKitTheme theme, CategoryModel category, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: _config?.getDuration('pillAnimationDuration', const Duration(milliseconds: 200)) ?? const Duration(milliseconds: 200),
        curve: _config?.getCurve('pillAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
        padding: _config?.getEdgeInsets('pillPadding', const EdgeInsets.symmetric(horizontal: 16, vertical: 8)) ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? (_config?.getColor('activePillColor', theme.primaryColor) ?? theme.primaryColor)
            : (_config?.getColor('inactivePillColor', theme.surfaceColor) ?? theme.surfaceColor),
          borderRadius: _config?.getBorderRadius('pillBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
              ? (_config?.getColor('activePillBorderColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('inactivePillBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2)),
            width: _getConfig('pillBorderWidth', 1.0),
          ),
          boxShadow: isSelected && _getConfig('enableActiveShadow', true)
            ? [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: _getConfig('activeShadowOpacity', 0.3)),
                  blurRadius: _getConfig('activeShadowBlur', 8.0),
                  offset: Offset(0, _getConfig('activeShadowOffsetY', 2.0)),
                ),
              ]
            : null,
        ),
        child: widget.customTabBuilder?.call(context, category, isSelected, index) ??
          Text(
            category.name,
            style: TextStyle(
              color: isSelected
                ? (_config?.getColor('activePillTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
                : (_config?.getColor('inactivePillTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
              fontSize: _getConfig('pillFontSize', 14.0),
              fontWeight: isSelected
                ? (_config?.getFontWeight('activePillFontWeight', FontWeight.w600) ?? FontWeight.w600)
                : (_config?.getFontWeight('inactivePillFontWeight', FontWeight.w400) ?? FontWeight.w400),
              fontFamily: _getConfig('fontFamily', null),
            ),
          ),
      ),
    );
  }

  Widget _buildUnderlineTabs(BuildContext context, ShopKitTheme theme) {
    return Column(
      children: [
        SizedBox(
          height: _getConfig('tabBarHeight', 48.0),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            tabAlignment: widget.alignment,
            padding: _config?.getEdgeInsets('tabBarPadding') ?? EdgeInsets.zero,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: _config?.getColor('underlineColor', theme.primaryColor) ?? theme.primaryColor,
                width: _getConfig('underlineWidth', 3.0),
              ),
              insets: _config?.getEdgeInsets('underlineInsets', const EdgeInsets.symmetric(horizontal: 16)) ?? const EdgeInsets.symmetric(horizontal: 16),
            ),
            labelColor: _config?.getColor('activeTextColor', theme.primaryColor) ?? theme.primaryColor,
            unselectedLabelColor: _config?.getColor('inactiveTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            tabs: _buildTabs(context, theme),
          ),
        ),
        if (_getConfig('showDivider', true))
          Divider(
            height: 1,
            color: _config?.getColor('dividerColor', theme.onSurfaceColor.withValues(alpha: 0.1)) ?? theme.onSurfaceColor.withValues(alpha: 0.1),
          ),
      ],
    );
  }

  Widget _buildBackgroundTabs(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: _getConfig('tabBarHeight', 48.0),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundTabsColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('backgroundTabsBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        tabAlignment: widget.alignment,
        indicator: BoxDecoration(
          color: _config?.getColor('backgroundActiveColor', theme.primaryColor) ?? theme.primaryColor,
          borderRadius: _config?.getBorderRadius('backgroundActiveBorderRadius', BorderRadius.circular(6)) ?? BorderRadius.circular(6),
        ),
        labelColor: _config?.getColor('backgroundActiveTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
        unselectedLabelColor: _config?.getColor('backgroundInactiveTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        tabs: _buildTabs(context, theme),
      ),
    );
  }

  Widget _buildCardTabs(BuildContext context, ShopKitTheme theme) {
    return SizedBox(
      height: _getConfig('tabBarHeight', 60.0),
      child: ListView.separated(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        padding: _config?.getEdgeInsets('tabBarPadding', const EdgeInsets.symmetric(horizontal: 16)) ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('tabSpacing', 12.0)),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == _selectedIndex;
          
          return _buildCardTab(context, theme, category, isSelected, index);
        },
      ),
    );
  }

  Widget _buildCardTab(BuildContext context, ShopKitTheme theme, CategoryModel category, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedContainer(
        duration: _config?.getDuration('cardAnimationDuration', const Duration(milliseconds: 200)) ?? const Duration(milliseconds: 200),
        padding: _config?.getEdgeInsets('cardTabPadding', const EdgeInsets.symmetric(horizontal: 16, vertical: 12)) ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
            ? (_config?.getColor('activeCardColor', theme.primaryColor) ?? theme.primaryColor)
            : (_config?.getColor('inactiveCardColor', theme.surfaceColor) ?? theme.surfaceColor),
          borderRadius: _config?.getBorderRadius('cardBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.onSurfaceColor.withValues(alpha: isSelected ? _getConfig('activeCardShadowOpacity', 0.15) : _getConfig('inactiveCardShadowOpacity', 0.05)),
              blurRadius: _getConfig('cardShadowBlur', 8.0),
              offset: Offset(0, _getConfig('cardShadowOffsetY', 2.0)),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.iconUrl != null || _getConfig('showCategoryIcons', false)) ...[
              SizedBox(
                width: _getConfig('cardIconSize', 24.0),
                height: _getConfig('cardIconSize', 24.0),
                child: category.iconUrl != null
                  ? Image.network(category.iconUrl!, fit: BoxFit.cover)
                  : Icon(
                      Icons.category,
                      size: _getConfig('cardIconSize', 24.0),
                      color: isSelected
                        ? (_config?.getColor('activeCardIconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
                        : (_config?.getColor('inactiveCardIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
                    ),
              ),
              SizedBox(height: _getConfig('cardIconSpacing', 4.0)),
            ],
            Text(
              category.name,
              style: TextStyle(
                color: isSelected
                  ? (_config?.getColor('activeCardTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
                  : (_config?.getColor('inactiveCardTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
                fontSize: _getConfig('cardFontSize', 12.0),
                fontWeight: isSelected
                  ? (_config?.getFontWeight('activeCardFontWeight', FontWeight.w600) ?? FontWeight.w600)
                  : (_config?.getFontWeight('inactiveCardFontWeight', FontWeight.w400) ?? FontWeight.w400),
                fontFamily: _getConfig('fontFamily', null),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipTabs(BuildContext context, ShopKitTheme theme) {
    return SizedBox(
      height: _getConfig('tabBarHeight', 40.0),
      child: ListView.separated(
        controller: widget.scrollController,
        scrollDirection: Axis.horizontal,
        padding: _config?.getEdgeInsets('tabBarPadding', const EdgeInsets.symmetric(horizontal: 16)) ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('tabSpacing', 8.0)),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = index == _selectedIndex;
          
          return FilterChip(
            label: Text(category.name),
            selected: isSelected,
            onSelected: (selected) => _tabController.animateTo(index),
            selectedColor: _config?.getColor('chipSelectedColor', theme.primaryColor) ?? theme.primaryColor,
            backgroundColor: _config?.getColor('chipBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
            labelStyle: TextStyle(
              color: isSelected
                ? (_config?.getColor('chipSelectedTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
                : (_config?.getColor('chipTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
              fontSize: _getConfig('chipFontSize', 14.0),
              fontWeight: isSelected
                ? (_config?.getFontWeight('chipSelectedFontWeight', FontWeight.w500) ?? FontWeight.w500)
                : (_config?.getFontWeight('chipFontWeight', FontWeight.w400) ?? FontWeight.w400),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context, ShopKitTheme theme) {
    return widget.categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final isSelected = index == _selectedIndex;

      return widget.customTabBuilder?.call(context, category, isSelected, index) ??
        Tab(
          child: Container(
            padding: _config?.getEdgeInsets('tabPadding', const EdgeInsets.symmetric(horizontal: 8)) ?? const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category.iconUrl != null && _getConfig('showTabIcons', true)) ...[
                  Image.network(
                    category.iconUrl!,
                    width: _getConfig('tabIconSize', 20.0),
                    height: _getConfig('tabIconSize', 20.0),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: _getConfig('tabIconSpacing', 8.0)),
                ],
                Flexible(
                  child: Text(
                    category.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (_getConfig('showProductCount', false) && category.itemCount > 0) ...[
                  SizedBox(width: _getConfig('countSpacing', 4.0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                        ? (_config?.getColor('activeCountBadgeColor', theme.onPrimaryColor.withValues(alpha: 0.2)) ?? theme.onPrimaryColor.withValues(alpha: 0.2))
                        : (_config?.getColor('inactiveCountBadgeColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${category.itemCount}',
                      style: TextStyle(
                        color: isSelected
                          ? (_config?.getColor('activeCountTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
                          : (_config?.getColor('inactiveCountTextColor', theme.primaryColor) ?? theme.primaryColor),
                        fontSize: _getConfig('countFontSize', 10.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
    }).toList();
  }

  Decoration? _buildIndicator(ShopKitTheme theme) {
    final indicatorType = _getConfig('indicatorType', 'underline');
    
    switch (indicatorType) {
      case 'dot':
        return _DotIndicator(
          color: _config?.getColor('indicatorColor', theme.primaryColor) ?? theme.primaryColor,
          radius: _getConfig('indicatorDotRadius', 3.0),
        );
      case 'line':
        return UnderlineTabIndicator(
          borderSide: BorderSide(
            color: _config?.getColor('indicatorColor', theme.primaryColor) ?? theme.primaryColor,
            width: _getConfig('indicatorLineWidth', 2.0),
          ),
        );
      case 'background':
        return BoxDecoration(
          color: _config?.getColor('indicatorColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1),
          borderRadius: _config?.getBorderRadius('indicatorBorderRadius', BorderRadius.circular(4)) ?? BorderRadius.circular(4),
        );
      default:
        return UnderlineTabIndicator(
          borderSide: BorderSide(
            color: _config?.getColor('indicatorColor', theme.primaryColor) ?? theme.primaryColor,
            width: _getConfig('indicatorWidth', 3.0),
          ),
        );
    }
  }

  /// Public API for external control
  void selectCategory(String categoryId) {
    final index = widget.categories.indexWhere((category) => category.id == categoryId);
    if (index != -1) {
      _tabController.animateTo(index);
    }
  }

  void selectIndex(int index) {
    if (index >= 0 && index < widget.categories.length) {
      _tabController.animateTo(index);
    }
  }

  CategoryModel? get selectedCategory {
    if (_selectedIndex >= 0 && _selectedIndex < widget.categories.length) {
      return widget.categories[_selectedIndex];
    }
    return null;
  }

  int get selectedIndex => _selectedIndex;
}

/// Custom dot indicator for tabs
class _DotIndicator extends Decoration {
  final Color color;
  final double radius;

  const _DotIndicator({
    required this.color,
    required this.radius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(color: color, radius: radius);
  }
}

class _DotPainter extends BoxPainter {
  final Color color;
  final double radius;

  _DotPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(
      offset.dx + configuration.size!.width / 2,
      offset.dy + configuration.size!.height - radius,
    );

    canvas.drawCircle(center, radius, paint);
  }
}
