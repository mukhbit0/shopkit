# ShopKit Showcase App

A comprehensive demonstration of all ShopKit widgets across multiple themes and design styles.

## Features

### 🎨 Multi-Theme Support
- **Material 3** - Google's latest design system with dynamic colors
- **Neumorphism** - Soft UI with subtle shadows and depth
- **Glassmorphism** - Modern transparent glass effects

### 📱 Widget Categories

#### Product Discovery
- **ProductCard** - Multiple layouts (default, elevated, outlined)
- **ProductGrid** - Responsive grid layouts (2-column, 3-column)
- **ProductSearchBar** - Various search styles (basic, filters, pill)
- **AddToCartButton** - Different states (default, icon, loading)

#### Cart Management
- **CartBubble** - Animated cart icon with item count
- **CartSummary** - Complete cart overview
- **Cart Controls** - Add/remove items functionality

#### User Engagement
- **WishlistButton** - Interactive wishlist functionality
- **Rating System** - 5-star rating component
- **Trust Badges** - Security and guarantee badges
- **Customer Reviews** - Review display components

### 🔄 Theme Switching
- Light/Dark mode support
- Real-time theme switching
- Persistent theme preferences
- System theme detection

### 🏗️ Modular Architecture

```
lib/
├── main_clean.dart              # App entry point
├── simple_showcase_app.dart     # Main app wrapper
├── themes/
│   └── theme_helper.dart        # Theme configurations
├── screens/
│   ├── home_screen.dart         # Main navigation
│   ├── product_discovery_screen.dart
│   ├── cart_management_screen.dart
│   └── user_engagement_screen.dart
└── data/
    └── clean_sample_data.dart   # Sample data
```

## Getting Started

1. **Run the app:**
   ```bash
   flutter run lib/main_clean.dart
   ```

2. **Navigate through categories:**
   - Tap on category cards to explore widgets
   - Switch themes using the theme selector
   - Toggle between light/dark modes

3. **Interact with widgets:**
   - Tap product cards to see interactions
   - Add/remove items from cart
   - Rate products and add to wishlist
   - View trust badges and reviews

## Design Patterns

### Material 3 Theme
- Dynamic color generation from seed colors
- Rounded corners with consistent radius
- Elevated surfaces with proper shadows
- Modern button styles and animations

### Neumorphic Theme
- Soft shadows with light/dark contrast
- Subtle depth and 3D effects
- Monochromatic color palettes
- Smooth, organic shapes

### Glassmorphic Theme
- Semi-transparent backgrounds
- Blur effects and backdrop filters
- Glowing borders and highlights
- Modern glass-like appearance

## Widget Demonstrations

Each screen showcases widgets in multiple variations:

### Product Discovery Screen
```dart
// Different card styles
ProductCard(style: 'default')
ProductCard(style: 'elevated') 
ProductCard(style: 'outlined')

// Grid layouts
ProductGrid(columns: 2)
ProductGrid(columns: 3, compact: true)

// Search variations
ProductSearchBar(style: 'basic')
ProductSearchBar(style: 'filters')
ProductSearchBar(style: 'pill')
```

### Cart Management Screen
```dart
// Cart bubble with animations
CartBubble(itemCount: count, animated: true)

// Theme-specific styling
CartBubble(theme: 'neumorphic')
CartBubble(theme: 'glassmorphic')
```

### User Engagement Screen
```dart
// Interactive components
WishlistButton(onToggle: callback)
RatingWidget(onRate: callback)
TrustBadge(type: 'security')
ReviewWidget(reviews: data)
```

## Customization Examples

The showcase demonstrates various customization approaches:

### Theme-Based Customization
```dart
// Material 3 style
FlexibleWidgetConfig(
  borderRadius: 8.0,
  elevation: 2.0,
  useSystemColors: true,
)

// Neumorphic style  
FlexibleWidgetConfig(
  borderRadius: 16.0,
  elevation: 0.0,
  shadowType: 'neumorphic',
)

// Glassmorphic style
FlexibleWidgetConfig(
  borderRadius: 20.0,
  backgroundColor: Colors.white.withValues(alpha: 0.1),
  backdropBlur: true,
)
```

### Widget-Specific Customization
```dart
// Product card variations
ProductCard(
  config: FlexibleWidgetConfig(
    layout: 'horizontal',
    showFullDescription: true,
    enableWishlist: true,
    cardElevation: 8.0,
  ),
)

// Search bar variations
ProductSearchBar(
  config: FlexibleWidgetConfig(
    showVoiceSearch: true,
    showFilters: true,
    enableAnimations: true,
  ),
)
```

## Best Practices Demonstrated

1. **Responsive Design**: Adapts to different screen sizes
2. **Accessibility**: WCAG compliant with proper semantics
3. **Performance**: Efficient rendering and state management
4. **User Experience**: Smooth animations and interactions
5. **Code Organization**: Clean, modular architecture

## Available Interactions

- **Theme Switching**: Change between Material 3, Neumorphism, Glassmorphism
- **Mode Toggle**: Light/Dark/System theme modes
- **Widget Navigation**: Explore different widget categories
- **Live Interactions**: Add to cart, wishlist, rating, etc.
- **State Management**: Persistent cart items and preferences
- **Animation Demos**: Smooth transitions and micro-interactions

## Performance Features

- Lazy loading of widget demonstrations
- Efficient state management
- Optimized rendering for smooth scrolling
- Memory-efficient image handling
- Responsive layout calculations

## Accessibility Features

- Screen reader support
- High contrast mode compatibility
- Keyboard navigation
- Semantic labels and descriptions
- Touch target sizing compliance

This showcase app serves as both a demonstration of ShopKit's capabilities and a reference implementation for building e-commerce applications with Flutter.
