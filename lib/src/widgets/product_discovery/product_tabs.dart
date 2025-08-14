import 'package:flutter/material.dart';
import '../../models/product_detail_model.dart';
import '../../config/flexible_widget_config.dart';

/// A tabbed widget for displaying product detail information
class ProductTabs extends StatefulWidget {
  const ProductTabs({
    super.key,
    required this.tabs,
    this.initialTabIndex = 0,
    this.tabBarHeight = 48.0,
    this.backgroundColor,
    this.selectedTabColor,
    this.unselectedTabColor,
    this.indicatorColor,
    this.tabPadding,
    this.contentPadding,
    this.isScrollable = true,
    this.borderRadius,
    this.flexibleConfig,
  });

  /// List of tabs to display
  final List<ProductTabModel> tabs;

  /// Initial tab index to show
  final int initialTabIndex;

  /// Height of the tab bar
  final double tabBarHeight;

  /// Background color of the tab bar
  final Color? backgroundColor;

  /// Color of selected tab
  final Color? selectedTabColor;

  /// Color of unselected tabs
  final Color? unselectedTabColor;

  /// Color of the tab indicator
  final Color? indicatorColor;

  /// Padding for tab labels
  final EdgeInsets? tabPadding;

  /// Padding for tab content
  final EdgeInsets? contentPadding;

  /// Whether tabs should be scrollable
  final bool isScrollable;

  /// Border radius for the tab container
  final BorderRadius? borderRadius;
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex.clamp(0, widget.tabs.length - 1);
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    T cfg<T>(String key, T fallback) {
      final fc = widget.flexibleConfig;
      if (fc != null) {
        if (fc.has('productTabs.$key')) { try { return fc.get<T>('productTabs.$key', fallback); } catch (_) {} }
        if (fc.has(key)) { try { return fc.get<T>(key, fallback); } catch (_) {} }
      }
      return fallback;
    }

    final tabBarHeight = cfg<double>('tabBarHeight', widget.tabBarHeight);
    final isScrollable = cfg<bool>('isScrollable', widget.isScrollable);
    final backgroundColor = cfg<Color>('backgroundColor', widget.backgroundColor ?? colorScheme.surface);
    final selectedColor = cfg<Color>('selectedTabColor', widget.selectedTabColor ?? colorScheme.primary);
    final unselectedColor = cfg<Color>('unselectedTabColor', widget.unselectedTabColor ?? colorScheme.onSurface.withValues(alpha: 0.6));
    final indicatorColor = cfg<Color>('indicatorColor', widget.indicatorColor ?? colorScheme.primary);
    final tabPadding = cfg<EdgeInsets>('tabPadding', widget.tabPadding ?? const EdgeInsets.symmetric(horizontal: 16));
    final contentPadding = cfg<EdgeInsets>('contentPadding', widget.contentPadding ?? const EdgeInsets.all(16));
    final radius = cfg<BorderRadius>('borderRadius', widget.borderRadius ?? BorderRadius.circular(12));

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            height: tabBarHeight,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius.topLeft.x),
                topRight: Radius.circular(radius.topRight.x),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: isScrollable,
              indicatorColor: indicatorColor,
              labelColor: selectedColor,
              unselectedLabelColor: unselectedColor,
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: theme.textTheme.titleSmall,
              labelPadding: tabPadding,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: widget.tabs.map((tab) => _buildTab(tab, theme)).toList(),
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs
                  .map((tab) => _buildTabContent(tab, theme, contentPadding))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(ProductTabModel tab, ThemeData theme) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            Icon(
              _getIconData(tab.icon!),
              size: 18,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              tab.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProductTabModel tab, ThemeData theme, EdgeInsets contentPadding) {
    return SingleChildScrollView(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tab.content.isNotEmpty)
            _buildContentText(tab.content, theme)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No content available for this tab',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentText(String content, ThemeData theme) {
    // Simple HTML-like parsing for basic formatting
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return const SizedBox(height: 8);
        }

        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.substring(2),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.substring(3),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.substring(4),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        if (line.startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: theme.textTheme.bodyMedium,
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            line,
            style: theme.textTheme.bodyMedium,
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'description':
      case 'info':
        return Icons.description;
      case 'specifications':
      case 'spec':
        return Icons.list_alt;
      case 'reviews':
      case 'review':
        return Icons.star;
      case 'shipping':
        return Icons.local_shipping;
      case 'return':
      case 'returns':
        return Icons.keyboard_return;
      case 'warranty':
        return Icons.security;
      case 'care':
        return Icons.cleaning_services;
      case 'size':
        return Icons.straighten;
      case 'materials':
        return Icons.texture;
      default:
        return Icons.info;
    }
  }
}

/// Predefined product tabs
class ProductTabDefaults {
  static const ProductTabModel description = ProductTabModel(
    id: 'description',
    title: 'Description',
    content: '',
    icon: 'description',
    order: 1,
  );

  static const ProductTabModel specifications = ProductTabModel(
    id: 'specifications',
    title: 'Specifications',
    content: '',
    icon: 'specifications',
    order: 2,
  );

  static const ProductTabModel reviews = ProductTabModel(
    id: 'reviews',
    title: 'Reviews',
    content: '',
    icon: 'reviews',
    order: 3,
  );

  static const ProductTabModel shipping = ProductTabModel(
    id: 'shipping',
    title: 'Shipping',
    content: '',
    icon: 'shipping',
    order: 4,
  );

  static const ProductTabModel returns = ProductTabModel(
    id: 'returns',
    title: 'Returns',
    content: '',
    icon: 'return',
    order: 5,
  );

  static const List<ProductTabModel> defaultTabs = [
    description,
    specifications,
    reviews,
    shipping,
    returns,
  ];
}
