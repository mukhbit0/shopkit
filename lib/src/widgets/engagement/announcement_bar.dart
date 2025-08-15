import 'package:flutter/material.dart';
import '../../models/announcement_model.dart';
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
    this.textStyle,
    this.maxLines,
    this.addBottomMargin = false,
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

  /// Custom text style for the announcement message
  final TextStyle? textStyle;

  /// Maximum lines for the announcement text
  final int? maxLines;

  /// Whether to add bottom margin after the announcement
  final bool addBottomMargin;

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

  @override
  Widget build(BuildContext context) {
    // Use modern theming when available
    if (widget.themeStyle != null) {
      final style = ShopKitThemeStyleExtension.fromString(widget.themeStyle!);
      final themeConfig = ShopKitThemeConfig.forStyle(style, context);
      return _buildThemedAnnouncement(context, themeConfig);
    }
    
    // Simple fallback to Flutter theme
    return _buildSimpleAnnouncement(context);
  }

  Widget _buildThemedAnnouncement(BuildContext context, ShopKitThemeConfig themeConfig) {
    final backgroundColor = widget.backgroundColor ?? 
        (themeConfig.primaryColor ?? Theme.of(context).colorScheme.primary);
    final textColor = widget.textColor ?? 
        (themeConfig.onPrimaryColor ?? Colors.white);
    
    return _buildAnnouncementContainer(
      context, 
      backgroundColor, 
      textColor, 
      themeConfig.borderRadius
    );
  }

  Widget _buildSimpleAnnouncement(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final textColor = widget.textColor ?? theme.colorScheme.onPrimary;
    
    return _buildAnnouncementContainer(context, backgroundColor, textColor, 8.0);
  }

  Widget _buildAnnouncementContainer(BuildContext context, Color backgroundColor, Color textColor, double borderRadius) {
    final showClose = widget.showCloseButton ?? widget.announcement.isDismissible;

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
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius * 0.6),
          boxShadow: [
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      ),
                    )
                  else
                    Icon(
                      _getIconData(widget.announcement.iconUrl!),
                      color: textColor,
                      size: 20,
                    ),
                  const SizedBox(width: 12),
                ],
                // Text content
                Expanded(
                  child: Text(
                    widget.announcement.message,
                    style: widget.textStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: widget.maxLines ?? 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Close button
                if (showClose) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close,
                      color: textColor.withValues(alpha: 0.8),
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return widget.position == AnnouncementPosition.top
        ? Column(
            children: [
              bar,
              if (widget.addBottomMargin) const SizedBox(height: 8),
            ],
          )
        : Column(
            children: [
              if (widget.addBottomMargin) const SizedBox(height: 8),
              bar,
            ],
          );
  }

  IconData _getIconData(String iconString) {
    // Simple icon mapping - can be expanded
    switch (iconString.toLowerCase()) {
      case 'info':
        return Icons.info_outline;
      case 'warning':
        return Icons.warning_outlined;
      case 'error':
        return Icons.error_outline;
      case 'success':
        return Icons.check_circle_outline;
      default:
        return Icons.announcement;
    }
  }
}
