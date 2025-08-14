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
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('should handle tap interactions', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      bool tapped = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(ProductCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('should handle add to cart callback', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
     

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            onAddToCart: (item) =>  item,
          ),
        ),
      );

      // Should render without error even with callback
      expect(find.byType(ProductCard), findsOneWidget);
    });
  });

  group('AddToCartButton Widget Tests', () {
    testWidgets('should display with product correctly', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            onAddToCart: (item) {},
          ),
        ),
      );

      expect(find.byType(AddToCartButton), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            isLoading: true,
            onAddToCart: (item) {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle tap when not loading', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      bool pressed = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            isLoading: false,
            onAddToCart: (item) => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(AddToCartButton));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('should display custom text', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();
      
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AddToCartButton(
            product: product,
            text: 'Buy Now',
            onAddToCart: (item) {},
          ),
        ),
      );

      expect(find.text('Buy Now'), findsOneWidget);
    });
  });

  group('ImageCarousel Widget Tests', () {
    testWidgets('should display single image', (WidgetTester tester) async {
      final images = [
        const ImageModel(id: '1', url: 'test1.jpg', altText: 'Test Image 1'),
      ];

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ImageCarousel(
            images: images,
          ),
        ),
      );

      expect(find.byType(ImageCarousel), findsOneWidget);
    });

    testWidgets('should display multiple images', (WidgetTester tester) async {
      final images = [
        const ImageModel(id: '1', url: 'test1.jpg', altText: 'Test Image 1'),
        const ImageModel(id: '2', url: 'test2.jpg', altText: 'Test Image 2'),
      ];

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ImageCarousel(
            images: images,
          ),
        ),
      );

      expect(find.byType(ImageCarousel), findsOneWidget);
    });

    testWidgets('should handle empty image list', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: const ImageCarousel(
            images: [],
          ),
        ),
      );

      // Should handle gracefully or show placeholder
      expect(find.byType(ImageCarousel), findsOneWidget);
    });
  });

  group('Widget Infrastructure Tests', () {
    testWidgets('ProductCard with fixed layout constraints', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: ProductCard(
            product: product,
            width: 200,
            height: 300,
          ),
        ),
      );

      expect(find.byType(ProductCard), findsOneWidget);
      
      // Verify no layout exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('ProductCard without explicit dimensions', (WidgetTester tester) async {
      final product = TestUtils.createMockProduct();

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: SingleChildScrollView(
            child: ProductCard(
              product: product,
            ),
          ),
        ),
      );

      expect(find.byType(ProductCard), findsOneWidget);
      
      // Verify no layout exceptions after our fix
      expect(tester.takeException(), isNull);
    });
  });
}
