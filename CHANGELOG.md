# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-13

### Added
- Initial release of ShopKit e-commerce widget library
- **Product Discovery Widgets**:
  - `ProductCard` - Customizable product display with animations
  - `ProductGrid` - Responsive grid layout with sliver support
  - `ProductSearchBar` - Search with autocomplete suggestions
  - `CategoryTabs` - Category navigation tabs
  - `ProductFilter` - Advanced filtering capabilities
  - `ProductRecommendation` - AI-driven product suggestions

- **Product Detail Widgets**:
  - `ProductDetailView` - Comprehensive product page
  - `ImageCarousel` - Swipeable image gallery with zoom
  - `VariantPicker` - Size/color selection with swatches
  - `ProductTabs` - Organized product information
  - `ReviewWidget` - Customer reviews and ratings

- **Cart Management Widgets**:
  - `CartBubble` - Floating cart indicator
  - `CartSummary` - Complete cart overview
  - `AddToCartButton` - Animated add-to-cart button
  - `StickyAddToCart` - Persistent purchase button

- **Core Features**:
  - Comprehensive data models with JSON serialization
  - Light and dark theme support with extensive customization
  - Headless controllers for state management flexibility
  - Full accessibility support (ARIA, keyboard navigation)
  - Responsive design for all screen sizes
  - Image caching and optimization
  - Smooth animations and micro-interactions

- **Data Models**:
  - `ProductModel` - Complete product representation
  - `VariantModel` - Product variants (size, color, etc.)
  - `CartModel` - Shopping cart with items and totals
  - `CartItemModel` - Individual cart items
  - `CategoryModel` - Product categories
  - `ReviewModel` - Customer reviews
  - Supporting models for addresses, payments, orders

- **Controllers**:
  - `CartController` - Headless cart management
  - `WishlistController` - Wishlist functionality
  - `ProductController` - Product state management

- **Theming System**:
  - `ECommerceTheme` - Comprehensive theme extension
  - Light and dark theme presets
  - Extensive customization options
  - Typography system
  - Color palette management
  - Animation timing controls

### Documentation
- Comprehensive README with examples
- API documentation for all widgets
- Example app demonstrating all features
- Migration guides and best practices

### Testing
- Unit tests for all models
- Widget tests for core components
- Integration tests for user flows

## [Unreleased]

### Planned for Next Release
- Checkout flow widgets (Phase 2)
- Post-purchase widgets (Phase 3)
- Marketing and engagement widgets
- Advanced analytics integration
- Internationalization support