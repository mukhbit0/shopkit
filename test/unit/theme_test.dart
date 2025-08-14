import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';

void main() {
  group('ShopKitTheme Tests', () {
    test('should create material3 theme correctly', () {
      final theme = ShopKitTheme.material3();

      expect(theme.style, equals(ShopKitThemeStyle.material3));
      expect(theme.primaryColor, isNotNull);
      expect(theme.secondaryColor, isNotNull);
      expect(theme.surfaceColor, isNotNull);
      expect(theme.textTheme, isNotNull);
    });

    test('should create neumorphic theme correctly', () {
      final theme = ShopKitTheme.neumorphic();

      expect(theme.style, equals(ShopKitThemeStyle.neumorphic));
      expect(theme.primaryColor, isNotNull);
      expect(theme.secondaryColor, isNotNull);
      expect(theme.surfaceColor, isNotNull);
      expect(theme.cardElevation, isA<double>());
    });

    test('should create glassmorphic theme correctly', () {
      final theme = ShopKitTheme.glassmorphic();

      expect(theme.style, equals(ShopKitThemeStyle.glassmorphic));
      expect(theme.primaryColor, isNotNull);
      expect(theme.secondaryColor, isNotNull);
      expect(theme.surfaceColor, isNotNull);
      expect(theme.borderRadius, isA<double>());
    });

    test('should allow custom seed color', () {
      const customSeed = Color(0xFF123456);

      final theme = ShopKitTheme.material3(
        seedColor: customSeed,
      );

      expect(theme.primaryColor, isNotNull);
      expect(theme.secondaryColor, isNotNull);
    });

    test('should have consistent theme properties', () {
      final theme = ShopKitTheme.material3();
      
      expect(theme.style, equals(ShopKitThemeStyle.material3));
      expect(theme.primaryColor, isNotNull);
      expect(theme.secondaryColor, isNotNull);
      expect(theme.borderRadius, greaterThan(0));
      expect(theme.cardElevation, greaterThanOrEqualTo(0));
    });

    test('should support different brightness', () {
      final lightTheme = ShopKitTheme.material3(brightness: Brightness.light);
      final darkTheme = ShopKitTheme.material3(brightness: Brightness.dark);

      expect(lightTheme.style, equals(ShopKitThemeStyle.material3));
      expect(darkTheme.style, equals(ShopKitThemeStyle.material3));
      // Colors should be different between light and dark
      expect(lightTheme.primaryColor.r, isNot(equals(darkTheme.primaryColor.r)));
    });
  });

  group('FlexibleWidgetConfig Tests', () {
    test('should create default configuration', () {
      const config = FlexibleWidgetConfig();

      expect(config.get<bool>('enableAnimations'), isTrue);
      expect(config.get<int>('animationDuration'), equals(300));
      expect(config.get<bool>('enableHaptics'), isTrue);
    });

    test('should create configuration with custom values', () {
      final customConfig = {
        'customProperty': 'testValue',
        'enableAnimations': false,
      };

      final config = FlexibleWidgetConfig(config: customConfig);

      expect(config.get<String>('customProperty'), equals('testValue'));
      expect(config.get<bool>('enableAnimations'), isFalse);
    });

    test('should handle missing properties gracefully', () {
      const config = FlexibleWidgetConfig();

      expect(() => config.get<String>('nonexistent'), throwsA(isA<Exception>()));
      expect(config.getOr<String>('nonexistent', 'default'), equals('default'));
    });

    test('should check if properties exist', () {
      const config = FlexibleWidgetConfig();

      expect(config.has('enableAnimations'), isTrue);
      expect(config.has('nonexistentProperty'), isFalse);
    });

    test('should merge configurations correctly', () {
      const config1 = FlexibleWidgetConfig(config: {'prop1': 'value1', 'prop2': 'value2'});
      final additionalConfig = {'prop2': 'newValue2', 'prop3': 'value3'};

      final merged = config1.merge(additionalConfig);

      expect(merged.get<String>('prop1'), equals('value1'));
      expect(merged.get<String>('prop2'), equals('newValue2')); // Overridden
      expect(merged.get<String>('prop3'), equals('value3'));
    });

    test('should copy configuration with new values', () {
      const originalConfig = FlexibleWidgetConfig(config: {
        'originalProp': 'originalValue',
      });

      final copied = originalConfig.copyWith(config: {
        'newProp': 'newValue',
      });

      expect(copied.get<String>('originalProp'), equals('originalValue'));
      expect(copied.get<String>('newProp'), equals('newValue'));
    });

    test('should handle widget-specific configurations', () {
      final buttonConfig = FlexibleWidgetConfig.forWidget('button');

      expect(buttonConfig.get<double>('height'), equals(48.0));
      expect(buttonConfig.get<double>('minWidth'), equals(88.0));
      expect(buttonConfig.get<bool>('enableElevation'), isTrue);
    });
  });
}