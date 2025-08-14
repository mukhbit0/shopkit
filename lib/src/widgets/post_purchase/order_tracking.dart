import 'package:flutter/material.dart';
import '../../config/flexible_widget_config.dart';
import '../../models/order_model.dart';

/// A widget for displaying order tracking information
class OrderTracking extends StatefulWidget {
  const OrderTracking({
    super.key,
    required this.order,
    this.onTrackingNumberTap,
    this.onContactSupport,
    this.showTrackingNumber = true,
    this.showEstimatedDelivery = true,
    this.showTrackingUpdates = true,
    this.showOrderSummary = true,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  this.flexibleConfig,
  });

  /// Order to track
  final OrderModel order;

  /// Callback when tracking number is tapped
  final ValueChanged<String>? onTrackingNumberTap;

  /// Callback when contact support is tapped
  final VoidCallback? onContactSupport;

  /// Whether to show tracking number
  final bool showTrackingNumber;

  /// Whether to show estimated delivery
  final bool showEstimatedDelivery;

  /// Whether to show tracking updates timeline
  final bool showTrackingUpdates;

  /// Whether to show order summary
  final bool showOrderSummary;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;
  /// Flexible configuration (orderTracking.* keys)
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    T _cfg<T>(String key, T fallback) {
      final fc = widget.flexibleConfig;
      if (fc != null) {
        if (fc.has('orderTracking.' + key)) { try { return fc.get<T>('orderTracking.' + key, fallback); } catch (_) {} }
        if (fc.has(key)) { try { return fc.get<T>(key, fallback); } catch (_) {} }
      }
      return fallback;
    }

    final showTracking = _cfg<bool>('showTrackingNumber', widget.showTrackingNumber);
    final showEta = _cfg<bool>('showEstimatedDelivery', widget.showEstimatedDelivery);
    final showTimeline = _cfg<bool>('showTrackingUpdates', widget.showTrackingUpdates);
    final showSummary = _cfg<bool>('showOrderSummary', widget.showOrderSummary);
    final resolvedPadding = _cfg<EdgeInsets>('padding', widget.padding ?? const EdgeInsets.all(16));
    final bgColor = _cfg<Color>('backgroundColor', widget.backgroundColor ?? colorScheme.surface);
    final radius = _cfg<BorderRadius>('borderRadius', widget.borderRadius ?? BorderRadius.circular(12));

    return Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme),

          const SizedBox(height: 16),

          // Status card
          _buildStatusCard(theme),

          const SizedBox(height: 16),

          // Tracking number
          if (showTracking && widget.order.trackingNumber != null) ...[
            _buildTrackingNumber(theme),
            const SizedBox(height: 16),
          ],

          // Estimated delivery
          if (showEta && widget.order.estimatedDelivery != null) ...[
            _buildEstimatedDelivery(theme),
            const SizedBox(height: 16),
          ],

          // Tracking timeline
          if (showTimeline && widget.order.trackingUpdates?.isNotEmpty == true) ...[
            _buildTrackingTimeline(theme),
            const SizedBox(height: 16),
          ],

          // Order summary
          if (showSummary) ...[
            _buildOrderSummary(theme),
            const SizedBox(height: 16),
          ],

          // Actions
          _buildActions(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Tracking',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order #${widget.order.id}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(theme),
      ],
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final status = widget.order.status;
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'processing':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'shipped':
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'delivered':
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'cancelled':
        backgroundColor = theme.colorScheme.errorContainer;
        textColor = theme.colorScheme.onErrorContainer;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
  final latestUpdate = widget.order.trackingUpdates?.isNotEmpty == true
    ? widget.order.trackingUpdates!.first
    : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(widget.order.status.toLowerCase()),
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.order.status}...',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (latestUpdate != null) ...[
                  Text(
                    _formatDateTime(latestUpdate.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                if (latestUpdate?.location != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        latestUpdate!.location!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingNumber(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tracking Number',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.order.trackingNumber!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onTrackingNumberTap != null)
            IconButton(
              onPressed: () =>
                  widget.onTrackingNumberTap!(widget.order.trackingNumber!),
              icon: const Icon(Icons.open_in_new, size: 20),
              tooltip: 'Track with carrier',
            ),
        ],
      ),
    );
  }

  Widget _buildEstimatedDelivery(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Delivery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.order.estimatedDelivery!
                      .toString()
                      .split(' ')[0], // Format as needed
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(ThemeData theme) {
    final updates = widget.order.trackingUpdates!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tracking Updates',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: updates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final update = updates[index];
            final isLatest = index == 0;

            return _buildTimelineItem(update, isLatest, theme);
          },
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
      TrackingUpdateModel update, bool isLatest, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isLatest
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            if (!isLatest)
              Container(
                width: 2,
                height: 24,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
          ],
        ),

        const SizedBox(width: 12),

        // Update content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                update.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isLatest ? FontWeight.w600 : null,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    _formatDateTime(update.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (update.location != null) ...[
                    Text(
                      ' • ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      update.location!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items (${widget.order.cart.items.length})'),
                  Text('\$${widget.order.cart.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              if (widget.order.cart.tax != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax'),
                    Text('\$${widget.order.cart.tax!.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              if (widget.order.cart.shipping != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shipping'),
                    Text(widget.order.cart.shipping! > 0
                        ? '\$${widget.order.cart.shipping!.toStringAsFixed(2)}'
                        : 'Free'),
                  ],
                ),
              ],
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text(
                    '\$${widget.order.cart.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Row(
      children: [
        if (widget.onContactSupport != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onContactSupport,
              icon: const Icon(Icons.support_agent, size: 18),
              label: const Text('Contact Support'),
            ),
          ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Icons.hourglass_empty;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }


  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}
