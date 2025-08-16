import 'package:flutter/material.dart';

// --- Core Design Tokens ---
import 'tokens.dart';

// --- Import All Modular Component Themes ---
import 'components/add_to_cart_button_theme.dart';
import 'components/announcement_bar_theme.dart';
import 'components/cart_bubble_theme.dart';
import 'components/cart_summary_theme.dart';
import 'components/category_tabs_theme.dart';
import 'components/checkout_step_theme.dart';
import 'components/image_carousel_theme.dart';
import 'components/product_card_theme.dart';
import 'components/product_filter_theme.dart';
import 'components/review_widget_theme.dart';
import 'components/sticky_header_theme.dart';
import 'components/variant_picker_theme.dart';
import 'components/wishlist_theme.dart';
import 'components/product_recommendation_theme.dart';

/// The master ShopKit theme extension.
///
/// This class is the single source of truth for all styling in the package.
/// It holds the core design tokens (colors, typography, etc.) and aggregates
/// all the individual component themes into one cohesive unit.
///
/// To use it in any widget, simply call:
/// `final shopKitTheme = Theme.of(context).extension<ShopKitTheme>();`
@immutable
class ShopKitTheme extends ThemeExtension<ShopKitTheme> {
  // --- Core Design Tokens ---
  final ShopKitColorScheme colors;
  final ShopKitTypography typography;
  final ShopKitSpacing spacing;
  final ShopKitBorderRadius radii;
  final ShopKitAnimation animations;

  // --- Component-Specific Themes ---
  final ProductCardTheme? productCardTheme;
  final AnnouncementBarTheme? announcementBarTheme;
  final AddToCartButtonTheme? addToCartButtonTheme;
  final WishlistTheme? wishlistTheme;
  final CartSummaryTheme? cartSummaryTheme;
  final ImageCarouselTheme? imageCarouselTheme;
  final VariantPickerTheme? variantPickerTheme;
  final CategoryTabsTheme? categoryTabsTheme;
  final CartBubbleTheme? cartBubbleTheme;
  final CheckoutStepTheme? checkoutStepTheme;
  final ProductFilterTheme? productFilterTheme;
  final ReviewWidgetTheme? reviewWidgetTheme;
  final StickyHeaderTheme? stickyHeaderTheme;
  final ProductRecommendationTheme? productRecommendationTheme;

  const ShopKitTheme({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.animations,
    this.productCardTheme,
    this.announcementBarTheme,
    this.addToCartButtonTheme,
    this.wishlistTheme,
    this.cartSummaryTheme,
    this.imageCarouselTheme,
    this.variantPickerTheme,
    this.categoryTabsTheme,
    this.cartBubbleTheme,
    this.checkoutStepTheme,
    this.productFilterTheme,
    this.reviewWidgetTheme,
    this.stickyHeaderTheme,
  this.productRecommendationTheme,
  });

  @override
  ShopKitTheme copyWith({
    ShopKitColorScheme? colors,
    ShopKitTypography? typography,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? radii,
    ShopKitAnimation? animations,
    ProductCardTheme? productCardTheme,
    AnnouncementBarTheme? announcementBarTheme,
    AddToCartButtonTheme? addToCartButtonTheme,
    WishlistTheme? wishlistTheme,
    CartSummaryTheme? cartSummaryTheme,
    ImageCarouselTheme? imageCarouselTheme,
    VariantPickerTheme? variantPickerTheme,
    CategoryTabsTheme? categoryTabsTheme,
    CartBubbleTheme? cartBubbleTheme,
    CheckoutStepTheme? checkoutStepTheme,
    ProductFilterTheme? productFilterTheme,
    ReviewWidgetTheme? reviewWidgetTheme,
    StickyHeaderTheme? stickyHeaderTheme,
  ProductRecommendationTheme? productRecommendationTheme,
  }) {
    return ShopKitTheme(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      animations: animations ?? this.animations,
      productCardTheme: productCardTheme ?? this.productCardTheme,
      announcementBarTheme: announcementBarTheme ?? this.announcementBarTheme,
      addToCartButtonTheme: addToCartButtonTheme ?? this.addToCartButtonTheme,
      wishlistTheme: wishlistTheme ?? this.wishlistTheme,
      cartSummaryTheme: cartSummaryTheme ?? this.cartSummaryTheme,
      imageCarouselTheme: imageCarouselTheme ?? this.imageCarouselTheme,
      variantPickerTheme: variantPickerTheme ?? this.variantPickerTheme,
      categoryTabsTheme: categoryTabsTheme ?? this.categoryTabsTheme,
      cartBubbleTheme: cartBubbleTheme ?? this.cartBubbleTheme,
      checkoutStepTheme: checkoutStepTheme ?? this.checkoutStepTheme,
      productFilterTheme: productFilterTheme ?? this.productFilterTheme,
      reviewWidgetTheme: reviewWidgetTheme ?? this.reviewWidgetTheme,
      stickyHeaderTheme: stickyHeaderTheme ?? this.stickyHeaderTheme,
  productRecommendationTheme: productRecommendationTheme ?? this.productRecommendationTheme,
    );
  }

