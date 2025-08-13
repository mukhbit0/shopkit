import 'package:equatable/equatable.dart';

/// Enum representing announcement types
enum AnnouncementType {
  promotion,
  sale,
  newProduct,
  shipping,
  maintenance,
  holiday,
  general
}

/// Extension for AnnouncementType styling
extension AnnouncementTypeExtension on AnnouncementType {
  String get displayName {
    switch (this) {
      case AnnouncementType.promotion:
        return 'Promotion';
      case AnnouncementType.sale:
        return 'Sale';
      case AnnouncementType.newProduct:
        return 'New Product';
      case AnnouncementType.shipping:
        return 'Shipping';
      case AnnouncementType.maintenance:
        return 'Maintenance';
      case AnnouncementType.holiday:
        return 'Holiday';
      case AnnouncementType.general:
        return 'General';
    }
  }

  /// Get appropriate icon for announcement type
  String get icon {
    switch (this) {
      case AnnouncementType.promotion:
        return '🎉';
      case AnnouncementType.sale:
        return '🏷️';
      case AnnouncementType.newProduct:
        return '✨';
      case AnnouncementType.shipping:
        return '🚚';
      case AnnouncementType.maintenance:
        return '🔧';
      case AnnouncementType.holiday:
        return '🎁';
      case AnnouncementType.general:
        return 'ℹ️';
    }
  }
}

/// Model representing an announcement or promotional banner
class AnnouncementModel extends Equatable {
  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = AnnouncementType.general,
    this.actionText,
    this.actionUrl,
    this.backgroundColor,
    this.textColor,
    this.iconUrl,
    this.startDate,
    this.endDate,
    this.priority = 0,
    this.isDismissible = true,
    this.autoHide = false,
    this.autoHideDuration,
    this.targetAudience,
    this.targetCountries,
    this.metadata,
  });

  /// Create AnnouncementModel from JSON
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: AnnouncementType.values.firstWhere(
          (AnnouncementType e) => e.toString().split('.').last == json['type'],
          orElse: () => AnnouncementType.general,
        ),
        actionText: json['actionText'] as String?,
        actionUrl: json['actionUrl'] as String?,
        backgroundColor: json['backgroundColor'] as String?,
        textColor: json['textColor'] as String?,
        iconUrl: json['iconUrl'] as String?,
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'] as String)
            : null,
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        priority: json['priority'] as int? ?? 0,
        isDismissible: json['isDismissible'] as bool? ?? true,
        autoHide: json['autoHide'] as bool? ?? false,
        autoHideDuration: json['autoHideDuration'] as int?,
        targetAudience: json['targetAudience'] as String?,
        targetCountries:
            (json['targetCountries'] as List<dynamic>?)?.cast<String>(),
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Unique announcement identifier
  final String id;

  /// Announcement title
  final String title;

  /// Announcement message/content
  final String message;

  /// Announcement type
  final AnnouncementType type;

  /// Call-to-action button text
  final String? actionText;

  /// Call-to-action URL or route
  final String? actionUrl;

  /// Background color for the announcement
  final String? backgroundColor;

  /// Text color for the announcement
  final String? textColor;

  /// Icon URL or emoji for the announcement
  final String? iconUrl;

  /// When the announcement starts showing
  final DateTime? startDate;

  /// When the announcement stops showing
  final DateTime? endDate;

  /// Priority level (higher = more important)
  final int priority;

  /// Whether the announcement can be dismissed
  final bool isDismissible;

  /// Whether the announcement should auto-hide
  final bool autoHide;

  /// Auto-hide duration in seconds
  final int? autoHideDuration;

  /// Target audience (all, new_users, premium, etc.)
  final String? targetAudience;

  /// Geographical targeting (country codes)
  final List<String>? targetCountries;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Check if announcement is currently active
  bool get isActive {
    final now = DateTime.now();

    // Check start date
    if (startDate != null && now.isBefore(startDate!)) {
      return false;
    }

    // Check end date
    if (endDate != null && now.isAfter(endDate!)) {
      return false;
    }

    return true;
  }

  /// Check if announcement has action button
  bool get hasAction => actionText != null && actionUrl != null;

  /// Check if announcement has custom styling
  bool get hasCustomStyling => backgroundColor != null || textColor != null;

  /// Check if announcement has icon
  bool get hasIcon => iconUrl != null;

  /// Get days until announcement expires
  int? get daysUntilExpiry {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;
    return endDate!.difference(now).inDays;
  }

  /// Check if announcement is expiring soon (within 24 hours)
  bool get isExpiringSoon {
    final days = daysUntilExpiry;
    return days != null && days <= 1;
  }

  /// Convert AnnouncementModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'message': message,
        'type': type.toString().split('.').last,
        'actionText': actionText,
        'actionUrl': actionUrl,
        'backgroundColor': backgroundColor,
        'textColor': textColor,
        'iconUrl': iconUrl,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'priority': priority,
        'isDismissible': isDismissible,
        'autoHide': autoHide,
        'autoHideDuration': autoHideDuration,
        'targetAudience': targetAudience,
        'targetCountries': targetCountries,
        'metadata': metadata,
      };

  /// Create a copy with modified properties
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? message,
    AnnouncementType? type,
    String? actionText,
    String? actionUrl,
    String? backgroundColor,
    String? textColor,
    String? iconUrl,
    DateTime? startDate,
    DateTime? endDate,
    int? priority,
    bool? isDismissible,
    bool? autoHide,
    int? autoHideDuration,
    String? targetAudience,
    List<String>? targetCountries,
    Map<String, dynamic>? metadata,
  }) =>
      AnnouncementModel(
        id: id ?? this.id,
        title: title ?? this.title,
        message: message ?? this.message,
        type: type ?? this.type,
        actionText: actionText ?? this.actionText,
        actionUrl: actionUrl ?? this.actionUrl,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        textColor: textColor ?? this.textColor,
        iconUrl: iconUrl ?? this.iconUrl,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        priority: priority ?? this.priority,
        isDismissible: isDismissible ?? this.isDismissible,
        autoHide: autoHide ?? this.autoHide,
        autoHideDuration: autoHideDuration ?? this.autoHideDuration,
        targetAudience: targetAudience ?? this.targetAudience,
        targetCountries: targetCountries ?? this.targetCountries,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        message,
        type,
        actionText,
        actionUrl,
        backgroundColor,
        textColor,
        iconUrl,
        startDate,
        endDate,
        priority,
        isDismissible,
        autoHide,
        autoHideDuration,
        targetAudience,
        targetCountries,
        metadata,
      ];
}
