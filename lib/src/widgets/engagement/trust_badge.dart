import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../models/badge_model.dart';

/// Convert hex string to Color (file-level helper used by widgets)
Color? _parseColorString(String? colorString) {
  if (colorString == null) return null;
  try {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    }
    return Color(int.parse(colorString, radix: 16) + 0xFF000000);
  } catch (e) {
    return null;
  }
}

/// A widget for displaying trust badges and security seals
class TrustBadge extends StatelessWidget {
  const TrustBadge({
    super.key,
    required this.badge,
    this.onTap,
    this.showTooltip = true,
    this.animateOnHover = true,
    this.borderRadius,
    this.elevation = 2.0,
    this.customSize,
    
  });

  /// Badge configuration
  final BadgeModel badge;

  /// Callback when badge is tapped
  final VoidCallback? onTap;

  /// Whether to show tooltip on hover
  final bool showTooltip;

  /// Whether to animate on hover
  final bool animateOnHover;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Shadow elevation
  final double elevation;

  /// Custom size override
  final Size? customSize;
  

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final shopTheme = theme.extension<ShopKitTheme>();
  final badgeTheme = shopTheme?.trustBadgeTheme;

  final resolvedElevation = badgeTheme?.elevation ?? elevation;
  final resolvedBorderRadius = borderRadius ?? badgeTheme?.borderRadius ?? BorderRadius.circular(8);
  final resolvedShowTooltip = badgeTheme?.showTooltip ?? showTooltip;
  final resolvedAnimateOnHover = badgeTheme?.animateOnHover ?? animateOnHover;
  final resolvedWidth = badgeTheme?.width ?? customSize?.width ?? badge.width ?? 80;
  final resolvedHeight = badgeTheme?.height ?? customSize?.height ?? badge.height ?? 40;
  final resolvedBg = badgeTheme?.backgroundColor ?? _parseColorString(badge.backgroundColor) ?? theme.colorScheme.surface;
  final resolvedBorderColor = badgeTheme?.borderColor ?? _parseColorString(badge.borderColor);
  final resolvedTextColor = badgeTheme?.textColor ?? _parseColorString(badge.textColor) ?? theme.colorScheme.onSurface;
  final resolvedIconScale = badgeTheme?.iconScale ?? 0.4;

    Widget badgeWidget = Container(
      width: resolvedWidth,
      height: resolvedHeight,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: resolvedBorderRadius,
        boxShadow: resolvedElevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: resolvedElevation * 2,
                  offset: Offset(0, resolvedElevation),
                ),
              ]
            : null,
  border: resolvedBorderColor != null ? Border.all(color: resolvedBorderColor) : null,
      ),
      child: ClipRRect(
        borderRadius: resolvedBorderRadius,
  child: _buildBadgeContent(theme, resolvedTextColor, resolvedIconScale),
      ),
    );

    // Add hover animation if enabled
    if (resolvedAnimateOnHover) {
      badgeWidget = MouseRegion(
        cursor:
            onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: badgeWidget,
        ),
      );
    }

    // Add tap functionality
    if (onTap != null) {
      badgeWidget = GestureDetector(
        onTap: onTap,
        child: badgeWidget,
      );
    }

    // Add tooltip if enabled
  if (resolvedShowTooltip && badge.description?.isNotEmpty == true) {
      badgeWidget = Tooltip(
        message: badge.description!,
        child: badgeWidget,
      );
    }

    return badgeWidget;
  }

  Widget _buildBadgeContent(ThemeData theme, Color textColor, double iconScale) {
    if (badge.imageUrl.isNotEmpty) {
      return Image.network(
        badge.imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackBadge(theme, textColor, iconScale),
      );
    }

    return _buildFallbackBadge(theme, textColor, iconScale);
  }

  Widget _buildFallbackBadge(ThemeData theme, Color textColor, double iconScale) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getBadgeIcon(),
            color: textColor,
            size: (customSize?.height ?? badge.height ?? 40) * iconScale,
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              badge.name ?? badge.altText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBadgeIcon() {
    switch (badge.type?.toLowerCase() ?? '') {
      case 'ssl':
      case 'security':
        return Icons.security;
      case 'payment':
        return Icons.payment;
      case 'shipping':
        return Icons.local_shipping;
      case 'return':
      case 'returns':
        return Icons.assignment_return;
      case 'guarantee':
      case 'warranty':
        return Icons.verified_user;
      case 'satisfaction':
        return Icons.thumb_up;
      case 'quality':
        return Icons.star;
      case 'certification':
        return Icons.verified;
      case 'privacy':
        return Icons.privacy_tip;
      case 'eco':
      case 'environmental':
        return Icons.eco;
      default:
        return Icons.verified;
    }
  }

  }

  

/// A widget for displaying multiple trust badges in a layout
class TrustBadgeCollection extends StatelessWidget {
  const TrustBadgeCollection({
    super.key,
    required this.badges,
    this.onBadgeTap,
    this.layout = BadgeLayout.horizontal,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.maxItemsPerRow,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.showTitle = false,
    this.title = 'Trusted by',
  
  });

  /// List of badges to display
  final List<BadgeModel> badges;

  /// Callback when a badge is tapped
  final Function(BadgeModel badge)? onBadgeTap;

  /// Layout style for badges
  final BadgeLayout layout;

  /// Spacing between badges
  final double spacing;

  /// Run spacing for wrap layout
  final double runSpacing;

  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;

  /// Maximum items per row (for wrap layout)
  final int? maxItemsPerRow;

  /// Background color
  final Color? backgroundColor;

  /// Internal padding
  final EdgeInsets? padding;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Whether to show collection title
  final bool showTitle;

  /// Collection title text
  final String title;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (badges.isEmpty) return const SizedBox.shrink();

