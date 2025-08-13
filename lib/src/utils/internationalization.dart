// internationalization.dart
import 'package:flutter/material.dart';

/// Internationalization configuration for ShopKit
class ShopKitI18n {
  const ShopKitI18n({
    required this.locale,
    required this.translations,
    this.fallbackLocale = const Locale('en', 'US'),
    this.rtlLanguages = const {'ar', 'he', 'fa', 'ur'},
    this.numberFormat,
    this.currencyFormat,
    this.dateFormat,
    this.pluralizationRules,
  });

  /// Current locale
  final Locale locale;

  /// Translation map
  final Map<String, Map<String, String>> translations;

  /// Fallback locale when translation is missing
  final Locale fallbackLocale;

  /// Set of RTL language codes
  final Set<String> rtlLanguages;

  /// Number formatting configuration
  final NumberFormatConfig? numberFormat;

  /// Currency formatting configuration
  final CurrencyFormatConfig? currencyFormat;

  /// Date formatting configuration
  final DateFormatConfig? dateFormat;

  /// Pluralization rules for different languages
  final Map<String, PluralizationRule>? pluralizationRules;

  /// Check if current locale is RTL
  bool get isRTL => rtlLanguages.contains(locale.languageCode);

  /// Get text direction for current locale
  TextDirection get textDirection => isRTL ? TextDirection.rtl : TextDirection.ltr;

  /// Get translation for key
  String translate(String key, {Map<String, dynamic>? variables}) {
    final localeKey = '${locale.languageCode}_${locale.countryCode}';
    final fallbackKey = '${fallbackLocale.languageCode}_${fallbackLocale.countryCode}';
    
    String? translation = translations[localeKey]?[key] ?? 
                         translations[locale.languageCode]?[key] ??
                         translations[fallbackKey]?[key] ??
                         translations[fallbackLocale.languageCode]?[key];

    if (translation == null) {
      return key; // Return key if no translation found
    }

    // Replace variables in translation
    if (variables != null) {
      variables.forEach((variable, value) {
        translation = translation!.replaceAll('{$variable}', value.toString());
      });
    }

    return translation!;
  }

  /// Get pluralized translation
  String translatePlural(
    String key,
    int count, {
    Map<String, dynamic>? variables,
  }) {
    final rule = pluralizationRules?[locale.languageCode] ?? 
                 pluralizationRules?[fallbackLocale.languageCode] ??
                 const EnglishPluralizationRule();

    final pluralForm = rule.getForm(count);
    final pluralKey = '${key}_$pluralForm';
    
    final translation = translate(pluralKey, variables: {
      ...?variables,
      'count': count,
    });

    return translation != pluralKey ? translation : translate(key, variables: variables);
  }

  /// Format number according to locale
  String formatNumber(num number) {
    if (numberFormat != null) {
      return numberFormat!.format(number, locale);
    }
    
    // Default formatting
    return number.toString();
  }

  /// Format currency according to locale
  String formatCurrency(double amount, String currencyCode) {
    if (currencyFormat != null) {
      return currencyFormat!.format(amount, currencyCode, locale);
    }
    
    // Default formatting
    return '$currencyCode $amount';
  }

  /// Format date according to locale
  String formatDate(DateTime date, {String? pattern}) {
    if (dateFormat != null) {
      return dateFormat!.format(date, locale, pattern: pattern);
    }
    
    // Default formatting
    return date.toString();
  }

  /// Create copy with different locale
  ShopKitI18n copyWith({
    Locale? locale,
    Map<String, Map<String, String>>? translations,
    Locale? fallbackLocale,
    Set<String>? rtlLanguages,
    NumberFormatConfig? numberFormat,
    CurrencyFormatConfig? currencyFormat,
    DateFormatConfig? dateFormat,
    Map<String, PluralizationRule>? pluralizationRules,
  }) {
    return ShopKitI18n(
      locale: locale ?? this.locale,
      translations: translations ?? this.translations,
      fallbackLocale: fallbackLocale ?? this.fallbackLocale,
      rtlLanguages: rtlLanguages ?? this.rtlLanguages,
      numberFormat: numberFormat ?? this.numberFormat,
      currencyFormat: currencyFormat ?? this.currencyFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      pluralizationRules: pluralizationRules ?? this.pluralizationRules,
    );
  }

