import 'package:equatable/equatable.dart';

/// Model representing a popup for marketing or alerts
class PopupModel extends Equatable {
  const PopupModel({
    required this.id,
    required this.title,
    required this.message,
    this.actionText,
    this.actionUrl,
    this.discountCode,
    this.imageUrl,
    this.type = PopupType.exitIntent,
    this.triggerDelay,
    this.isModal = true,
    this.position = PopupPosition.center,
  });

  /// Unique identifier for the popup
  final String id;

  /// Popup title
  final String title;

  /// Main message content
  final String message;

  /// Optional action button text
  final String? actionText;

  /// Optional action URL or route
  final String? actionUrl;

  /// Optional discount code to display
  final String? discountCode;

  /// Optional image URL for visual appeal
  final String? imageUrl;

  /// Type of popup trigger
  final PopupType type;

  /// Delay before showing popup (in seconds)
  final int? triggerDelay;

  /// Whether popup should be modal (blocking)
  final bool isModal;

  /// Position of the popup on screen
  final PopupPosition position;

  /// Convenience getters for widget compatibility
  String? get content => message;
  String? get headline => title;
  String? get backgroundColor => null;
  String? get textColor => null;
  String? get buttonText => actionText;
  String? get buttonColor => null;
  String? get buttonTextColor => null;
  String? get secondaryButtonText => null;
  String? get discount => discountCode;
  bool? get urgencyTimer => false;
  DateTime? get startDate => null;
  DateTime? get endDate => null;

  /// Create PopupModel from JSON
  factory PopupModel.fromJson(Map<String, dynamic> json) => PopupModel(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        actionText: json['actionText'] as String?,
        actionUrl: json['actionUrl'] as String?,
        discountCode: json['discountCode'] as String?,
        imageUrl: json['imageUrl'] as String?,
        type: PopupType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => PopupType.exitIntent,
        ),
        triggerDelay: json['triggerDelay'] as int?,
        isModal: json['isModal'] as bool? ?? true,
        position: PopupPosition.values.firstWhere(
          (e) => e.toString().split('.').last == json['position'],
          orElse: () => PopupPosition.center,
        ),
      );

  /// Convert PopupModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'actionText': actionText,
        'actionUrl': actionUrl,
        'discountCode': discountCode,
        'imageUrl': imageUrl,
        'type': type.toString().split('.').last,
        'triggerDelay': triggerDelay,
        'isModal': isModal,
        'position': position.toString().split('.').last,
      };

  /// Create a copy with modified properties
  PopupModel copyWith({
    String? id,
    String? title,
    String? message,
    String? actionText,
    String? actionUrl,
    String? discountCode,
    String? imageUrl,
    PopupType? type,
    int? triggerDelay,
    bool? isModal,
    PopupPosition? position,
  }) =>
      PopupModel(
        id: id ?? this.id,
        title: title ?? this.title,
        message: message ?? this.message,
        actionText: actionText ?? this.actionText,
        actionUrl: actionUrl ?? this.actionUrl,
        discountCode: discountCode ?? this.discountCode,
        imageUrl: imageUrl ?? this.imageUrl,
        type: type ?? this.type,
        triggerDelay: triggerDelay ?? this.triggerDelay,
        isModal: isModal ?? this.isModal,
        position: position ?? this.position,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        actionText,
        actionUrl,
        discountCode,
        imageUrl,
        type,
        triggerDelay,
        isModal,
        position,
      ];
}

/// Types of popup triggers
enum PopupType {
  exitIntent,
  timeDelay,
  scrollPercentage,
  cartAbandonment,
  promotion,
  newsletter,
  pageVisit,
}

/// Popup positions on screen
enum PopupPosition {
  center,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topCenter,
  bottomCenter,
}