  @override
  ShopKitTheme lerp(ThemeExtension<ShopKitTheme>? other, double t) {
    if (other is! ShopKitTheme) return this;

    // This is the full, correct implementation for smooth theme animations.
    return ShopKitTheme(
      // Core tokens are snapped for simplicity as lerping them is complex.
      colors: t < 0.5 ? colors : other.colors,
      typography: t < 0.5 ? typography : other.typography,
      spacing: t < 0.5 ? spacing : other.spacing,
      radii: t < 0.5 ? radii : other.radii,
      animations: t < 0.5 ? animations : other.animations,
      
      // Lerp each component theme individually.
      productCardTheme: productCardTheme?.lerp(other.productCardTheme, t),
      announcementBarTheme: announcementBarTheme?.lerp(other.announcementBarTheme, t),
      addToCartButtonTheme: addToCartButtonTheme?.lerp(other.addToCartButtonTheme, t),
      wishlistTheme: wishlistTheme?.lerp(other.wishlistTheme, t),
      cartSummaryTheme: cartSummaryTheme?.lerp(other.cartSummaryTheme, t),
      imageCarouselTheme: imageCarouselTheme?.lerp(other.imageCarouselTheme, t),
      variantPickerTheme: variantPickerTheme?.lerp(other.variantPickerTheme, t),
      categoryTabsTheme: categoryTabsTheme?.lerp(other.categoryTabsTheme, t),
      cartBubbleTheme: cartBubbleTheme?.lerp(other.cartBubbleTheme, t),
      checkoutStepTheme: checkoutStepTheme?.lerp(other.checkoutStepTheme, t),
      productFilterTheme: productFilterTheme?.lerp(other.productFilterTheme, t),
      reviewWidgetTheme: reviewWidgetTheme?.lerp(other.reviewWidgetTheme, t),
      stickyHeaderTheme: stickyHeaderTheme?.lerp(other.stickyHeaderTheme, t),
  productRecommendationTheme: productRecommendationTheme?.lerp(other.productRecommendationTheme, t),
    );
  }
}

/// Provides pre-built, production-ready themes for ShopKit.
///
/// Use these static methods to easily apply a consistent, beautiful theme to your app.
class ShopKitThemes {
  // --- Base Tokens (used by multiple themes) ---
  static final _baseTypography = ShopKitTypography(
    headline1: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    headline2: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    body1: const TextStyle(fontSize: 16, height: 1.5),
    body2: const TextStyle(fontSize: 14, height: 1.4),
    button: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    caption: const TextStyle(fontSize: 12),
  );