  /// Prebuilt locales
  static const Map<String, Locale> supportedLocales = {
    'en_US': Locale('en', 'US'),
    'en_GB': Locale('en', 'GB'),
    'es_ES': Locale('es', 'ES'),
    'es_MX': Locale('es', 'MX'),
    'fr_FR': Locale('fr', 'FR'),
    'fr_CA': Locale('fr', 'CA'),
    'de_DE': Locale('de', 'DE'),
    'it_IT': Locale('it', 'IT'),
    'pt_BR': Locale('pt', 'BR'),
    'pt_PT': Locale('pt', 'PT'),
    'ru_RU': Locale('ru', 'RU'),
    'ja_JP': Locale('ja', 'JP'),
    'ko_KR': Locale('ko', 'KR'),
    'zh_CN': Locale('zh', 'CN'),
    'zh_TW': Locale('zh', 'TW'),
    'ar_SA': Locale('ar', 'SA'),
    'hi_IN': Locale('hi', 'IN'),
    'th_TH': Locale('th', 'TH'),
    'vi_VN': Locale('vi', 'VN'),
    'tr_TR': Locale('tr', 'TR'),
    'nl_NL': Locale('nl', 'NL'),
    'sv_SE': Locale('sv', 'SE'),
    'da_DK': Locale('da', 'DK'),
    'no_NO': Locale('no', 'NO'),
    'fi_FI': Locale('fi', 'FI'),
    'pl_PL': Locale('pl', 'PL'),
    'cs_CZ': Locale('cs', 'CZ'),
    'hu_HU': Locale('hu', 'HU'),
    'ro_RO': Locale('ro', 'RO'),
    'bg_BG': Locale('bg', 'BG'),
    'hr_HR': Locale('hr', 'HR'),
    'sk_SK': Locale('sk', 'SK'),
    'sl_SI': Locale('sl', 'SI'),
    'et_EE': Locale('et', 'EE'),
    'lv_LV': Locale('lv', 'LV'),
    'lt_LT': Locale('lt', 'LT'),
  };
}

/// Number formatting configuration
abstract class NumberFormatConfig {
  const NumberFormatConfig();
  
  String format(num number, Locale locale);
}

/// Currency formatting configuration
abstract class CurrencyFormatConfig {
  const CurrencyFormatConfig();
  
  String format(double amount, String currencyCode, Locale locale);
}

/// Date formatting configuration
abstract class DateFormatConfig {
  const DateFormatConfig();
  
  String format(DateTime date, Locale locale, {String? pattern});
}

/// Pluralization rule interface
abstract class PluralizationRule {
  const PluralizationRule();
  
  String getForm(int count);
}

/// English pluralization rule
class EnglishPluralizationRule extends PluralizationRule {
  const EnglishPluralizationRule();
  
  @override
  String getForm(int count) {
    if (count == 1) return 'one';
    return 'other';
  }
}

