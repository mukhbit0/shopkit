import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';

void main() {
  group('Basic ProductModel Tests', () {
    test('should create a product model', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 99.99,
        currency: 'USD',
      );

      expect(product.id, equals('1'));
      expect(product.name, equals('Test Product'));
      expect(product.price, equals(99.99));
      expect(product.currency, equals('USD'));
    });

    test('should calculate discounted price', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        currency: 'USD',
        discountPercentage: 20.0,
      );

      expect(product.discountedPrice, equals(80.0));
    });
  });
}
