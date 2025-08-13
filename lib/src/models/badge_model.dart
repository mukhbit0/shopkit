import 'package:equatable/equatable.dart';

/// Model representing a trust badge for security and credibility
class BadgeModel extends Equatable {
  const BadgeModel({
    required this.id,
    required this.url,
    required this.altText,
    this.link,
    this.width,
    this.height,
    this.position = BadgePosition.footer,
  });

  /// Unique identifier for the badge
  final String id;

  /// Badge image URL
  final String url;

  /// Alt text for accessibility
  final String altText;

  /// Optional info link when badge is tapped
  final String? link;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  /// Position where badge should be displayed
  final BadgePosition position;

  /// Convenience getters for widget compatibility
  String get imageUrl => url;
  String? get name => altText;
  String? get type => position.toString().split('.').last;
  String? get description => altText;
  String? get backgroundColor => null;
  String? get borderColor => null;
  String? get textColor => null;

  /// Create BadgeModel from JSON
  factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
        id: json['id'] as String,
        url: json['url'] as String,
        altText: json['altText'] as String,
        link: json['link'] as String?,
        width: (json['width'] as num?)?.toDouble(),
        height: (json['height'] as num?)?.toDouble(),
        position: BadgePosition.values.firstWhere(
          (e) => e.toString().split('.').last == json['position'],
          orElse: () => BadgePosition.footer,
        ),
      );

  /// Convert BadgeModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'altText': altText,
        'link': link,
        'width': width,
        'height': height,
        'position': position.toString().split('.').last,
      };

  /// Create a copy with modified properties
  BadgeModel copyWith({
    String? id,
    String? url,
    String? altText,
    String? link,
    double? width,
    double? height,
    BadgePosition? position,
  }) =>
      BadgeModel(
        id: id ?? this.id,
        url: url ?? this.url,
        altText: altText ?? this.altText,
        link: link ?? this.link,
        width: width ?? this.width,
        height: height ?? this.height,
        position: position ?? this.position,
      );

  @override
  List<Object?> get props => [
        id,
        url,
        altText,
        link,
        width,
        height,
        position,
      ];
}

/// Enumeration of badge positions
enum BadgePosition {
  header,
  footer,
  sidebar,
  checkout,
  floating,
}
