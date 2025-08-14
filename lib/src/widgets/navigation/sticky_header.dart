import 'package:flutter/material.dart';
import '../../models/menu_item_model.dart';
import '../../config/flexible_widget_config.dart';

/// A sticky header widget with navigation and search functionality
class StickyHeader extends StatefulWidget {
  const StickyHeader({
    super.key,
    this.title,
    this.logo,
    this.menuItems = const [],
    this.onMenuItemTap,
    this.onSearchTap,
    this.onCartTap,
    this.backgroundColor,
    this.elevation = 4.0,
    this.height = 60.0,
    this.showSearch = true,
    this.showCart = true,
    this.cartItemCount,
    this.flexibleConfig,
  });
  final FlexibleWidgetConfig? flexibleConfig;

  /// Optional title to display in the header
  final String? title;

  /// Optional logo widget to display
  final Widget? logo;

  /// List of menu items to display
  final List<MenuItemModel> menuItems;

  /// Callback when a menu item is tapped
  final void Function(MenuItemModel item)? onMenuItemTap;

  /// Callback when search is tapped
  final VoidCallback? onSearchTap;

  /// Callback when cart is tapped
  final VoidCallback? onCartTap;

  /// Background color of the header
  final Color? backgroundColor;

  /// Elevation of the header
  final double elevation;

  /// Height of the header
  final double height;

  /// Whether to show search icon
  final bool showSearch;

  /// Whether to show cart icon
  final bool showCart;

  /// Number of items in cart to show badge
  final int? cartItemCount;

  @override
  State<StickyHeader> createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<StickyHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    T cfg<T>(String key, T fallback) {
      final fc = widget.flexibleConfig;
      if (fc != null) {
        if (fc.has('stickyHeader.$key')) { try { return fc.get<T>('stickyHeader.$key', fallback); } catch (_) {} }
        if (fc.has(key)) { try { return fc.get<T>(key, fallback); } catch (_) {} }
      }
      return fallback;
    }

    final height = cfg<double>('height', widget.height);
    final background = cfg<Color>('backgroundColor', widget.backgroundColor ?? colorScheme.surface);
    final elevation = cfg<double>('elevation', widget.elevation);
    final showSearch = cfg<bool>('showSearch', widget.showSearch);
    final showCart = cfg<bool>('showCart', widget.showCart);
    final showShadow = cfg<bool>('showShadow', true);
    final padding = cfg<EdgeInsets>('padding', const EdgeInsets.symmetric(horizontal: 16.0));

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (widget.logo != null)
                widget.logo!
              else if (widget.title != null)
                Text(
                  widget.title!,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.menuItems.map((item) => Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _buildMenuItem(item, theme),
                    )).toList(),
                  ),
                ),
              ),
              if (showSearch)
                IconButton(
                  onPressed: widget.onSearchTap,
                  icon: Icon(Icons.search, color: colorScheme.onSurface),
                  tooltip: 'Search',
                ),
              if (showCart)
                Stack(
                  children: [
                    IconButton(
                      onPressed: widget.onCartTap,
                      icon: Icon(Icons.shopping_cart_outlined, color: colorScheme.onSurface),
                      tooltip: 'Cart',
                    ),
                    if (widget.cartItemCount != null && widget.cartItemCount! > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${widget.cartItemCount}',
                            style: TextStyle(
                              color: colorScheme.onError,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItemModel item, ThemeData theme) {
    return InkWell(
      onTap: item.isEnabled ? () => widget.onMenuItemTap?.call(item) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null)
              item.icon!
            else if (item.iconUrl != null)
              Image.network(
                item.iconUrl!,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 20),
              ),
            if (item.icon != null || item.iconUrl != null)
              const SizedBox(width: 8),
            Text(
              item.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: item.isEnabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (item.badgeCount != null && item.badgeCount! > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${item.badgeCount}',
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
