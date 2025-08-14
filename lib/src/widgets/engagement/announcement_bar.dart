import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/announcement_model.dart';
import '../../theme/ecommerce_theme.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme_styles.dart';

/// Position options for announcement bar
enum AnnouncementPosition {
  top,
  bottom,
}

/// A customizable announcement bar for promotions and notifications
class AnnouncementBar extends StatefulWidget {
  const AnnouncementBar({
    super.key,
    required this.announcement,
    this.onActionTap,
    this.onDismiss,
    this.position = AnnouncementPosition.top,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.actionColor,
    this.closeColor,
    this.showCloseButton,
    this.animationDuration,
    this.autoHide = false,
    this.autoHideDuration,
  this.config,
  this.themeStyle,
  });

  /// Announcement data to display
  final AnnouncementModel announcement;

  /// Callback when action button is tapped
  final VoidCallback? onActionTap;

  /// Callback when announcement is dismissed
  final VoidCallback? onDismiss;

  /// Position of the announcement bar
  final AnnouncementPosition position;

  /// Custom height
  final double? height;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Custom action button color
  final Color? actionColor;

  /// Custom close button color
  final Color? closeColor;

  /// Whether to show close button (overrides announcement.isDismissible)
  final bool? showCloseButton;

  /// Custom animation duration
  final Duration? animationDuration;

  /// Whether to auto-hide the announcement
  final bool autoHide;

  /// Duration before auto-hiding
  final Duration? autoHideDuration;

  /// Optional flexible config (overrides individual params when provided)
  final FlexibleWidgetConfig? config;

  /// Built-in theme style support - pass theme name as string. When provided
  /// the new ShopKitThemeConfig system styles the bar and overrides legacy
  /// color fallback logic (unless explicit colors are passed in props).
  final String? themeStyle;

  @override
  State<AnnouncementBar> createState() => _AnnouncementBarState();
}

