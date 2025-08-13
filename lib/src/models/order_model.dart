import 'package:equatable/equatable.dart';

import 'address_model.dart';
import 'cart_model.dart';
import 'payment_model.dart';

/// Enum representing order status
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
  returned
}

/// Extension for OrderStatus to provide display names
extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  bool get isActive => !<OrderStatus>[
        OrderStatus.cancelled,
        OrderStatus.refunded,
        OrderStatus.returned
      ].contains(this);
  bool get isCompleted => this == OrderStatus.delivered;
  bool get canCancel =>
      <OrderStatus>[OrderStatus.pending, OrderStatus.confirmed].contains(this);
  bool get canTrack =>
      <OrderStatus>[OrderStatus.processing, OrderStatus.shipped].contains(this);

  /// Convert to lowercase string for compatibility
  String toLowerCase() => toString().split('.').last.toLowerCase();

  /// Convert to uppercase string for compatibility
  String toUpperCase() => toString().split('.').last.toUpperCase();
}

/// Model representing a customer order
class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.cart,
    required this.shippingAddress,
    required this.paymentMethod,
    this.billingAddress,
    this.trackingNumber,
    this.carrier,
    this.estimatedDelivery,
    this.deliveredAt,
    this.notes,
    this.trackingUpdates,
  });

  /// Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        userId: json['userId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        status: OrderStatus.values.firstWhere(
          (OrderStatus e) => e.toString().split('.').last == json['status'],
        ),
        cart: CartModel.fromJson(json['cart'] as Map<String, dynamic>),
        shippingAddress: AddressModel.fromJson(
            json['shippingAddress'] as Map<String, dynamic>),
        billingAddress: json['billingAddress'] != null
            ? AddressModel.fromJson(
                json['billingAddress'] as Map<String, dynamic>)
            : null,
        paymentMethod: PaymentMethodModel.fromJson(
            json['paymentMethod'] as Map<String, dynamic>),
        trackingNumber: json['trackingNumber'] as String?,
        carrier: json['carrier'] as String?,
        estimatedDelivery: json['estimatedDelivery'] != null
            ? DateTime.parse(json['estimatedDelivery'] as String)
            : null,
        deliveredAt: json['deliveredAt'] != null
            ? DateTime.parse(json['deliveredAt'] as String)
            : null,
        notes: json['notes'] as String?,
        trackingUpdates: (json['trackingUpdates'] as List<dynamic>?)
            ?.map(
                (u) => TrackingUpdateModel.fromJson(u as Map<String, dynamic>))
            .toList(),
      );

  /// Unique order identifier
  final String id;

  /// Order number (human-readable)
  final String orderNumber;

  /// User ID who placed the order
  final String userId;

  /// When the order was placed
  final DateTime createdAt;

  /// When the order was last updated
  final DateTime updatedAt;

  /// Current order status
  final OrderStatus status;

  /// Cart snapshot at time of order
  final CartModel cart;

  /// Shipping address
  final AddressModel shippingAddress;

  /// Billing address (optional, defaults to shipping)
  final AddressModel? billingAddress;

  /// Payment method used
  final PaymentMethodModel paymentMethod;

  /// Tracking number for shipment
  final String? trackingNumber;

  /// Shipping carrier (e.g., 'UPS', 'FedEx')
  final String? carrier;

  /// Expected delivery date
  final DateTime? estimatedDelivery;

  /// Actual delivery date
  final DateTime? deliveredAt;

  /// Order notes/instructions
  final String? notes;

  /// Tracking updates timeline
  final List<TrackingUpdateModel>? trackingUpdates;

  /// Get effective billing address (billing or shipping)
  AddressModel get effectiveBillingAddress => billingAddress ?? shippingAddress;

  /// Check if order can be cancelled
  bool get canCancel => status.canCancel;

  /// Check if order can be tracked
  bool get canTrack => status.canTrack && trackingNumber != null;

  /// Check if order is completed
  bool get isCompleted => status.isCompleted;

  /// Check if order is active (not cancelled/refunded/returned)
  bool get isActive => status.isActive;

  /// Get order total from cart
  double get total => cart.total;

  /// Get formatted order total
  String get formattedTotal => cart.formattedTotal;

  /// Convenience getter for shipping info
  Map<String, dynamic>? get shippingInfo => {
        'trackingNumber': trackingNumber,
        'carrier': carrier,
        'estimatedDelivery': estimatedDelivery?.toIso8601String(),
        'deliveredAt': deliveredAt?.toIso8601String(),
      };

  /// Get most recent tracking update
  TrackingUpdateModel? get latestUpdate {
    if (trackingUpdates == null || trackingUpdates!.isEmpty) return null;
    return trackingUpdates!.reduce(
        (TrackingUpdateModel a, TrackingUpdateModel b) =>
            a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  /// Convert OrderModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'orderNumber': orderNumber,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'status': status.toString().split('.').last,
        'cart': cart.toJson(),
        'shippingAddress': shippingAddress.toJson(),
        'billingAddress': billingAddress?.toJson(),
        'paymentMethod': paymentMethod.toJson(),
        'trackingNumber': trackingNumber,
        'carrier': carrier,
        'estimatedDelivery': estimatedDelivery?.toIso8601String(),
        'deliveredAt': deliveredAt?.toIso8601String(),
        'notes': notes,
        'trackingUpdates': trackingUpdates
            ?.map((TrackingUpdateModel u) => u.toJson())
            .toList(),
      };

  /// Create a copy with modified properties
  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderStatus? status,
    CartModel? cart,
    AddressModel? shippingAddress,
    AddressModel? billingAddress,
    PaymentMethodModel? paymentMethod,
    String? trackingNumber,
    String? carrier,
    DateTime? estimatedDelivery,
    DateTime? deliveredAt,
    String? notes,
    List<TrackingUpdateModel>? trackingUpdates,
  }) =>
      OrderModel(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        cart: cart ?? this.cart,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        billingAddress: billingAddress ?? this.billingAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        carrier: carrier ?? this.carrier,
        estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        notes: notes ?? this.notes,
        trackingUpdates: trackingUpdates ?? this.trackingUpdates,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        orderNumber,
        userId,
        createdAt,
        updatedAt,
        status,
        cart,
        shippingAddress,
        billingAddress,
        paymentMethod,
        trackingNumber,
        carrier,
        estimatedDelivery,
        deliveredAt,
        notes,
        trackingUpdates,
      ];
}

