import 'package:equatable/equatable.dart';

/// Enum representing notification types
enum NotificationType {
  backInStock,
  priceDropAlert,
  orderUpdate,
  promocode,
  newsletter,
  recommendation,
  review,
  wishlist
}

/// Extension for NotificationType display names
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.backInStock:
        return 'Back in Stock';
      case NotificationType.priceDropAlert:
        return 'Price Drop Alert';
      case NotificationType.orderUpdate:
        return 'Order Update';
      case NotificationType.promocode:
        return 'Promo Code';
      case NotificationType.newsletter:
        return 'Newsletter';
      case NotificationType.recommendation:
        return 'Product Recommendation';
      case NotificationType.review:
        return 'Review Reminder';
      case NotificationType.wishlist:
        return 'Wishlist Update';
    }
  }
}

/// Model representing a user notification preference or subscription
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.email,
    required this.createdAt,
    this.productId,
    this.phone,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.pushEnabled = false,
    this.isActive = true,
    this.lastNotifiedAt,
    this.notificationCount = 0,
    this.maxNotifications,
    this.priceThreshold,
    this.metadata,
  });

  /// Create NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        productId: json['productId'] as String?,
        type: NotificationType.values.firstWhere(
          (NotificationType e) => e.toString().split('.').last == json['type'],
        ),
        email: json['email'] as String,
        phone: json['phone'] as String?,
        emailEnabled: json['emailEnabled'] as bool? ?? true,
        smsEnabled: json['smsEnabled'] as bool? ?? false,
        pushEnabled: json['pushEnabled'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isActive: json['isActive'] as bool? ?? true,
        lastNotifiedAt: json['lastNotifiedAt'] != null
            ? DateTime.parse(json['lastNotifiedAt'] as String)
            : null,
        notificationCount: json['notificationCount'] as int? ?? 0,
        maxNotifications: json['maxNotifications'] as int?,
        priceThreshold: (json['priceThreshold'] as num?)?.toDouble(),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique notification identifier
  final String id;

  /// User ID this notification belongs to
  final String userId;

  /// Product ID (if product-specific notification)
  final String? productId;

  /// Notification type
  final NotificationType type;

  /// User's email for notifications
  final String email;

  /// User's phone for SMS notifications (optional)
  final String? phone;

  /// Whether email notifications are enabled
  final bool emailEnabled;

  /// Whether SMS notifications are enabled
  final bool smsEnabled;

  /// Whether push notifications are enabled
  final bool pushEnabled;

  /// When the notification was created/subscribed
  final DateTime createdAt;

  /// Whether the notification is currently active
  final bool isActive;

  /// When the notification was last triggered
  final DateTime? lastNotifiedAt;

  /// How many times this notification has been sent
  final int notificationCount;

  /// Maximum number of notifications to send
  final int? maxNotifications;

  /// Price threshold for price drop alerts
  final double? priceThreshold;

  /// Additional metadata for the notification
  final Map<String, dynamic>? metadata;

  /// Check if notification can be sent (not exceeded max)
  bool get canNotify {
    if (!isActive) return false;
    if (maxNotifications == null) return true;
    return notificationCount < maxNotifications!;
  }

  /// Check if any notification method is enabled
  bool get hasEnabledMethods => emailEnabled || smsEnabled || pushEnabled;

  /// Check if notification is product-specific
  bool get isProductSpecific => productId != null;

  /// Get days since last notification
  int get daysSinceLastNotification {
    if (lastNotifiedAt == null) return -1;
    return DateTime.now().difference(lastNotifiedAt!).inDays;
  }

  /// Check if notification should throttle (recently sent)
  bool get shouldThrottle {
    if (lastNotifiedAt == null) return false;

    // Different throttling rules by type
    switch (type) {
      case NotificationType.backInStock:
        return daysSinceLastNotification < 1; // Once per day max
      case NotificationType.priceDropAlert:
        return daysSinceLastNotification < 1; // Once per day max
      case NotificationType.orderUpdate:
        return false; // No throttling for order updates
      case NotificationType.promocode:
        return daysSinceLastNotification < 7; // Once per week max
      case NotificationType.newsletter:
        return daysSinceLastNotification < 7; // Once per week max
      case NotificationType.recommendation:
        return daysSinceLastNotification < 3; // Every 3 days max
      case NotificationType.review:
        return daysSinceLastNotification < 14; // Every 2 weeks max
      case NotificationType.wishlist:
        return daysSinceLastNotification < 7; // Once per week max
    }
  }

  /// Convert NotificationModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'productId': productId,
        'type': type.toString().split('.').last,
        'email': email,
        'phone': phone,
        'emailEnabled': emailEnabled,
        'smsEnabled': smsEnabled,
        'pushEnabled': pushEnabled,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
        'lastNotifiedAt': lastNotifiedAt?.toIso8601String(),
        'notificationCount': notificationCount,
        'maxNotifications': maxNotifications,
        'priceThreshold': priceThreshold,
        'metadata': metadata,
      };

  /// Create a copy with modified properties
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? productId,
    NotificationType? type,
    String? email,
    String? phone,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? pushEnabled,
    DateTime? createdAt,
    bool? isActive,
    DateTime? lastNotifiedAt,
    int? notificationCount,
    int? maxNotifications,
    double? priceThreshold,
    Map<String, dynamic>? metadata,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        type: type ?? this.type,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        emailEnabled: emailEnabled ?? this.emailEnabled,
        smsEnabled: smsEnabled ?? this.smsEnabled,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
        lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
        notificationCount: notificationCount ?? this.notificationCount,
        maxNotifications: maxNotifications ?? this.maxNotifications,
        priceThreshold: priceThreshold ?? this.priceThreshold,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        productId,
        type,
        email,
        phone,
        emailEnabled,
        smsEnabled,
        pushEnabled,
        createdAt,
        isActive,
        lastNotifiedAt,
        notificationCount,
        maxNotifications,
        priceThreshold,
        metadata,
      ];
}
