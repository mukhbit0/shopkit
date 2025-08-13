import 'package:flutter/material.dart';
import '../../models/cart_model.dart';
import '../../models/address_model.dart';
import '../../models/payment_model.dart';
import '../../theme/ecommerce_theme.dart';

/// Enum for checkout steps
enum CheckoutStep {
  shipping,
  payment,
  review,
}

/// Model for checkout step data
class CheckoutStepModel {
  const CheckoutStepModel({
    required this.step,
    required this.title,
    required this.isCompleted,
    this.isActive = false,
    this.content,
  });

  final CheckoutStep step;
  final String title;
  final bool isCompleted;
  final bool isActive;
  final Widget? content;
}

/// A multi-step checkout widget with progress indicator
class CheckoutStepper extends StatefulWidget {
  const CheckoutStepper({
    super.key,
    required this.cart,
    this.onStepChanged,
    this.onCheckoutComplete,
    this.initialStep = CheckoutStep.shipping,
    this.shippingAddress,
    this.billingAddress,
    this.paymentMethod,
    this.shippingOptions = const [],
    this.paymentMethods = const [],
    this.showProgressBar = true,
    this.allowStepNavigation = true,
    this.backgroundColor,
    this.stepActiveColor,
    this.stepCompletedColor,
    this.stepInactiveColor,
  });

  /// Cart containing items to checkout
  final CartModel cart;

  /// Callback when step changes
  final void Function(CheckoutStep)? onStepChanged;

  /// Callback when checkout is completed
  final void Function(Map<String, dynamic>)? onCheckoutComplete;

  /// Initial checkout step
  final CheckoutStep initialStep;

  /// Selected shipping address
  final AddressModel? shippingAddress;

  /// Selected billing address
  final AddressModel? billingAddress;

  /// Selected payment method
  final PaymentMethodModel? paymentMethod;

  /// Available shipping options
  final List<Map<String, dynamic>> shippingOptions;

  /// Available payment methods
  final List<PaymentMethodModel> paymentMethods;

  /// Whether to show progress bar
  final bool showProgressBar;

  /// Whether users can navigate between steps
  final bool allowStepNavigation;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom active step color
  final Color? stepActiveColor;

  /// Custom completed step color
  final Color? stepCompletedColor;

  /// Custom inactive step color
  final Color? stepInactiveColor;

  @override
  State<CheckoutStepper> createState() => _CheckoutStepperState();
}

