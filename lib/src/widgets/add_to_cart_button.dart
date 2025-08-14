// Unified AddToCartButton export
// Aliases the new theming-aware implementation. The legacy implementation in
// cart_management/add_to_cart_button.dart is deprecated and will be removed in a
// future major release.

import 'product_discovery/add_to_cart_button.dart';

export 'product_discovery/add_to_cart_button.dart' show AddToCartButton, AddToCartButtonStyle, AddToCartButtonSize, QuantitySelectorStyle, AddToCartAnimationType;

// Backwards compatibility: old symbol name (if previously exposed) maps to new class.
@Deprecated('Use AddToCartButton instead. This alias will be removed in a future major release.')
typedef AddToCartButtonUnified = AddToCartButton;