class _AnnouncementBarState extends State<AnnouncementBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    final cfg = widget.config ?? FlexibleWidgetConfig.forWidget(
      'announcement_bar',
      context: context,
      overrides: {
        if (widget.animationDuration != null)
          'animationDuration': widget.animationDuration!.inMilliseconds,
        if (widget.height != null) 'height': widget.height,
      },
    );

    final animMs = cfg.get<int>('animationDuration', 300);

    _animationController = AnimationController(
      duration: Duration(milliseconds: animMs),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.position == AnnouncementPosition.top
          ? const Offset(0, -1)
          : const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation
    _animationController.forward();

    // Auto-hide if enabled
    if (widget.autoHide || widget.announcement.autoHide) {
      final cfg = widget.config;
      final autoHideMs = widget.autoHideDuration?.inMilliseconds ??
          (widget.announcement.autoHideDuration != null
              ? widget.announcement.autoHideDuration! * 1000
              : (cfg?.get<int>('autoHideDuration', 5000) ?? 5000));
      Future.delayed(Duration(milliseconds: autoHideMs), _dismiss);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!_isVisible) return;

    setState(() {
      _isVisible = false;
    });

    await _animationController.reverse();
    widget.onDismiss?.call();
  }

  Color _getBackgroundColor(ECommerceTheme theme) {
  final cfg = widget.config; // Access legacy flexible widget config if provided.
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    if (cfg?.has('backgroundColor') == true) {
      final dynamic val = cfg!.get<dynamic>('backgroundColor');
      if (val is Color) return val;
    }
    if (widget.announcement.backgroundColor != null) {
      return _parseColor(widget.announcement.backgroundColor!) ?? theme.primaryColor;
    }

    switch (widget.announcement.type) {
      case AnnouncementType.promotion:
      case AnnouncementType.sale:
        return theme.primaryColor;
      case AnnouncementType.newProduct:
        return theme.successColor;
      case AnnouncementType.shipping:
        return theme.secondaryColor;
      case AnnouncementType.maintenance:
        return theme.warningColor;
      case AnnouncementType.holiday:
        return const Color(0xFF8B5CF6); // Purple
      case AnnouncementType.general:
        return theme.onSurfaceColor;
    }
  }

  Color _getTextColor(ECommerceTheme theme) {
  final cfg = widget.config;
    if (widget.textColor != null) return widget.textColor!;
    if (cfg?.has('textColor') == true) {
      final dynamic val = cfg!.get<dynamic>('textColor');
      if (val is Color) return val;
    }
    if (widget.announcement.textColor != null) {
      return _parseColor(widget.announcement.textColor!) ?? Colors.white;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final legacyTheme = context.ecommerceTheme;
    final useNewTheme = widget.themeStyle != null;
    ShopKitThemeConfig? themeCfg;
    if (useNewTheme) {
      final style = ShopKitThemeStyleExtension.fromString(widget.themeStyle!);
      themeCfg = ShopKitThemeConfig.forStyle(style, context);
    }
  final backgroundColor = useNewTheme
    ? (widget.backgroundColor ?? (themeCfg!.primaryColor ?? Theme.of(context).colorScheme.primary))
    : _getBackgroundColor(legacyTheme);
  final textColor = useNewTheme
    ? (widget.textColor ?? (themeCfg!.onPrimaryColor ?? Colors.white))
    : _getTextColor(legacyTheme);
    final showClose =
        widget.showCloseButton ?? widget.announcement.isDismissible;

    if (!widget.announcement.isActive || !_isVisible) {
      return const SizedBox.shrink();
    }

  final bar = SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
      minHeight: widget.height ?? 48,
        ),
        decoration: BoxDecoration(
      color: useNewTheme && (themeCfg?.enableBlur ?? false)
              ? backgroundColor.withValues(alpha: 0.85)
              : backgroundColor,
      gradient: useNewTheme && (themeCfg?.enableGradients ?? false)
              ? LinearGradient(
                  colors: [
                    backgroundColor.withValues(alpha: 0.95),
                    backgroundColor.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
      borderRadius: useNewTheme
        ? BorderRadius.circular((themeCfg?.borderRadius ?? 16) * 0.6)
              : null,
      border: useNewTheme && (themeCfg?.enableGradients ?? false)
              ? Border.all(
          color: (themeCfg?.primaryColor ?? backgroundColor)
                      .withValues(alpha: 0.25),
                )
              : null,
      boxShadow: useNewTheme && (themeCfg?.enableShadows ?? false)
              ? [
                  BoxShadow(
          color: (themeCfg?.shadowColor ?? Colors.black)
                        .withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: widget.position == AnnouncementPosition.top
                        ? const Offset(0, 2)
                        : const Offset(0, -2),
                  ),
                ],
        ),
        child: SafeArea(
          top: widget.position == AnnouncementPosition.top,
          bottom: widget.position == AnnouncementPosition.bottom,
          child: Padding(
            padding: EdgeInsets.symmetric(
        horizontal: useNewTheme ? 16 : legacyTheme.spacing,
        vertical: useNewTheme ? 10 : legacyTheme.spacing * 0.5,
            ),
            child: Row(
              children: [
                // Icon
                if (widget.announcement.hasIcon) ...[
                  if (widget.announcement.iconUrl!.startsWith('http'))
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.network(
                        widget.announcement.iconUrl!,
                        color: textColor,
                        errorBuilder: (context, error, stackTrace) => Text(
                          widget.announcement.type.icon,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Text(
                      widget.announcement.iconUrl ??
                          widget.announcement.type.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(width: 12),
                ],

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        widget.announcement.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Message
                      if (widget.announcement.message.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.announcement.message,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Action Button
                if (widget.announcement.hasAction) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: widget.onActionTap,
            child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (widget.actionColor ?? textColor)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                useNewTheme ? (themeCfg?.borderRadius ?? 16) * 0.4 : 16),
                        border: useNewTheme
                            ? Border.all(
                  color: (themeCfg?.primaryColor ?? textColor)
                                    .withValues(alpha: 0.3),
                              )
                            : null,
                      ),
                      child: Text(
                        widget.announcement.actionText!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: widget.actionColor ?? textColor,
                        ),
                      ),
                    ),
                  ),
                ],

                // Close Button
                if (showClose) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color:
                          widget.closeColor ?? textColor.withValues(alpha: 0.8),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

  if (useNewTheme && (themeCfg?.enableBlur ?? false)) {
      return ClipRRect(
        borderRadius:
      BorderRadius.circular((themeCfg?.borderRadius ?? 16) * 0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: bar,
        ),
      );
    }
    return bar;
  }

  Color? _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      } else if (colorString.startsWith('0x')) {
        return Color(int.parse(colorString));
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }
}