/// Default e-commerce translations
class ShopKitTranslations {
  static const Map<String, Map<String, String>> defaultTranslations = {
    'en': {
      // Common
      'add_to_cart': 'Add to Cart',
      'add_to_wishlist': 'Add to Wishlist',
      'remove_from_wishlist': 'Remove from Wishlist',
      'buy_now': 'Buy Now',
      'price': 'Price',
      'sale_price': 'Sale Price',
      'out_of_stock': 'Out of Stock',
      'in_stock': 'In Stock',
      'limited_stock': 'Limited Stock',
      'free_shipping': 'Free Shipping',
      'shipping': 'Shipping',
      'tax': 'Tax',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'discount': 'Discount',
      'coupon_code': 'Coupon Code',
      'apply_coupon': 'Apply Coupon',
      'remove_coupon': 'Remove Coupon',
      
      // Cart
      'cart': 'Cart',
      'shopping_cart': 'Shopping Cart',
      'cart_empty': 'Your cart is empty',
      'cart_item_count_one': '{count} item',
      'cart_item_count_other': '{count} items',
      'remove_item': 'Remove Item',
      'update_quantity': 'Update Quantity',
      'continue_shopping': 'Continue Shopping',
      'proceed_to_checkout': 'Proceed to Checkout',
      
      // Checkout
      'checkout': 'Checkout',
      'billing_address': 'Billing Address',
      'shipping_address': 'Shipping Address',
      'payment_method': 'Payment Method',
      'place_order': 'Place Order',
      'order_summary': 'Order Summary',
      'delivery_method': 'Delivery Method',
      'express_delivery': 'Express Delivery',
      'standard_delivery': 'Standard Delivery',
      'pickup': 'Pickup',
      
      // Product
      'product_details': 'Product Details',
      'product_reviews': 'Product Reviews',
      'product_description': 'Description',
      'product_specifications': 'Specifications',
      'product_variants': 'Variants',
      'size': 'Size',
      'color': 'Color',
      'quantity': 'Quantity',
      'reviews': 'Reviews',
      'rating': 'Rating',
      'review_count_one': '{count} review',
      'review_count_other': '{count} reviews',
      
      // Search & Filter
      'search': 'Search',
      'search_products': 'Search products...',
      'filters': 'Filters',
      'sort_by': 'Sort by',
      'price_low_to_high': 'Price: Low to High',
      'price_high_to_low': 'Price: High to Low',
      'popularity': 'Popularity',
      'newest': 'Newest',
      'customer_rating': 'Customer Rating',
      'clear_filters': 'Clear Filters',
      'apply_filters': 'Apply Filters',
      'categories': 'Categories',
      'brands': 'Brands',
      'price_range': 'Price Range',
      'min_price': 'Min Price',
      'max_price': 'Max Price',
      
      // Account
      'my_account': 'My Account',
      'profile': 'Profile',
      'orders': 'Orders',
      'wishlist': 'Wishlist',
      'addresses': 'Addresses',
      'payment_methods': 'Payment Methods',
      'order_history': 'Order History',
      'track_order': 'Track Order',
      'order_status': 'Order Status',
      'order_placed': 'Order Placed',
      'order_confirmed': 'Order Confirmed',
      'order_shipped': 'Order Shipped',
      'order_delivered': 'Order Delivered',
      'order_cancelled': 'Order Cancelled',
      
      // Errors & Messages
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Info',
      'loading': 'Loading...',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'close': 'Close',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'required_field': 'This field is required',
      'invalid_email': 'Invalid email address',
      'invalid_phone': 'Invalid phone number',
      'password_too_short': 'Password must be at least 8 characters',
      'passwords_do_not_match': 'Passwords do not match',
      'item_added_to_cart': 'Item added to cart',
      'item_removed_from_cart': 'Item removed from cart',
      'item_added_to_wishlist': 'Item added to wishlist',
      'item_removed_from_wishlist': 'Item removed from wishlist',
      'coupon_applied': 'Coupon applied successfully',
      'coupon_invalid': 'Invalid coupon code',
      'order_placed_successfully': 'Order placed successfully',
      'payment_failed': 'Payment failed',
      'network_error': 'Network error. Please try again.',
    },
    
    'es': {
      // Common
      'add_to_cart': 'Añadir al Carrito',
      'add_to_wishlist': 'Añadir a la Lista de Deseos',
      'remove_from_wishlist': 'Quitar de la Lista de Deseos',
      'buy_now': 'Comprar Ahora',
      'price': 'Precio',
      'sale_price': 'Precio de Oferta',
      'out_of_stock': 'Agotado',
      'in_stock': 'En Stock',
      'limited_stock': 'Stock Limitado',
      'free_shipping': 'Envío Gratis',
      'shipping': 'Envío',
      'tax': 'Impuesto',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'discount': 'Descuento',
      'coupon_code': 'Código de Cupón',
      'apply_coupon': 'Aplicar Cupón',
      'remove_coupon': 'Quitar Cupón',
      
      // Cart
      'cart': 'Carrito',
      'shopping_cart': 'Carrito de Compras',
      'cart_empty': 'Tu carrito está vacío',
      'cart_item_count_one': '{count} artículo',
      'cart_item_count_other': '{count} artículos',
      'remove_item': 'Quitar Artículo',
      'update_quantity': 'Actualizar Cantidad',
      'continue_shopping': 'Continuar Comprando',
      'proceed_to_checkout': 'Proceder al Pago',
      
      // ... more Spanish translations
    },
    
    'fr': {
      // Common
      'add_to_cart': 'Ajouter au Panier',
      'add_to_wishlist': 'Ajouter à la Liste de Souhaits',
      'remove_from_wishlist': 'Retirer de la Liste de Souhaits',
      'buy_now': 'Acheter Maintenant',
      'price': 'Prix',
      'sale_price': 'Prix de Vente',
      'out_of_stock': 'Rupture de Stock',
      'in_stock': 'En Stock',
      'limited_stock': 'Stock Limité',
      'free_shipping': 'Livraison Gratuite',
      'shipping': 'Livraison',
      'tax': 'Taxe',
      'total': 'Total',
      'subtotal': 'Sous-total',
      'discount': 'Remise',
      'coupon_code': 'Code de Coupon',
      'apply_coupon': 'Appliquer le Coupon',
      'remove_coupon': 'Retirer le Coupon',
      
      // Cart
      'cart': 'Panier',
      'shopping_cart': 'Panier d\'Achat',
      'cart_empty': 'Votre panier est vide',
      'cart_item_count_one': '{count} article',
      'cart_item_count_other': '{count} articles',
      'remove_item': 'Retirer l\'Article',
      'update_quantity': 'Mettre à Jour la Quantité',
      'continue_shopping': 'Continuer les Achats',
      'proceed_to_checkout': 'Procéder au Paiement',
      
      // ... more French translations
    },
    
    'ar': {
      // Common
      'add_to_cart': 'أضف إلى السلة',
      'add_to_wishlist': 'أضف إلى قائمة الأمنيات',
      'remove_from_wishlist': 'احذف من قائمة الأمنيات',
      'buy_now': 'اشتر الآن',
      'price': 'السعر',
      'sale_price': 'سعر البيع',
      'out_of_stock': 'نفدت الكمية',
      'in_stock': 'متوفر',
      'limited_stock': 'كمية محدودة',
      'free_shipping': 'شحن مجاني',
      'shipping': 'الشحن',
      'tax': 'الضريبة',
      'total': 'المجموع',
      'subtotal': 'المجموع الفرعي',
      'discount': 'الخصم',
      'coupon_code': 'كود الكوبون',
      'apply_coupon': 'تطبيق الكوبون',
      'remove_coupon': 'إزالة الكوبون',
      
      // Cart
      'cart': 'السلة',
      'shopping_cart': 'سلة التسوق',
      'cart_empty': 'سلتك فارغة',
      'cart_item_count_one': '{count} عنصر',
      'cart_item_count_other': '{count} عناصر',
      'remove_item': 'احذف العنصر',
      'update_quantity': 'تحديث الكمية',
      'continue_shopping': 'متابعة التسوق',
      'proceed_to_checkout': 'المتابعة للدفع',
      
      // ... more Arabic translations
    },
  };
}

