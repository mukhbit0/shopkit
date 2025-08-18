/// ShopKit - Flutter E-Commerce Widget Library
///
/// A comprehensive collection of customizable e-commerce widgets for Flutter
/// applications with built-in data models, headless architecture support,
/// and extensive theming capabilities.
library;
///
/// ## Quick Start
///
/// ```dart
/// import 'package:shopkit/shopkit.dart';
///
/// // Create a product
/// final product = ProductModel(
///   id: '1',
///   name: 'Wireless Headphones',
///   price: 99.99,
///   currency: 'USD',
///   imageUrl: 'https://example.com/headphones.jpg',
/// );
///
/// // Display in a card
/// ProductCard(
///   product: product,
///   onAddToCart: (cartItem) => print('Added: ${cartItem.product.name}'),
/// )
/// ```
///
/// ## Features
///
/// - 🎨 Deep theming with light/dark mode support
/// - 🔧 Headless architecture for flexible state management
/// - 📱 Responsive design for all screen sizes
/// - ♿ Full accessibility support
/// - 🎭 Smooth animations and micro-interactions
/// - 📦 Type-safe data models with JSON serialization
///
/// ## Widget Categories
///
/// ### Product Discovery
/// Widgets for finding and browsing products:
/// - [ProductCard] - Individual product display
/// - [ProductGrid] - Responsive product grid
/// - [ProductSearchBar] - Search with autocomplete
/// - [CategoryTabs] - Category navigation
/// - [ProductFilter] - Advanced filtering
/// - [ProductRecommendation] - Product suggestions
/// - [ProductTabs] - Product detail tabs
///
/// ### Product Details
/// Widgets for detailed product views:
/// - [ProductDetailView] - Complete product page
/// - [ImageCarousel] - Image gallery with zoom
/// - [VariantPicker] - Size/color selection
/// - [ProductTabs] - Organized information tabs
/// - [ReviewWidget] - Customer reviews display
///
/// ### Cart Management
/// Widgets for shopping cart functionality:
/// - [CartBubble] - Floating cart indicator
/// - [CartSummary] - Cart contents overview
/// - [AddToCartButton] - Add to cart action
/// - [StickyAddToCart] - Persistent cart button
///
/// ### Checkout Flow
/// Widgets for purchase completion:
/// - [CheckoutStepper] - Multi-step checkout
/// - [ShippingCalculator] - Dynamic shipping costs
/// - [PaymentMethodSelector] - Payment options
/// - [CartDiscount] - Promo code application
///
/// ## Data Models
///
/// Type-safe models for all e-commerce data:
/// - [ProductModel] - Product information
/// - [VariantModel] - Product variants
/// - [CartModel] - Shopping cart state
/// - [CartItemModel] - Individual cart items
/// - [CategoryModel] - Product categories
/// - [ReviewModel] - Customer reviews
///
/// ## Theming
///
/// Comprehensive theming system:
/// - [ECommerceTheme] - Main theme extension
/// - Light and dark theme presets
/// - Extensive customization options
///
/// ## Controllers
///
/// Headless business logic controllers:
/// - [CartController] - Cart state management
/// - [WishlistController] - Wishlist functionality
/// - [ProductController] - Product state management

// Export controllers
export 'src/controllers/cart_controller.dart';
export 'src/controllers/product_controller.dart';
export 'src/controllers/wishlist_controller.dart';

// Export the new ThemeExtension-based ShopKit theme and theme style helpers
export 'src/theme/theme.dart';
export 'src/theme/shopkit_theme_styles.dart';

// Export internationalization
export 'src/utils/internationalization.dart';

// Export deprecated shims for examples/tests. These are kept for
// backward compatibility and are marked deprecated. Prefer ShopKitTheme.
// Note: Legacy FlexibleWidgetConfig removed - use ShopKitTheme instead

// Export all models
export 'src/models/address_model.dart';
export 'src/models/announcement_model.dart';
export 'src/models/badge_model.dart';
export 'src/models/cart_model.dart';
export 'src/models/category_model.dart';
export 'src/models/checkout_step_model.dart';
export 'src/models/currency_model.dart';
export 'src/models/filter_model.dart';
export 'src/models/image_model.dart';
export 'src/models/menu_item_model.dart';
export 'src/models/notification_model.dart';
export 'src/models/order_model.dart';
export 'src/models/payment_model.dart';
export 'src/models/popup_model.dart';
export 'src/models/product_detail_model.dart';
export 'src/models/product_model.dart';
export 'src/models/review_model.dart';
export 'src/models/search_model.dart';
export 'src/models/share_model.dart';
export 'src/models/user_model.dart';
export 'src/models/variant_model.dart';
export 'src/models/wishlist_model.dart';

// Export utilities
export 'src/utils/constants.dart';

// Export widgets - Product Discovery
export 'src/widgets/product_discovery/category_tabs.dart';
export 'src/widgets/product_discovery/image_carousal.dart';
export 'src/widgets/product_discovery/product_card.dart';
export 'src/widgets/product_discovery/product_detail_view.dart';
export 'src/widgets/product_discovery/product_grid.dart';
export 'src/widgets/product_discovery/product_search_bar.dart';
export 'src/widgets/navigation/sticky_header.dart';
export 'src/widgets/product_discovery/variant_picker.dart';

// Export widgets - Product Detail
export 'src/widgets/product_discovery/product_filter.dart';
export 'src/widgets/product_discovery/product_recommendation.dart';
export 'src/widgets/product_discovery/product_tabs.dart';
export 'src/widgets/product_discovery/review_widget.dart';

// Export widgets - Cart Management
export 'src/widgets/add_to_cart_button.dart';
export 'src/widgets/cart_management/cart_bubble.dart';
export 'src/widgets/cart_management/cart_summary.dart';
export 'src/widgets/cart_management/sticky_add_to_cart.dart';

// Export widgets - Checkout
export 'src/widgets/checkout/shipping_calculator.dart';
export 'src/widgets/checkout/payment_method_selector.dart';

// Export widgets - Post Purchase
export 'src/widgets/post_purchase/order_tracking.dart';

// Export widgets - Engagement
export 'src/widgets/engagement/announcement_bar.dart';
export 'src/widgets/engagement/exit_intent_popup.dart';
export 'src/widgets/engagement/social_share.dart';
export 'src/widgets/engagement/trust_badge.dart';
export 'src/widgets/engagement/wishlist.dart';

// Export widgets - Navigation & Utility
export 'src/widgets/navigation/back_to_top.dart';
export 'src/widgets/navigation/currency_converter.dart';
