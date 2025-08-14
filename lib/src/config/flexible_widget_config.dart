import 'package:flutter/material.dart';

/// A flexible configuration system for ShopKit widgets
/// This is the foundational class that enables unlimited customization
class FlexibleWidgetConfig {
  /// Core configuration map
  final Map<String, dynamic> _config;
  
  /// Theme context for the configuration
  final BuildContext? context;
  
  /// Default configuration values
  static const Map<String, dynamic> _defaults = {
    // Animation settings
    'enableAnimations': true,
    'animationDuration': 300,
    'animationCurve': 'easeInOut',
    
    // Interaction settings
    'enableHaptics': true,
    'enableSounds': false,
    'enableRipple': true,
    
    // Layout settings
    'borderRadius': 12.0,
    'padding': 16.0,
    'margin': 8.0,
    'spacing': 8.0,
    
    // Typography settings
    'fontSize': 16.0,
    'fontWeight': 'normal',
    'fontFamily': null,
    
    // Color settings
    'enableThemeColors': true,
    'customColors': <String, Color>{},
    
    // Accessibility settings
    'enableA11y': true,
    'semanticLabels': <String, String>{},
    'minimumTapTarget': 48.0,
    
    // Performance settings
    'enableCaching': true,
    'lazyLoading': true,
    'imageQuality': 'high',
    
    // Advanced features
    'enableGestures': true,
    'enableKeyboardShortcuts': false,
    'enableDebugMode': false,
  };

  const FlexibleWidgetConfig({
    Map<String, dynamic> config = const {},
    this.context,
  }) : _config = config;

  /// Creates a configuration with theme-aware defaults
  factory FlexibleWidgetConfig.fromTheme(
    BuildContext context, {
    Map<String, dynamic> overrides = const {},
  }) {
    return FlexibleWidgetConfig(
      context: context,
      config: {
        ..._defaults,
        ...overrides,
      },
    );
  }

  /// Creates a configuration for specific widget types
  factory FlexibleWidgetConfig.forWidget(
    String widgetType, {
    BuildContext? context,
    Map<String, dynamic> overrides = const {},
  }) {
    final widgetDefaults = _getWidgetDefaults(widgetType);
    return FlexibleWidgetConfig(
      context: context,
      config: {
        ..._defaults,
        ...widgetDefaults,
        ...overrides,
      },
    );
  }

  /// Get widget-specific defaults
  static Map<String, dynamic> _getWidgetDefaults(String widgetType) {
    switch (widgetType) {
      case 'button':
        return {
          'height': 48.0,
          'minWidth': 88.0,
          'enableElevation': true,
          'elevation': 2.0,
          'borderRadius': 8.0,
        };
      
      case 'card':
        return {
          'elevation': 4.0,
          'borderRadius': 12.0,
          'padding': 16.0,
          'enableShadow': true,
        };
      
      case 'input':
        return {
          'height': 56.0,
          'borderRadius': 8.0,
          'enableFloatingLabel': true,
          'enableCounter': false,
        };
      
      case 'grid':
        return {
          'crossAxisSpacing': 12.0,
          'mainAxisSpacing': 12.0,
          'childAspectRatio': 0.8,
          'enablePullToRefresh': true,
        };
      
      case 'list':
        return {
          'itemSpacing': 8.0,
          'enableDividers': false,
          'enableScrollIndicators': true,
          'enableInfiniteScroll': true,
        };
      
      default:
        return {};
    }
  }

  /// Get a configuration value with type safety
  T get<T>(String key, [T? defaultValue]) {
    final value = _config[key];
    if (value is T) return value;
    
    final defaultFromMap = _defaults[key];
    if (defaultFromMap is T) return defaultFromMap;
    
    if (defaultValue != null) return defaultValue;
    
    throw FlexibleConfigException(
      'Configuration key "$key" not found and no default provided'
    );
  }

  /// Get a configuration value with fallback
  T getOr<T>(String key, T fallback) {
    try {
      return get<T>(key);
    } catch (e) {
      return fallback;
    }
  }

  /// Check if a configuration key exists
  bool has(String key) {
    return _config.containsKey(key) || _defaults.containsKey(key);
  }

  /// Get all configuration keys
  Iterable<String> get keys => {..._defaults.keys, ..._config.keys};

  /// Create a new configuration with merged values
  FlexibleWidgetConfig merge(Map<String, dynamic> other) {
    return FlexibleWidgetConfig(
      context: context,
      config: {..._config, ...other},
    );
  }