/// I18n provider widget
class ShopKitI18nProvider extends InheritedWidget {
  const ShopKitI18nProvider({
    super.key,
    required this.i18n,
    required super.child,
  });

  final ShopKitI18n i18n;

  static ShopKitI18n? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShopKitI18nProvider>()?.i18n;
  }

  static ShopKitI18n of(BuildContext context) {
    final i18n = maybeOf(context);
    assert(i18n != null, 'No ShopKitI18nProvider found in context');
    return i18n!;
  }

  @override
  bool updateShouldNotify(ShopKitI18nProvider oldWidget) {
    return i18n != oldWidget.i18n;
  }
}

/// Extension for easy translation access
extension BuildContextI18nExtension on BuildContext {
  /// Get translation for key
  String tr(String key, {Map<String, dynamic>? variables}) {
    final i18n = ShopKitI18nProvider.maybeOf(this);
    if (i18n == null) return key;
    return i18n.translate(key, variables: variables);
  }

  /// Get pluralized translation
  String trPlural(String key, int count, {Map<String, dynamic>? variables}) {
    final i18n = ShopKitI18nProvider.maybeOf(this);
    if (i18n == null) return key;
    return i18n.translatePlural(key, count, variables: variables);
  }

  /// Get current locale
  Locale? get currentLocale {
    return ShopKitI18nProvider.maybeOf(this)?.locale;
  }

  /// Check if current locale is RTL
  bool get isRTL {
    return ShopKitI18nProvider.maybeOf(this)?.isRTL ?? false;
  }

  /// Get text direction for current locale
  TextDirection get textDirection {
    return ShopKitI18nProvider.maybeOf(this)?.textDirection ?? TextDirection.ltr;
  }
}
