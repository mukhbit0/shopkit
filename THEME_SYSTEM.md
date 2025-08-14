# ShopKit Theme System

ShopKit now features a revolutionary **built-in theme system** that makes styling widgets incredibly easy! Just pass a theme name as a string parameter, and your widgets automatically adapt to stunning visual styles.

## 🚀 Quick Start

Instead of complex configuration objects, simply use the `themeStyle` parameter:

```dart
// Before: Complex configuration required
ProductCard(
  product: product,
  // Complex theme configuration...
)

// After: Super simple theme parameter!
ProductCard(
  product: product,
  themeStyle: 'neumorphism', // That's it!
)
```

## 🎨 Available Theme Styles

- **`material3`** - Modern Material Design 3 styling
- **`materialYou`** - Dynamic Material You with gradients
- **`neumorphism`** - Soft, pressed-in effect with shadows
- **`glassmorphism`** - Translucent glass effect with blur
- **`cupertino`** - Clean iOS-style design
- **`minimal`** - Simple, border-only design
- **`retro`** - Bold 80s-style with sharp shadows
- **`neon`** - Cyberpunk glow effects

## 📱 Responsive by Default

All widgets now use **flutter_screenutil** for perfect responsiveness across all devices:

- Automatically adapts to screen sizes
- Consistent spacing and typography
- No overflow issues
- Works on phones, tablets, and web

## 🧩 Supported Widgets

All ShopKit widgets now support the `themeStyle` parameter:

### Product Discovery
```dart
// Product Card with different themes
ProductCard(
  product: product,
  themeStyle: 'glassmorphism',
)

// Add to Cart Button
AddToCartButtonNew(
  product: product,
  themeStyle: 'neon',
  text: 'Add to Cart',
)

// Search Bar
ProductSearchBarAdvanced(
  themeStyle: 'neumorphism',
  onSearch: (query) => handleSearch(query),
)

// Category Tabs
CategoryTabs(
  categories: categories,
  themeStyle: 'material3',
)

// Announcement Bar
AnnouncementBarNew(
  announcements: announcements,
  themeStyle: 'retro',
)

// Variant Picker
VariantPicker(
  variants: variants,
  themeStyle: 'cupertino',
)

// Image Carousel
ImageCarousel(
  images: images,
  themeStyle: 'minimal',
)
```

## 🌟 Theme Examples

### Material 3 Style
```dart
ProductCard(
  product: product,
  themeStyle: 'material3',
  // Clean, modern Material Design 3
  // Elevated card with subtle shadows
  // Dynamic color theming
)
```

### Neumorphism Style
```dart
ProductCard(
  product: product,
  themeStyle: 'neumorphism',
  // Soft, pressed-in appearance
  // Dual-directional shadows
  // Subtle depth effect
)
```

### Glassmorphism Style
```dart
ProductCard(
  product: product,
  themeStyle: 'glassmorphism',
  // Translucent background
  // Backdrop blur effect
  // Elegant glass appearance
)
```

### Neon Style
```dart
ProductCard(
  product: product,
  themeStyle: 'neon',
  // Cyberpunk glow effects
  // Bright neon borders
  // Dark background with color pops
)
```

## 🔄 Easy Theme Switching

Change the entire app's feel by simply updating the theme parameter:

```dart
class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String currentTheme = 'material3';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Theme selector
        DropdownButton<String>(
          value: currentTheme,
          items: [
            'material3',
            'materialYou',
            'neumorphism',
            'glassmorphism',
            'cupertino',
            'minimal',
            'retro',
            'neon',
          ].map((theme) => DropdownMenuItem(
            value: theme,
            child: Text(theme),
          )).toList(),
          onChanged: (theme) {
            setState(() {
              currentTheme = theme!;
            });
          },
        ),
        
        // All widgets automatically update!
        ProductCard(
          product: product,
          themeStyle: currentTheme, // Dynamic theme switching
        ),
        
        AddToCartButtonNew(
          product: product,
          themeStyle: currentTheme, // Same theme everywhere
        ),
        
        ProductSearchBarAdvanced(
          themeStyle: currentTheme, // Consistent styling
        ),
      ],
    );
  }
}
```

## 🎯 Fallback System

If no `themeStyle` is provided, widgets gracefully fall back to the legacy theme system or basic styling:

```dart
// Uses legacy theme system
ProductCard(
  product: product,
  // No themeStyle parameter
)

// Uses new theme system
ProductCard(
  product: product,
  themeStyle: 'neumorphism', // New theme applied
)
```

## 📊 Performance

- **Zero configuration** required
- **Lazy loading** of theme configurations
- **Optimized rendering** with built-in caching
- **Responsive by default** with ScreenUtil

## 🔧 Customization

While the built-in themes cover most use cases, you can still use the advanced configuration system for complete customization:

```dart
ProductCard(
  product: product,
  themeStyle: 'glassmorphism', // Quick theme
  config: FlexibleWidgetConfig(
    // Additional customizations if needed
  ),
)
```

## 🚀 Getting Started

1. **Install dependencies:**
```yaml
dependencies:
  shopkit: ^1.0.0
  flutter_screenutil: ^5.9.3
```

2. **Initialize ScreenUtil:**
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          home: YourHomePage(),
        );
      },
    );
  }
}
```

3. **Use themed widgets:**
```dart
ProductCard(
  product: product,
  themeStyle: 'neumorphism', // Just add this parameter!
)
```

## 🎨 Mix and Match

Create unique experiences by mixing different themes:

```dart
Column(
  children: [
    ProductSearchBarAdvanced(themeStyle: 'glassmorphism'),
    CategoryTabs(themeStyle: 'material3'),
    ProductCard(themeStyle: 'neumorphism'),
    AddToCartButtonNew(themeStyle: 'neon'),
  ],
)
```

## 📱 Responsive Design

All themes automatically adapt to different screen sizes:

- **Mobile:** Compact spacing, smaller elements
- **Tablet:** Medium spacing, balanced proportions  
- **Desktop:** Larger spacing, enhanced visual effects

The `flutter_screenutil` integration ensures perfect scaling across all devices.

---

**ShopKit Theme System** - Making beautiful e-commerce UIs accessible to everyone! 🛍️✨
