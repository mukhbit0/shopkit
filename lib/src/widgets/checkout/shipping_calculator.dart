import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/address_model.dart';
import '../../models/cart_model.dart';

/// A widget for calculating shipping costs
class ShippingCalculator extends StatefulWidget {
  const ShippingCalculator({
    super.key,
    required this.onShippingCalculated,
    this.cart,
    this.initialAddress,
    this.shippingMethods = const [],
    this.showAddressForm = true,
    this.showShippingMethods = true,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  /// Callback when shipping is calculated
  final ValueChanged<ShippingResult> onShippingCalculated;

  /// Cart for calculating shipping
  final CartModel? cart;

  /// Initial address for calculation
  final AddressModel? initialAddress;

  /// Available shipping methods
  final List<ShippingMethod> shippingMethods;

  /// Whether to show address input form
  final bool showAddressForm;

  /// Whether to show shipping method selection
  final bool showShippingMethods;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  @override
  State<ShippingCalculator> createState() => _ShippingCalculatorState();
}

class _ShippingCalculatorState extends State<ShippingCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  List<ShippingMethod> _availableMethods = [];
  ShippingMethod? _selectedMethod;
  bool _isCalculating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _availableMethods = List.from(widget.shippingMethods);

    if (widget.initialAddress != null) {
      _populateAddressForm(widget.initialAddress!);
      _calculateShipping();
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Shipping Calculator',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Address form
            if (widget.showAddressForm) ...[
              _buildAddressForm(theme),
              const SizedBox(height: 16),
            ],

            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCalculating ? null : _calculateShipping,
                child: _isCalculating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Calculate Shipping'),
              ),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Shipping methods
            if (widget.showShippingMethods && _availableMethods.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildShippingMethods(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        // Street address
        TextFormField(
          controller: _streetController,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter street address';
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        // City and State
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Postal code and Country
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z\s-]')),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter postal code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter country';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingMethods(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Methods',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._availableMethods
            .map((method) => _buildShippingMethodItem(method, theme)),
      ],
    );
  }

  Widget _buildShippingMethodItem(ShippingMethod method, ThemeData theme) {
    final isSelected = _selectedMethod?.id == method.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
          _onShippingMethodSelected(method);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : null,
          ),
          child: Row(
            children: [
              Radio<String>(
                value: method.id,
                groupValue: _selectedMethod?.id,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = method;
                  });
                  _onShippingMethodSelected(method);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (method.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        method.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    if (method.estimatedDelivery != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            method.estimatedDelivery!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                method.cost > 0
                    ? '\$${method.cost.toStringAsFixed(2)}'
                    : 'Free',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: method.cost > 0
                      ? theme.colorScheme.onSurface
                      : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _populateAddressForm(AddressModel address) {
    _streetController.text = address.street;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _postalCodeController.text = address.postalCode;
    _countryController.text = address.country;
  }

  Future<void> _calculateShipping() async {
    if (widget.showAddressForm && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCalculating = true;
      _errorMessage = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock shipping calculation logic
      final address = AddressModel(
        id: 'temp',
        fullName: 'Temp User',
        street1: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
      );

      final calculatedMethods = _calculateShippingMethods(address);

      setState(() {
        _availableMethods = calculatedMethods;
        _isCalculating = false;
        if (calculatedMethods.isNotEmpty) {
          _selectedMethod = calculatedMethods.first;
        }
      });

      if (_selectedMethod != null) {
        _onShippingMethodSelected(_selectedMethod!);
      }
    } catch (e) {
      setState(() {
        _isCalculating = false;
        _errorMessage = 'Failed to calculate shipping. Please try again.';
      });
    }
  }

  List<ShippingMethod> _calculateShippingMethods(AddressModel address) {
    // Mock calculation based on address and cart
    final methods = <ShippingMethod>[];

    // Standard shipping
    methods.add(ShippingMethod(
      id: 'standard',
      name: 'Standard Shipping',
      description: 'Delivery in 5-7 business days',
      cost: address.country.toLowerCase() == 'united states' ? 5.99 : 15.99,
      estimatedDelivery: '5-7 business days',
    ));

    // Express shipping
    methods.add(ShippingMethod(
      id: 'express',
      name: 'Express Shipping',
      description: 'Delivery in 2-3 business days',
      cost: address.country.toLowerCase() == 'united states' ? 12.99 : 25.99,
      estimatedDelivery: '2-3 business days',
    ));

    // Overnight shipping
    if (address.country.toLowerCase() == 'united states') {
      methods.add(const ShippingMethod(
        id: 'overnight',
        name: 'Overnight Shipping',
        description: 'Next business day delivery',
        cost: 24.99,
        estimatedDelivery: '1 business day',
      ));
    }

    // Free shipping for orders over $50
    if (widget.cart != null && widget.cart!.subtotal >= 50) {
      methods.insert(
          0,
          const ShippingMethod(
            id: 'free',
            name: 'Free Shipping',
            description: 'Free standard shipping on orders over \$50',
            cost: 0,
            estimatedDelivery: '5-7 business days',
          ));
    }

    return methods;
  }

  void _onShippingMethodSelected(ShippingMethod method) {
    final address = AddressModel(
      id: 'temp',
      fullName: 'Temp User',
      street1: _streetController.text,
      city: _cityController.text,
      state: _stateController.text,
      postalCode: _postalCodeController.text,
      country: _countryController.text,
    );

    final result = ShippingResult(
      address: address,
      method: method,
      cost: method.cost,
      estimatedDelivery: method.estimatedDelivery,
    );

    widget.onShippingCalculated(result);
  }
}

/// Model representing a shipping method
class ShippingMethod {
  const ShippingMethod({
    required this.id,
    required this.name,
    required this.cost,
    this.description,
    this.estimatedDelivery,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final double cost;
  final String? description;
  final String? estimatedDelivery;
  final bool isAvailable;
}

/// Model representing shipping calculation result
class ShippingResult {
  const ShippingResult({
    required this.address,
    required this.method,
    required this.cost,
    this.estimatedDelivery,
  });

  final AddressModel address;
  final ShippingMethod method;
  final double cost;
  final String? estimatedDelivery;
}
