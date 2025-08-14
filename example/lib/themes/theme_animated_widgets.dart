import 'package:flutter/material.dart';
import 'dart:ui';

// Theme-specific animated widgets
class ThemeAnimatedCard extends StatefulWidget {
  const ThemeAnimatedCard({
    super.key,
    required this.child,
    required this.themeStyle,
    this.onTap,
    this.padding,
    this.margin,
  });

  final Widget child;
  final String themeStyle;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  State<ThemeAnimatedCard> createState() => _ThemeAnimatedCardState();
}

class _ThemeAnimatedCardState extends State<ThemeAnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _opacityController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeOut),
    );

    // Start entrance animation
    _opacityController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: _buildCard(context),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        return _buildNeumorphicCard(context);
      case 'glassmorphic':
        return _buildGlassmorphicCard(context);
      default: // Material 3
        return _buildMaterial3Card(context);
    }
  }

  Widget _buildMaterial3Card(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: widget.margin ?? const EdgeInsets.all(8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) {
            _scaleController.forward();
          },
          onTapUp: (_) {
            _scaleController.reverse();
          },
          onTapCancel: () {
            _scaleController.reverse();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF2D3748) : const Color(0xFFE0E5EC);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: widget.margin ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Light shadow (top-left)
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
            offset: const Offset(-6, -6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          // Dark shadow (bottom-right)
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400,
            offset: const Offset(6, 6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) {
            _scaleController.forward();
            // Add bounce animation for neumorphic
            _rotationController.forward().then((_) {
              _rotationController.reverse();
            });
          },
          onTapUp: (_) {
            _scaleController.reverse();
          },
          onTapCancel: () {
            _scaleController.reverse();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(20),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: widget.margin ?? const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) {
                  _scaleController.forward();
                },
                onTapUp: (_) {
                  _scaleController.reverse();
                },
                onTapCancel: () {
                  _scaleController.reverse();
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(24),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Theme-specific animated button
class ThemeAnimatedButton extends StatefulWidget {
  const ThemeAnimatedButton({
    super.key,
    required this.child,
    required this.themeStyle,
    required this.onPressed,
    this.isLoading = false,
  });

  final Widget child;
  final String themeStyle;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<ThemeAnimatedButton> createState() => _ThemeAnimatedButtonState();
}

class _ThemeAnimatedButtonState extends State<ThemeAnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _loadingController;
  late Animation<double> _pressAnimation;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(ThemeAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pressAnimation,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (widget.themeStyle.toLowerCase()) {
      case 'neumorphic':
        return _buildNeumorphicButton(context);
      case 'glassmorphic':
        return _buildGlassmorphicButton(context);
      default: // Material 3
        return _buildMaterial3Button(context);
    }
  }

  Widget _buildMaterial3Button(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : () {
        _pressController.forward().then((_) {
          _pressController.reverse();
        });
        widget.onPressed?.call();
      },
      child: widget.isLoading 
        ? RotationTransition(
            turns: _loadingAnimation,
            child: const Icon(Icons.refresh),
          )
        : widget.child,
    );
  }

  Widget _buildNeumorphicButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF2D3748) : const Color(0xFFE0E5EC);
    
    return GestureDetector(
      onTapDown: (_) {
        _pressController.forward();
      },
      onTapUp: (_) {
        _pressController.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () {
        _pressController.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: _pressController.value > 0.5 ? [
            // Pressed state - inset shadows
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400,
              offset: const Offset(3, 3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.7),
              offset: const Offset(-3, -3),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ] : [
            // Normal state - raised shadows
            BoxShadow(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
              offset: const Offset(-6, -6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.grey.shade400,
              offset: const Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: widget.isLoading 
          ? RotationTransition(
              turns: _loadingAnimation,
              child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            )
          : widget.child,
      ),
    );
  }

  Widget _buildGlassmorphicButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTapDown: (_) {
            _pressController.forward();
          },
          onTapUp: (_) {
            _pressController.reverse();
            widget.onPressed?.call();
          },
          onTapCancel: () {
            _pressController.reverse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isDark 
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: widget.isLoading 
              ? RotationTransition(
                  turns: _loadingAnimation,
                  child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
                )
              : widget.child,
          ),
        ),
      ),
    );
  }
}

// Theme-specific page transitions
class ThemePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final String themeStyle;

  ThemePageRoute({required this.page, required this.themeStyle})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(child, animation, themeStyle);
          },
          transitionDuration: const Duration(milliseconds: 500),
        );

  static Widget _buildTransition(Widget child, Animation<double> animation, String themeStyle) {
    switch (themeStyle.toLowerCase()) {
      case 'neumorphic':
        // Bouncy scale transition
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: child,
        );
      case 'glassmorphic':
        // Blur + fade transition
        return FadeTransition(
          opacity: animation,
          child: Transform.scale(
            scale: 0.9 + (animation.value * 0.1),
            child: child,
          ),
        );
      default: // Material 3
        // Slide transition
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
    }
  }
}
