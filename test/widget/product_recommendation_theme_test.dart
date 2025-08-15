import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/src/widgets/product_discovery/product_recommendation.dart';
import 'package:shopkit/src/models/product_model.dart';

void main() {
  group('ProductRecommendation Theme Migration Tests', () {
    late List<ProductModel> testProducts;

    setUp(() {
      testProducts = [
        const ProductModel(
          id: '1',
          name: 'Test Product 1',
          price: 29.99,
          currency: 'USD',
          imageUrl: 'https://example.com/image1.jpg',
        ),
        const ProductModel(
          id: '2',
          name: 'Test Product 2',
          price: 39.99,
          currency: 'USD',
          imageUrl: 'https://example.com/image2.jpg',
        ),
      ];
    });

    testWidgets('should render without themeStyle', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductRecommendation(
              products: testProducts,
              title: 'Test Recommendations',
            ),
          ),
        ),
      );

      expect(find.text('Test Recommendations'), findsOneWidget);
      expect(find.byType(ProductRecommendation), findsOneWidget);
    });

    testWidgets('should render with themeStyle parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductRecommendation(
              products: testProducts,
              title: 'Test Recommendations',
              themeStyle: 'glassmorphism', // NEW: Theme style support
            ),
          ),
        ),
      );

      expect(find.text('Test Recommendations'), findsOneWidget);
      expect(find.byType(ProductRecommendation), findsOneWidget);
    });

    testWidgets('should render with different theme styles', (WidgetTester tester) async {
      const themeStyles = ['material3', 'neumorphism', 'glassmorphism', 'neon'];
      
      for (String style in themeStyles) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProductRecommendation(
                products: testProducts,
                title: 'Test $style',
                themeStyle: style,
              ),
            ),
          ),
        );

        expect(find.text('Test $style'), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
