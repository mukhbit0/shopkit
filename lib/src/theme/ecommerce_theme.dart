import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// Comprehensive theme extension for e-commerce widgets
class ECommerceTheme extends ThemeExtension<ECommerceTheme> {
  const ECommerceTheme({
    this.primaryColor = const Color(0xFF2563EB),
    this.secondaryColor = const Color(0xFF10B981),
    this.errorColor = const Color(0xFFEF4444),
    this.warningColor = const Color(0xFFF59E0B),
    this.successColor = const Color(0xFF10B981),
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.surfaceColor = Colors.white,
    this.onSurfaceColor = const Color(0xFF1F2937),
    this.cardRadius = 12.0,
    this.cardElevation = 2.0,
    this.cardShadowColor,
    this.buttonRadius = 8.0,
    this.buttonHeight = 48.0,
    this.spacing = 16.0,
    this.productCardAspectRatio = 0.75,
    this.animationDuration = const Duration(milliseconds: 200),
    this.priceTextStyle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.buttonTextStyle,
    this.gradientColors,
    this.borderColor,
    this.dividerColor,
    this.iconColor,
    this.disabledColor,
    this.hoverColor,
    this.focusColor,
  });

  /// Primary brand color
  final Color primaryColor;

  /// Secondary accent color
  final Color secondaryColor;

  /// Error state color
  final Color errorColor;

  /// Warning state color
  final Color warningColor;

  /// Success state color
  final Color successColor;

  /// Background color for screens
  final Color backgroundColor;

  /// Surface color for cards and panels
  final Color surfaceColor;

  /// Text color on surfaces
  final Color onSurfaceColor;

  /// Border radius for cards
  final double cardRadius;

  /// Elevation for cards
  final double cardElevation;

  /// Shadow color for cards
  final Color? cardShadowColor;

  /// Border radius for buttons
  final double buttonRadius;

  /// Standard button height
  final double buttonHeight;

  /// Standard spacing unit
  final double spacing;

  /// Aspect ratio for product cards
  final double productCardAspectRatio;

  /// Standard animation duration
  final Duration animationDuration;

  /// Text style for prices
  final TextStyle? priceTextStyle;

  /// Text style for titles
  final TextStyle? titleTextStyle;

  /// Text style for subtitles
  final TextStyle? subtitleTextStyle;

  /// Text style for buttons
  final TextStyle? buttonTextStyle;

  /// Gradient colors for buttons/backgrounds
  final List<Color>? gradientColors;

  /// Border color for inputs and dividers
  final Color? borderColor;

  /// Divider color
  final Color? dividerColor;

  /// Icon color
  final Color? iconColor;

  /// Disabled state color
  final Color? disabledColor;

  /// Hover state color
  final Color? hoverColor;

  /// Focus state color
  final Color? focusColor;

  /// Light theme preset
  static const ECommerceTheme light = ECommerceTheme(
    primaryColor: Color(0xFF2563EB),
    secondaryColor: Color(0xFF10B981),
    backgroundColor: Color(0xFFFAFAFA),
    surfaceColor: Colors.white,
    onSurfaceColor: Color(0xFF1F2937),
    borderColor: Color(0xFFE5E7EB),
    dividerColor: Color(0xFFE5E7EB),
    iconColor: Color(0xFF6B7280),
    disabledColor: Color(0xFF9CA3AF),
    hoverColor: Color(0xFFF3F4F6),
    focusColor: Color(0xFFDBEAFE),
  );

  /// Dark theme preset
  static const ECommerceTheme dark = ECommerceTheme(
    primaryColor: Color(0xFF3B82F6),
    secondaryColor: Color(0xFF059669),
    backgroundColor: Color(0xFF111827),
    surfaceColor: Color(0xFF1F2937),
    onSurfaceColor: Color(0xFFF9FAFB),
    borderColor: Color(0xFF374151),
    dividerColor: Color(0xFF374151),
    iconColor: Color(0xFF9CA3AF),
    disabledColor: Color(0xFF6B7280),
    hoverColor: Color(0xFF374151),
    focusColor: Color(0xFF1E40AF),
  );

  /// Premium theme with gradients
  static const ECommerceTheme premium = ECommerceTheme(
    primaryColor: Color(0xFF7C3AED),
    secondaryColor: Color(0xFFEC4899),
    backgroundColor: Color(0xFFFAFAFA),
    surfaceColor: Colors.white,
    onSurfaceColor: Color(0xFF1F2937),
    cardRadius: 16.0,
    buttonRadius: 12.0,
    gradientColors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
  );

  /// Get effective border color
  Color get effectiveBorderColor =>
      borderColor ?? onSurfaceColor.withValues(alpha: 0.12);

  /// Get effective divider color
  Color get effectiveDividerColor =>
      dividerColor ?? onSurfaceColor.withValues(alpha: 0.12);

