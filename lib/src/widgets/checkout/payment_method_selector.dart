import 'package:flutter/material.dart';
import '../../models/payment_model.dart';
import '../../config/flexible_widget_config.dart';

/// A widget for selecting payment methods
class PaymentMethodSelector extends StatefulWidget {
  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    required this.onPaymentMethodSelected,
    this.selectedPaymentMethod,
    this.onAddPaymentMethod,
    this.showAddPaymentMethod = true,
    this.allowMultipleSelection = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.itemSpacing = 12.0,
  this.flexibleConfig,
  });

  /// List of available payment methods
  final List<PaymentMethodModel> paymentMethods;

  /// Callback when a payment method is selected
  final ValueChanged<PaymentMethodModel> onPaymentMethodSelected;

  /// Currently selected payment method
  final PaymentMethodModel? selectedPaymentMethod;

  /// Callback when add payment method is tapped
  final VoidCallback? onAddPaymentMethod;

  /// Whether to show add payment method button
  final bool showAddPaymentMethod;

  /// Whether to allow multiple payment method selection
  final bool allowMultipleSelection;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// Spacing between payment method items
  final double itemSpacing;

  /// Flexible configuration (namespaced paymentMethods.) keys:
  ///  backgroundColor, borderRadius, padding, itemSpacing, showAddButton,
  ///  allowMultipleSelection, headerText, addButtonLabel, emptyStateTitle,
  ///  emptyStateSubtitle, enableAnimations
  final FlexibleWidgetConfig? flexibleConfig;

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentMethodModel? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedPaymentMethod ??
        widget.paymentMethods.where((method) => method.isDefault).firstOrNull;
  }

  @override
  void didUpdateWidget(PaymentMethodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPaymentMethod != oldWidget.selectedPaymentMethod) {
      _selectedMethod = widget.selectedPaymentMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    T cfg<T>(String key, T fallback) {
      final fc = widget.flexibleConfig;
      if (fc != null) {
        if (fc.has('paymentMethods.$key')) { try { return fc.get<T>('paymentMethods.$key', fallback); } catch (_) {} }
        if (fc.has(key)) { try { return fc.get<T>(key, fallback); } catch (_) {} }
      }
      return fallback;
    }

    final padding = widget.padding ?? cfg<EdgeInsets>('padding', const EdgeInsets.all(16));
    final bgColor = widget.backgroundColor ?? cfg<Color>('backgroundColor', colorScheme.surface);
    final borderRadius = widget.borderRadius ?? cfg<BorderRadius>('borderRadius', BorderRadius.circular(12));
    final itemSpacing = cfg<double>('itemSpacing', widget.itemSpacing);
    final showAdd = cfg<bool>('showAddButton', widget.showAddPaymentMethod);
    final headerText = cfg<String>('headerText', 'Payment Method');
    final addLabel = cfg<String>('addButtonLabel', 'Add');
    final emptyTitle = cfg<String>('emptyStateTitle', 'No Payment Methods');
    final emptySubtitle = cfg<String>('emptyStateSubtitle', 'Add a payment method to continue');

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  headerText,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showAdd && widget.onAddPaymentMethod != null)
                TextButton.icon(
                  onPressed: widget.onAddPaymentMethod,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(addLabel),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Payment methods list
          if (widget.paymentMethods.isEmpty)
            _buildEmptyState(theme, emptyTitle, emptySubtitle)
          else
            Column(
              children: widget.paymentMethods
                  .map((method) => Padding(
                        padding: EdgeInsets.only(bottom: itemSpacing),
                        child: _buildPaymentMethodItem(method, theme),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(PaymentMethodModel method, ThemeData theme) {
    final isSelected = _selectedMethod?.id == method.id;
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => _selectPaymentMethod(method),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected ? colorScheme.primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            // Payment method icon
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: _buildPaymentIcon(method, theme),
            ),

            const SizedBox(width: 16),

            // Payment method details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getPaymentMethodDisplayName(method),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (method.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getPaymentMethodSubtitle(method),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            Radio<String>(
              value: method.id,
              groupValue: _selectedMethod?.id,
              onChanged: (value) => _selectPaymentMethod(method),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon(PaymentMethodModel method, ThemeData theme) {
    if (method.iconUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          method.iconUrl!,
          width: 48,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultIcon(method.type, theme),
        ),
      );
    }

    return _buildDefaultIcon(method.type, theme);
  }

  Widget _buildDefaultIcon(PaymentType type, ThemeData theme) {
    IconData iconData;
    Color? iconColor;

    switch (type.toLowerCase()) {
      case 'credit_card':
      case 'debit_card':
        iconData = Icons.credit_card;
        iconColor = theme.colorScheme.primary;
        break;
      case 'paypal':
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.blue;
        break;
      case 'apple_pay':
        iconData = Icons.phone_iphone;
        iconColor = Colors.black;
        break;
      case 'google_pay':
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.orange;
        break;
      case 'bank_transfer':
        iconData = Icons.account_balance;
        iconColor = theme.colorScheme.primary;
        break;
      case 'cryptocurrency':
        iconData = Icons.currency_bitcoin;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.payment;
        iconColor = theme.colorScheme.primary;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 20,
    );
  }

  Widget _buildEmptyState(ThemeData theme, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.payment,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (widget.showAddPaymentMethod && widget.onAddPaymentMethod != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: widget.onAddPaymentMethod,
                icon: const Icon(Icons.add),
                label: const Text('Add Payment Method'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodDisplayName(PaymentMethodModel method) {
    switch (method.type.toLowerCase()) {
      case 'credit_card':
        return 'Credit Card';
      case 'debit_card':
        return 'Debit Card';
      case 'paypal':
        return 'PayPal';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cryptocurrency':
        return 'Cryptocurrency';
      default:
        return method.type
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
    }
  }

  String _getPaymentMethodSubtitle(PaymentMethodModel method) {
    if (method.lastFourDigits?.isNotEmpty == true) {
      if (method.type.toLowerCase().contains('card')) {
        return '•••• •••• •••• ${method.lastFourDigits}';
      } else {
        return 'Ending in ${method.lastFourDigits}';
      }
    }

    switch (method.type.toLowerCase()) {
      case 'paypal':
        return 'Pay with your PayPal account';
      case 'apple_pay':
        return 'Pay with Touch ID or Face ID';
      case 'google_pay':
        return 'Pay with your Google account';
      case 'bank_transfer':
        return 'Direct bank transfer';
      case 'cryptocurrency':
        return 'Pay with cryptocurrency';
      default:
        return 'Secure payment method';
    }
  }

  void _selectPaymentMethod(PaymentMethodModel method) {
    setState(() {
      _selectedMethod = method;
    });
    widget.onPaymentMethodSelected(method);
  }
}

/// Predefined payment method types
class PaymentMethodTypes {
  static const String creditCard = 'credit_card';
  static const String debitCard = 'debit_card';
  static const String paypal = 'paypal';
  static const String applePay = 'apple_pay';
  static const String googlePay = 'google_pay';
  static const String bankTransfer = 'bank_transfer';
  static const String cryptocurrency = 'cryptocurrency';

  static const List<String> all = [
    creditCard,
    debitCard,
    paypal,
    applePay,
    googlePay,
    bankTransfer,
    cryptocurrency,
  ];
}
