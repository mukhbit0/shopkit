import 'package:flutter/material.dart';
import '../../models/announcement_model.dart';
import '../../theme/theme.dart';

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

  // NOTE: Legacy flexible config & themeStyle removed. Use ShopKitTheme.announcementBarTheme.

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

  final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
  final animMs = widget.animationDuration?.inMilliseconds ?? shopKitTheme?.animations.normal.inMilliseconds ?? 300;

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
    final autoHideMs = widget.autoHideDuration?.inMilliseconds ??
      (widget.announcement.autoHideDuration != null
        ? widget.announcement.autoHideDuration! * 1000
        : 5000);
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
    final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();
    final compTheme = shopKitTheme?.announcementBarTheme;
    final backgroundColor = widget.backgroundColor ?? compTheme?.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final textColor = widget.textColor ?? compTheme?.textStyle?.color ?? Theme.of(context).colorScheme.onPrimary;
    final height = widget.height ?? compTheme?.height ?? 48.0;
    return _buildAnnouncementContainer(context, backgroundColor, textColor, shopKitTheme?.radii.md.toDouble() ?? 12.0, height: height);
  }
  Widget _buildAnnouncementContainer(BuildContext context, Color backgroundColor, Color textColor, double borderRadius, {required double height}) {
    final showClose = widget.showCloseButton ?? widget.announcement.isDismissible;

    if (!widget.announcement.isActive || !_isVisible) {
      return const SizedBox.shrink();
    }

    final bar = SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
  constraints: BoxConstraints(minHeight: height),
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
