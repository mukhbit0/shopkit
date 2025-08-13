import 'package:equatable/equatable.dart';

/// Model representing currency information for price conversion
class CurrencyModel extends Equatable {
  const CurrencyModel({
    required this.code,
    required this.symbol,
    required this.exchangeRate,
    this.name,
    this.isBaseCurrency = false,
    this.decimalPlaces = 2,
    this.symbolPosition = CurrencySymbolPosition.before,
  });

  /// ISO 4217 currency code (e.g., 'USD', 'EUR')
  final String code;

  /// Currency symbol (e.g., '$', '€')
  final String symbol;

  /// Exchange rate relative to base currency
  final double exchangeRate;

  /// Full currency name (e.g., 'US Dollar')
  final String? name;

  /// Whether this is the base currency (exchange rate = 1.0)
  final bool isBaseCurrency;

  /// Number of decimal places to display
  final int decimalPlaces;

  /// Position of currency symbol relative to amount
  final CurrencySymbolPosition symbolPosition;

  /// Convenience getters for widget compatibility
  String? get flag => _getFlagEmoji(code);

  /// Get flag emoji for currency code
  String? _getFlagEmoji(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '🇺🇸';
      case 'EUR':
        return '🇪🇺';
      case 'GBP':
        return '🇬🇧';
      case 'JPY':
        return '🇯🇵';
      case 'CAD':
        return '🇨🇦';
      case 'AUD':
        return '🇦🇺';
      case 'CHF':
        return '🇨🇭';
      case 'CNY':
        return '🇨🇳';
      default:
        return null;
    }
  }

  /// Format amount with currency symbol
  String format(double amount) {
    final convertedAmount = convert(amount);
    final formatted = convertedAmount.toStringAsFixed(decimalPlaces);

    switch (symbolPosition) {
      case CurrencySymbolPosition.before:
        return '$symbol$formatted';
      case CurrencySymbolPosition.after:
        return '$formatted$symbol';
      case CurrencySymbolPosition.beforeWithSpace:
        return '$symbol $formatted';
      case CurrencySymbolPosition.afterWithSpace:
        return '$formatted $symbol';
    }
  }

  /// Convert amount from base currency to this currency
  double convert(double amount) => amount * exchangeRate;

  /// Convert amount from this currency to base currency
  double convertToBase(double amount) => amount / exchangeRate;

  /// Format amount with currency symbol
  String formatAmount(double amount) {
    final convertedAmount = convert(amount);
    final formatted = convertedAmount.toStringAsFixed(decimalPlaces);

    switch (symbolPosition) {
      case CurrencySymbolPosition.before:
        return '$symbol$formatted';
      case CurrencySymbolPosition.after:
        return '$formatted$symbol';
      case CurrencySymbolPosition.beforeWithSpace:
        return '$symbol $formatted';
      case CurrencySymbolPosition.afterWithSpace:
        return '$formatted $symbol';
    }
  }

  /// Create CurrencyModel from JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        code: json['code'] as String,
        symbol: json['symbol'] as String,
        exchangeRate: (json['exchangeRate'] as num).toDouble(),
        name: json['name'] as String?,
        isBaseCurrency: json['isBaseCurrency'] as bool? ?? false,
        decimalPlaces: json['decimalPlaces'] as int? ?? 2,
        symbolPosition: CurrencySymbolPosition.values.firstWhere(
          (e) => e.toString().split('.').last == json['symbolPosition'],
          orElse: () => CurrencySymbolPosition.before,
        ),
      );

  /// Convert CurrencyModel to JSON
  Map<String, dynamic> toJson() => {
        'code': code,
        'symbol': symbol,
        'exchangeRate': exchangeRate,
        'name': name,
        'isBaseCurrency': isBaseCurrency,
        'decimalPlaces': decimalPlaces,
        'symbolPosition': symbolPosition.toString().split('.').last,
      };

  /// Create a copy with modified properties
  CurrencyModel copyWith({
    String? code,
    String? symbol,
    double? exchangeRate,
    String? name,
    bool? isBaseCurrency,
    int? decimalPlaces,
    CurrencySymbolPosition? symbolPosition,
  }) =>
      CurrencyModel(
        code: code ?? this.code,
        symbol: symbol ?? this.symbol,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        name: name ?? this.name,
        isBaseCurrency: isBaseCurrency ?? this.isBaseCurrency,
        decimalPlaces: decimalPlaces ?? this.decimalPlaces,
        symbolPosition: symbolPosition ?? this.symbolPosition,
      );

  @override
  List<Object?> get props => [
        code,
        symbol,
        exchangeRate,
        name,
        isBaseCurrency,
        decimalPlaces,
        symbolPosition,
      ];
}

/// Position of currency symbol relative to amount
enum CurrencySymbolPosition {
  before, // $100
  after, // 100$
  beforeWithSpace, // $ 100
  afterWithSpace, // 100 $
}

/// Common currencies with their symbols and typical exchange rates
class CommonCurrencies {
  static const CurrencyModel usd = CurrencyModel(
    code: 'USD',
    symbol: '\$',
    exchangeRate: 1.0,
    name: 'US Dollar',
    isBaseCurrency: true,
  );

  static const CurrencyModel eur = CurrencyModel(
    code: 'EUR',
    symbol: '€',
    exchangeRate: 0.85, // Example rate
    name: 'Euro',
    symbolPosition: CurrencySymbolPosition.afterWithSpace,
  );

  static const CurrencyModel gbp = CurrencyModel(
    code: 'GBP',
    symbol: '£',
    exchangeRate: 0.73, // Example rate
    name: 'British Pound',
  );

  static const CurrencyModel jpy = CurrencyModel(
    code: 'JPY',
    symbol: '¥',
    exchangeRate: 110.0, // Example rate
    name: 'Japanese Yen',
    decimalPlaces: 0,
  );

  static const CurrencyModel cad = CurrencyModel(
    code: 'CAD',
    symbol: 'C\$',
    exchangeRate: 1.25, // Example rate
    name: 'Canadian Dollar',
  );

  static const CurrencyModel aud = CurrencyModel(
    code: 'AUD',
    symbol: 'A\$',
    exchangeRate: 1.35, // Example rate
    name: 'Australian Dollar',
  );

  static const List<CurrencyModel> popular = [
    usd,
    eur,
    gbp,
    jpy,
    cad,
    aud,
  ];

  /// Static factory methods for common currencies
  static CurrencyModel usdCurrency() => usd;
  static CurrencyModel eurCurrency() => eur;
  static CurrencyModel gbpCurrency() => gbp;
  static CurrencyModel jpyCurrency() => jpy;
  static CurrencyModel cadCurrency() => cad;
  static CurrencyModel audCurrency() => aud;
  static CurrencyModel chfCurrency() => const CurrencyModel(
        code: 'CHF',
        symbol: '₣',
        exchangeRate: 0.91,
        name: 'Swiss Franc',
      );
  static CurrencyModel cnyCurrency() => const CurrencyModel(
        code: 'CNY',
        symbol: '¥',
        exchangeRate: 6.45,
        name: 'Chinese Yuan',
      );
}
