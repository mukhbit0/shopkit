import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';

void main() {
  group('ProductModel Tests', () {
    test('should create a valid product model', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 99.99,
        currency: 'USD',
        imageUrl: 'https://example.com/image.jpg',
        description: 'A test product',
        rating: 4.5,
        reviewCount: 100,
        discountPercentage: 10.0,
        isInStock: true,
      );

      expect(product.id, equals('1'));
      expect(product.name, equals('Test Product'));
      expect(product.price, equals(99.99));
      expect(product.currency, equals('USD'));
      expect(product.isInStock, isTrue);
    });

    test('should calculate discounted price correctly', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        currency: 'USD',
        imageUrl: 'https://example.com/image.jpg',
        description: 'A test product',
        rating: 4.5,
        reviewCount: 100,
        discountPercentage: 20.0,
        isInStock: true,
      );

      expect(product.discountedPrice, equals(80.0));
    });

    test('should handle zero discount correctly', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        currency: 'USD',
        imageUrl: 'https://example.com/image.jpg',
        description: 'A test product',
        rating: 4.5,
        reviewCount: 100,
        discountPercentage: 0.0,
        isInStock: true,
      );

      expect(product.discountedPrice, equals(100.0));
    });

    test('should format price with currency correctly', () {
      const product = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 99.99,
        currency: 'USD',
        imageUrl: 'https://example.com/image.jpg',
        description: 'A test product',
        rating: 4.5,
        reviewCount: 100,
        discountPercentage: 0.0,
        isInStock: true,
      );

      expect(product.formattedPrice, contains('99.99'));
      expect(product.formattedPrice, contains('\$')); // USD uses $ symbol
    });

    test('should convert to and from JSON correctly', () {
      const originalProduct = ProductModel(
        id: '1',
        name: 'Test Product',
        price: 99.99,
        currency: 'USD',
        imageUrl: 'https://example.com/image.jpg',
        description: 'A test product',
        rating: 4.5,
        reviewCount: 100,
        discountPercentage: 10.0,
        isInStock: true,
      );

      final json = originalProduct.toJson();
      final convertedProduct = ProductModel.fromJson(json);

      expect(convertedProduct.id, equals(originalProduct.id));
      expect(convertedProduct.name, equals(originalProduct.name));
      expect(convertedProduct.price, equals(originalProduct.price));
      expect(convertedProduct.currency, equals(originalProduct.currency));
      expect(convertedProduct.isInStock, equals(originalProduct.isInStock));
    });
  });
}
