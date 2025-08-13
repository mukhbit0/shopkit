import 'package:flutter/material.dart';
import '../../models/popup_model.dart';

/// A widget that displays an exit intent popup when user attempts to leave
class ExitIntentPopup extends StatefulWidget {
  const ExitIntentPopup({
    super.key,
    required this.popup,
    this.onClose,
    this.onAction,
    this.onSecondaryAction,
    this.autoCloseAfter,
    this.blurBackground = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.child,
  });

  /// Popup configuration
  final PopupModel popup;

  /// Callback when popup is closed
  final VoidCallback? onClose;

  /// Callback for primary action button
  final VoidCallback? onAction;

  /// Callback for secondary action button
  final VoidCallback? onSecondaryAction;

  /// Auto close popup after duration
  final Duration? autoCloseAfter;

  /// Whether to blur background
  final bool blurBackground;

  /// Animation duration
  final Duration animationDuration;

  /// Child widget to wrap (typically the main app content)
  final Widget? child;

  @override
  State<ExitIntentPopup> createState() => _ExitIntentPopupState();
}

class _ExitIntentPopupState extends State<ExitIntentPopup>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  bool _hasShown = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Auto close if specified
    if (widget.autoCloseAfter != null) {
      Future.delayed(widget.autoCloseAfter!, () {
        if (mounted && _isVisible) {
          _hidePopup();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Convert hex string to Color
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;
    try {
      if (colorString.startsWith('#')) {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Color(int.parse(colorString, radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (_) => _handleExitIntent(),
      child: Stack(
        children: [
          if (widget.child != null) widget.child!,
          if (_isVisible)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildPopupContent(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPopupContent() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 600,
      ),
      decoration: BoxDecoration(
        color: _parseColor(widget.popup.backgroundColor) ??
            theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.popup.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _parseColor(widget.popup.textColor) ??
                          theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _hidePopup,
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Image if provided
                  if (widget.popup.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.popup.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          width: double.infinity,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Headline
                  if (widget.popup.headline != null) ...[
                    Text(
                      widget.popup.headline!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _parseColor(widget.popup.textColor) ??
                            theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Content
                  Text(
                    widget.popup.content ?? widget.popup.message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _parseColor(widget.popup.textColor) ??
                          theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Discount/Offer highlight
                  if (widget.popup.discount != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '${widget.popup.discount}% OFF',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],

                  // Urgency timer if provided
                  if (widget.popup.urgencyTimer != null) ...[
                    const SizedBox(height: 20),
                    _buildUrgencyTimer(theme),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Primary button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onAction?.call();
                      _hidePopup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _parseColor(widget.popup.buttonColor) ??
                          theme.colorScheme.primary,
                      foregroundColor:
                          _parseColor(widget.popup.buttonTextColor) ??
                              theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.popup.buttonText ?? 'Claim Offer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Secondary button
                if (widget.popup.secondaryButtonText != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        widget.onSecondaryAction?.call();
                        _hidePopup();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.popup.secondaryButtonText!,
                        style: TextStyle(
                          color: _parseColor(widget.popup.textColor)
                                  ?.withValues(alpha: 0.7) ??
                              theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyTimer(ThemeData theme) {
    // If urgencyTimer is not enabled, don't show timer
    if (widget.popup.urgencyTimer != true) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DateTime>(
      stream:
          Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = DateTime.now();
        // Create a fixed 24-hour countdown from when popup is shown
        final targetTime = now.add(const Duration(hours: 24));
        final timeLeft = targetTime.difference(now);

        if (timeLeft.isNegative) {
          return const SizedBox.shrink();
        }

        final hours = timeLeft.inHours.remainder(24);
        final minutes = timeLeft.inMinutes.remainder(60);
        final seconds = timeLeft.inSeconds.remainder(60);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(
                'Limited Time Offer Expires In:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeBlock(
                      hours.toString().padLeft(2, '0'), 'HOURS', theme),
                  _buildTimeBlock(
                      minutes.toString().padLeft(2, '0'), 'MINS', theme),
                  _buildTimeBlock(
                      seconds.toString().padLeft(2, '0'), 'SECS', theme),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeBlock(String value, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.red[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _handleExitIntent() {
    if (!_hasShown && !_isVisible && _shouldShowPopup()) {
      _showPopup();
    }
  }

  bool _shouldShowPopup() {
    final now = DateTime.now();

    // Check if we're within the display period
    if (widget.popup.startDate != null &&
        now.isBefore(widget.popup.startDate!)) {
      return false;
    }

    if (widget.popup.endDate != null && now.isAfter(widget.popup.endDate!)) {
      return false;
    }

    // Check trigger conditions based on popup type
    switch (widget.popup.type) {
      case PopupType.exitIntent:
        return true; // Already triggered by exit intent
      case PopupType.timeDelay:
        // This would need additional timing logic
        return false;
      case PopupType.scrollPercentage:
        // This would need scroll position tracking
        return false;
      case PopupType.pageVisit:
        // This would need page view tracking
        return false;
      case PopupType.cartAbandonment:
        // This would need cart tracking
        return false;
      case PopupType.promotion:
      case PopupType.newsletter:
        // Default behavior for other popup types
        return false;
    }
  }

  void _showPopup() {
    if (!mounted) return;

    setState(() {
      _isVisible = true;
      _hasShown = true;
    });

    _animationController.forward();
  }

  void _hidePopup() {
    if (!mounted) return;

    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        widget.onClose?.call();
      }
    });
  }
}

/// Utility class for managing exit intent detection
class ExitIntentDetector {
  static bool _isEnabled = true;
  static final Set<String> _shownPopups = <String>{};

  /// Enable/disable exit intent detection globally
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Check if exit intent detection is enabled
  static bool get isEnabled => _isEnabled;

  /// Mark a popup as shown to prevent duplicate displays
  static void markAsShown(String popupId) {
    _shownPopups.add(popupId);
  }

  /// Check if a popup has been shown
  static bool hasBeenShown(String popupId) {
    return _shownPopups.contains(popupId);
  }

  /// Clear shown popup history
  static void clearHistory() {
    _shownPopups.clear();
  }

  /// Reset specific popup to allow it to be shown again
  static void resetPopup(String popupId) {
    _shownPopups.remove(popupId);
  }
}