/// Model representing a tracking update for an order
class TrackingUpdateModel extends Equatable {
  const TrackingUpdateModel({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.description,
    this.location,
    this.carrierCode,
    this.isException = false,
  });

  /// Create TrackingUpdateModel from JSON
  factory TrackingUpdateModel.fromJson(Map<String, dynamic> json) =>
      TrackingUpdateModel(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: json['status'] as String,
        description: json['description'] as String,
        location: json['location'] as String?,
        carrierCode: json['carrierCode'] as String?,
        isException: json['isException'] as bool? ?? false,
      );

  /// Unique update identifier
  final String id;

  /// When this update occurred
  final DateTime timestamp;

  /// Update status description
  final String status;

  /// Detailed description of the update
  final String description;

  /// Location where update occurred
  final String? location;

  /// Carrier-specific status code
  final String? carrierCode;

  /// Whether this is an exception/problem
  final bool isException;

  /// Convert TrackingUpdateModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
        'description': description,
        'location': location,
        'carrierCode': carrierCode,
        'isException': isException,
      };

  /// Create a copy with modified properties
  TrackingUpdateModel copyWith({
    String? id,
    DateTime? timestamp,
    String? status,
    String? description,
    String? location,
    String? carrierCode,
    bool? isException,
  }) =>
      TrackingUpdateModel(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        description: description ?? this.description,
        location: location ?? this.location,
        carrierCode: carrierCode ?? this.carrierCode,
        isException: isException ?? this.isException,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        timestamp,
        status,
        description,
        location,
        carrierCode,
        isException,
      ];
}
