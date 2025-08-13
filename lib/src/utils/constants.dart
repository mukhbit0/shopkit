// constants.dart
import 'package:flutter/material.dart';

class ShopKitConstants {
  static const String packageName = 'shopkit';
  static const String version = '1.0.0';
  
  // Default values
  static const String defaultCurrency = 'USD';
  static const String defaultLocale = 'en_US';
  static const int defaultPageSize = 20;
  static const int defaultMaxSuggestions = 5;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Common spacing values
  static const double spacing2xs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;
  
  // Common border radius values
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 9999.0;
  
  // Shadow elevations
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  
  // Font weights
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  // Rating constraints
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Cart constraints
  static const int minQuantity = 1;
  static const int maxQuantity = 999;
  
  // Image constraints
  static const double maxImageSize = 2048;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}

// formatters.dart
class ShopKitFormatters {
  /// Format price with currency symbol
  static String formatPrice(double price, String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${price.toStringAsFixed(0)}';
      case 'INR':
        return '₹${price.toStringAsFixed(2)}';
      case 'CNY':
        return '¥${price.toStringAsFixed(2)}';
      case 'CAD':
        return 'C\$${price.toStringAsFixed(2)}';
      case 'AUD':
        return 'A\$${price.toStringAsFixed(2)}';
      default:
        return '$currency ${price.toStringAsFixed(2)}';
    }
  }

  /// Format large numbers (e.g., 1000 -> 1K)
  static String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
  }

  /// Format rating display
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Format discount percentage
  static String formatDiscountPercentage(double percentage) {
    return '${percentage.round()}% OFF';
  }

  /// Format date relative to now
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// Format phone number
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    
    return phone; // Return original if format not recognized
  }
}

// validators.dart
class ShopKitValidators {
  /// Validate email address
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validate phone number
  static bool isValidPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 10 && digits.length <= 15;
  }

  /// Validate credit card number (basic Luhn algorithm)
  static bool isValidCreditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length < 13 || digits.length > 19) {
      return false;
    }
    
    int sum = 0;
    bool alternate = false;
    
    for (int i = digits.length - 1; i >= 0; i--) {
      int digit = int.parse(digits[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  /// Validate postal code based on country
  static bool isValidPostalCode(String postalCode, String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'US':
        return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(postalCode);
      case 'CA':
        return RegExp(r'^[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d$').hasMatch(postalCode);
      case 'UK':
      case 'GB':
        return RegExp(r'^[A-Za-z]{1,2}\d[A-Za-z\d]?\s?\d[A-Za-z]{2}$').hasMatch(postalCode);
      case 'DE':
        return RegExp(r'^\d{5}$').hasMatch(postalCode);
      case 'FR':
        return RegExp(r'^\d{5}$').hasMatch(postalCode);
      default:
        return postalCode.isNotEmpty && postalCode.length >= 3;
    }
  }

  /// Validate price (positive number with max 2 decimal places)
  static bool isValidPrice(String price) {
    try {
      final value = double.parse(price);
      return value >= 0 && RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(price);
    } catch (e) {
      return false;
    }
  }

  /// Validate quantity
  static bool isValidQuantity(int quantity, {int min = 1, int max = 999}) {
    return quantity >= min && quantity <= max;
  }

  /// Validate rating (1-5 scale)
  static bool isValidRating(double rating) {
    return rating >= ShopKitConstants.minRating && 
           rating <= ShopKitConstants.maxRating;
  }

  /// Validate required string field
  static bool isValidRequiredString(String? value, {int minLength = 1}) {
    return value != null && value.trim().length >= minLength;
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  /// Validate image URL (checks for supported formats)
  static bool isValidImageUrl(String url) {
    if (!isValidUrl(url)) return false;
    
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    
    return ShopKitConstants.supportedImageFormats.any(
      (format) => path.endsWith('.$format'),
    );
  }

  /// Validate SKU format (alphanumeric with dashes/underscores)
  static bool isValidSku(String sku) {
    return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(sku) && sku.length <= 50;
  }

  /// Validate hex color
  static bool isValidHexColor(String color) {
    return RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$').hasMatch(color);
  }

  /// Get validation error message for email
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Please enter a valid email address';
    return null;
  }

  /// Get validation error message for phone
  static String? getPhoneError(String phone) {
    if (phone.isEmpty) return 'Phone number is required';
    if (!isValidPhoneNumber(phone)) return 'Please enter a valid phone number';
    return null;
  }

  /// Get validation error message for price
  static String? getPriceError(String price) {
    if (price.isEmpty) return 'Price is required';
    if (!isValidPrice(price)) return 'Please enter a valid price';
    return null;
  }

  /// Get validation error message for required field
  static String? getRequiredFieldError(String? value, String fieldName) {
    if (!isValidRequiredString(value)) {
      return '$fieldName is required';
    }
    return null;
  }
}