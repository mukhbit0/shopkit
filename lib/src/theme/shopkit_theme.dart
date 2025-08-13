import 'package:flutter/material.dart';

/// A comprehensive theming system for ShopKit widgets
/// This replaces the old ECommerceTheme with modern, flexible architecture
class ShopKitTheme {
  /// Core colors
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color backgroundColor;
  final Color errorColor;
  final Color warningColor;
  final Color successColor;
  final Color infoColor;
  
  /// Text colors
  final Color onPrimaryColor;
  final Color onSecondaryColor;
  final Color onSurfaceColor;
  final Color onBackgroundColor;
  final Color onErrorColor;
  
  /// Typography
  final TextTheme textTheme;
  final String? fontFamily;
  
  /// Shape and spacing
  final double borderRadius;
  final double cardElevation;
  final EdgeInsets defaultPadding;
  final EdgeInsets defaultMargin;
  
  /// Animation settings
  final Duration defaultAnimationDuration;
  final Curve defaultAnimationCurve;
  
  /// Theme style
  final ShopKitThemeStyle style;
  
  /// Custom properties
  final Map<String, dynamic> customProperties;

  const ShopKitTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.backgroundColor,
    required this.errorColor,
    required this.warningColor,
    required this.successColor,
    required this.infoColor,
    required this.onPrimaryColor,
    required this.onSecondaryColor,
    required this.onSurfaceColor,
    required this.onBackgroundColor,
    required this.onErrorColor,
    required this.textTheme,
    this.fontFamily,
    this.borderRadius = 12.0,
    this.cardElevation = 4.0,
    this.defaultPadding = const EdgeInsets.all(16.0),
    this.defaultMargin = const EdgeInsets.all(8.0),
    this.defaultAnimationDuration = const Duration(milliseconds: 300),
    this.defaultAnimationCurve = Curves.easeInOut,
    this.style = ShopKitThemeStyle.material,
    this.customProperties = const {},
  });

  /// Create a light theme
  factory ShopKitTheme.light({
    Color? primaryColor,
    Color? secondaryColor,
    ShopKitThemeStyle style = ShopKitThemeStyle.material,
    Map<String, dynamic> customProperties = const {},
  }) {
    final primary = primaryColor ?? const Color(0xFF1976D2);
    final secondary = secondaryColor ?? const Color(0xFF42A5F5);
    
    return ShopKitTheme(
      primaryColor: primary,
      secondaryColor: secondary,
      surfaceColor: Colors.white,
      backgroundColor: const Color(0xFFF5F5F5),
      errorColor: const Color(0xFFD32F2F),
      warningColor: const Color(0xFFF57C00),
      successColor: const Color(0xFF388E3C),
      infoColor: const Color(0xFF1976D2),
      onPrimaryColor: Colors.white,
      onSecondaryColor: Colors.white,
      onSurfaceColor: const Color(0xFF212121),
      onBackgroundColor: const Color(0xFF212121),
      onErrorColor: Colors.white,
      textTheme: _buildTextTheme(const Color(0xFF212121)),
      style: style,
      customProperties: customProperties,
    );
  }

  /// Create a dark theme
  factory ShopKitTheme.dark({
    Color? primaryColor,
    Color? secondaryColor,
    ShopKitThemeStyle style = ShopKitThemeStyle.material,
    Map<String, dynamic> customProperties = const {},
  }) {
    final primary = primaryColor ?? const Color(0xFF64B5F6);
    final secondary = secondaryColor ?? const Color(0xFF42A5F5);
    
    return ShopKitTheme(
      primaryColor: primary,
      secondaryColor: secondary,
      surfaceColor: const Color(0xFF1E1E1E),
      backgroundColor: const Color(0xFF121212),
      errorColor: const Color(0xFFEF5350),
      warningColor: const Color(0xFFFFB74D),
      successColor: const Color(0xFF66BB6A),
      infoColor: const Color(0xFF64B5F6),
      onPrimaryColor: const Color(0xFF212121),
      onSecondaryColor: Colors.white,
      onSurfaceColor: Colors.white,
      onBackgroundColor: Colors.white,
      onErrorColor: Colors.white,
      textTheme: _buildTextTheme(Colors.white),
      style: style,
      customProperties: customProperties,
    );
  }

  /// Create a neumorphic theme
  factory ShopKitTheme.neumorphic({
    Color? baseColor,
    ShopKitThemeStyle style = ShopKitThemeStyle.neumorphic,
    Map<String, dynamic> customProperties = const {},
  }) {
    final base = baseColor ?? const Color(0xFFE0E0E0);
    const primary = Color(0xFF6200EA);
    
    return ShopKitTheme(
      primaryColor: primary,
      secondaryColor: const Color(0xFF7C4DFF),
      surfaceColor: base,
      backgroundColor: base,
      errorColor: const Color(0xFFD32F2F),
      warningColor: const Color(0xFFF57C00),
      successColor: const Color(0xFF388E3C),
      infoColor: primary,
      onPrimaryColor: Colors.white,
      onSecondaryColor: Colors.white,
      onSurfaceColor: const Color(0xFF424242),
      onBackgroundColor: const Color(0xFF424242),
      onErrorColor: Colors.white,
      textTheme: _buildTextTheme(const Color(0xFF424242)),
      borderRadius: 16.0,
      cardElevation: 0.0,
      style: style,
      customProperties: {
        'neumorphicLightShadow': Colors.white,
        'neumorphicDarkShadow': const Color(0xFFBEBEBE),
        'neumorphicBlurRadius': 10.0,
        'neumorphicSpreadRadius': 1.0,
        ...customProperties,
      },
    );
  }

  /// Create a glassmorphic theme
  factory ShopKitTheme.glassmorphic({
    Color? primaryColor,
    Color? backgroundColor,
    ShopKitThemeStyle style = ShopKitThemeStyle.glassmorphic,
    Map<String, dynamic> customProperties = const {},
  }) {
    final primary = primaryColor ?? const Color(0xFF6200EA);
    final background = backgroundColor ?? const Color(0xFF1A1A1A);
    
    return ShopKitTheme(
      primaryColor: primary,
      secondaryColor: const Color(0xFF7C4DFF),
      surfaceColor: Colors.white.withValues(alpha: 0.1),
      backgroundColor: background,
      errorColor: const Color(0xFFEF5350),
      warningColor: const Color(0xFFFFB74D),
      successColor: const Color(0xFF66BB6A),
      infoColor: primary,
      onPrimaryColor: Colors.white,
      onSecondaryColor: Colors.white,
      onSurfaceColor: Colors.white,
      onBackgroundColor: Colors.white,
      onErrorColor: Colors.white,
      textTheme: _buildTextTheme(Colors.white),
      borderRadius: 20.0,
      cardElevation: 0.0,
      style: style,
      customProperties: {
        'glassBlurRadius': 10.0,
        'glassOpacity': 0.1,
        'glassBorderOpacity': 0.2,
        'enableBackdropFilter': true,
        ...customProperties,
      },
    );
  }

  /// Create a Material 3 theme
  factory ShopKitTheme.material3({
    Color? seedColor,
    Brightness brightness = Brightness.light,
    Map<String, dynamic> customProperties = const {},
  }) {
    final seed = seedColor ?? const Color(0xFF6750A4);
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    
    return ShopKitTheme(
      primaryColor: scheme.primary,
      secondaryColor: scheme.secondary,
      surfaceColor: scheme.surface,
      backgroundColor: scheme.surface,
      errorColor: scheme.error,
      warningColor: const Color(0xFFF57C00),
      successColor: const Color(0xFF388E3C),
      infoColor: scheme.primary,
      onPrimaryColor: scheme.onPrimary,
      onSecondaryColor: scheme.onSecondary,
      onSurfaceColor: scheme.onSurface,
      onBackgroundColor: scheme.onSurface,
      onErrorColor: scheme.onError,
      textTheme: _buildTextTheme(scheme.onSurface),
      borderRadius: 12.0,
      cardElevation: 1.0,
      style: ShopKitThemeStyle.material3,
      customProperties: {
        'colorScheme': scheme,
        'useMaterial3': true,
        ...customProperties,
      },
    );
  }

  /// Build text theme
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.33,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: baseColor,
        height: 1.45,
      ),
    );
  }

  /// Get a color by semantic name
  Color getSemanticColor(String name) {
    switch (name.toLowerCase()) {
      case 'primary':
        return primaryColor;
      case 'secondary':
        return secondaryColor;
      case 'surface':
        return surfaceColor;
      case 'background':
        return backgroundColor;
      case 'error':
        return errorColor;
      case 'warning':
        return warningColor;
      case 'success':
        return successColor;
      case 'info':
        return infoColor;
      case 'onprimary':
        return onPrimaryColor;
      case 'onsecondary':
        return onSecondaryColor;
      case 'onsurface':
        return onSurfaceColor;
      case 'onbackground':
        return onBackgroundColor;
      case 'onerror':
        return onErrorColor;
      default:
        return primaryColor;
    }
  }

  /// Get a text style by semantic name
  TextStyle getTextStyle(String name) {
    switch (name.toLowerCase()) {
      case 'displaylarge':
        return textTheme.displayLarge!;
      case 'displaymedium':
        return textTheme.displayMedium!;
      case 'displaysmall':
        return textTheme.displaySmall!;
      case 'headlinelarge':
        return textTheme.headlineLarge!;
      case 'headlinemedium':
        return textTheme.headlineMedium!;
      case 'headlinesmall':
        return textTheme.headlineSmall!;
      case 'titlelarge':
        return textTheme.titleLarge!;
      case 'titlemedium':
        return textTheme.titleMedium!;
      case 'titlesmall':
        return textTheme.titleSmall!;
      case 'bodylarge':
        return textTheme.bodyLarge!;
      case 'bodymedium':
        return textTheme.bodyMedium!;
      case 'bodysmall':
        return textTheme.bodySmall!;
      case 'labellarge':
        return textTheme.labelLarge!;
      case 'labelmedium':
        return textTheme.labelMedium!;
      case 'labelsmall':
        return textTheme.labelSmall!;
      default:
        return textTheme.bodyMedium!;
    }
  }

  /// Get custom property
  T? getCustomProperty<T>(String key) {
    return customProperties[key] as T?;
  }

  /// Check if custom property exists
  bool hasCustomProperty(String key) {
    return customProperties.containsKey(key);
  }

  /// Create a copy with modified properties
  ShopKitTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? surfaceColor,
    Color? backgroundColor,
    Color? errorColor,
    Color? warningColor,
    Color? successColor,
    Color? infoColor,
    Color? onPrimaryColor,
    Color? onSecondaryColor,
    Color? onSurfaceColor,
    Color? onBackgroundColor,
    Color? onErrorColor,
    TextTheme? textTheme,
    String? fontFamily,
    double? borderRadius,
    double? cardElevation,
    EdgeInsets? defaultPadding,
    EdgeInsets? defaultMargin,
    Duration? defaultAnimationDuration,
    Curve? defaultAnimationCurve,
    ShopKitThemeStyle? style,
    Map<String, dynamic>? customProperties,
  }) {
    return ShopKitTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      successColor: successColor ?? this.successColor,
      infoColor: infoColor ?? this.infoColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
      onErrorColor: onErrorColor ?? this.onErrorColor,
      textTheme: textTheme ?? this.textTheme,
      fontFamily: fontFamily ?? this.fontFamily,
      borderRadius: borderRadius ?? this.borderRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      defaultPadding: defaultPadding ?? this.defaultPadding,
      defaultMargin: defaultMargin ?? this.defaultMargin,
      defaultAnimationDuration: defaultAnimationDuration ?? this.defaultAnimationDuration,
      defaultAnimationCurve: defaultAnimationCurve ?? this.defaultAnimationCurve,
      style: style ?? this.style,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  /// Convert to Flutter ThemeData
  ThemeData toThemeData() {
    final colorScheme = ColorScheme(
      brightness: backgroundColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      error: errorColor,
      onError: onErrorColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
    );

    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: fontFamily,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ShopKitTheme &&
      runtimeType == other.runtimeType &&
      primaryColor == other.primaryColor &&
      secondaryColor == other.secondaryColor &&
      surfaceColor == other.surfaceColor &&
      backgroundColor == other.backgroundColor &&
      style == other.style;

  @override
  int get hashCode =>
    primaryColor.hashCode ^
    secondaryColor.hashCode ^
    surfaceColor.hashCode ^
    backgroundColor.hashCode ^
    style.hashCode;

  @override
  String toString() {
    return 'ShopKitTheme(style: $style, primary: $primaryColor)';
  }
}

/// Theme styles supported by ShopKit
enum ShopKitThemeStyle {
  material,
  material3,
  cupertino,
  neumorphic,
  glassmorphic,
  custom,
}

/// Inherited widget for providing ShopKitTheme
class ShopKitThemeProvider extends InheritedWidget {
  final ShopKitTheme theme;

  const ShopKitThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static ShopKitTheme of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ShopKitThemeProvider>();
    if (provider != null) {
      return provider.theme;
    }
    
    // Fallback to creating theme from Flutter theme
    return _createFromFlutterTheme(context);
  }

  static ShopKitTheme? maybeOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ShopKitThemeProvider>();
    return provider?.theme;
  }

  static ShopKitTheme _createFromFlutterTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ShopKitTheme(
      primaryColor: colorScheme.primary,
      secondaryColor: colorScheme.secondary,
      surfaceColor: colorScheme.surface,
      backgroundColor: colorScheme.surface,
      errorColor: colorScheme.error,
      warningColor: const Color(0xFFF57C00),
      successColor: const Color(0xFF388E3C),
      infoColor: colorScheme.primary,
      onPrimaryColor: colorScheme.onPrimary,
      onSecondaryColor: colorScheme.onSecondary,
      onSurfaceColor: colorScheme.onSurface,
      onBackgroundColor: colorScheme.onSurface,
      onErrorColor: colorScheme.onError,
      textTheme: theme.textTheme,
      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
    );
  }

  @override
  bool updateShouldNotify(ShopKitThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