  /// Get effective icon color
  Color get effectiveIconColor =>
      iconColor ?? onSurfaceColor.withValues(alpha: 0.6);

  /// Get effective disabled color
  Color get effectiveDisabledColor =>
      disabledColor ?? onSurfaceColor.withValues(alpha: 0.38);

  /// Get effective hover color
  Color get effectiveHoverColor =>
      hoverColor ?? primaryColor.withValues(alpha: 0.04);

  /// Get effective focus color
  Color get effectiveFocusColor =>
      focusColor ?? primaryColor.withValues(alpha: 0.12);

  /// Get effective card shadow color
  Color get effectiveCardShadowColor =>
      cardShadowColor ?? Colors.black.withValues(alpha: 0.1);

  /// Default price text style
  TextStyle get defaultPriceTextStyle =>
      priceTextStyle ??
      TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      );

  /// Default title text style
  TextStyle get defaultTitleTextStyle =>
      titleTextStyle ??
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onSurfaceColor,
      );

  /// Default subtitle text style
  TextStyle get defaultSubtitleTextStyle =>
      subtitleTextStyle ??
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor.withValues(alpha: 0.7),
      );

  /// Default button text style
  TextStyle get defaultButtonTextStyle =>
      buttonTextStyle ??
      const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  /// Create gradient decoration if gradient colors are provided
  BoxDecoration? get gradientDecoration {
    if (gradientColors == null || gradientColors!.length < 2) return null;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColors!,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(buttonRadius),
    );
  }

  /// Standard card decoration
  BoxDecoration get cardDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: effectiveCardShadowColor,
            blurRadius: cardElevation * 2,
            offset: Offset(0, cardElevation),
          ),
        ],
      );

  /// Input field decoration
  InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: errorColor),
        ),
        filled: true,
        fillColor: surfaceColor,
      );

  /// Primary button style
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        minimumSize: Size.fromHeight(buttonHeight),
        textStyle: defaultButtonTextStyle,
      );

  /// Secondary button style
  ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        minimumSize: Size.fromHeight(buttonHeight),
        textStyle: defaultButtonTextStyle.copyWith(color: primaryColor),
      );

  /// Text button style
  ButtonStyle get textButtonStyle => TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        minimumSize: Size.fromHeight(buttonHeight),
        textStyle: defaultButtonTextStyle.copyWith(color: primaryColor),
      );

  @override
  ECommerceTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? errorColor,
    Color? warningColor,
    Color? successColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? onSurfaceColor,
    double? cardRadius,
    double? cardElevation,
    Color? cardShadowColor,
    double? buttonRadius,
    double? buttonHeight,
    double? spacing,
    double? productCardAspectRatio,
    Duration? animationDuration,
    TextStyle? priceTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? buttonTextStyle,
    List<Color>? gradientColors,
    Color? borderColor,
    Color? dividerColor,
    Color? iconColor,
    Color? disabledColor,
    Color? hoverColor,
    Color? focusColor,
  }) {
    return ECommerceTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      successColor: successColor ?? this.successColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      cardRadius: cardRadius ?? this.cardRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      spacing: spacing ?? this.spacing,
      productCardAspectRatio:
          productCardAspectRatio ?? this.productCardAspectRatio,
      animationDuration: animationDuration ?? this.animationDuration,
      priceTextStyle: priceTextStyle ?? this.priceTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      gradientColors: gradientColors ?? this.gradientColors,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      iconColor: iconColor ?? this.iconColor,
      disabledColor: disabledColor ?? this.disabledColor,
      hoverColor: hoverColor ?? this.hoverColor,
      focusColor: focusColor ?? this.focusColor,
    );
  }

  @override
  ECommerceTheme lerp(ThemeExtension<ECommerceTheme>? other, double t) {
    if (other is! ECommerceTheme) return this;

    return ECommerceTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
      cardShadowColor: Color.lerp(cardShadowColor, other.cardShadowColor, t),
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      productCardAspectRatio:
          lerpDouble(productCardAspectRatio, other.productCardAspectRatio, t)!,
      animationDuration: other.animationDuration,
      priceTextStyle: TextStyle.lerp(priceTextStyle, other.priceTextStyle, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      subtitleTextStyle:
          TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t),
      buttonTextStyle:
          TextStyle.lerp(buttonTextStyle, other.buttonTextStyle, t),
      gradientColors: t < 0.5 ? gradientColors : other.gradientColors,
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t),
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t),
      focusColor: Color.lerp(focusColor, other.focusColor, t),
    );
  }
}

/// Extension to easily access ECommerceTheme from BuildContext
extension ECommerceThemeExtension on BuildContext {
  ECommerceTheme get ecommerceTheme =>
      Theme.of(this).extension<ECommerceTheme>() ?? const ECommerceTheme();
}
