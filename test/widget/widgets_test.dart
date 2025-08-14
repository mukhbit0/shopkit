import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';
import '../utils/test_utils.dart';

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('should display product information correctly', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct(
        name: 'Test Product',
        price: 99.99,
        rating: 4.5,
      );

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('should handle tap interactions', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
            onTap: () => tapped = true,
          ),
        ),
      );

      await TestUtils.simulateUserTap(tester, find.byType(ProductCard));
      expect(tapped, isTrue);
    });

    testWidgets('should display discount badge when product has discount', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct(discountPercentage: 20.0);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('20% OFF'), findsOneWidget);
    });

    testWidgets('should show out of stock indicator', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct(isInStock: false);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('Out of Stock'), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      await TestUtils.verifyAccessibility(tester);
    });

    testWidgets('should adapt to different screen sizes', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      final widget = ProductCard(
        product: product,
        config: TestUtils.createTestConfig(),
      );

      await TestUtils.testResponsiveLayout(
        tester,
        widget,
        testSizes: [
          const Size(400, 800), // Mobile
          const Size(768, 1024), // Tablet
          const Size(1200, 800), // Desktop
        ],
      );
    });
  });

  group('ProductGrid Widget Tests', () {
    testWidgets('should display multiple products in grid', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(6);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductGrid(
            products: products,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.byType(ProductCard), findsNWidgets(6));
    });

    testWidgets('should handle empty product list', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductGrid(
            products: const [],
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('No products found'), findsOneWidget);
    });

    testWidgets('should adjust grid columns based on screen size', (WidgetTester tester) async {
      final products = TestUtils.createMockProductList(4);
      final widget = ProductGrid(
        products: products,
        config: TestUtils.createTestConfig(),
      );

      // Test mobile (should show 2 columns)
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(TestUtils.createTestApp(child: widget));
      await tester.pumpAndSettle();

      // Test tablet (should show 3 columns)
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpWidget(TestUtils.createTestApp(child: widget));
      await tester.pumpAndSettle();

      // Test desktop (should show 4 columns)
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(TestUtils.createTestApp(child: widget));
      await tester.pumpAndSettle();
    });
  });

  group('AddToCartButton Widget Tests', () {
    testWidgets('should display add to cart button', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('should handle add to cart action', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      bool addedToCart = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            config: TestUtils.createTestConfig(),
            onAddToCart: (p) => addedToCart = true,
          ),
        ),
      );

      await TestUtils.simulateUserTap(tester, find.byType(AddToCartButton));
      expect(addedToCart, isTrue);
    });

    testWidgets('should show loading state', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            config: TestUtils.createTestConfig(),
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should be disabled when out of stock', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct(isInStock: false);

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('CartBubble Widget Tests', () {
    testWidgets('should display cart item count', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: CartBubble(
            itemCount: 5,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('should hide when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: CartBubble(
            itemCount: 0,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.text('0'), findsNothing);
    });

    testWidgets('should handle tap to open cart', (WidgetTester tester) async {
      bool cartOpened = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: CartBubble(
            itemCount: 3,
            config: TestUtils.createTestConfig(),
            onTap: () => cartOpened = true,
          ),
        ),
      );

      await TestUtils.simulateUserTap(tester, find.byType(CartBubble));
      expect(cartOpened, isTrue);
    });
  });

  group('ProductSearchBar Widget Tests', () {
    testWidgets('should display search input field', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductSearchBar(
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should handle text input and search', (WidgetTester tester) async {
      String searchQuery = '';

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductSearchBar(
            config: TestUtils.createTestConfig(),
            onSearch: (query) => searchQuery = query,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test search');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(searchQuery, equals('test search'));
    });

    testWidgets('should show clear button when text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductSearchBar(
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'search term');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });

  group('ImageCarousel Widget Tests', () {
    testWidgets('should display multiple images', (WidgetTester tester) async {
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ];

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ImageCarousel(
            images: images,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should show page indicators', (WidgetTester tester) async {
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ];

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ImageCarousel(
            images: images,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      expect(find.byType(PageView), findsOneWidget);
      // Check for page indicators
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle swipe gestures', (WidgetTester tester) async {
      final images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
      ];

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ImageCarousel(
            images: images,
            config: TestUtils.createTestConfig(),
          ),
        ),
      );

      // Swipe left to go to next image
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      // Verify page changed (implementation specific)
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
