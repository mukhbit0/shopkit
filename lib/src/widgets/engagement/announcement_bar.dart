import 'package:flutter/material.dart';
import '../../models/announcement_model.dart';
import '../../theme/ecommerce_theme.dart';

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

    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
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
      final duration = widget.autoHideDuration ??
          (widget.announcement.autoHideDuration != null
              ? Duration(seconds: widget.announcement.autoHideDuration!)
              : const Duration(seconds: 5));

      Future.delayed(duration, _dismiss);
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
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    if (widget.announcement.backgroundColor != null) {
      return _parseColor(widget.announcement.backgroundColor!) ??
          theme.primaryColor;
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
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    if (widget.announcement.textColor != null) {
      return _parseColor(widget.announcement.textColor!) ?? Colors.white;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.ecommerceTheme;
    final backgroundColor = _getBackgroundColor(theme);
    final textColor = _getTextColor(theme);
    final showClose =
        widget.showCloseButton ?? widget.announcement.isDismissible;

    if (!widget.announcement.isActive || !_isVisible) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: widget.height ?? 48,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
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
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing,
              vertical: theme.spacing * 0.5,
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
                  TextButton(
                    onPressed: widget.onActionTap,
                    style: TextButton.styleFrom(
                      foregroundColor: widget.actionColor ?? textColor,
                      backgroundColor: textColor.withValues(alpha: 0.2),
                      minimumSize: const Size(60, 32),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.announcement.actionText!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
