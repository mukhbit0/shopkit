import 'package:flutter/material.dart';

class CartDemoPage extends StatelessWidget {
  const CartDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 100),
            SizedBox(height: 16),
            Text('Cart functionality will be displayed here'),
            Text('Add items from the Shop tab to see them here'),
          ],
        ),
      ),
    );
  }
}

class CheckoutDemoPage extends StatelessWidget {
  const CheckoutDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment_outlined, size: 100),
            SizedBox(height: 16),
            Text('Checkout process will be displayed here'),
          ],
        ),
      ),
    );
  }
}
