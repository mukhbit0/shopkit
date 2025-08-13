import 'package:equatable/equatable.dart';

/// Model representing social sharing information
class ShareModel extends Equatable {
  const ShareModel({
    required this.id,
    required this.platform,
    required this.url,
    this.text,
    this.imageUrl,
    this.hashtags,
    this.via,
  });

  /// Unique identifier for the share
  final String id;

  /// Social media platform (facebook, twitter, instagram, etc.)
  final String platform;

  /// URL to share
  final String url;

  /// Optional text content to share
  final String? text;

  /// Optional image URL to share
  final String? imageUrl;

  /// Optional hashtags for the share
  final List<String>? hashtags;

  /// Optional "via" attribution (typically for Twitter)
  final String? via;

  /// Get formatted share URL for the platform
  String get shareUrl {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}';
      case 'twitter':
        final tweetText = text ?? '';
        final hashtag = hashtags?.isNotEmpty == true
            ? ' ${hashtags!.map((h) => '#$h').join(' ')}'
            : '';
        final viaText = via != null ? ' via @$via' : '';
        return 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$tweetText$hashtag$viaText')}&url=${Uri.encodeComponent(url)}';
      case 'linkedin':
        return 'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(url)}';
      case 'pinterest':
        final description = text ?? '';
        final media = imageUrl ?? '';
        return 'https://pinterest.com/pin/create/button/?url=${Uri.encodeComponent(url)}&media=${Uri.encodeComponent(media)}&description=${Uri.encodeComponent(description)}';
      case 'whatsapp':
        final message = text != null ? '$text $url' : url;
        return 'https://wa.me/?text=${Uri.encodeComponent(message)}';
      case 'telegram':
        return 'https://t.me/share/url?url=${Uri.encodeComponent(url)}&text=${Uri.encodeComponent(text ?? '')}';
      default:
        return url;
    }
  }

  /// Create ShareModel from JSON
  factory ShareModel.fromJson(Map<String, dynamic> json) => ShareModel(
        id: json['id'] as String,
        platform: json['platform'] as String,
        url: json['url'] as String,
        text: json['text'] as String?,
        imageUrl: json['imageUrl'] as String?,
        hashtags: (json['hashtags'] as List<dynamic>?)?.cast<String>(),
        via: json['via'] as String?,
      );

  /// Convert ShareModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'platform': platform,
        'url': url,
        'text': text,
        'imageUrl': imageUrl,
        'hashtags': hashtags,
        'via': via,
      };

  /// Create a copy with modified properties
  ShareModel copyWith({
    String? id,
    String? platform,
    String? url,
    String? text,
    String? imageUrl,
    List<String>? hashtags,
    String? via,
  }) =>
      ShareModel(
        id: id ?? this.id,
        platform: platform ?? this.platform,
        url: url ?? this.url,
        text: text ?? this.text,
        imageUrl: imageUrl ?? this.imageUrl,
        hashtags: hashtags ?? this.hashtags,
        via: via ?? this.via,
      );

  /// Convenience getters for widget compatibility
  String? get type => platform;

  /// Generate share URL for the given platform
  String generateShareUrl({String? customText, String? customUrl}) {
    final shareText = customText ?? text ?? '';
    final shareUrl = customUrl ?? url;

    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareUrl)}';
      case 'twitter':
        final hashtag = hashtags?.isNotEmpty == true
            ? ' ${hashtags!.map((h) => '#$h').join(' ')}'
            : '';
        final viaText = via != null ? ' via @$via' : '';
        return 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$shareText$hashtag$viaText')}&url=${Uri.encodeComponent(shareUrl)}';
      case 'linkedin':
        return 'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(shareUrl)}';
      case 'pinterest':
        final media = imageUrl ?? '';
        return 'https://pinterest.com/pin/create/button/?url=${Uri.encodeComponent(shareUrl)}&media=${Uri.encodeComponent(media)}&description=${Uri.encodeComponent(shareText)}';
      case 'whatsapp':
        return 'https://wa.me/?text=${Uri.encodeComponent('$shareText $shareUrl')}';
      default:
        return shareUrl;
    }
  }

  @override
  List<Object?> get props => [
        id,
        platform,
        url,
        text,
        imageUrl,
        hashtags,
        via,
      ];
}

/// Predefined social media platforms
class SocialPlatforms {
  static const String facebook = 'facebook';
  static const String twitter = 'twitter';
  static const String linkedin = 'linkedin';
  static const String pinterest = 'pinterest';
  static const String whatsapp = 'whatsapp';
  static const String telegram = 'telegram';
  static const String instagram = 'instagram';
  static const String tiktok = 'tiktok';
  static const String reddit = 'reddit';
  static const String email = 'email';

  static const List<String> all = [
    facebook,
    twitter,
    linkedin,
    pinterest,
    whatsapp,
    telegram,
    instagram,
    tiktok,
    reddit,
    email,
  ];
}
