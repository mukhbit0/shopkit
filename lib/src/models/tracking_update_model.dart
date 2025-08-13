import 'package:equatable/equatable.dart';

/// Model representing a tracking update for an order
class TrackingUpdateModel extends Equatable {
  const TrackingUpdateModel({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.description,
    this.location,
    this.carrierName,
    this.estimatedDelivery,
    this.imageUrl,
  });

  /// Unique identifier for the tracking update
  final String id;

  /// Timestamp when the update occurred
  final DateTime timestamp;

  /// Status code or identifier
  final String status;

  /// Human-readable description of the update
  final String description;

  /// Location where the update occurred
  final String? location;

  /// Name of the shipping carrier
  final String? carrierName;

  /// Estimated delivery date (if available)
  final DateTime? estimatedDelivery;

  /// Optional image URL (e.g., delivery photo)
  final String? imageUrl;

  /// Create TrackingUpdateModel from JSON
  factory TrackingUpdateModel.fromJson(Map<String, dynamic> json) =>
      TrackingUpdateModel(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        status: json['status'] as String,
        description: json['description'] as String,
        location: json['location'] as String?,
        carrierName: json['carrierName'] as String?,
        estimatedDelivery: json['estimatedDelivery'] != null
            ? DateTime.parse(json['estimatedDelivery'] as String)
            : null,
        imageUrl: json['imageUrl'] as String?,
      );

  /// Convert TrackingUpdateModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
        'description': description,
        'location': location,
        'carrierName': carrierName,
        'estimatedDelivery': estimatedDelivery?.toIso8601String(),
        'imageUrl': imageUrl,
      };

  /// Create a copy with modified properties
  TrackingUpdateModel copyWith({
    String? id,
    DateTime? timestamp,
    String? status,
    String? description,
    String? location,
    String? carrierName,
    DateTime? estimatedDelivery,
    String? imageUrl,
  }) =>
      TrackingUpdateModel(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        description: description ?? this.description,
        location: location ?? this.location,
        carrierName: carrierName ?? this.carrierName,
        estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  List<Object?> get props => [
        id,
        timestamp,
        status,
        description,
        location,
        carrierName,
        estimatedDelivery,
        imageUrl,
      ];
}

/// Common tracking statuses
class TrackingStatuses {
  static const String orderPlaced = 'order_placed';
  static const String orderConfirmed = 'order_confirmed';
  static const String processing = 'processing';
  static const String shipped = 'shipped';
  static const String inTransit = 'in_transit';
  static const String outForDelivery = 'out_for_delivery';
  static const String delivered = 'delivered';
  static const String attemptedDelivery = 'attempted_delivery';
  static const String exception = 'exception';
  static const String returned = 'returned';

  static const List<String> all = [
    orderPlaced,
    orderConfirmed,
    processing,
    shipped,
    inTransit,
    outForDelivery,
    delivered,
    attemptedDelivery,
    exception,
    returned,
  ];

  /// Get human-readable description for status
  static String getDescription(String status) {
    switch (status) {
      case orderPlaced:
        return 'Order has been placed';
      case orderConfirmed:
        return 'Order confirmed by merchant';
      case processing:
        return 'Order is being processed';
      case shipped:
        return 'Package has been shipped';
      case inTransit:
        return 'Package is in transit';
      case outForDelivery:
        return 'Out for delivery';
      case delivered:
        return 'Package delivered';
      case attemptedDelivery:
        return 'Delivery attempted';
      case exception:
        return 'Delivery exception occurred';
      case returned:
        return 'Package returned to sender';
      default:
        return 'Status update';
    }
  }
}