class _CheckoutStepperState extends State<CheckoutStepper> {
  late CheckoutStep _currentStep;
  AddressModel? _selectedShippingAddress;
  AddressModel? _selectedBillingAddress;
  PaymentMethodModel? _selectedPaymentMethod;
  Map<String, dynamic>? _selectedShippingOption;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _selectedShippingAddress = widget.shippingAddress;
    _selectedBillingAddress = widget.billingAddress;
    _selectedPaymentMethod = widget.paymentMethod;
  }

  List<CheckoutStepModel> get _steps => [
        CheckoutStepModel(
          step: CheckoutStep.shipping,
          title: 'Shipping',
          isCompleted: _isStepCompleted(CheckoutStep.shipping),
          isActive: _currentStep == CheckoutStep.shipping,
        ),
        CheckoutStepModel(
          step: CheckoutStep.payment,
          title: 'Payment',
          isCompleted: _isStepCompleted(CheckoutStep.payment),
          isActive: _currentStep == CheckoutStep.payment,
        ),
        CheckoutStepModel(
          step: CheckoutStep.review,
          title: 'Review',
          isCompleted: _isStepCompleted(CheckoutStep.review),
          isActive: _currentStep == CheckoutStep.review,
        ),
      ];

  bool _isStepCompleted(CheckoutStep step) {
    switch (step) {
      case CheckoutStep.shipping:
        return _selectedShippingAddress != null &&
            _selectedShippingOption != null;
      case CheckoutStep.payment:
        return _selectedPaymentMethod != null;
      case CheckoutStep.review:
        return false; // Review step is never "completed" until checkout
    }
  }

  bool _canProceedToNextStep() {
    return _isStepCompleted(_currentStep);
  }

  void _goToStep(CheckoutStep step) {
    if (!widget.allowStepNavigation) return;

    setState(() {
      _currentStep = step;
    });
    widget.onStepChanged?.call(step);
  }

  void _nextStep() {
    if (!_canProceedToNextStep()) return;

    switch (_currentStep) {
      case CheckoutStep.shipping:
        _goToStep(CheckoutStep.payment);
        break;
      case CheckoutStep.payment:
        _goToStep(CheckoutStep.review);
        break;
      case CheckoutStep.review:
        _completeCheckout();
        break;
    }
  }

  void _previousStep() {
    switch (_currentStep) {
      case CheckoutStep.payment:
        _goToStep(CheckoutStep.shipping);
        break;
      case CheckoutStep.review:
        _goToStep(CheckoutStep.payment);
        break;
      case CheckoutStep.shipping:
        break; // Can't go back from first step
    }
  }

  Future<void> _completeCheckout() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate checkout processing
      await Future.delayed(const Duration(seconds: 2));

      final checkoutData = {
        'cart': widget.cart.toJson(),
        'shippingAddress': _selectedShippingAddress?.toJson(),
        'billingAddress': _selectedBillingAddress?.toJson(),
        'paymentMethod': _selectedPaymentMethod?.toJson(),
        'shippingOption': _selectedShippingOption,
        'timestamp': DateTime.now().toIso8601String(),
      };

      widget.onCheckoutComplete?.call(checkoutData);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.ecommerceTheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.backgroundColor,
      ),
      child: Column(
        children: [
          // Progress Bar
          if (widget.showProgressBar) _buildProgressBar(theme),

          // Step Content
          Expanded(
            child: _buildStepContent(theme),
          ),

          // Navigation Buttons
          _buildNavigationButtons(theme),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ECommerceTheme theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacing),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: theme.effectiveCardShadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _steps.expand((step) sync* {
          final index = _steps.indexOf(step);

          // Step Circle
          yield _buildStepCircle(step, theme);

          // Connector Line (except for last step)
          if (index < _steps.length - 1) {
            yield Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: step.isCompleted
                      ? widget.stepCompletedColor ?? theme.successColor
                      : widget.stepInactiveColor ?? theme.effectiveBorderColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }

  Widget _buildStepCircle(CheckoutStepModel step, ECommerceTheme theme) {
    Color backgroundColor;
    Color iconColor;
    Widget icon;

    if (step.isCompleted) {
      backgroundColor = widget.stepCompletedColor ?? theme.successColor;
      iconColor = Colors.white;
      icon = const Icon(Icons.check, size: 16, color: Colors.white);
    } else if (step.isActive) {
      backgroundColor = widget.stepActiveColor ?? theme.primaryColor;
      iconColor = Colors.white;
      icon = Text(
        '${_steps.indexOf(step) + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );
    } else {
      backgroundColor = widget.stepInactiveColor ?? theme.effectiveBorderColor;
      iconColor = theme.onSurfaceColor.withValues(alpha: 0.5);
      icon = Text(
        '${_steps.indexOf(step) + 1}',
        style: TextStyle(
          color: iconColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );
    }

    return GestureDetector(
      onTap: widget.allowStepNavigation ? () => _goToStep(step.step) : null,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Text(
            step.title,
            style: theme.defaultSubtitleTextStyle.copyWith(
              fontSize: 12,
              fontWeight: step.isActive ? FontWeight.w600 : FontWeight.w500,
              color: step.isActive
                  ? theme.primaryColor
                  : theme.onSurfaceColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(ECommerceTheme theme) {
    switch (_currentStep) {
      case CheckoutStep.shipping:
        return _buildShippingStep(theme);
      case CheckoutStep.payment:
        return _buildPaymentStep(theme);
      case CheckoutStep.review:
        return _buildReviewStep(theme);
    }
  }

  Widget _buildShippingStep(ECommerceTheme theme) {
    return Padding(
      padding: EdgeInsets.all(theme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: theme.defaultTitleTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: theme.spacing),

          // Address selection placeholder
          Container(
            padding: EdgeInsets.all(theme.spacing),
            decoration: theme.cardDecoration,
            child: Column(
              children: [
                if (_selectedShippingAddress != null) ...[
                  Text(
                    _selectedShippingAddress!.formattedAddress,
                    style: theme.defaultSubtitleTextStyle,
                  ),
                ] else ...[
                  Text(
                    'Select shipping address',
                    style: theme.defaultSubtitleTextStyle,
                  ),
                ],
                SizedBox(height: theme.spacing),
                ElevatedButton(
                  onPressed: () {
                    // Mock address selection
                    setState(() {
                      _selectedShippingAddress = const AddressModel(
                        id: '1',
                        fullName: 'John Doe',
                        street1: '123 Main St',
                        city: 'New York',
                        state: 'NY',
                        postalCode: '10001',
                        country: 'USA',
                      );
                    });
                  },
                  style: theme.primaryButtonStyle,
                  child: const Text('Select Address'),
                ),
              ],
            ),
          ),

          SizedBox(height: theme.spacing * 1.5),

          // Shipping Options
          if (_selectedShippingAddress != null) ...[
            Text(
              'Shipping Method',
              style: theme.defaultTitleTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: theme.spacing),
            ...[
              'Standard (5-7 days) - FREE',
              'Express (2-3 days) - \$9.99',
              'Next Day - \$19.99'
            ].map((option) => _buildShippingOption(option, theme)),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingOption(String option, ECommerceTheme theme) {
    final isSelected = _selectedShippingOption?['name'] == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedShippingOption = {'name': option, 'cost': 0.0};
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: theme.spacing * 0.5),
        padding: EdgeInsets.all(theme.spacing),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(theme.cardRadius),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.effectiveBorderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? theme.primaryColor : theme.effectiveIconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: theme.defaultTitleTextStyle.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep(ECommerceTheme theme) {
    return Padding(
      padding: EdgeInsets.all(theme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: theme.defaultTitleTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: theme.spacing),

          // Payment method selection
          ...['Credit Card', 'PayPal', 'Apple Pay'].map((method) {
            final isSelected = _selectedPaymentMethod?.name == method;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = PaymentMethodModel(
                    id: method.toLowerCase().replaceAll(' ', '_'),
                    type: PaymentType.creditCard,
                    name: method,
                  );
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: theme.spacing),
                padding: EdgeInsets.all(theme.spacing),
                decoration: BoxDecoration(
                  color: theme.surfaceColor,
                  borderRadius: BorderRadius.circular(theme.cardRadius),
                  border: Border.all(
                    color: isSelected
                        ? theme.primaryColor
                        : theme.effectiveBorderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? theme.primaryColor
                          : theme.effectiveIconColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        method,
                        style:
                            theme.defaultTitleTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                    Icon(
                      _getPaymentIcon(method),
                      color: theme.effectiveIconColor,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewStep(ECommerceTheme theme) {
    return Padding(
      padding: EdgeInsets.all(theme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Review',
            style: theme.defaultTitleTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: theme.spacing),

          // Order Summary
          Container(
            padding: EdgeInsets.all(theme.spacing),
            decoration: theme.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Items
                Text(
                  'Items (${widget.cart.itemCount})',
                  style: theme.defaultTitleTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: theme.spacing * 0.75),

                ...widget.cart.items.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: theme.spacing * 0.5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.displayName} × ${item.quantity}',
                              style: theme.defaultSubtitleTextStyle,
                            ),
                          ),
                          Text(
                            item.getFormattedTotal(widget.cart.currency),
                            style: theme.defaultTitleTextStyle
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    )),

                Divider(color: theme.effectiveDividerColor),

                // Totals
                _buildReviewTotal(
                    'Subtotal', widget.cart.formattedSubtotal, theme),
                if (widget.cart.shipping != null)
                  _buildReviewTotal(
                      'Shipping', widget.cart.formattedShipping, theme),
                if (widget.cart.tax != null)
                  _buildReviewTotal('Tax', widget.cart.formattedTax, theme),
                if (widget.cart.discount != null && widget.cart.discount! > 0)
                  _buildReviewTotal(
                      'Discount', '-${widget.cart.formattedDiscount}', theme,
                      color: theme.successColor),

                Divider(color: theme.effectiveDividerColor),

                _buildReviewTotal('Total', widget.cart.formattedTotal, theme,
                    isTotal: true),
              ],
            ),
          ),

          SizedBox(height: theme.spacing),

          // Shipping Address
          if (_selectedShippingAddress != null) ...[
            Text(
              'Shipping Address',
              style: theme.defaultTitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: theme.spacing * 0.5),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(theme.spacing),
              decoration: theme.cardDecoration,
              child: Text(
                _selectedShippingAddress!.formattedAddress,
                style: theme.defaultSubtitleTextStyle,
              ),
            ),
            SizedBox(height: theme.spacing),
          ],

          // Payment Method
          if (_selectedPaymentMethod != null) ...[
            Text(
              'Payment Method',
              style: theme.defaultTitleTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: theme.spacing * 0.5),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(theme.spacing),
              decoration: theme.cardDecoration,
              child: Row(
                children: [
                  Icon(
                    _getPaymentIcon(_selectedPaymentMethod!.name),
                    color: theme.effectiveIconColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedPaymentMethod!.name,
                    style: theme.defaultSubtitleTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewTotal(
    String label,
    String value,
    ECommerceTheme theme, {
    Color? color,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing * 0.25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.defaultTitleTextStyle
                    .copyWith(fontWeight: FontWeight.w600)
                : theme.defaultSubtitleTextStyle,
          ),
          Text(
            value,
            style: (isTotal
                    ? theme.defaultPriceTextStyle
                    : theme.defaultTitleTextStyle.copyWith(fontSize: 14))
                .copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ECommerceTheme theme) {
    return Container(
      padding: EdgeInsets.all(theme.spacing),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: theme.effectiveCardShadowColor,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          if (_currentStep != CheckoutStep.shipping)
            Expanded(
              child: OutlinedButton(
                onPressed: _isProcessing ? null : _previousStep,
                style: theme.secondaryButtonStyle,
                child: const Text('Back'),
              ),
            ),

          if (_currentStep != CheckoutStep.shipping)
            SizedBox(width: theme.spacing),

          // Next/Complete Button
          Expanded(
            flex: _currentStep == CheckoutStep.shipping ? 1 : 2,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : _canProceedToNextStep()
                      ? _nextStep
                      : null,
              style: theme.primaryButtonStyle,
              child: _isProcessing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Processing...'),
                      ],
                    )
                  : Text(_getNextButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case CheckoutStep.shipping:
        return 'Continue to Payment';
      case CheckoutStep.payment:
        return 'Review Order';
      case CheckoutStep.review:
        return 'Place Order';
    }
  }

  IconData _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'credit card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple pay':
        return Icons.phone_iphone;
      case 'google pay':
        return Icons.android;
      default:
        return Icons.payment;
    }
  }
}
