import 'package:equatable/equatable.dart';

/// Model representing a customer review
class ReviewModel extends Equatable {
  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userAvatarUrl,
    this.title,
    this.updatedAt,
    this.imageUrls,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.isFlagged = false,
    this.merchantResponse,
    this.merchantResponseDate,
    this.variantInfo,
  });

  /// Create ReviewModel from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userAvatarUrl: json['userAvatarUrl'] as String?,
        productId: json['productId'] as String,
        rating: (json['rating'] as num).toDouble(),
        title: json['title'] as String?,
        comment: json['comment'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        imageUrls: (json['imageUrls'] as List<dynamic>?)?.cast<String>(),
        isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
        helpfulCount: json['helpfulCount'] as int? ?? 0,
        isFlagged: json['isFlagged'] as bool? ?? false,
        merchantResponse: json['merchantResponse'] as String?,
        merchantResponseDate: json['merchantResponseDate'] != null
            ? DateTime.parse(json['merchantResponseDate'] as String)
            : null,
        variantInfo: json['variantInfo'] as String?,
      );

  /// Unique review identifier
  final String id;

  /// ID of the user who wrote the review
  final String userId;

  /// Display name of the reviewer
  final String userName;

  /// User's avatar URL
  final String? userAvatarUrl;

  /// Product ID this review is for
  final String productId;

  /// Rating given (1-5 scale)
  final double rating;

  /// Review title/summary
  final String? title;

  /// Review comment/text
  final String comment;

  /// When the review was posted
  final DateTime createdAt;

  /// When the review was last updated
  final DateTime? updatedAt;

  /// Images attached to the review
  final List<String>? imageUrls;

  /// Whether the reviewer has a verified purchase
  final bool isVerifiedPurchase;

  /// Whether the review is helpful (upvoted)
  final int helpfulCount;

  /// Whether the review has been flagged
  final bool isFlagged;

  /// Store/merchant response to the review
  final String? merchantResponse;

  /// When merchant responded
  final DateTime? merchantResponseDate;

  /// Review variant information (what specific variant was reviewed)
  final String? variantInfo;

  /// Check if review has images
  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;

  /// Check if review has merchant response
  bool get hasMerchantResponse => merchantResponse != null;

  /// Check if review was recently posted (within 7 days)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;
    return difference <= 7;
  }

  /// Convenience getter for verified purchase status (alias)
  bool get verifiedPurchase => isVerifiedPurchase;

  /// Convenience getter for review date (alias for createdAt)
  DateTime get date => createdAt;

  /// Convenience getter for media URLs (alias for imageUrls)
  List<String>? get mediaUrls => imageUrls;

  /// Get formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  /// Get star rating as integer (for display purposes)
  int get starRating => rating.round();

  /// Check if rating is high (4+ stars)
  bool get isPositiveReview => rating >= 4.0;

  /// Check if rating is low (2 or fewer stars)
  bool get isNegativeReview => rating <= 2.0;

  /// Convert ReviewModel to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'userName': userName,
        'userAvatarUrl': userAvatarUrl,
        'productId': productId,
        'rating': rating,
        'title': title,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'imageUrls': imageUrls,
        'isVerifiedPurchase': isVerifiedPurchase,
        'helpfulCount': helpfulCount,
        'isFlagged': isFlagged,
        'merchantResponse': merchantResponse,
        'merchantResponseDate': merchantResponseDate?.toIso8601String(),
        'variantInfo': variantInfo,
      };

  /// Create a copy with modified properties
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? productId,
    double? rating,
    String? title,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    bool? isVerifiedPurchase,
    int? helpfulCount,
    bool? isFlagged,
    String? merchantResponse,
    DateTime? merchantResponseDate,
    String? variantInfo,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
        productId: productId ?? this.productId,
        rating: rating ?? this.rating,
        title: title ?? this.title,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        imageUrls: imageUrls ?? this.imageUrls,
        isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
        helpfulCount: helpfulCount ?? this.helpfulCount,
        isFlagged: isFlagged ?? this.isFlagged,
        merchantResponse: merchantResponse ?? this.merchantResponse,
        merchantResponseDate: merchantResponseDate ?? this.merchantResponseDate,
        variantInfo: variantInfo ?? this.variantInfo,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        userId,
        userName,
        userAvatarUrl,
        productId,
        rating,
        title,
        comment,
        createdAt,
        updatedAt,
        imageUrls,
        isVerifiedPurchase,
        helpfulCount,
        isFlagged,
        merchantResponse,
        merchantResponseDate,
        variantInfo,
      ];
}