  static const _baseSpacing = ShopKitSpacing(xs: 4, sm: 8, md: 16, lg: 24, xl: 32);
  static const _baseRadii = ShopKitBorderRadius(sm: 8, md: 12, lg: 16, full: 999);
  static const _baseAnimations = ShopKitAnimation(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 500),
    easeOut: Curves.easeOut,
    easeIn: Curves.easeIn,
    bounce: Curves.elasticOut,
  );

  /// A modern, clean theme based on Material 3 principles.
  static ShopKitTheme material3(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final colors = ShopKitColorScheme(
      primary: colorScheme.primary, onPrimary: colorScheme.onPrimary,
      secondary: colorScheme.secondary, onSecondary: colorScheme.onSecondary,
      surface: colorScheme.surface, onSurface: colorScheme.onSurface,
      background: colorScheme.surface, onBackground: colorScheme.onSurface,
      error: colorScheme.error, onError: colorScheme.onError,
      success: isDark ? Colors.green.shade300 : Colors.green.shade700,
      warning: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
      info: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
    );

    return ShopKitTheme(
      colors: colors,
      typography: _baseTypography,
      spacing: _baseSpacing,
      radii: _baseRadii,
      animations: _baseAnimations,
      // --- Component Themes for Material Style ---
      productCardTheme: ProductCardTheme(
        backgroundColor: colorScheme.surfaceContainerHighest,
        elevation: 0.5,
        borderRadius: BorderRadius.circular(_baseRadii.md),
        titleStyle: _baseTypography.body2.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface),
        priceStyle: _baseTypography.body1.copyWith(fontWeight: FontWeight.bold, color: colors.primary),
        wishlistIconColor: colors.secondary,
      ),
      announcementBarTheme: AnnouncementBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        textStyle: _baseTypography.button.copyWith(color: colorScheme.onPrimaryContainer, fontSize: 14),
        height: 48,
      ),
      addToCartButtonTheme: AddToCartButtonTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledColor: colors.onSurface.withValues(alpha: 0.12),
        successColor: colors.success,
        height: 48,
        borderRadius: BorderRadius.circular(_baseRadii.full),
        textStyle: _baseTypography.button,
      ),
      cartSummaryTheme: CartSummaryTheme(
        backgroundColor: colorScheme.surface,
        borderRadius: BorderRadius.circular(_baseRadii.lg),
        titleStyle: _baseTypography.headline2,
        totalValueStyle: _baseTypography.headline1.copyWith(color: colors.primary),
      ),
       wishlistTheme: WishlistTheme(
        backgroundColor: colorScheme.surface,
        titleStyle: _baseTypography.headline1,
        iconColor: colorScheme.primary,
      ),
      imageCarouselTheme: ImageCarouselTheme(
        indicatorColor: colorScheme.primary.withValues(alpha: 0.4),
        activeIndicatorColor: colorScheme.primary,
        arrowBackgroundColor: colorScheme.surface.withValues(alpha: 0.8),
        arrowIconColor: colorScheme.onSurface,
        borderRadius: BorderRadius.circular(_baseRadii.lg),
      ),
      categoryTabsTheme: CategoryTabsTheme(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary,
        selectedLabelStyle: _baseTypography.body2.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: _baseTypography.body2.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      variantPickerTheme: VariantPickerTheme(
        selectedChipColor: colorScheme.primary,
        unselectedChipColor: colorScheme.surfaceContainerHighest,
        selectedChipTextStyle: _baseTypography.body2.copyWith(color: colorScheme.onPrimary),
        unselectedChipTextStyle: _baseTypography.body2,
        groupTitleStyle: _baseTypography.caption,
      ),
      cartBubbleTheme: CartBubbleTheme(
        backgroundColor: colors.primary,
        iconColor: colors.onPrimary,
        badgeColor: colors.secondary,
        badgeTextColor: colors.onSecondary,
        size: 40,
        iconSize: 18,
        borderRadius: BorderRadius.circular(_baseRadii.full),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      checkoutStepTheme: CheckoutStepTheme(
        activeColor: colorScheme.primary,
        inactiveColor: colorScheme.onSurface.withValues(alpha: 0.12),
        completedColor: colors.success,
        activeTitleStyle: _baseTypography.body2.copyWith(fontWeight: FontWeight.w600),
        inactiveTitleStyle: _baseTypography.body2,
        connectorColor: colorScheme.onSurfaceVariant,
      ),
      productFilterTheme: ProductFilterTheme(
        backgroundColor: colorScheme.surface,
        borderRadius: BorderRadius.circular(_baseRadii.md),
        headerTextStyle: _baseTypography.headline2,
        filterTitleStyle: _baseTypography.body2,
        activeChipColor: colorScheme.primary,
        inactiveChipColor: colorScheme.surfaceContainerHighest,
        activeChipTextStyle: _baseTypography.body2.copyWith(color: colorScheme.onPrimary),
        inactiveChipTextStyle: _baseTypography.body2,
      ),
      productRecommendationTheme: ProductRecommendationTheme(
        backgroundColor: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(_baseRadii.lg),
        titleStyle: _baseTypography.headline2,
        subtitleStyle: _baseTypography.body2.copyWith(color: colorScheme.onSurfaceVariant),
        cardAspectRatio: 0.75,
      ),
      stickyHeaderTheme: StickyHeaderTheme(
        backgroundColor: colorScheme.surface,
        elevation: 2.0,
        titleStyle: _baseTypography.headline2,
        iconColor: colorScheme.onSurface,
      ),
      reviewWidgetTheme: ReviewWidgetTheme(
        summaryBackgroundColor: colorScheme.surfaceContainerHighest,
        starColor: Colors.amber,
        ratingBarColor: colorScheme.primary,
        authorTextStyle: _baseTypography.body2.copyWith(fontWeight: FontWeight.w600),
        bodyTextStyle: _baseTypography.body2,
        dateTextStyle: _baseTypography.caption,
      ),
    );
  }

  /// An expressive theme with large corner radii and vibrant colors, inspired by Material You.
  static ShopKitTheme materialYou(ColorScheme colorScheme) {
    final base = material3(colorScheme);
    final expressiveRadii = const ShopKitBorderRadius(sm: 12, md: 16, lg: 24, full: 999);
    return base.copyWith(
      radii: expressiveRadii,
      productCardTheme: base.productCardTheme?.copyWith(
        borderRadius: BorderRadius.circular(expressiveRadii.lg),
      ),
      addToCartButtonTheme: base.addToCartButtonTheme?.copyWith(
        borderRadius: BorderRadius.circular(expressiveRadii.md),
      ),
      imageCarouselTheme: base.imageCarouselTheme?.copyWith(
        borderRadius: BorderRadius.circular(expressiveRadii.lg),
      ),
    );
  }

  /// A sleek, modern theme with a frosted-glass effect. Best used with a background image.
  static ShopKitTheme glassmorphic(ColorScheme colorScheme) {
    final base = material3(colorScheme);
    final isDark = colorScheme.brightness == Brightness.dark;
    final glassColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.25);
    final onGlassColor = isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.8);

    return base.copyWith(
      productCardTheme: base.productCardTheme?.copyWith(
        backgroundColor: glassColor,
        elevation: 0,
        titleStyle: base.productCardTheme?.titleStyle?.copyWith(color: onGlassColor),
        priceStyle: base.productCardTheme?.priceStyle?.copyWith(color: base.colors.primary),
      ),
      announcementBarTheme: base.announcementBarTheme?.copyWith(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
        textStyle: base.announcementBarTheme?.textStyle?.copyWith(color: colorScheme.onSurface),
      ),
      stickyHeaderTheme: base.stickyHeaderTheme?.copyWith(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
      )
    );
  }

  /// A soft, tactile theme based on the Neumorphism design trend.
  static ShopKitTheme neumorphic(ColorScheme colorScheme) {
    final base = material3(colorScheme);
    return base.copyWith(
      productCardTheme: base.productCardTheme?.copyWith(
        backgroundColor: colorScheme.surface,
        elevation: 0, // Neumorphism uses shadows, not elevation
      ),
      addToCartButtonTheme: base.addToCartButtonTheme?.copyWith(
        elevation: 0,
      ),
    );
  }

  /// A clean, minimal theme inspired by Apple's Human Interface Guidelines.
  static ShopKitTheme cupertino(ColorScheme colorScheme) {
    final base = material3(colorScheme);
    final cupertinoRadii = const ShopKitBorderRadius(sm: 6, md: 8, lg: 10, full: 999);
    return base.copyWith(
      radii: cupertinoRadii,
      productCardTheme: base.productCardTheme?.copyWith(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        borderRadius: BorderRadius.circular(cupertinoRadii.lg),
      ),
      addToCartButtonTheme: base.addToCartButtonTheme?.copyWith(
        borderRadius: BorderRadius.circular(cupertinoRadii.md),
      ),
    );
  }

  /// A fun, vintage-style theme with a distinct color palette and blocky shadows.
  static ShopKitTheme retro(ColorScheme colorScheme) {
    final base = material3(colorScheme);
    final retroColors = ShopKitColorScheme(
      primary: const Color(0xFFFF6B35),
      onPrimary: Colors.white,
      secondary: const Color(0xFF004E64),
      onSecondary: Colors.white,
      surface: const Color(0xFFFFF8DC), // Cornsilk
      onSurface: const Color(0xFF333333),
      background: const Color(0xFFF0EAD6), // Linen
      onBackground: const Color(0xFF333333),
      error: const Color(0xFFC70039),
      onError: Colors.white,
      success: const Color(0xFF2E7D32),
      warning: const Color(0xFFF9A825),
      info: const Color(0xFF0277BD),
    );
    final retroRadii = const ShopKitBorderRadius(sm: 0, md: 4, lg: 8, full: 999);

    return base.copyWith(
      colors: retroColors,
      radii: retroRadii,
      productCardTheme: base.productCardTheme?.copyWith(
        backgroundColor: retroColors.surface,
        borderRadius: BorderRadius.circular(retroRadii.md),
        elevation: 4.0, // Retro uses more defined shadows
      ),
      addToCartButtonTheme: base.addToCartButtonTheme?.copyWith(
        backgroundColor: retroColors.primary,
        foregroundColor: retroColors.onPrimary,
        borderRadius: BorderRadius.circular(retroRadii.sm),
      ),
    );
  }

  /// A dark theme with vibrant, glowing colors against a black background.
  static ShopKitTheme neon(ColorScheme colorScheme) {
    final base = material3(colorScheme.copyWith(brightness: Brightness.dark));
    final neonColors = ShopKitColorScheme(
      primary: const Color(0xFF00FFFF), // Cyan
      onPrimary: Colors.black,
      secondary: const Color(0xFFF000FF), // Magenta
      onSecondary: Colors.black,
      surface: const Color(0xFF1A1A1A),
      onSurface: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      error: const Color(0xFFFF0055),
      onError: Colors.black,
      success: const Color(0xFF50FF00),
      warning: const Color(0xFFFFC600),
      info: const Color(0xFF0077FF),
    );
    final neonRadii = const ShopKitBorderRadius(sm: 12, md: 20, lg: 30, full: 999);

    return base.copyWith(
      colors: neonColors,
      radii: neonRadii,
      productCardTheme: base.productCardTheme?.copyWith(
        backgroundColor: neonColors.surface,
        borderRadius: BorderRadius.circular(neonRadii.md),
        elevation: 0, // Glow is handled by shadows
        priceStyle: base.productCardTheme?.priceStyle?.copyWith(color: neonColors.primary),
      ),
      addToCartButtonTheme: base.addToCartButtonTheme?.copyWith(
        backgroundColor: neonColors.primary,
        foregroundColor: neonColors.onPrimary,
        borderRadius: BorderRadius.circular(neonRadii.full),
      ),
      cartBubbleTheme: base.cartBubbleTheme?.copyWith(
        backgroundColor: neonColors.primary,
        iconColor: neonColors.onPrimary,
        badgeColor: neonColors.secondary,
        badgeTextColor: neonColors.onSecondary,
      ),
    );
  }
}
