import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/share_model.dart';

/// A widget for sharing content on social media platforms
class SocialShare extends StatefulWidget {
  const SocialShare({
    super.key,
    required this.shareModel,
    this.onShare,
    this.onCopyLink,
    this.showLabels = true,
    this.iconSize = 40.0,
    this.spacing = 12.0,
    this.direction = Axis.horizontal,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.enabledPlatforms,
    this.customPlatforms = const [],
  });

  /// Share model containing content and URLs
  final ShareModel shareModel;

  /// Callback when share is initiated
  final Function(String platform, String url)? onShare;

  /// Callback when copy link is tapped
  final VoidCallback? onCopyLink;

  /// Whether to show platform labels
  final bool showLabels;

  /// Size of platform icons
  final double iconSize;

  /// Spacing between platform buttons
  final double spacing;

  /// Layout direction
  final Axis direction;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// List of enabled platforms (null = all enabled)
  final List<String>? enabledPlatforms;

  /// Custom platform configurations
  final List<SocialPlatform> customPlatforms;

  @override
  State<SocialShare> createState() => _SocialShareState();
}

class _SocialShareState extends State<SocialShare>
    with TickerProviderStateMixin {
  bool _showCopiedMessage = false;
  late AnimationController _copiedAnimationController;
  late Animation<double> _copiedFadeAnimation;

  @override
  void initState() {
    super.initState();

    _copiedAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _copiedFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _copiedAnimationController,
      curve: const Interval(0.0, 0.3),
    ));
  }

  @override
  void dispose() {
    _copiedAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.share,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Share this ${widget.shareModel.type}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Copy link button with animation
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.link),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                    tooltip: 'Copy link',
                  ),
                  if (_showCopiedMessage)
                    AnimatedBuilder(
                      animation: _copiedAnimationController,
                      builder: (context, child) {
                        return Positioned(
                          top: -30,
                          child: Opacity(
                            opacity: _copiedFadeAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.inverseSurface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Copied!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onInverseSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Platform buttons
          if (widget.direction == Axis.horizontal)
            _buildHorizontalPlatforms(theme)
          else
            _buildVerticalPlatforms(theme),
        ],
      ),
    );
  }

  Widget _buildHorizontalPlatforms(ThemeData theme) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.spacing,
      children: _getPlatforms().map((platform) {
        return _buildPlatformButton(platform, theme);
      }).toList(),
    );
  }

  Widget _buildVerticalPlatforms(ThemeData theme) {
    return Column(
      children: _getPlatforms().map((platform) {
        return Padding(
          padding: EdgeInsets.only(bottom: widget.spacing),
          child: _buildPlatformButton(platform, theme, isVertical: true),
        );
      }).toList(),
    );
  }

  Widget _buildPlatformButton(
    SocialPlatform platform,
    ThemeData theme, {
    bool isVertical = false,
  }) {
    return InkWell(
      onTap: () => _shareToPlatform(platform),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(isVertical ? 12 : 8),
        decoration: BoxDecoration(
          color: platform.color?.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: platform.color?.withValues(alpha: 0.3) ??
                theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: isVertical
            ? Row(
                children: [
                  _buildPlatformIcon(platform, theme),
                  if (widget.showLabels) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        platform.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPlatformIcon(platform, theme),
                  if (widget.showLabels) ...[
                    const SizedBox(height: 4),
                    Text(
                      platform.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildPlatformIcon(SocialPlatform platform, ThemeData theme) {
    if (platform.icon != null) {
      return Icon(
        platform.icon,
        size: widget.iconSize * 0.6,
        color: platform.color ?? theme.colorScheme.primary,
      );
    }

    if (platform.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          platform.imageUrl!,
          width: widget.iconSize * 0.6,
          height: widget.iconSize * 0.6,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.share,
            size: widget.iconSize * 0.6,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      width: widget.iconSize * 0.6,
      height: widget.iconSize * 0.6,
      decoration: BoxDecoration(
        color: platform.color ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          platform.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.iconSize * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<SocialPlatform> _getPlatforms() {
    final defaultPlatforms = [
      const SocialPlatform(
        id: 'facebook',
        name: 'Facebook',
        icon: Icons.facebook,
        color: Color(0xFF1877F2),
      ),
      const SocialPlatform(
        id: 'twitter',
        name: 'Twitter',
        icon: Icons.close, // Would use Twitter icon if available
        color: Color(0xFF1DA1F2),
      ),
      const SocialPlatform(
        id: 'instagram',
        name: 'Instagram',
        icon: Icons.camera_alt,
        color: Color(0xFFE4405F),
      ),
      const SocialPlatform(
        id: 'linkedin',
        name: 'LinkedIn',
        icon: Icons.business,
        color: Color(0xFF0A66C2),
      ),
      const SocialPlatform(
        id: 'whatsapp',
        name: 'WhatsApp',
        icon: Icons.message,
        color: Color(0xFF25D366),
      ),
      const SocialPlatform(
        id: 'pinterest',
        name: 'Pinterest',
        icon: Icons.push_pin,
        color: Color(0xFFBD081C),
      ),
      const SocialPlatform(
        id: 'email',
        name: 'Email',
        icon: Icons.email,
        color: Color(0xFF34495E),
      ),
    ];

    // Add custom platforms
    final allPlatforms = [...defaultPlatforms, ...widget.customPlatforms];

    // Filter by enabled platforms if specified
    if (widget.enabledPlatforms != null) {
      return allPlatforms.where((platform) {
        return widget.enabledPlatforms!.contains(platform.id);
      }).toList();
    }

    return allPlatforms;
  }

  void _shareToPlatform(SocialPlatform platform) {
    final shareUrl = widget.shareModel.generateShareUrl();

    widget.onShare?.call(platform.id, shareUrl);

    // Show feedback
    _showShareFeedback(platform.name);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.shareModel.url));

    widget.onCopyLink?.call();

    // Show copied animation
    setState(() {
      _showCopiedMessage = true;
    });

    _copiedAnimationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _copiedAnimationController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _showCopiedMessage = false;
              });
            }
          });
        }
      });
    });
  }

  void _showShareFeedback(String platformName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shared to $platformName'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Social media platform configuration
class SocialPlatform {
  const SocialPlatform({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    this.color,
  });

  /// Platform identifier
  final String id;

  /// Display name
  final String name;

  /// Platform icon
  final IconData? icon;

  /// Platform image URL
  final String? imageUrl;

  /// Platform brand color
  final Color? color;
}

/// Quick access widget for common sharing scenarios
class QuickShareButton extends StatelessWidget {
  const QuickShareButton({
    super.key,
    required this.shareModel,
    this.platforms = const ['facebook', 'twitter', 'whatsapp'],
    this.onShare,
    this.icon = Icons.share,
    this.label = 'Share',
    this.showLabel = true,
  });

  /// Share model
  final ShareModel shareModel;

  /// Platforms to include in quick share
  final List<String> platforms;

  /// Share callback
  final Function(String platform, String url)? onShare;

  /// Button icon
  final IconData icon;

  /// Button label
  final String label;

  /// Whether to show label
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(icon),
      tooltip: label,
      onSelected: (platform) {
        final shareUrl = shareModel.generateShareUrl();
        onShare?.call(platform, shareUrl);
      },
      itemBuilder: (context) {
        return platforms.map((platform) {
          return PopupMenuItem<String>(
            value: platform,
            child: Row(
              children: [
                _getPlatformIcon(platform),
                const SizedBox(width: 12),
                Text(_getPlatformName(platform)),
              ],
            ),
          );
        }).toList();
      },
      child: showLabel
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(label),
              ],
            )
          : null,
    );
  }

  Widget _getPlatformIcon(String platform) {
    switch (platform) {
      case 'facebook':
        return const Icon(Icons.facebook, color: Color(0xFF1877F2));
      case 'twitter':
        return const Icon(Icons.close,
            color: Color(0xFF1DA1F2)); // Twitter icon
      case 'whatsapp':
        return const Icon(Icons.message, color: Color(0xFF25D366));
      case 'linkedin':
        return const Icon(Icons.business, color: Color(0xFF0A66C2));
      case 'email':
        return const Icon(Icons.email, color: Color(0xFF34495E));
      default:
        return const Icon(Icons.share);
    }
  }

  String _getPlatformName(String platform) {
    switch (platform) {
      case 'facebook':
        return 'Facebook';
      case 'twitter':
        return 'Twitter';
      case 'whatsapp':
        return 'WhatsApp';
      case 'linkedin':
        return 'LinkedIn';
      case 'email':
        return 'Email';
      default:
        return platform;
    }
  }
}
