import 'package:flutter/material.dart';
import '../../models/product_detail_model.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system

/// A tabbed widget for displaying product detail information, styled via ShopKitTheme.
class ProductTabs extends StatefulWidget {
  /// Creates a ProductTabs widget.
  /// The constructor is now clean, focusing only on data and behavior.
  const ProductTabs({
    super.key,
    required this.tabs,
    this.initialTabIndex = 0,
    this.contentPadding,
    this.isScrollable = true,
  });

  /// The list of `ProductTabModel`s to display.
  final List<ProductTabModel> tabs;

  /// The index of the tab that should be selected initially.
  final int initialTabIndex;

  /// Padding for the content inside each tab view.
  final EdgeInsets? contentPadding;

  /// Whether the tab bar can be scrolled horizontally.
  final bool isScrollable;

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, widget.tabs.length - 1),
    );
  }
  
  @override
  void didUpdateWidget(covariant ProductTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialTabIndex.clamp(0, widget.tabs.length - 1),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    // REUSE: We use CategoryTabsTheme here for consistency.
    final tabsTheme = shopKitTheme?.categoryTabsTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: tabsTheme?.backgroundColor ?? theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor, width: 1.0),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            indicatorColor: tabsTheme?.indicatorColor ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
            labelColor: tabsTheme?.selectedLabelStyle?.color ?? shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
            unselectedLabelColor: tabsTheme?.unselectedLabelStyle?.color ?? theme.colorScheme.onSurfaceVariant,
            labelStyle: tabsTheme?.selectedLabelStyle ?? shopKitTheme?.typography.button,
            unselectedLabelStyle: tabsTheme?.unselectedLabelStyle ?? shopKitTheme?.typography.button,
            indicator: tabsTheme?.indicatorDecoration,
            tabs: widget.tabs.map((tab) => _buildTab(tab)).toList(),
          ),
        ),

        // Tab Content
        Flexible(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) => _buildTabContent(tab)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(ProductTabModel tab) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tab.icon != null) ...[
            Icon(_getIconData(tab.icon!), size: 18),
            const SizedBox(width: 8),
          ],
          Text(tab.title),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProductTabModel tab) {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();

    return SingleChildScrollView(
      padding: widget.contentPadding ?? EdgeInsets.all(shopKitTheme?.spacing.md ?? 16.0),
      child: Text(
        tab.content,
        style: shopKitTheme?.typography.body1 ?? theme.textTheme.bodyLarge,
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'description':
      case 'info':
        return Icons.description_outlined;
      case 'specifications':
      case 'spec':
        return Icons.list_alt_outlined;
      case 'reviews':
      case 'review':
        return Icons.star_outline;
      case 'shipping':
        return Icons.local_shipping_outlined;
      case 'return':
      case 'returns':
        return Icons.keyboard_return_outlined;
      case 'warranty':
        return Icons.security_outlined;
      case 'care':
        return Icons.cleaning_services_outlined;
      case 'size':
        return Icons.straighten_outlined;
      case 'materials':
        return Icons.texture;
      default:
        return Icons.info_outline;
    }
  }
}