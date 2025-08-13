// widget_theme_config.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_theme.dart';

/// Haptic feedback types for widget interactions
enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
  none,
}

/// Widget-specific theme configuration interface
abstract class WidgetThemeConfig {
  const WidgetThemeConfig();
  
  /// Build widget with theme configuration
  Widget build(BuildContext context, Widget child);
  
  /// Get decoration for the widget
  Decoration? getDecoration(ShopKitBaseTheme theme);
  
  /// Get text style for the widget
  TextStyle? getTextStyle(ShopKitBaseTheme theme);
  
  /// Get color for the widget
  Color? getColor(ShopKitBaseTheme theme);
}

/// Flexible widget builder with theme support
class FlexibleWidgetBuilder {
  const FlexibleWidgetBuilder({
    this.builder,
    this.customDecoration,
    this.customTextStyle,
    this.customColor,
    this.customPadding,
    this.customMargin,
    this.customConstraints,
    this.customAlignment,
    this.customProperties = const {},
  });

  /// Custom widget builder function
  final Widget Function(BuildContext context, ShopKitBaseTheme theme, Widget child)? builder;

  /// Custom decoration override
  final Decoration? customDecoration;

  /// Custom text style override
  final TextStyle? customTextStyle;

  /// Custom color override
  final Color? customColor;

  /// Custom padding override
  final EdgeInsetsGeometry? customPadding;

  /// Custom margin override
  final EdgeInsetsGeometry? customMargin;

  /// Custom constraints override
  final BoxConstraints? customConstraints;

  /// Custom alignment override
  final AlignmentGeometry? customAlignment;

  /// Custom properties for unlimited extensibility
  final Map<String, dynamic> customProperties;

  /// Build the widget with theme
  Widget build(
    BuildContext context,
    ShopKitBaseTheme theme,
    Widget child, {
    WidgetThemeConfig? config,
  }) {
    // Use custom builder if provided
    if (builder != null) {
      return builder!(context, theme, child);
    }

    // Apply custom decoration, styling, and layout
    Widget result = child;

    // Apply constraints
    if (customConstraints != null) {
      result = ConstrainedBox(
        constraints: customConstraints!,
        child: result,
      );
    }

    // Apply padding
    if (customPadding != null) {
      result = Padding(
        padding: customPadding!,
        child: result,
      );
    }

    // Apply decoration and styling
    final decoration = customDecoration ?? config?.getDecoration(theme);
    if (decoration != null) {
      result = DecoratedBox(
        decoration: decoration,
        child: result,
      );
    }

    // Apply margin
    if (customMargin != null) {
      result = Padding(
        padding: customMargin!,
        child: result,
      );
    }

    // Apply alignment
    if (customAlignment != null) {
      result = Align(
        alignment: customAlignment!,
        child: result,
      );
    }

    return result;
  }

  /// Create a copy with overrides
  FlexibleWidgetBuilder copyWith({
    Widget Function(BuildContext context, ShopKitBaseTheme theme, Widget child)? builder,
    Decoration? customDecoration,
    TextStyle? customTextStyle,
    Color? customColor,
    EdgeInsetsGeometry? customPadding,
    EdgeInsetsGeometry? customMargin,
    BoxConstraints? customConstraints,
    AlignmentGeometry? customAlignment,
    Map<String, dynamic>? customProperties,
  }) {
    return FlexibleWidgetBuilder(
      builder: builder ?? this.builder,
      customDecoration: customDecoration ?? this.customDecoration,
      customTextStyle: customTextStyle ?? this.customTextStyle,
      customColor: customColor ?? this.customColor,
      customPadding: customPadding ?? this.customPadding,
      customMargin: customMargin ?? this.customMargin,
      customConstraints: customConstraints ?? this.customConstraints,
      customAlignment: customAlignment ?? this.customAlignment,
      customProperties: customProperties ?? this.customProperties,
    );
  }
}

/// Layout configuration for responsive design
class ResponsiveLayoutConfig {
  const ResponsiveLayoutConfig({
    this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
    this.breakpoints = const ResponsiveBreakpoints(),
    this.defaultBuilder,
  });

  /// Builder for mobile screens
  final Widget Function(BuildContext context, ShopKitBaseTheme theme)? mobileBuilder;

  /// Builder for tablet screens
  final Widget Function(BuildContext context, ShopKitBaseTheme theme)? tabletBuilder;

  /// Builder for desktop screens
  final Widget Function(BuildContext context, ShopKitBaseTheme theme)? desktopBuilder;

  /// Custom breakpoints
  final ResponsiveBreakpoints breakpoints;

  /// Default builder when specific ones are not provided
  final Widget Function(BuildContext context, ShopKitBaseTheme theme)? defaultBuilder;

  /// Build widget based on screen size
  Widget build(BuildContext context, ShopKitBaseTheme theme) {
    final width = MediaQuery.of(context).size.width;

    if (width < breakpoints.tablet && mobileBuilder != null) {
      return mobileBuilder!(context, theme);
    } else if (width < breakpoints.desktop && tabletBuilder != null) {
      return tabletBuilder!(context, theme);
    } else if (desktopBuilder != null) {
      return desktopBuilder!(context, theme);
    } else if (defaultBuilder != null) {
      return defaultBuilder!(context, theme);
    }

    // Fallback to container
    return const SizedBox.shrink();
  }
}

