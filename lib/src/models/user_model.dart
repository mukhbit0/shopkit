import 'package:equatable/equatable.dart';

import 'address_model.dart';
import 'order_model.dart';
import 'payment_model.dart';

/// Model representing a user/customer
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.preferredCurrency = 'USD',
    this.preferredLocale = 'en_US',
    this.addresses,
    this.paymentMethods,
    this.orders,
    this.preferences,
    this.isSubscribedToNewsletter = false,
    this.loyaltyPoints,
    this.membershipTier,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phone: json['phone'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
        preferredCurrency: json['preferredCurrency'] as String? ?? 'USD',
        preferredLocale: json['preferredLocale'] as String? ?? 'en_US',
        addresses: (json['addresses'] as List<dynamic>?)
            ?.map((a) => AddressModel.fromJson(a as Map<String, dynamic>))
            .toList(),
        paymentMethods: (json['paymentMethods'] as List<dynamic>?)
            ?.map((p) => PaymentMethodModel.fromJson(p as Map<String, dynamic>))
            .toList(),
        orders: (json['orders'] as List<dynamic>?)
            ?.map((o) => OrderModel.fromJson(o as Map<String, dynamic>))
            .toList(),
        preferences: json['preferences'] as Map<String, dynamic>?,
        isSubscribedToNewsletter:
            json['isSubscribedToNewsletter'] as bool? ?? false,
        loyaltyPoints: (json['loyaltyPoints'] as num?)?.toDouble(),
        membershipTier: json['membershipTier'] as String?,
      );

  /// Unique user identifier
  final String id;

  /// User's email address
  final String email;

  /// User's first name
  final String firstName;

  /// User's last name
  final String lastName;

  /// User's phone number
  final String? phone;

  /// User's profile avatar URL
  final String? avatarUrl;

  /// When the user account was created
  final DateTime createdAt;

  /// When the user account was last updated
  final DateTime updatedAt;

  /// Whether the user's email is verified
  final bool isEmailVerified;

  /// Whether the user's phone is verified
  final bool isPhoneVerified;

  /// User's preferred currency
  final String preferredCurrency;

  /// User's preferred language/locale
  final String preferredLocale;

  /// User's saved addresses
  final List<AddressModel>? addresses;

  /// User's saved payment methods
  final List<PaymentMethodModel>? paymentMethods;

  /// User's order history
  final List<OrderModel>? orders;

  /// User preferences and settings
  final Map<String, dynamic>? preferences;

  /// User's subscription status (newsletter, etc.)
  final bool isSubscribedToNewsletter;

  /// User's loyalty points or credits
  final double? loyaltyPoints;

  /// User's membership tier (bronze, silver, gold, etc.)
  final String? membershipTier;

  /// Get user's full name
  String get fullName => '$firstName $lastName';

  /// Get user's initials
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  /// Check if user has complete profile
  bool get hasCompleteProfile =>
      email.isNotEmpty &&
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      isEmailVerified;

  /// Get default shipping address
  AddressModel? get defaultShippingAddress {
    if (addresses == null) return null;
    return addresses!.cast<AddressModel?>().firstWhere(
          (AddressModel? address) =>
              address!.isDefault && address.type == 'home',
          orElse: () => addresses!.isNotEmpty ? addresses!.first : null,
        );
  }

  /// Get default payment method
  PaymentMethodModel? get defaultPaymentMethod {
    if (paymentMethods == null) return null;
    return paymentMethods!.cast<PaymentMethodModel?>().firstWhere(
          (PaymentMethodModel? method) => method!.isDefault,
          orElse: () =>
              paymentMethods!.isNotEmpty ? paymentMethods!.first : null,
        );
  }

  /// Get total number of orders
  int get totalOrders => orders?.length ?? 0;

  /// Get total amount spent across all orders
  double get totalSpent {
    if (orders == null) return 0.0;
    return orders!
        .fold(0.0, (double sum, OrderModel order) => sum + order.total);
  }

  /// Check if user is a premium member
  bool get isPremiumMember =>
      membershipTier != null && membershipTier != 'bronze';

  /// Get formatted loyalty points
  String get formattedLoyaltyPoints {
    if (loyaltyPoints == null) return '0 points';
    return '${loyaltyPoints!.toStringAsFixed(0)} points';
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        'preferredCurrency': preferredCurrency,
        'preferredLocale': preferredLocale,
        'addresses': addresses?.map((AddressModel a) => a.toJson()).toList(),
        'paymentMethods':
            paymentMethods?.map((PaymentMethodModel p) => p.toJson()).toList(),
        'orders': orders?.map((OrderModel o) => o.toJson()).toList(),
        'preferences': preferences,
        'isSubscribedToNewsletter': isSubscribedToNewsletter,
        'loyaltyPoints': loyaltyPoints,
        'membershipTier': membershipTier,
      };

  /// Create a copy with modified properties
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? preferredCurrency,
    String? preferredLocale,
    List<AddressModel>? addresses,
    List<PaymentMethodModel>? paymentMethods,
    List<OrderModel>? orders,
    Map<String, dynamic>? preferences,
    bool? isSubscribedToNewsletter,
    double? loyaltyPoints,
    String? membershipTier,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
        preferredCurrency: preferredCurrency ?? this.preferredCurrency,
        preferredLocale: preferredLocale ?? this.preferredLocale,
        addresses: addresses ?? this.addresses,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        orders: orders ?? this.orders,
        preferences: preferences ?? this.preferences,
        isSubscribedToNewsletter:
            isSubscribedToNewsletter ?? this.isSubscribedToNewsletter,
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        membershipTier: membershipTier ?? this.membershipTier,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        email,
        firstName,
        lastName,
        phone,
        avatarUrl,
        createdAt,
        updatedAt,
        isEmailVerified,
        isPhoneVerified,
        preferredCurrency,
        preferredLocale,
        addresses,
        paymentMethods,
        orders,
        preferences,
        isSubscribedToNewsletter,
        loyaltyPoints,
        membershipTier,
      ];
}