    final shopTheme = theme.extension<ShopKitTheme>();
    final collectionTheme = shopTheme?.trustBadgeTheme;

    final resolvedSpacing = spacing;
    final resolvedRunSpacing = runSpacing;
    final resolvedShowTitle = showTitle;
    final resolvedTitle = title;
    final resolvedPadding = padding ?? collectionTheme?.padding ?? const EdgeInsets.all(16);
    final resolvedBg = backgroundColor ?? collectionTheme?.backgroundColor ?? Colors.transparent;
    final resolvedRadius = borderRadius ?? collectionTheme?.borderRadius ?? BorderRadius.circular(8);

    return Container(
      padding: resolvedPadding,
      decoration: resolvedBg != Colors.transparent
          ? BoxDecoration(
              color: resolvedBg,
              borderRadius: resolvedRadius,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (resolvedShowTitle) ...[
            Text(
              resolvedTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: resolvedSpacing),
          ],
      _buildBadgeLayout(resolvedSpacing, resolvedRunSpacing),
        ],
      ),
    );
  }

  Widget _buildBadgeLayout(double spacingOverride, double runSpacingOverride) {
    switch (layout) {
      case BadgeLayout.horizontal:
    return _buildHorizontalLayout(spacingOverride);
      case BadgeLayout.vertical:
    return _buildVerticalLayout(spacingOverride);
      case BadgeLayout.grid:
    return _buildGridLayout(spacingOverride, runSpacingOverride);
      case BadgeLayout.wrap:
    return _buildWrapLayout(spacingOverride, runSpacingOverride);
    }
  }

  Widget _buildHorizontalLayout(double spacingValue) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: badges.asMap().entries.map((entry) {
          final index = entry.key;
          final badge = entry.value;
          return Padding(
            padding: EdgeInsets.only(
        right: index < badges.length - 1 ? spacingValue : 0,
            ),
            child: TrustBadge(
              badge: badge,
              onTap: onBadgeTap != null ? () => onBadgeTap!(badge) : null,
        
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalLayout(double spacingValue) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: badges.asMap().entries.map((entry) {
        final index = entry.key;
        final badge = entry.value;
        return Padding(
          padding: EdgeInsets.only(
      bottom: index < badges.length - 1 ? spacingValue : 0,
          ),
          child: TrustBadge(
            badge: badge,
            onTap: onBadgeTap != null ? () => onBadgeTap!(badge) : null,
                
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGridLayout(double spacingValue, double runSpacingValue) {
    const crossAxisCount = 2;
    final itemCount = badges.length;
    final rowCount = (itemCount / crossAxisCount).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        final startIndex = rowIndex * crossAxisCount;
        final endIndex = (startIndex + crossAxisCount).clamp(0, itemCount);
        final rowBadges = badges.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(
      bottom: rowIndex < rowCount - 1 ? runSpacingValue : 0,
          ),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: rowBadges.asMap().entries.map((entry) {
              final index = entry.key;
              final badge = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
          right: index < rowBadges.length - 1 ? spacingValue : 0,
                  ),
                  child: TrustBadge(
                    badge: badge,
                    onTap: onBadgeTap != null ? () => onBadgeTap!(badge) : null,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildWrapLayout(double spacingValue, double runSpacingValue) {
    return Wrap(
    spacing: spacingValue,
    runSpacing: runSpacingValue,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: badges.map((badge) {
        return TrustBadge(
          badge: badge,
          onTap: onBadgeTap != null ? () => onBadgeTap!(badge) : null,
              
        );
      }).toList(),
    );
  }

  
}

/// Layout options for badge collections
enum BadgeLayout {
  horizontal,
  vertical,
  grid,
  wrap,
}

/// Preset trust badge configurations for common e-commerce scenarios
class TrustBadgePresets {
  static List<BadgeModel> get ecommerceBasic => [
        const BadgeModel(
          id: 'ssl',
          url: 'https://example.com/ssl-badge.png',
          altText: 'SSL Secure',
          width: 80,
          height: 40,
        ),
        const BadgeModel(
          id: 'money_back',
          url: 'https://example.com/money-back-badge.png',
          altText: '30-Day Returns',
          width: 80,
          height: 40,
        ),
        const BadgeModel(
          id: 'free_shipping',
          url: 'https://example.com/free-shipping-badge.png',
          altText: 'Free Shipping',
          width: 80,
          height: 40,
        ),
      ];

  static List<BadgeModel> get paymentSecurity => [
        const BadgeModel(
          id: 'payment_secure',
          url: 'https://example.com/secure-payment-badge.png',
          altText: 'Secure Payment',
          width: 100,
          height: 50,
        ),
        const BadgeModel(
          id: 'ssl',
          url: 'https://example.com/ssl-certificate-badge.png',
          altText: 'SSL Certificate',
          width: 100,
          height: 50,
        ),
        const BadgeModel(
          id: 'privacy',
          url: 'https://example.com/privacy-badge.png',
          altText: 'Privacy Protected',
          width: 100,
          height: 50,
        ),
      ];

  static List<BadgeModel> get qualityAssurance => [
        const BadgeModel(
          id: 'quality',
          url: 'https://example.com/quality-badge.png',
          altText: 'Premium Quality',
          width: 90,
          height: 45,
        ),
        const BadgeModel(
          id: 'satisfaction',
          url: 'https://example.com/satisfaction-badge.png',
          altText: 'Satisfaction Guaranteed',
          width: 90,
          height: 45,
        ),
        const BadgeModel(
          id: 'warranty',
          url: 'https://example.com/warranty-badge.png',
          altText: '1-Year Warranty',
          width: 90,
          height: 45,
        ),
      ];
}
