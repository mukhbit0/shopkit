import 'package:flutter/material.dart';
import '../screens/product_discovery_screen.dart';
import '../screens/cart_management_screen.dart';
import '../screens/user_engagement_screen.dart';
import '../themes/theme_animated_widgets.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.onThemeModeChanged,
    required this.currentThemeStyle,
    required this.currentThemeMode,
  });

  final ValueChanged<String> onThemeChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final String currentThemeStyle;
  final ThemeMode currentThemeMode;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<WidgetCategory> _categories = [
    WidgetCategory(
      id: 'product_discovery',
      name: 'Product Discovery',
      description: 'Find and browse products with style',
      icon: Icons.search,
      color: Colors.blue,
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
      widgets: ['ProductCard', 'ProductGrid', 'ProductSearchBar', 'CategoryTabs'],
    ),
    WidgetCategory(
      id: 'cart_management',
      name: 'Cart Management',
      description: 'Shopping cart functionality',
      icon: Icons.shopping_cart,
      color: Colors.green,
      gradient: [Colors.green.shade400, Colors.green.shade600],
      widgets: ['CartBubble', 'CartSummary', 'AddToCartButton'],
    ),
    WidgetCategory(
      id: 'user_engagement',
      name: 'User Engagement',
      description: 'Engage and retain customers',
      icon: Icons.favorite,
      color: Colors.pink,
      gradient: [Colors.pink.shade400, Colors.pink.shade600],
      widgets: ['WishlistButton', 'ReviewWidget', 'TrustBadge'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, theme),
          _buildThemeSelector(context, theme),
          _buildCategoriesGrid(context, theme),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) => Opacity(
            opacity: _fadeAnimation.value,
            child: const Text(
              'ShopKit',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
                theme.colorScheme.tertiary,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Beautiful E-Commerce Widgets',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Unlimited Customization • Multiple Themes • Production Ready',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Theme Styles',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildThemeStyleSelector(context, theme),
            const SizedBox(height: 16),
            _buildThemeModeSelector(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeStyleSelector(BuildContext context, ThemeData theme) {
    return Wrap(
      spacing: 12,
      children: [
        _buildThemeChip('Material 3', 'material3', Colors.blue, theme),
        _buildThemeChip('Neumorphism', 'neumorphism', Colors.purple, theme),
        _buildThemeChip('Glassmorphism', 'glassmorphism', Colors.cyan, theme),
      ],
    );
  }

  Widget _buildThemeChip(String label, String value, Color color, ThemeData theme) {
    final isSelected = widget.currentThemeStyle == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => widget.onThemeChanged(value),
        backgroundColor: color.withValues(alpha: 0.1),
        selectedColor: color.withValues(alpha: 0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.brightness_6,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Theme Mode:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.settings, size: 16),
            ),
          ],
          selected: {widget.currentThemeMode},
          onSelectionChanged: (modes) => widget.onThemeModeChanged(modes.first),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, ThemeData theme) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildCategoryCard(context, _categories[index], theme, index),
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, WidgetCategory category, ThemeData theme, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.1;
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
          ),
        );
        
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: ThemeAnimatedCard(
        themeStyle: widget.currentThemeStyle,
        onTap: () => _navigateToCategory(context, category),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_getCardRadius()),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: category.gradient,
            ),
          ),
          child: Stack(
            children: [
              // Add theme-specific overlay effects
              if (widget.currentThemeStyle.toLowerCase() == 'glassmorphic')
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_getCardRadius()),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_getCardRadius()),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_getCardRadius()),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryIcon(category),
                    const Spacer(),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: _getTitleFontSize(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildWidgetCountBadge(category),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(WidgetCategory category) {
    final iconWidget = Icon(
      category.icon,
      size: 40,
      color: Colors.white,
    );

    switch (widget.currentThemeStyle.toLowerCase()) {
      case 'neumorphic':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                offset: const Offset(-2, -2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: iconWidget,
        );
      case 'glassmorphic':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: iconWidget,
        );
      default: // Material 3
        return iconWidget;
    }
  }

  Widget _buildWidgetCountBadge(WidgetCategory category) {
    final badgeContent = Text(
      '${category.widgets.length} widgets',
      style: const TextStyle(
        fontSize: 10,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );

    switch (widget.currentThemeStyle.toLowerCase()) {
      case 'neumorphic':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: badgeContent,
        );
      case 'glassmorphic':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: badgeContent,
        );
      default: // Material 3
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: badgeContent,
        );
    }
  }

  double _getCardRadius() {
    switch (widget.currentThemeStyle.toLowerCase()) {
      case 'neumorphic':
        return 25;
      case 'glassmorphic':
        return 30;
      default: // Material 3
        return 20;
    }
  }

  double _getTitleFontSize() {
    switch (widget.currentThemeStyle.toLowerCase()) {
      case 'neumorphic':
        return 16;
      case 'glassmorphic':
        return 20;
      default: // Material 3
        return 18;
    }
  }

  void _navigateToCategory(BuildContext context, WidgetCategory category) {
    Widget screen;
    
    switch (category.id) {
      case 'product_discovery':
        screen = ProductDiscoveryScreen(
          themeStyle: widget.currentThemeStyle,
        );
        break;
      case 'cart_management':
        screen = CartManagementScreen(
          themeStyle: widget.currentThemeStyle,
        );
        break;
      case 'user_engagement':
        screen = UserEngagementScreen(
          themeStyle: widget.currentThemeStyle,
        );
        break;
      default:
        return;
    }

    Navigator.of(context).push(
      ThemePageRoute(
        page: screen,
        themeStyle: widget.currentThemeStyle,
      ),
    );
  }
}

class WidgetCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final List<String> widgets;

  const WidgetCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.widgets,
  });
}