  /// Create a new configuration with additional values
  FlexibleWidgetConfig copyWith({
    Map<String, dynamic>? config,
    BuildContext? context,
  }) {
    return FlexibleWidgetConfig(
      context: context ?? this.context,
      config: config != null ? {..._config, ...config} : _config,
    );
  }

  /// Get theme-aware color
  Color getColor(String key, [Color? defaultColor]) {
    // First check for custom color
    final customColors = get<Map<String, Color>>('customColors', {});
    if (customColors.containsKey(key)) {
      return customColors[key]!;
    }

    // Then check configuration
    final configColor = _config[key];
    if (configColor is Color) return configColor;

    // Then check if theme colors are enabled
    if (get<bool>('enableThemeColors', true) && context != null) {
      return _getThemeColor(key, context!) ?? defaultColor ?? Colors.grey;
    }

    return defaultColor ?? Colors.grey;
  }

  /// Get theme color by key
  Color? _getThemeColor(String key, BuildContext context) {
    final theme = Theme.of(context);
    
    switch (key) {
      case 'primary':
        return theme.primaryColor;
      case 'secondary':
        return theme.colorScheme.secondary;
      case 'surface':
        return theme.colorScheme.surface;
      case 'background': // deprecated alias
        return theme.colorScheme.surface; // map to surface to avoid deprecated background
      case 'error':
        return theme.colorScheme.error;
      case 'onPrimary':
        return theme.colorScheme.onPrimary;
      case 'onSecondary':
        return theme.colorScheme.onSecondary;
      case 'onSurface':
        return theme.colorScheme.onSurface;
      case 'onBackground': // deprecated alias
        return theme.colorScheme.onSurface;
      case 'onError':
        return theme.colorScheme.onError;
      default:
        return null;
    }
  }

  /// Get animation curve
  Curve getCurve(String key, [Curve? defaultCurve]) {
    final curveString = get<String>(key, 'easeInOut');
    return _stringToCurve(curveString) ?? defaultCurve ?? Curves.easeInOut;
  }

  /// Convert string to curve
  Curve? _stringToCurve(String curveString) {
    switch (curveString.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'easeIn':
      case 'easein':
        return Curves.easeIn;
      case 'easeOut':
      case 'easeout':
        return Curves.easeOut;
      case 'easeInOut':
      case 'easeinout':
        return Curves.easeInOut;
      case 'bounceIn':
      case 'bouncein':
        return Curves.bounceIn;
      case 'bounceOut':
      case 'bounceout':
        return Curves.bounceOut;
      case 'elasticIn':
      case 'elasticin':
        return Curves.elasticIn;
      case 'elasticOut':
      case 'elasticout':
        return Curves.elasticOut;
      case 'fastOutSlowIn':
      case 'fastoutslowIn':
        return Curves.fastOutSlowIn;
      default:
        return null;
    }
  }

  /// Get font weight from string or FontWeight
  FontWeight getFontWeight(String key, [FontWeight? defaultWeight]) {
    final value = _config[key];
    
    if (value is FontWeight) return value;
    
    if (value is String) {
      return _stringToFontWeight(value) ?? defaultWeight ?? FontWeight.normal;
    }
    
    return defaultWeight ?? FontWeight.normal;
  }

  /// Convert string to font weight
  FontWeight? _stringToFontWeight(String weightString) {
    switch (weightString.toLowerCase()) {
      case 'thin':
      case '100':
        return FontWeight.w100;
      case 'extralight':
      case 'ultralight':
      case '200':
        return FontWeight.w200;
      case 'light':
      case '300':
        return FontWeight.w300;
      case 'normal':
      case 'regular':
      case '400':
        return FontWeight.w400;
      case 'medium':
      case '500':
        return FontWeight.w500;
      case 'semibold':
      case 'demibold':
      case '600':
        return FontWeight.w600;
      case 'bold':
      case '700':
        return FontWeight.w700;
      case 'extrabold':
      case 'ultrabold':
      case '800':
        return FontWeight.w800;
      case 'black':
      case 'heavy':
      case '900':
        return FontWeight.w900;
      default:
        return null;
    }
  }

  /// Get BorderRadius from configuration
  BorderRadius getBorderRadius(String key, [BorderRadius? defaultRadius]) {
    final value = _config[key];
    
    if (value is BorderRadius) return value;
    
    if (value is double) {
      return BorderRadius.circular(value);
    }
    
    if (value is Map<String, dynamic>) {
      return BorderRadius.only(
        topLeft: Radius.circular(value['topLeft'] ?? 0.0),
        topRight: Radius.circular(value['topRight'] ?? 0.0),
        bottomLeft: Radius.circular(value['bottomLeft'] ?? 0.0),
        bottomRight: Radius.circular(value['bottomRight'] ?? 0.0),
      );
    }
    
    return defaultRadius ?? BorderRadius.circular(get<double>('borderRadius', 12.0));
  }

