import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';
import '../utils/test_utils.dart';

void main() {
  group('CartController Tests', () {
    late CartController cartController;
    late ProductModel product;

    setUp(() {
      cartController = CartController();
      product = TestUtils.createMockProduct();
    });

    test('should initialize with empty cart', () {
      expect(cartController.cart.items, isEmpty);
      expect(cartController.cart.total, equals(0.0));
      expect(cartController.isLoading, isFalse);
    });

    test('should add item to cart correctly', () async {
      await cartController.addToCart(product, quantity: 2);

      expect(cartController.cart.items.length, equals(1));
      expect(cartController.cart.items.first.quantity, equals(2));
      expect(cartController.cart.items.first.product.id, equals(product.id));
      expect(cartController.cart.subtotal, equals(product.discountedPrice * 2));
    });

    test('should update quantity when adding existing item', () async {
      // First add
      await cartController.addToCart(product, quantity: 1);
      expect(cartController.cart.items.length, equals(1));
      expect(cartController.cart.items.first.quantity, equals(1));

      // Add same product again
      await cartController.addToCart(product, quantity: 2);
      expect(cartController.cart.items.length, equals(1));
      expect(cartController.cart.items.first.quantity, equals(3));
    });

    test('should remove item from cart correctly', () async {
      await cartController.addToCart(product, quantity: 2);
      final itemId = cartController.cart.items.first.id;

      await cartController.removeItem(itemId);

      expect(cartController.cart.items, isEmpty);
      expect(cartController.cart.total, equals(0.0));
    });

    test('should update item quantity correctly', () async {
      await cartController.addToCart(product, quantity: 2);
      final itemId = cartController.cart.items.first.id;

      await cartController.updateQuantity(itemId, 5);

      expect(cartController.cart.items.first.quantity, equals(5));
      expect(cartController.cart.subtotal, equals(product.discountedPrice * 5));
    });

    test('should handle discount application', () async {
      await cartController.addToCart(product, quantity: 1);

      final result = await cartController.applyPromoCode('SAVE20');

      expect(result, isTrue);
      expect(cartController.cart.discount, greaterThan(0));
      expect(cartController.cart.total, lessThan(cartController.cart.subtotal));
    });

    test('should clear cart correctly', () async {
      final product1 = TestUtils.createMockProduct(id: '1', name: 'Product 1');
      final product2 = TestUtils.createMockProduct(id: '2', name: 'Product 2');

      await cartController.addToCart(product1, quantity: 1);
      await cartController.addToCart(product2, quantity: 2);

      await cartController.clearCart();

      expect(cartController.cart.items, isEmpty);
      expect(cartController.cart.total, equals(0.0));
    });
  });

  group('ProductController Tests', () {
    late ProductController productController;

    setUp(() {
      productController = ProductController();
    });

    test('should initialize with empty products', () {
      expect(productController.allProducts, isEmpty);
      expect(productController.products, isEmpty);
      expect(productController.isLoading, isFalse);
    });

    test('should load products correctly', () async {
      await productController.loadProducts();

      expect(productController.allProducts, isNotEmpty);
      expect(productController.products, isNotEmpty);
    });

    test('should filter products by category', () async {
      await productController.loadProducts();

      productController.filterByCategory('Electronics');

      expect(productController.products, isNotEmpty);
      // Verify filtering logic
      for (final product in productController.products) {
        expect(product.categoryId, equals('Electronics'));
      }
    });

    test('should search products correctly', () async {
      await productController.loadProducts();

      await productController.searchProducts('iPhone');

      expect(productController.lastSearchResult, isNotNull);
      expect(productController.lastSearchResult!.products, isNotEmpty);
      
      final hasIPhone = productController.lastSearchResult!.products
          .any((product) => product.name.toLowerCase().contains('iphone'));
      expect(hasIPhone, isTrue);
    });

    test('should sort products correctly', () async {
      await productController.loadProducts();

      productController.sortProducts('price', ascending: true);

      expect(productController.products, isNotEmpty);
      // Verify price ascending order
      for (int i = 0; i < productController.products.length - 1; i++) {
        expect(productController.products[i].price, 
               lessThanOrEqualTo(productController.products[i + 1].price));
      }
    });

    test('should handle pagination correctly', () async {
      await productController.loadProducts();
      final initialCount = productController.products.length;

      if (productController.hasMore) {
        await productController.loadProducts();
        expect(productController.products.length, greaterThanOrEqualTo(initialCount));
      }
    });
  });

  group('WishlistController Tests', () {
    late WishlistController wishlistController;
    late ProductModel product;

    setUp(() {
      wishlistController = WishlistController();
      product = TestUtils.createMockProduct();
    });

    test('should initialize with empty wishlist', () {
      expect(wishlistController.items, isEmpty);
      expect(wishlistController.itemCount, equals(0));
      expect(wishlistController.isEmpty, isTrue);
      expect(wishlistController.isNotEmpty, isFalse);
    });

    test('should add item to wishlist correctly', () async {
      final result = await wishlistController.addToWishlist(product);

      expect(result, isTrue);
      expect(wishlistController.items.length, equals(1));
      expect(wishlistController.items.first.id, equals(product.id));
      expect(wishlistController.isInWishlist(product.id), isTrue);
    });

    test('should remove item from wishlist correctly', () async {
      await wishlistController.addToWishlist(product);
      
      final result = await wishlistController.removeFromWishlist(product.id);

      expect(result, isTrue);
      expect(wishlistController.items, isEmpty);
      expect(wishlistController.isInWishlist(product.id), isFalse);
    });

    test('should toggle item in wishlist correctly', () async {
      // Add to wishlist
      await wishlistController.toggleWishlist(product);
      expect(wishlistController.isInWishlist(product.id), isTrue);

      // Remove from wishlist
      await wishlistController.toggleWishlist(product);
      expect(wishlistController.isInWishlist(product.id), isFalse);
    });

    test('should not add duplicate items', () async {
      await wishlistController.addToWishlist(product);
      final result = await wishlistController.addToWishlist(product);

      expect(result, isFalse);
      expect(wishlistController.items.length, equals(1));
    });

    test('should clear wishlist correctly', () async {
      final product1 = TestUtils.createMockProduct(id: '1', name: 'Product 1');
      final product2 = TestUtils.createMockProduct(id: '2', name: 'Product 2');

      await wishlistController.addToWishlist(product1);
      await wishlistController.addToWishlist(product2);

      await wishlistController.clearWishlist();

      expect(wishlistController.items, isEmpty);
      expect(wishlistController.itemCount, equals(0));
    });
  });
}
