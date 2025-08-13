# ShopKit 🛒

A comprehensive Flutter e-commerce widget library with unlimited customization, multiple design systems, complete internationalization, and robust testing infrastructure.

[![pub package](https://img.shields.io/pub/v/shopkit.svg)](https://pub.dev/packages/shopkit)
[![codecov](https://codecov.io/gh/yourusername/shopkit/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/shopkit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

## 🎯 Why ShopKit?

ShopKit eliminates all common e-commerce development pain points:

- ✅ **Zero Hardcoded Values** - Everything is customizable through configuration
- ✅ **Multiple Design Systems** - Material 3, Neumorphism, Glassmorphism support
- ✅ **Complete Internationalization** - 35+ languages with RTL support
- ✅ **Comprehensive Testing** - 100% test coverage with unit, widget, and integration tests
- ✅ **Performance Optimized** - Lazy loading, caching, and efficient rendering
- ✅ **Accessibility First** - WCAG 2.1 compliant with screen reader support
- ✅ **Developer Experience** - Hot reload, type safety, and detailed documentation

## 🚀 Features

### 🎨 Advanced Theming System

- **Material 3 Design** - Latest Material Design with dynamic color support
- **Neumorphism** - Soft UI with customizable depth and shadow effects  
- **Glassmorphism** - Modern glass effects with backdrop blur
- **Custom Themes** - Create unlimited custom themes with abstract base classes
- **Theme Hot Reload** - Switch themes instantly without app restart
- **Export/Import** - Save and share theme configurations

### 🌍 Internationalization

- **35+ Languages** - Comprehensive translation support including RTL languages
- **Custom Translations** - Override any text with your own translations
- **Pluralization** - Smart plural forms for different languages
- **Date/Currency Formatting** - Localized formatting for all regions
- **RTL Support** - Full right-to-left language support

### 🔧 Flexible Configuration

- **Widget Builder System** - Configure every aspect of widget behavior
- **Responsive Layouts** - Automatic adaptation to screen sizes
- **Accessibility Config** - Comprehensive accessibility customization
- **Animation Control** - Fine-tune all animations and transitions
- **Validation System** - Flexible form validation with custom rules

### 📱 Production-Ready Widgets

- **Product Grid/List** - Responsive product displays with lazy loading
- **Search & Filters** - Real-time search with advanced filtering
- **Shopping Cart** - Full cart management with animations
- **Checkout Flow** - Complete multi-step checkout process
- **User Profiles** - Account management and preferences
- **Wishlist** - Save and manage favorite products

## 🏗️ Installation

Add ShopKit to your `pubspec.yaml`:

```yaml
dependencies:
  shopkit: ^1.0.0
```

Import the package:

```dart
import 'package:shopkit/shopkit.dart';
```

## ⚡ Quick Start

### Basic Setup

```dart
import 'package:flutter/material.dart';
import 'package:shopkit/shopkit.dart';

void main() {
  runApp(MyShopApp());
}

class MyShopApp extends StatelessWidget {
  final themeManager = ShopKitThemeManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      home: ShopKitThemeProvider(
        themeManager: themeManager,
        child: HomePage(),
      ),
    );
  }
}
```

### Product Display

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = [
      ProductModel(
        id: '1',
        name: 'Amazing Product',
        price: 99.99,
        currency: 'USD',
        images: [
          ImageModel(
            id: 'img1',
            url: 'https://example.com/product.jpg',
            alt: 'Product image',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          CartBubble(
            itemCount: 3,
            config: FlexibleWidgetBuilder(),
          ),
        ],
      ),
      body: ProductGrid(
        products: products,
        config: FlexibleWidgetBuilder(
          responsiveLayout: ResponsiveLayoutConfig(
            mobileColumns: 2,
            tabletColumns: 3,
            desktopColumns: 4,
          ),
        ),
      ),
    );
  }
}
```

## 🎨 Theme Customization

### Material 3 Theme

```dart
// Set Material 3 theme with custom seed color
themeManager.setMaterial3Theme(
  seedColor: Color(0xFF6750A4),
  useDynamicColor: true,
);
```

### Neumorphism Theme

```dart
// Set Neumorphism theme with custom surface
themeManager.setNeumorphismTheme(
  surfaceColor: Color(0xFFE0E5EC),
  intensity: 1.5,
);
```

### Glassmorphism Theme

```dart
// Set Glassmorphism theme with custom blur
themeManager.setGlassmorphismTheme(
  blurIntensity: 25.0,
  backdropOpacity: 0.2,
  glowEffect: true,
);
```

### Custom Theme

```dart
class MyCustomTheme extends ShopKitBaseTheme {
  @override
  DesignSystem get designSystem => DesignSystem.custom;
  
  @override
  ShopKitColorScheme get colorScheme => ShopKitColorScheme(
    primary: Color(0xFF1976D2),
    // ... other colors
  );
  
  // Implement other required properties
}

// Use custom theme
themeManager.setTheme(MyCustomTheme());
```

## 🌎 Internationalization

### Basic Usage

```dart
// Get current translation
final i18n = ShopKitI18n();
String addToCart = i18n.translate('add_to_cart'); // "Add to Cart"

// Translate for specific locale
String spanish = i18n.translate('add_to_cart', locale: Locale('es')); // "Agregar al Carrito"
```

### Custom Translations

```dart
final customI18n = ShopKitI18n(
  customTranslations: {
    'en': {
      'my_custom_key': 'My Custom Text',
      'add_to_cart': 'Buy Now', // Override default
    },
    'es': {
      'my_custom_key': 'Mi Texto Personalizado',
    },
  },
);
```

### Pluralization

```dart
// Handle plurals correctly for different languages
String itemCount = i18n.plural('items_in_cart', 5); // "5 items in cart"
String singleItem = i18n.plural('items_in_cart', 1); // "1 item in cart"
```

## 🔧 Widget Configuration

### Complete Customization

```dart
final config = FlexibleWidgetBuilder(
  // Responsive behavior
  responsiveLayout: ResponsiveLayoutConfig(
    mobileColumns: 1,
    tabletColumns: 2,
    desktopColumns: 3,
    enableResponsive: true,
  ),
  
  // Accessibility settings
  accessibility: AccessibilityConfig(
    enableSemantics: true,
    minTouchTargetSize: 48.0,
    semanticLabels: {
      'add_to_cart': 'Add item to shopping cart',
    },
  ),
  
  // Interaction behavior
  interaction: InteractionConfig(
    enableHover: true,
    enableLongPress: true,
    hapticFeedbackType: HapticFeedbackType.light,
    pressAnimation: InteractionAnimation.scale,
  ),
  
  // Theme overrides
  theme: WidgetThemeConfig(
    customColors: {
      'accent': Colors.purple,
      'highlight': Colors.amber,
    },
    customTextStyles: {
      'price': TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    },
  ),
  
  // Animation settings
  animation: AnimationConfig(
    duration: Duration(milliseconds: 250),
    curve: Curves.easeOutCubic,
    enableMicroInteractions: true,
  ),
  
  // Custom properties
  customProperties: {
    'showBadges': true,
    'maxItems': 20,
    'specialMode': 'featured',
  },
);

// Use with any widget
ProductCard(
  product: product,
  config: config,
)
```

## 🧪 Testing

ShopKit includes comprehensive testing infrastructure:

### Run All Tests

```bash
# Run all tests with coverage
flutter test --coverage

# Run specific test suites
flutter test test/unit/
flutter test test/widget/
flutter test integration_test/
```

### Test Coverage

```bash
# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Testing Your Implementation

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shopkit/shopkit.dart';

void main() {
  testWidgets('ProductCard displays product information', (tester) async {
    final product = TestUtils.createMockProduct(
      name: 'Test Product',
      price: 99.99,
    );

    await tester.pumpWidget(
      TestUtils.createTestApp(
        child: ProductCard(
          product: product,
          config: TestUtils.createTestConfig(),
        ),
      ),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$99.99'), findsOneWidget);
  });
}
```

## 📊 Performance

ShopKit is optimized for performance:

- **Lazy Loading** - Products load as needed
- **Image Caching** - Efficient image management  
- **Widget Recycling** - Optimized list rendering
- **Minimal Rebuilds** - Smart state management
- **Bundle Size** - Tree-shaking friendly

### Performance Testing

```dart
// Built-in performance testing utilities
await TestUtils.performanceTest(
  tester,
  () => tester.drag(find.byType(ProductGrid), Offset(0, -200)),
  iterations: 100,
  maxDuration: Duration(seconds: 1),
);
```

## ♿ Accessibility

Full accessibility support out of the box:

- **Screen Reader** - Complete VoiceOver/TalkBack support
- **Keyboard Navigation** - Full keyboard accessibility
- **Touch Targets** - Minimum 44px touch targets
- **Color Contrast** - WCAG 2.1 AA compliant
- **High Contrast** - Support for accessibility settings
- **Reduced Motion** - Respects user preferences

### Accessibility Testing

```dart
// Verify accessibility in tests
TestUtils.verifyAccessibility(tester);

// Test with different accessibility settings
await TestUtils.verifyInternationalization(
  tester,
  (locale) => MyWidget(locale: locale),
);
```

## 📚 API Reference

### Core Classes

- **ShopKitThemeManager** - Theme management and switching
- **FlexibleWidgetBuilder** - Widget configuration system
- **ShopKitI18n** - Internationalization utilities
- **ProductModel** - Product data structure
- **CartController** - Shopping cart management
- **UserModel** - User account data

### Widgets

- **ProductCard** - Individual product display
- **ProductGrid** - Grid layout for products
- **ProductSearchBar** - Search with suggestions
- **CartBubble** - Cart icon with item count
- **AddToCartButton** - Customizable add to cart
- **CategoryTabs** - Category navigation
- **VariantPicker** - Product variant selection

### Themes

- **ShopKitMaterial3Theme** - Material Design 3
- **ShopKitNeumorphismTheme** - Soft UI design
- **ShopKitGlassmorphismTheme** - Glass effect design
- **ShopKitBaseTheme** - Abstract base for custom themes

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Ensure all tests pass
5. Submit a pull request

### Development Setup

```bash
# Clone the repository
git clone https://github.com/mukhbit0/shopkit.git
cd shopkit

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run example app
cd example
flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Examples](https://github.com/mukhbit0/shopkit/tree/main/example)
- [Changelog](CHANGELOG.md)

---

## Support 💬

- 📧 Email: [support@ionicerrrrscode.com](support@ionicerrrrscode.com)
- 🐛 Issues: [GitHub Issues](https://github.com/mukhbit0/shopkit/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/mukhbit0/shopkit/discussions)

---

Made with ❤️ by the [Ionic Errrrs Code](ionicerrrrscode.com)