/// Responsive breakpoints configuration
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints({
    this.mobile = 0,
    this.tablet = 768,
    this.desktop = 1024,
    this.largeDesktop = 1440,
  });

  final double mobile;
  final double tablet;
  final double desktop;
  final double largeDesktop;

  /// Check if current width is mobile
  bool isMobile(double width) => width < tablet;

  /// Check if current width is tablet
  bool isTablet(double width) => width >= tablet && width < desktop;

  /// Check if current width is desktop
  bool isDesktop(double width) => width >= desktop;
}

/// Animation configuration for widgets
class WidgetAnimationConfig {
  const WidgetAnimationConfig({
    this.duration,
    this.curve,
    this.reverseDuration,
    this.reverseCurve,
    this.delay,
    this.animateOnMount = true,
    this.animateOnUpdate = false,
    this.customAnimations = const {},
  });

  /// Animation duration
  final Duration? duration;

  /// Animation curve
  final Curve? curve;

  /// Reverse animation duration
  final Duration? reverseDuration;

  /// Reverse animation curve
  final Curve? reverseCurve;

  /// Delay before animation starts
  final Duration? delay;

  /// Whether to animate when widget mounts
  final bool animateOnMount;

  /// Whether to animate when widget updates
  final bool animateOnUpdate;

  /// Custom animation configurations
  final Map<String, AnimationController Function()> customAnimations;

  /// Create animation controller
  AnimationController createController(TickerProvider vsync, ShopKitBaseTheme theme) {
    return AnimationController(
      duration: duration ?? theme.animation.normal,
      reverseDuration: reverseDuration,
      vsync: vsync,
    );
  }

  /// Create curved animation
  Animation<double> createCurvedAnimation(
    AnimationController controller,
    ShopKitBaseTheme theme,
  ) {
    return CurvedAnimation(
      parent: controller,
      curve: curve ?? theme.animation.easeCurve,
      reverseCurve: reverseCurve,
    );
  }
}

/// State management configuration for widgets
class WidgetStateConfig<T> {
  const WidgetStateConfig({
    this.initialState,
    this.onStateChanged,
    this.stateBuilder,
    this.statePredicate,
    this.stateAnimation,
  });

  /// Initial state value
  final T? initialState;

  /// Callback when state changes
  final void Function(T oldState, T newState)? onStateChanged;

  /// Builder that depends on state
  final Widget Function(BuildContext context, T state, ShopKitBaseTheme theme)? stateBuilder;

  /// Predicate to determine if state should update
  final bool Function(T oldState, T newState)? statePredicate;

  /// Animation configuration for state changes
  final WidgetAnimationConfig? stateAnimation;
}

/// Accessibility configuration for widgets
class AccessibilityConfig {
  const AccessibilityConfig({
    this.semanticsLabel,
    this.semanticsHint,
    this.semanticsValue,
    this.excludeSemantics = false,
    this.isButton = false,
    this.isHeader = false,
    this.isLink = false,
    this.isTextField = false,
    this.isChecked,
    this.isSelected,
    this.isToggled,
    this.customSemanticsProperties = const {},
  });

  /// Semantic label for screen readers
  final String? semanticsLabel;

  /// Semantic hint for additional context
  final String? semanticsHint;

  /// Semantic value for current state
  final String? semanticsValue;

  /// Whether to exclude from semantic tree
  final bool excludeSemantics;

  /// Whether this widget acts as a button
  final bool isButton;

  /// Whether this widget is a header
  final bool isHeader;

  /// Whether this widget is a link
  final bool isLink;

  /// Whether this widget is a text field
  final bool isTextField;

  /// Checked state for checkboxes/toggles
  final bool? isChecked;

  /// Selected state for selectable items
  final bool? isSelected;

  /// Toggled state for toggle buttons
  final bool? isToggled;

  /// Custom semantic properties
  final Map<String, dynamic> customSemanticsProperties;

  /// Build semantic widget wrapper
  Widget wrap(Widget child) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      value: semanticsValue,
      button: isButton,
      header: isHeader,
      link: isLink,
      textField: isTextField,
      checked: isChecked,
      selected: isSelected,
      toggled: isToggled,
      child: child,
    );
  }
}

/// Interaction configuration for widgets
class InteractionConfig {
  const InteractionConfig({
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onHover,
    this.onFocusChange,
    this.enableFeedback = true,
    this.feedbackType = HapticFeedbackType.lightImpact,
    this.cursorType = SystemMouseCursors.click,
    this.customInteractions = const {},
  });

  /// Tap callback
  final VoidCallback? onTap;

  /// Double tap callback
  final VoidCallback? onDoubleTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Pan start callback
  final void Function(DragStartDetails)? onPanStart;

  /// Pan update callback
  final void Function(DragUpdateDetails)? onPanUpdate;

  /// Pan end callback
  final void Function(DragEndDetails)? onPanEnd;

  /// Hover callback
  final void Function(bool)? onHover;

  /// Focus change callback
  final void Function(bool)? onFocusChange;

  /// Whether to enable haptic feedback
  final bool enableFeedback;

  /// Type of haptic feedback
  final HapticFeedbackType feedbackType;

  /// Mouse cursor type
  final SystemMouseCursor cursorType;

  /// Custom interaction handlers
  final Map<String, Function> customInteractions;

  /// Build gesture detector wrapper
  Widget wrap(Widget child) {
    return MouseRegion(
      cursor: cursorType,
      onEnter: onHover != null ? (_) => onHover!(true) : null,
      onExit: onHover != null ? (_) => onHover!(false) : null,
      child: GestureDetector(
        onTap: () {
          if (enableFeedback) {
            HapticFeedback.selectionClick();
          }
          onTap?.call();
        },
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: Focus(
          onFocusChange: onFocusChange,
          child: child,
        ),
      ),
    );
  }
}
