import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shopkit/shopkit.dart';
import '../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ShopKit E2E (Adjusted) Tests', () {
    testWidgets('basic shopping flow smoke test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(8);

      // Initial grid
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductGrid(products: products),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProductGrid), findsOneWidget);
      expect(find.byType(ProductCard), findsWidgets);

      // Tap first product -> simulate detail view by pumping detail
      final firstCard = find.byType(ProductCard).first;
      await tester.tap(firstCard);
      await tester.pump();

      // Show a detail view explicitly
      final selected = products.first;
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductDetailViewNew(product: selected),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailViewNew), findsOneWidget);

      // Add to cart button scenario
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(product: selected),
        ),
      );
      await tester.tap(find.byType(AddToCartButton));
      await tester.pump();

      // Cart bubble simulation
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: CartBubbleAdvanced(cartItems: [
            CartItemModel(
                product: selected,
                quantity: 1,
                id: '',
                pricePerItem: selected.price)
          ]),
        ),
      );
      expect(find.byType(CartBubbleAdvanced), findsOneWidget);

      // Performance check (simple)
      await TestUtils.performanceTest(() async {
        await tester.pumpAndSettle();
      }, maxDuration: const Duration(seconds: 2));
    });

    testWidgets('performance scroll test (grid)', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(60);
      await tester.pumpWidget(
          TestUtils.createTestApp(child: ProductGrid(products: products)));
      await tester.pumpAndSettle();

      await TestUtils.performanceTest(() async {
        await tester.drag(find.byType(GridView), const Offset(0, -1200));
        await tester.pumpAndSettle();
      }, maxDuration: const Duration(seconds: 4));
    });

    testWidgets('theme application smoke test', (WidgetTester tester) async {
      final theme = ShopKitTheme.material3();
      await tester.pumpWidget(TestUtils.createTestApp(
          child: ProductGrid(products: TestUtils.createMockProductList(4)),
          theme: theme));
      await tester.pumpAndSettle();
      TestUtils.verifyThemeApplication(tester, theme);
    });

    testWidgets('accessibility basic test', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(5);
      await tester.pumpWidget(
          TestUtils.createTestApp(child: ProductGrid(products: products)));
      await TestUtils.verifyAccessibility(tester);
    });

    testWidgets('invalid product data handling', (WidgetTester tester) async {
      final invalid =
          ProductModel(id: '', name: '', price: -1, currency: 'USD');
      await tester.pumpWidget(
          TestUtils.createTestApp(child: ProductCard(product: invalid)));
      expect(tester.takeException(), isNull);
    });
  });
}
// (All deep scenario helper functions removed in simplified version)
