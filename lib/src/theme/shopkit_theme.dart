import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Modern ShopKit theme system built on top of shadcn/ui
class ShopKitTheme {
  const ShopKitTheme._({
    required this.shadTheme,
    required this.colorScheme,
    required this.spacing,
    required this.borderRadius,
    required this.elevation,
    required this.typography,
  });

  final ShadThemeData shadTheme;
  final ShadColorScheme colorScheme;
  final ShopKitSpacing spacing;
  final ShopKitBorderRadius borderRadius;
  final ShopKitElevation elevation;
  final ShopKitTypography typography;

  /// Light theme configuration
  static ShopKitTheme light({
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    final shadTheme = ShadThemeData(
      brightness: Brightness.light,
      colorScheme: ShadColorScheme.fromName('blue'),
    );

    return ShopKitTheme._(
      shadTheme: shadTheme,
      colorScheme: shadTheme.colorScheme,
      spacing: const ShopKitSpacing(),
      borderRadius: const ShopKitBorderRadius(),
      elevation: const ShopKitElevation(),
      typography: const ShopKitTypography(),
    );
  }

  /// Dark theme configuration
  static ShopKitTheme dark({
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    final shadTheme = ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: ShadColorScheme.fromName('blue', brightness: Brightness.dark),
    );

    return ShopKitTheme._(
      shadTheme: shadTheme,
      colorScheme: shadTheme.colorScheme,
      spacing: const ShopKitSpacing(),
      borderRadius: const ShopKitBorderRadius(),
      elevation: const ShopKitElevation(),
      typography: const ShopKitTypography(),
    );
  }

  /// Custom theme with specific color scheme
  static ShopKitTheme custom({
    required String colorScheme,
    Brightness brightness = Brightness.light,
  }) {
    final shadTheme = ShadThemeData(
      brightness: brightness,
      colorScheme: ShadColorScheme.fromName(colorScheme, brightness: brightness),
    );

    return ShopKitTheme._(
      shadTheme: shadTheme,
      colorScheme: shadTheme.colorScheme,
      spacing: const ShopKitSpacing(),
      borderRadius: const ShopKitBorderRadius(),
      elevation: const ShopKitElevation(),
      typography: const ShopKitTypography(),
    );
  }

  /// Copy theme with modifications
  ShopKitTheme copyWith({
    ShadThemeData? shadTheme,
    ShadColorScheme? colorScheme,
    ShopKitSpacing? spacing,
    ShopKitBorderRadius? borderRadius,
    ShopKitElevation? elevation,
    ShopKitTypography? typography,
  }) {
    return ShopKitTheme._(
      shadTheme: shadTheme ?? this.shadTheme,
      colorScheme: colorScheme ?? this.colorScheme,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      typography: typography ?? this.typography,
    );
  }
}

/// Spacing system for consistent layout
class ShopKitSpacing {
  const ShopKitSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
}

/// Border radius system
class ShopKitBorderRadius {
  const ShopKitBorderRadius({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
}

/// Elevation system
class ShopKitElevation {
  const ShopKitElevation({
    this.none = 0,
    this.sm = 2,
    this.md = 4,
    this.lg = 8,
    this.xl = 12,
  });

  final double none;
  final double sm;
  final double md;
  final double lg;
  final double xl;
}

/// Typography system
class ShopKitTypography {
  const ShopKitTypography();

  TextStyle get h1 => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  TextStyle get h2 => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  TextStyle get h3 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  TextStyle get h4 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  TextStyle get body1 => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  TextStyle get body2 => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  TextStyle get button => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );
}

/// Main app wrapper that provides ShopKit theming
class ShopKitApp extends StatelessWidget {
  const ShopKitApp({
    super.key,
    required this.home,
    this.title = 'ShopKit App',
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.debugShowCheckedModeBanner = false,
  });

  final Widget home;
  final String title;
  final ShopKitTheme? theme;
  final ShopKitTheme? darkTheme;
  final ThemeMode themeMode;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    final lightTheme = theme ?? ShopKitTheme.light();
    final darkThemeData = darkTheme ?? ShopKitTheme.dark();

    return ShadApp(
      title: title,
      theme: lightTheme.shadTheme,
      darkTheme: darkThemeData.shadTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      home: home,
    );
  }
}