  /// Get EdgeInsets from configuration
  EdgeInsets getEdgeInsets(String key, [EdgeInsets? defaultInsets]) {
    final value = _config[key];
    
    if (value is EdgeInsets) return value;
    
    if (value is double) {
      return EdgeInsets.all(value);
    }
    
    if (value is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: value['left']?.toDouble() ?? 0.0,
        top: value['top']?.toDouble() ?? 0.0,
        right: value['right']?.toDouble() ?? 0.0,
        bottom: value['bottom']?.toDouble() ?? 0.0,
      );
    }
    
    if (value is List<double> && value.length >= 2) {
      if (value.length == 2) {
        return EdgeInsets.symmetric(vertical: value[0], horizontal: value[1]);
      } else if (value.length >= 4) {
        return EdgeInsets.fromLTRB(value[0], value[1], value[2], value[3]);
      }
    }
    
    return defaultInsets ?? EdgeInsets.all(get<double>('padding', 16.0));
  }

  /// Get Duration from configuration
  Duration getDuration(String key, [Duration? defaultDuration]) {
    final value = _config[key];
    
    if (value is Duration) return value;
    
    if (value is int) {
      return Duration(milliseconds: value);
    }
    
    if (value is double) {
      return Duration(milliseconds: value.round());
    }
    
    return defaultDuration ?? Duration(milliseconds: get<int>('animationDuration', 300));
  }

  /// Get Size from configuration
  Size getSize(String key, [Size? defaultSize]) {
    final value = _config[key];
    
    if (value is Size) return value;
    
    if (value is Map<String, dynamic>) {
      final width = value['width']?.toDouble() ?? 0.0;
      final height = value['height']?.toDouble() ?? 0.0;
      return Size(width, height);
    }
    
    if (value is List<double> && value.length >= 2) {
      return Size(value[0], value[1]);
    }
    
    return defaultSize ?? const Size(200, 100);
  }

  /// Debug information
  Map<String, dynamic> toDebugMap() {
    return {
      'config': _config,
      'defaults': _defaults,
      'hasContext': context != null,
    };
  }

  @override
  String toString() {
    return 'FlexibleWidgetConfig(${_config.length} configs, hasContext: ${context != null})';
  }
}

/// Exception thrown when configuration access fails
class FlexibleConfigException implements Exception {
  final String message;
  
  const FlexibleConfigException(this.message);
  
  @override
  String toString() => 'FlexibleConfigException: $message';
}

/// Helper class for building configurations fluently
class FlexibleConfigBuilder {
  final Map<String, dynamic> _config = {};
  BuildContext? _context;

  FlexibleConfigBuilder([this._context]);

  /// Set a configuration value
  FlexibleConfigBuilder set<T>(String key, T value) {
    _config[key] = value;
    return this;
  }

  /// Set multiple configuration values
  FlexibleConfigBuilder setAll(Map<String, dynamic> values) {
    _config.addAll(values);
    return this;
  }

  /// Set context
  FlexibleConfigBuilder withContext(BuildContext context) {
    _context = context;
    return this;
  }

  /// Enable feature
  FlexibleConfigBuilder enable(String feature) {
    return set(feature, true);
  }

  /// Disable feature
  FlexibleConfigBuilder disable(String feature) {
    return set(feature, false);
  }

  /// Set color
  FlexibleConfigBuilder color(String key, Color color) {
    return set(key, color);
  }

  /// Set size
  FlexibleConfigBuilder size(String key, double value) {
    return set(key, value);
  }

  /// Set duration
  FlexibleConfigBuilder duration(String key, Duration duration) {
    return set(key, duration);
  }

  /// Set animation curve
  FlexibleConfigBuilder curve(String key, Curve curve) {
    return set(key, curve);
  }

  /// Build the configuration
  FlexibleWidgetConfig build() {
    return FlexibleWidgetConfig(
      config: Map.from(_config),
      context: _context,
    );
  }
}

/// Extension to make configuration building more convenient
extension FlexibleConfigExtensions on Map<String, dynamic> {
  FlexibleWidgetConfig toFlexibleConfig([BuildContext? context]) {
    return FlexibleWidgetConfig(config: this, context: context);
  }
}
