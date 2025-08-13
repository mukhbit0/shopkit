import 'package:equatable/equatable.dart';

/// Enum representing payment method types
enum PaymentType {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
  bankTransfer,
  crypto,
  giftCard,
  buyNowPayLater
}

/// Extension for PaymentType display names
extension PaymentTypeExtension on PaymentType {
  String get displayName {
    switch (this) {
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.debitCard:
        return 'Debit Card';
      case PaymentType.paypal:
        return 'PayPal';
      case PaymentType.applePay:
        return 'Apple Pay';
      case PaymentType.googlePay:
        return 'Google Pay';
      case PaymentType.bankTransfer:
        return 'Bank Transfer';
      case PaymentType.crypto:
        return 'Cryptocurrency';
      case PaymentType.giftCard:
        return 'Gift Card';
      case PaymentType.buyNowPayLater:
        return 'Buy Now, Pay Later';
    }
  }

  /// Convert to lowercase string for compatibility
  String toLowerCase() => toString().split('.').last.toLowerCase();

  /// Replace all occurrences for compatibility
  String replaceAll(String from, String replace) =>
      displayName.replaceAll(from, replace);

  /// Convert to uppercase string for compatibility
  String toUpperCase() => toString().split('.').last.toUpperCase();
}

/// Model representing a payment method
class PaymentMethodModel extends Equatable {
  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.name,
    this.lastFourDigits,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.iconUrl,
    this.isDefault = false,
    this.isVerified = false,
    this.processor,
    this.externalId,
    this.supportedCurrencies,
  });

  /// Create PaymentMethodModel from JSON
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json['id'] as String,
        type: PaymentType.values.firstWhere(
          (PaymentType e) => e.toString().split('.').last == json['type'],
        ),
        name: json['name'] as String,
        lastFourDigits: json['lastFourDigits'] as String?,
        cardBrand: json['cardBrand'] as String?,
        expiryMonth: json['expiryMonth'] as int?,
        expiryYear: json['expiryYear'] as int?,
        cardholderName: json['cardholderName'] as String?,
        iconUrl: json['iconUrl'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
        isVerified: json['isVerified'] as bool? ?? false,
        processor: json['processor'] as String?,
        externalId: json['externalId'] as String?,
        supportedCurrencies:
            (json['supportedCurrencies'] as List<dynamic>?)?.cast<String>(),
      );

  /// Unique payment method identifier
  final String id;

  /// Payment method type
  final PaymentType type;

  /// Display name for the payment method
  final String name;

  /// Last 4 digits of card number (for cards)
  final String? lastFourDigits;

  /// Card brand (Visa, Mastercard, etc.)
  final String? cardBrand;

  /// Expiration month (for cards)
  final int? expiryMonth;

  /// Expiration year (for cards)
  final int? expiryYear;

  /// Cardholder name (for cards)
  final String? cardholderName;

  /// Payment method icon URL
  final String? iconUrl;

  /// Whether this is the default payment method
  final bool isDefault;

  /// Whether this payment method is verified/validated
  final bool isVerified;

  /// Payment processor (Stripe, PayPal, etc.)
  final String? processor;

  /// External payment method ID (from payment processor)
  final String? externalId;

  /// Currency this payment method supports
  final List<String>? supportedCurrencies;

  /// Check if payment method is a card type
  bool get isCard =>
      type == PaymentType.creditCard || type == PaymentType.debitCard;

  /// Check if payment method is digital wallet
  bool get isDigitalWallet => <PaymentType>[
        PaymentType.paypal,
        PaymentType.applePay,
        PaymentType.googlePay,
      ].contains(type);

  /// Check if card is expired (for card types)
  bool get isExpired {
    if (!isCard || expiryMonth == null || expiryYear == null) return false;

    final now = DateTime.now();
    final expiry = DateTime(expiryYear!, expiryMonth!);
    return now.isAfter(expiry);
  }

  /// Get masked card number for display
  String get maskedCardNumber {
    if (!isCard || lastFourDigits == null) return '';
    return '**** **** **** $lastFourDigits';
  }

  /// Get formatted expiry date
  String get formattedExpiry {
    if (expiryMonth == null || expiryYear == null) return '';
    return '${expiryMonth.toString().padLeft(2, '0')}/${expiryYear.toString().substring(2)}';
  }

  /// Check if payment method supports currency
  bool supportsCurrency(String currency) {
    if (supportedCurrencies == null) return true; // Assume all if not specified
    return supportedCurrencies!.contains(currency.toUpperCase());
  }

  /// Convert PaymentMethodModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.toString().split('.').last,
        'name': name,
        'lastFourDigits': lastFourDigits,
        'cardBrand': cardBrand,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cardholderName': cardholderName,
        'iconUrl': iconUrl,
        'isDefault': isDefault,
        'isVerified': isVerified,
        'processor': processor,
        'externalId': externalId,
        'supportedCurrencies': supportedCurrencies,
      };

  /// Create a copy with modified properties
  PaymentMethodModel copyWith({
    String? id,
    PaymentType? type,
    String? name,
    String? lastFourDigits,
    String? cardBrand,
    int? expiryMonth,
    int? expiryYear,
    String? cardholderName,
    String? iconUrl,
    bool? isDefault,
    bool? isVerified,
    String? processor,
    String? externalId,
    List<String>? supportedCurrencies,
  }) =>
      PaymentMethodModel(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        lastFourDigits: lastFourDigits ?? this.lastFourDigits,
        cardBrand: cardBrand ?? this.cardBrand,
        expiryMonth: expiryMonth ?? this.expiryMonth,
        expiryYear: expiryYear ?? this.expiryYear,
        cardholderName: cardholderName ?? this.cardholderName,
        iconUrl: iconUrl ?? this.iconUrl,
        isDefault: isDefault ?? this.isDefault,
        isVerified: isVerified ?? this.isVerified,
        processor: processor ?? this.processor,
        externalId: externalId ?? this.externalId,
        supportedCurrencies: supportedCurrencies ?? this.supportedCurrencies,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        type,
        name,
        lastFourDigits,
        cardBrand,
        expiryMonth,
        expiryYear,
        cardholderName,
        iconUrl,
        isDefault,
        isVerified,
        processor,
        externalId,
        supportedCurrencies,
      ];
}
