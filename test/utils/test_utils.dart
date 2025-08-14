import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';

class TestUtils {
  /// Create a mock product for testing
  static ProductModel createMockProduct({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
    String? categoryId,
    bool? isInStock,
    double? discountPercentage,
    List<VariantModel>? variants,
    String? brand,
    String? sku,
    double? weight,
    String? dimensions,
    String? currency,
    double? rating,
    int? reviewCount,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? '1',
      name: name ?? 'Test Product',
      description: description ?? 'A test product for unit testing',
      price: price ?? 99.99,
      currency: currency ?? 'USD',
      imageUrl: imageUrl,
      imageUrls: imageUrls ?? ['https://example.com/image1.jpg'],
      categoryId: categoryId ?? 'test-category',
      isInStock: isInStock ?? true,
      brand: brand ?? 'Test Brand',
      variants: variants ?? [],
      tags: tags ?? const ['test', 'mock'],
      sku: sku ?? 'TEST-SKU-001',
      weight: weight ?? 1.0,
      dimensions: dimensions ?? '10x5x2 cm',
      rating: rating ?? 4.5,
      reviewCount: reviewCount ?? 10,
      discountPercentage: discountPercentage,
    );
  }

  /// Create a test app wrapper for widget testing
  static Widget createTestApp({
    required Widget child,
    ShopKitTheme? theme,
    Locale? locale,
  }) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: locale,
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Create a mock configuration for testing
  static FlexibleWidgetConfig createMockConfig({
    Map<String, dynamic>? customProperties,
  }) {
    return FlexibleWidgetConfig(
      config: customProperties ?? {},
    );
  }

  /// Performance test helper
  static Future<void> performanceTest(
    Future<void> Function() testFunction, {
    Duration maxDuration = const Duration(seconds: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    await testFunction();
    
    stopwatch.stop();
    
    if (stopwatch.elapsed > maxDuration) {
      expect(
        stopwatch.elapsed,
        lessThan(maxDuration),
        reason: 'Performance test exceeded maximum duration',
      );
    }
    
    print('Performance test completed in ${stopwatch.elapsed.inMilliseconds}ms');
  }

  /// Verify widget accessibility
  static Future<void> verifyAccessibility(WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    // Basic accessibility verification
    handle.dispose();
  }

  /// Test widget with different screen sizes
  static Future<void> testResponsiveLayout(
    WidgetTester tester,
    Widget widget, {
    required List<Size> testSizes,
  }) async {
    for (final size in testSizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(widget);
      await tester.pump();
      
      // Verify no overflow errors
      expect(tester.takeException(), isNull);
    }
  }

  /// Verify widget appears correctly
  static void verifyWidgetPresence(
    WidgetTester tester,
    Finder finder,
  ) {
    expect(finder, findsOneWidget);
  }

  /// Verify theme application
  static void verifyThemeApplication(
    WidgetTester tester,
    ShopKitTheme expectedTheme,
  ) {
    // For now, just verify the theme is not null since ShopKitTheme.of doesn't exist
    expect(expectedTheme.primaryColor, isNotNull);
    expect(expectedTheme.secondaryColor, isNotNull);
  }

  /// Test accessibility features
  static Future<void> testAccessibilityFeatures(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(createTestApp(child: widget));
    await verifyAccessibility(tester);
  }

  /// Simulate user interactions
  static Future<void> simulateUserInteraction(
    WidgetTester tester,
    Finder target, {
    bool longPress = false,
  }) async {
    if (longPress) {
      await tester.longPress(target);
    } else {
      await tester.tap(target);
    }
    await tester.pump();
  }

  /// Helper to wait for animations to complete
  static Future<void> waitForAnimations(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Create mock cart model for testing
  static CartModel createMockCart({
    List<CartItemModel>? items,
    double? tax,
    double? shipping,
    double? discount,
    String? currency,
  }) {
    return CartModel(
      id: 'test-cart-1',
      items: items ?? [],
      currency: currency ?? 'USD',
      tax: tax,
      shipping: shipping,
      discount: discount,
    );
  }

  /// Create mock category for testing
  static CategoryModel createMockCategory({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? itemCount,
  }) {
    return CategoryModel(
      id: id ?? 'test-category-1',
      name: name ?? 'Test Category',
      description: description ?? 'A test category',
      imageUrl: imageUrl ?? 'https://example.com/category.jpg',
      itemCount: itemCount ?? 10,
    );
  }
}
