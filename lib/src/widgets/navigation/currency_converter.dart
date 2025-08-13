import 'package:flutter/material.dart';
import '../../models/currency_model.dart';

/// A widget for currency conversion and display
class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({
    super.key,
    required this.amount,
    required this.fromCurrency,
    this.toCurrency,
    this.availableCurrencies = const [],
    this.onCurrencyChanged,
    this.showDropdown = true,
    this.showSymbol = true,
    this.showCode = false,
    this.decimalPlaces = 2,
    this.style,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.compact = false,
  });

  /// Amount to convert
  final double amount;

  /// Source currency
  final CurrencyModel fromCurrency;

  /// Target currency (if null, uses fromCurrency)
  final CurrencyModel? toCurrency;

  /// Available currencies for dropdown
  final List<CurrencyModel> availableCurrencies;

  /// Callback when currency is changed
  final ValueChanged<CurrencyModel>? onCurrencyChanged;

  /// Whether to show currency dropdown
  final bool showDropdown;

  /// Whether to show currency symbol
  final bool showSymbol;

  /// Whether to show currency code
  final bool showCode;

  /// Number of decimal places
  final int decimalPlaces;

  /// Text style
  final TextStyle? style;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// Whether to use compact layout
  final bool compact;

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  late CurrencyModel _currentCurrency;

  @override
  void initState() {
    super.initState();
    _currentCurrency = widget.toCurrency ?? widget.fromCurrency;
  }

  @override
  void didUpdateWidget(CurrencyConverter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.toCurrency != oldWidget.toCurrency) {
      _currentCurrency = widget.toCurrency ?? widget.fromCurrency;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final convertedAmount = _convertAmount();

    if (widget.compact) {
      return _buildCompactView(theme, convertedAmount);
    }

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: _buildFullView(theme, convertedAmount),
    );
  }

  Widget _buildCompactView(ThemeData theme, double convertedAmount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatAmount(convertedAmount),
          style: widget.style ?? theme.textTheme.bodyMedium,
        ),
        if (widget.showDropdown && widget.availableCurrencies.isNotEmpty) ...[
          const SizedBox(width: 4),
          _buildCurrencyDropdown(theme, isCompact: true),
        ],
      ],
    );
  }

  Widget _buildFullView(ThemeData theme, double convertedAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.currency_exchange,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Currency Converter',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Original amount
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatAmount(widget.amount,
                          currency: widget.fromCurrency),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Currency info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.fromCurrency.code,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.fromCurrency.name != null &&
                      widget.fromCurrency.name != widget.fromCurrency.code)
                    Text(
                      widget.fromCurrency.name!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Arrow
        const SizedBox(height: 8),
        Center(
          child: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),

        // Converted amount
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatAmount(convertedAmount),
                      style:
                          (widget.style ?? theme.textTheme.bodyLarge)?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Currency dropdown
              if (widget.showDropdown && widget.availableCurrencies.isNotEmpty)
                _buildCurrencyDropdown(theme)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _currentCurrency.code,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (_currentCurrency.name != null &&
                        _currentCurrency.name != _currentCurrency.code)
                      Text(
                        _currentCurrency.name!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),

        // Exchange rate info
        if (_currentCurrency.code != widget.fromCurrency.code) ...[
          const SizedBox(height: 8),
          Text(
            '1 ${widget.fromCurrency.code} = ${_getExchangeRate().toStringAsFixed(4)} ${_currentCurrency.code}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCurrencyDropdown(ThemeData theme, {bool isCompact = false}) {
    return DropdownButton<CurrencyModel>(
      value: _currentCurrency,
      isDense: isCompact,
      underline: const SizedBox.shrink(),
      items: widget.availableCurrencies.map((currency) {
        return DropdownMenuItem<CurrencyModel>(
          value: currency,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCompact && currency.flag != null) ...[
                Text(currency.flag!),
                const SizedBox(width: 4),
              ],
              Text(
                isCompact
                    ? currency.code
                    : '${currency.code} - ${currency.name}',
                style: isCompact ? theme.textTheme.bodySmall : null,
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (currency) {
        if (currency != null) {
          setState(() {
            _currentCurrency = currency;
          });
          widget.onCurrencyChanged?.call(currency);
        }
      },
    );
  }

  double _convertAmount() {
    if (_currentCurrency.code == widget.fromCurrency.code) {
      return widget.amount;
    }

    final exchangeRate = _getExchangeRate();
    return widget.amount * exchangeRate;
  }

  double _getExchangeRate() {
    if (_currentCurrency.code == widget.fromCurrency.code) {
      return 1.0;
    }

    // Convert from base currency to target currency
    final fromRate = widget.fromCurrency.exchangeRate;
    final toRate = _currentCurrency.exchangeRate;

    return toRate / fromRate;
  }

  String _formatAmount(double amount, {CurrencyModel? currency}) {
    final curr = currency ?? _currentCurrency;
    return curr.formatAmount(amount);
  }
}

/// A simple currency display widget
class CurrencyDisplay extends StatelessWidget {
  const CurrencyDisplay({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
    this.showSymbol = true,
    this.showCode = false,
    this.decimalPlaces = 2,
    this.color,
  });

  /// Amount to display
  final double amount;

  /// Currency to use for formatting
  final CurrencyModel currency;

  /// Text style
  final TextStyle? style;

  /// Whether to show currency symbol
  final bool showSymbol;

  /// Whether to show currency code
  final bool showCode;

  /// Number of decimal places
  final int decimalPlaces;

  /// Text color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      currency.formatAmount(amount),
      style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
        color: color,
      ),
    );
  }
}

/// A currency selector widget
class CurrencySelector extends StatefulWidget {
  const CurrencySelector({
    super.key,
    required this.currencies,
    this.selectedCurrency,
    this.onCurrencySelected,
    this.title = 'Select Currency',
    this.showFlags = true,
    this.showSearchBar = true,
    this.groupByRegion = false,
  });

  /// Available currencies
  final List<CurrencyModel> currencies;

  /// Currently selected currency
  final CurrencyModel? selectedCurrency;

  /// Callback when currency is selected
  final ValueChanged<CurrencyModel>? onCurrencySelected;

  /// Dialog title
  final String title;

  /// Whether to show country flags
  final bool showFlags;

  /// Whether to show search bar
  final bool showSearchBar;

  /// Whether to group currencies by region
  final bool groupByRegion;

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late List<CurrencyModel> _filteredCurrencies;

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = widget.currencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      _filteredCurrencies = widget.currencies.where((currency) {
        return (currency.name?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            currency.code.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Search bar
            if (widget.showSearchBar)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search currencies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                  ),
                  onChanged: _filterCurrencies,
                ),
              ),

            // Currency list
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = _filteredCurrencies[index];
                  final isSelected =
                      currency.code == widget.selectedCurrency?.code;

                  return ListTile(
                    leading: widget.showFlags && currency.flag != null
                        ? Text(
                            currency.flag!,
                            style: const TextStyle(fontSize: 24),
                          )
                        : CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              currency.code.substring(0, 2),
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    title: Text(
                      currency.name ?? currency.code,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text(currency.code),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    selected: isSelected,
                    onTap: () {
                      widget.onCurrencySelected?.call(currency);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Utility methods for currency operations
class CurrencyUtils {
  /// Show currency selector dialog
  static Future<CurrencyModel?> showCurrencySelector(
    BuildContext context, {
    required List<CurrencyModel> currencies,
    CurrencyModel? selectedCurrency,
    String title = 'Select Currency',
    bool showFlags = true,
    bool showSearchBar = true,
  }) async {
    return showDialog<CurrencyModel>(
      context: context,
      builder: (context) => CurrencySelector(
        currencies: currencies,
        selectedCurrency: selectedCurrency,
        title: title,
        showFlags: showFlags,
        showSearchBar: showSearchBar,
        onCurrencySelected: (currency) => Navigator.of(context).pop(currency),
      ),
    );
  }

  /// Get popular currencies
  static List<CurrencyModel> getPopularCurrencies() {
    return [
      CommonCurrencies.usd,
      CommonCurrencies.eur,
      CommonCurrencies.gbp,
      CommonCurrencies.jpy,
      CommonCurrencies.cad,
      CommonCurrencies.aud,
    ];
  }

  /// Format amount with automatic currency detection
  static String formatAmount(
    double amount,
    String currencyCode, {
    int decimalPlaces = 2,
    bool showSymbol = true,
    bool showCode = false,
  }) {
    final currency = _getCurrencyByCode(currencyCode);
    return currency.formatAmount(amount);
  }

  static CurrencyModel _getCurrencyByCode(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return CommonCurrencies.usd;
      case 'EUR':
        return CommonCurrencies.eur;
      case 'GBP':
        return CommonCurrencies.gbp;
      case 'JPY':
        return CommonCurrencies.jpy;
      case 'CAD':
        return CommonCurrencies.cad;
      case 'AUD':
        return CommonCurrencies.aud;
      case 'CHF':
        return CommonCurrencies.chfCurrency();
      case 'CNY':
        return CommonCurrencies.cnyCurrency();
      default:
        return CommonCurrencies.usd; // Default fallback
    }
  }
}
