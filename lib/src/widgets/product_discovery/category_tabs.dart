import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../models/category_model.dart';

/// A comprehensive category tabs widget with advanced customization
/// Features: Unlimited styles, animations, indicators, scrolling, and theming
class CategoryTabs extends StatefulWidget {
  const CategoryTabs({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
  // config removed
    this.customBuilder,
    this.customTabBuilder,
    this.customIndicatorBuilder,
    this.scrollController,
    this.isScrollable = true,
    this.alignment = TabAlignment.start,
    this.enableAnimations = true,
    this.enableHaptics = true,
  // themeStyle removed
  });

  /// List of categories to display
  final List<CategoryModel> categories;

  /// Currently selected category ID
  final String? selectedCategoryId;

  /// Callback when category is selected
  final void Function(CategoryModel)? onCategorySelected;

  // Legacy FlexibleWidgetConfig removed

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

  // themeStyle removed; using CategoryTabsTheme

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
  // Legacy config & dynamic lookups removed; using explicit constants & theme tokens

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _findSelectedIndex();
  }

  void _setupControllers() {
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
      initialIndex: _selectedIndex,
  animationDuration: widget.enableAnimations ? const Duration(milliseconds: 300) : Duration.zero,
    );

    _tabController.addListener(_handleTabSelection);
  }

  void _setupAnimations() {
  _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

  _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

  _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
    .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

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
  if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }

    setState(() => _selectedIndex = newIndex);
    widget.onCategorySelected?.call(category);
  }

  @override
  void didUpdateWidget(CategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  final theme = Theme.of(context).extension<ShopKitTheme>()!;
  final content = FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
    child: _buildTabsContainer(context, theme),
      ),
    );

    return content;
  }

  // Removed themed tabs path

  Widget _buildTabsContainer(BuildContext context, ShopKitTheme theme) {
  return _buildDefaultTabs(context, theme);
  }

  Widget _buildDefaultTabs(BuildContext context, ShopKitTheme theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.categoryTabsTheme?.backgroundColor ?? theme.surfaceColor,
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        tabAlignment: widget.alignment,
        padding: EdgeInsets.zero,
        indicator: widget.customIndicatorBuilder != null ? null : _buildIndicator(theme),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.categoryTabsTheme?.indicatorColor ?? theme.primaryColor,
        unselectedLabelColor: theme.categoryTabsTheme?.unselectedLabelStyle?.color ?? theme.onSurfaceColor.withValues(alpha: 0.6),
        labelStyle: theme.categoryTabsTheme?.selectedLabelStyle ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: theme.categoryTabsTheme?.unselectedLabelStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        tabs: _buildTabs(context, theme),
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category.iconUrl != null) ...[
                  Image.network(
                    category.iconUrl!,
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                ],
                Flexible(
                  child: Text(
                    category.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (category.itemCount > 0) ...[
                  const SizedBox(width: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.onPrimaryColor.withValues(alpha: 0.2)
                          : theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${category.itemCount}',
                      style: TextStyle(
                        color: isSelected ? theme.onPrimaryColor : theme.primaryColor,
                        fontSize: 10,
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
    // Simplified single underline indicator using theme color
    return UnderlineTabIndicator(
      borderSide: BorderSide(color: theme.primaryColor, width: 3),
    );
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
// Removed custom dot indicator (legacy multi-style support)


