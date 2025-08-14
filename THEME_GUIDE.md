# ShopKit Built-in Theme System

ShopKit now includes a powerful built-in theme system that allows you to apply different visual styles to widgets with a simple parameter. No complex configuration needed!

## 🎨 Available Theme Styles

- **material3** - Modern Material Design 3 styling
- **materialYou** - Dynamic Material You with gradients
- **neumorphism** - Soft shadows and subtle depth
- **glassmorphism** - Transparent glass-like effects with blur
- **cupertino** - iOS-inspired clean borders
- **minimal** - Clean and simple design
- **retro** - Bold shadows and vintage aesthetics
- **neon** - Glowing effects with cyber aesthetics

## 🚀 Quick Start

### ProductCard with Built-in Themes

```dart
import 'package:shopkit/shopkit.dart';

// Material 3 style
ProductCard(
  product: product,
  themeStyle: 'material3',
  onTap: () => navigateToProduct(product),
  onAddToCart: (cartItem) => addToCart(cartItem),
)

// Neumorphic style
ProductCard(
  product: product,
  themeStyle: 'neumorphism',
  onTap: () => navigateToProduct(product),
  onAddToCart: (cartItem) => addToCart(cartItem),
)

// Glassmorphic style
ProductCard(
  product: product,
  themeStyle: 'glassmorphism',
  onTap: () => navigateToProduct(product),
  onAddToCart: (cartItem) => addToCart(cartItem),
)
```

## ✨ Features

### Automatic Styling

- **Smart Animations**: Each theme includes custom animations using flutter_animate
- **Responsive Design**: Themes adapt to light/dark mode automatically  
- **Consistent Colors**: Uses your app's color scheme as base
- **Performance Optimized**: Animations are smooth and efficient

### Theme-Specific Effects

- **Neumorphism**: Dual-direction shadows that create depth
- **Glassmorphism**: Real backdrop blur with gradient overlays
- **Neon**: Glowing borders with shimmer effects
- **Retro**: Sharp shadows with vintage color accents
- **Material You**: Dynamic gradients and shimmer animations

## 🎯 Usage Patterns

### Theme Switching

```dart
class ProductList extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    String currentTheme = 'material3';
    
    return GridView.builder(
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          themeStyle: currentTheme, // Easy theme switching
          onTap: () => navigateToProduct(products[index]),
        );
      },
    );
  }
}
```

### Mixed Themes in One App

```dart
// Hero product with neon theme
ProductCard(
  product: featuredProduct,
  themeStyle: 'neon',
),

// Regular products with material3
...products.map((product) => ProductCard(
  product: product,
  themeStyle: 'material3',
)).toList(),
```

## 🛠 Customization

### Without Theme Style (Fallback)

When no `themeStyle` is provided, the widget falls back to a clean, default design that respects your app's theme.

```dart
ProductCard(
  product: product,
  // No themeStyle = uses default design
  onTap: () => navigateToProduct(product),
)
```

## 📦 Dependencies

The theme system requires:

- `flutter_animate` for smooth animations
- `dart:ui` for advanced effects like blur

Both are automatically included when you add ShopKit to your project.

## 🎨 Theme Examples

Run the example app to see all themes in action:

```bash
cd example
flutter run
```

The demo showcases all 8 theme styles side by side, so you can see the differences and choose what works best for your app.

## 🔧 Advanced Usage

### Theme Configurations

Each theme has pre-configured settings for:

- Border radius and elevation
- Colors and gradients  
- Animation curves and durations
- Visual effects (shadows, blur, glow)

### Extending Themes

The theme system is built on `ShopKitThemeConfig` which you can extend to create custom themes:

```dart
// Access theme configuration
final themeConfig = ShopKitThemeConfig.forStyle(
  ShopKitThemeStyle.neumorphism, 
  context
);
```

This gives you access to all the styling parameters used by the built-in themes, allowing you to create your own custom implementations.
