import 'package:equatable/equatable.dart';

/// Model representing an image with metadata
class ImageModel extends Equatable {
  const ImageModel({
    required this.id,
    required this.url,
    this.altText,
    this.caption,
    this.width,
    this.height,
    this.fileSize,
    this.format,
    this.isThumbnail = false,
    this.priority = 0,
    this.sortOrder,
    this.colorPalette,
    this.dominantColor,
    this.isContentSensitive = false,
    this.tags,
  });

  /// Create ImageModel from JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json['id'] as String,
        url: json['url'] as String,
        altText: json['altText'] as String?,
        caption: json['caption'] as String?,
        width: json['width'] as int?,
        height: json['height'] as int?,
        fileSize: json['fileSize'] as int?,
        format: json['format'] as String?,
        isThumbnail: json['isThumbnail'] as bool? ?? false,
        priority: json['priority'] as int? ?? 0,
        sortOrder: json['sortOrder'] as int?,
        colorPalette: (json['colorPalette'] as List<dynamic>?)?.cast<String>(),
        dominantColor: json['dominantColor'] as String?,
        isContentSensitive: json['isContentSensitive'] as bool? ?? false,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      );

  /// Unique image identifier
  final String id;

  /// Image URL or asset path
  final String url;

  /// Alternative text for accessibility
  final String? altText;

  /// Image caption or description
  final String? caption;

  /// Image width in pixels
  final int? width;

  /// Image height in pixels
  final int? height;

  /// Image file size in bytes
  final int? fileSize;

  /// Image format (jpg, png, webp, etc.)
  final String? format;

  /// Whether this is a thumbnail image
  final bool isThumbnail;

  /// Priority for loading (higher = load first)
  final int priority;

  /// Sort order for display in galleries
  final int? sortOrder;

  /// Color palette extracted from image (hex codes)
  final List<String>? colorPalette;

  /// Dominant color from the image (hex code)
  final String? dominantColor;

  /// Whether image contains sensitive content
  final bool isContentSensitive;

  /// Image tags for categorization
  final List<String>? tags;

  /// Get image aspect ratio
  double? get aspectRatio {
    if (width == null || height == null) return null;
    return width! / height!;
  }

  /// Check if image is landscape orientation
  bool get isLandscape {
    final ratio = aspectRatio;
    return ratio != null && ratio > 1.0;
  }

  /// Check if image is portrait orientation
  bool get isPortrait {
    final ratio = aspectRatio;
    return ratio != null && ratio < 1.0;
  }

  /// Check if image is square
  bool get isSquare {
    final ratio = aspectRatio;
    return ratio != null && (ratio - 1.0).abs() < 0.1;
  }

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSize == null) return '';

    if (fileSize! < 1024) {
      return '${fileSize}B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// Get image dimensions as string
  String get dimensionsString {
    if (width == null || height == null) return '';
    return '${width}x$height';
  }

  /// Check if image has metadata
  bool get hasMetadata => width != null || height != null || fileSize != null;

  /// Check if image has color information
  bool get hasColorInfo => colorPalette != null || dominantColor != null;

  /// Convert ImageModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'altText': altText,
        'caption': caption,
        'width': width,
        'height': height,
        'fileSize': fileSize,
        'format': format,
        'isThumbnail': isThumbnail,
        'priority': priority,
        'sortOrder': sortOrder,
        'colorPalette': colorPalette,
        'dominantColor': dominantColor,
        'isContentSensitive': isContentSensitive,
        'tags': tags,
      };

  /// Create a copy with modified properties
  ImageModel copyWith({
    String? id,
    String? url,
    String? altText,
    String? caption,
    int? width,
    int? height,
    int? fileSize,
    String? format,
    bool? isThumbnail,
    int? priority,
    int? sortOrder,
    List<String>? colorPalette,
    String? dominantColor,
    bool? isContentSensitive,
    List<String>? tags,
  }) =>
      ImageModel(
        id: id ?? this.id,
        url: url ?? this.url,
        altText: altText ?? this.altText,
        caption: caption ?? this.caption,
        width: width ?? this.width,
        height: height ?? this.height,
        fileSize: fileSize ?? this.fileSize,
        format: format ?? this.format,
        isThumbnail: isThumbnail ?? this.isThumbnail,
        priority: priority ?? this.priority,
        sortOrder: sortOrder ?? this.sortOrder,
        colorPalette: colorPalette ?? this.colorPalette,
        dominantColor: dominantColor ?? this.dominantColor,
        isContentSensitive: isContentSensitive ?? this.isContentSensitive,
        tags: tags ?? this.tags,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        url,
        altText,
        caption,
        width,
        height,
        fileSize,
        format,
        isThumbnail,
        priority,
        sortOrder,
        colorPalette,
        dominantColor,
        isContentSensitive,
        tags,
      ];
}
