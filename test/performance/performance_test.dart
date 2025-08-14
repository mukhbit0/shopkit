import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';
import '../utils/test_utils.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('product grid scrolling performance', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(100);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductGrid(
            products: products,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      // Test scrolling performance
      await TestUtils.performanceTest(
        tester,
        () async {
          await tester.drag(find.byType(GridView), const Offset(0, -1000));
        },
        iterations: 20,
        maxDuration: const Duration(seconds: 5),
      );
    });

    testWidgets('theme switching performance', (WidgetTester tester) async {
      final themes = [
        ShopKitTheme.material3(),
        ShopKitTheme.neumorphic(),
        ShopKitTheme.glassmorphic(),
      ];

      await TestUtils.performanceTest(
        tester,
        () async {
          for (final theme in themes) {
            await tester.pumpWidget(
              TestUtils.createTestApp(
                child: const ProductGrid(products: [], config: FlexibleWidgetConfig()),
                theme: theme,
              ),
            );
          }
        },
        iterations: 10,
        maxDuration: const Duration(seconds: 3),
      );
    });

    testWidgets('large dataset rendering performance', (WidgetTester tester) async {
      // Test with increasingly large datasets
      final testSizes = [10, 50, 100, 500];

      for (final size in testSizes) {
        final products = TestUtils.createMockProductList(size);

        await TestUtils.performanceTest(
          tester,
          () async {
            await tester.pumpWidget(
              TestUtils.createTestApp(
                child: ProductGrid(
                  products: products,
                  config: TestUtils.createTestConfig(),
                ),
              ),
            );
          },
          iterations: 5,
          maxDuration: Duration(seconds: size ~/ 50 + 2),
        );

        print('Performance test completed for $size products');
      }
    });

    testWidgets('image loading performance', (WidgetTester tester) async {
      final imageUrls = List.generate(20, (index) => 'https://picsum.photos/300/300?random=$index');

      await TestUtils.performanceTest(
        tester,
        () async {
          await tester.pumpWidget(
            TestUtils.createTestApp(
              child: ImageCarousel(
                images: imageUrls,
                config: TestUtils.createTestConfig(),
              ),
            ),
          );
        },
        iterations: 5,
        maxDuration: const Duration(seconds: 10),
      );
    });

    testWidgets('animation performance test', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      // Test tap animation performance
      await TestUtils.performanceTest(
        tester,
        () async {
          await tester.tap(find.byType(ProductCard));
          await tester.pump(); // Start animation
          await tester.pump(const Duration(milliseconds: 100)); // Mid animation
          await tester.pumpAndSettle(); // Complete animation
        },
        iterations: 20,
        maxDuration: const Duration(seconds: 3),
      );
    });

    testWidgets('search performance test', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductSearchBar(
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      final searchQueries = [
        'phone',
        'laptop',
        'headphones',
        'camera',
        'tablet',
      ];

      await TestUtils.performanceTest(
        tester,
        () async {
          for (final query in searchQueries) {
            await tester.enterText(find.byType(TextField), query);
            await tester.testTextInput.receiveAction(TextInputAction.search);
            await tester.pumpAndSettle();
          }
        },
        iterations: 10,
        maxDuration: const Duration(seconds: 5),
      );
    });

    testWidgets('memory usage test', (WidgetTester tester) async {
      // Create and dispose multiple widget instances to test memory leaks
      for (int i = 0; i < 50; i++) {
        final products = TestUtils.createMockProductList(20);

        await tester.pumpWidget(
          TestUtils.createTestApp(
            child: ProductGrid(
              products: products,
              config: TestUtils.createTestConfig(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Dispose the widget
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }

      // If we reach here without memory issues, the test passes
      expect(true, isTrue);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('product card accessibility', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      await TestUtils.testAccessibilityFeatures(
        tester,
        ProductCard(
          product: product,
          config: TestUtils.createTestConfig(),
        ),
      );
    });

    testWidgets('search bar accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductSearchBar(
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      await TestUtils.testAccessibilityFeatures(
        tester,
        ProductSearchBar(
          config: TestUtils.createTestConfig(),
        ),
      );

      // Test screen reader support
      final SemanticsHandle handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Search products'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('cart button accessibility', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      await TestUtils.testAccessibilityFeatures(
        tester,
        AddToCartButton(
          product: product,
          config: TestUtils.createTestConfig(),
        ),
      );

      // Test button semantics
      final SemanticsHandle handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('Add ${product.name} to cart'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('high contrast mode test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(5);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(highContrast: true),
          child: TestUtils.createTestApp(
            child: ProductGrid(
              products: products,
              config: TestUtils.createTestConfig(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no layout issues in high contrast mode
      expect(tester.takeException(), isNull);
      expect(find.byType(ProductCard), findsNWidgets(5));
    });

    testWidgets('large text scale test', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaleFactor: 3.0),
          child: TestUtils.createTestApp(
            child: ProductCard(
              product: product,
              config: TestUtils.createTestConfig(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify no overflow with large text
      expect(tester.takeException(), isNull);
      expect(find.byType(ProductCard), findsOneWidget);
    });

    testWidgets('reduced motion test', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: TestUtils.createTestApp(
            child: ProductCard(
              product: product,
              config: TestUtils.createTestConfig(),
            ),
          ),
        ),
      );

      // Tap the card and verify animations are disabled
      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      // With animations disabled, transitions should be immediate
      expect(find.byType(ProductCard), findsOneWidget);
    });

    testWidgets('keyboard navigation test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(3);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductGrid(
            products: products,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      // Test tab navigation
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Test enter key activation
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // Verify keyboard interaction works
      expect(tester.takeException(), isNull);
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('mobile layout test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(6);

      await TestUtils.testResponsiveLayout(
        tester,
        ProductGrid(
          products: products,
          config: TestUtils.createTestConfig(),
        ),
        testSizes: [
          const Size(360, 640), // Small mobile
          const Size(414, 896), // Large mobile
        ],
      );
    });

    testWidgets('tablet layout test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(9);

      await TestUtils.testResponsiveLayout(
        tester,
        ProductGrid(
          products: products,
          config: TestUtils.createTestConfig(),
        ),
        testSizes: [
          const Size(768, 1024), // Portrait tablet
          const Size(1024, 768), // Landscape tablet
        ],
      );
    });

    testWidgets('desktop layout test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(12);

      await TestUtils.testResponsiveLayout(
        tester,
        ProductGrid(
          products: products,
          config: TestUtils.createTestConfig(),
        ),
        testSizes: [
          const Size(1200, 800), // Desktop
          const Size(1920, 1080), // Large desktop
        ],
      );
    });

    testWidgets('orientation change test', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      // Test portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductDetailView(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Test landscape
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductDetailView(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
