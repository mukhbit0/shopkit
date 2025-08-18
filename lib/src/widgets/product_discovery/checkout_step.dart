import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../theme/shopkit_theme_styles.dart';
import '../../theme/components/checkout_step_theme.dart';

// Minimal shim used during incremental migration. Will be removed.
class _ConfigShim {
  final CheckoutStepTheme? _theme;
  _ConfigShim(this._theme);

  Color? getColor(String key, Color? defaultColor) {
    switch (key) {
      case 'activeStepColor':
      case 'activeColor':
        return _theme?.activeColor ?? defaultColor;
      case 'inactiveStepColor':
        return _theme?.inactiveColor ?? defaultColor;
      case 'completedStepColor':
        return _theme?.completedColor ?? defaultColor;
      default:
        return defaultColor;
    }
  }

  FontWeight? getFontWeight(String key, FontWeight? defaultWeight) {
    return defaultWeight;
  }

  Curve? getCurve(String key, Curve defaultCurve) {
    return defaultCurve;
  }
}

/// A comprehensive checkout step widget with advanced features and unlimited customization
/// Features: Multiple layouts, animations, validation, progress tracking, and extensive theming
class CheckoutStepNew extends StatefulWidget {
  const CheckoutStepNew({
    super.key,
    required this.steps,
    this.customBuilder,
    this.customStepBuilder,
    this.customProgressBuilder,
    this.customNavigationBuilder,
    this.onStepTapped,
    this.onStepValidated,
    this.onStepCompleted,
    this.onCheckoutCompleted,
    this.currentStep = 0,
    this.enableNavigation = true,
    this.enableValidation = true,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showProgress = true,
    this.showStepNumbers = true,
    this.allowStepJumping = false,
    this.style = CheckoutStepStyle.vertical,
    this.progressStyle = CheckoutProgressStyle.linear,
    this.validationMode = CheckoutValidationMode.onNext,
    this.themeStyle,
  });

  /// Steps data for the checkout flow
  final List<CheckoutStepData> steps;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<CheckoutStepData>, CheckoutStepNewState)? customBuilder;

  /// Custom step builder
  final Widget Function(BuildContext, CheckoutStepData, int, bool)? customStepBuilder;

  /// Custom progress builder
  final Widget Function(BuildContext, int, int)? customProgressBuilder;

  /// Custom navigation builder
  final Widget Function(BuildContext, int, int, VoidCallback?, VoidCallback?)? customNavigationBuilder;

  /// Callback when a step is tapped
  final Function(int)? onStepTapped;

  /// Callback when step is validated
  final Function(int, bool)? onStepValidated;

  /// Callback when a step is marked completed
  final Function(int)? onStepCompleted;

  /// Callback when checkout completes
  final VoidCallback? onCheckoutCompleted;

  /// Current active step
  final int currentStep;

  /// Whether to enable navigation
  final bool enableNavigation;

  /// Whether to enable validation
  final bool enableValidation;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to show progress indicator
  final bool showProgress;

  /// Whether to show step numbers
  final bool showStepNumbers;

  /// Whether to allow jumping to non-sequential steps
  final bool allowStepJumping;

  /// Style of the checkout steps
  final CheckoutStepStyle style;

  /// Style of the progress indicator
  final CheckoutProgressStyle progressStyle;

  /// Validation mode
  final CheckoutValidationMode validationMode;

  /// Built-in theme styling support - just pass a string!
  final String? themeStyle;

  @override
  State<CheckoutStepNew> createState() => CheckoutStepNewState();
}

class CheckoutStepNewState extends State<CheckoutStepNew>
    with TickerProviderStateMixin {
  late AnimationController _stepController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  // FlexibleWidgetConfig removed; theme extensions used instead
  int _currentStep = 0;
  List<bool> _stepValidations = [];
  List<bool> _stepCompletions = [];
  PageController? _pageController;

  // Theme helper: prefer CheckoutStepTheme values when present
  CheckoutStepTheme? get _checkoutTheme => Theme.of(context).extension<ShopKitTheme>()?.checkoutStepTheme;
  CheckoutStepTheme? get checkoutTheme => _checkoutTheme;

  // Small helper to pick a themed value or fallback
  T _pick<T>(T? themeValue, T fallback) => themeValue ?? fallback;

  // Lightweight compatibility helpers: these bridge existing _getConfig/_config calls
  // to the typed CheckoutStepTheme where possible. They'll be removed as we finish
  // the migration, but keep the file compiling during incremental edits.

  // Mimic a minimal config accessor for common types
  T _getConfig<T>(String key, T defaultValue) {
    // Map known keys to theme tokens where feasible
    switch (key) {
      case 'activeColor':
      case 'activeStepColor':
        if (_checkoutTheme?.activeColor != null && defaultValue is Color) {
          return _checkoutTheme!.activeColor as T;
        }
        break;
      case 'inactiveStepColor':
        if (_checkoutTheme?.inactiveColor != null && defaultValue is Color) {
          return _checkoutTheme!.inactiveColor as T;
        }
        break;
      case 'completedStepColor':
        if (_checkoutTheme?.completedColor != null && defaultValue is Color) {
          return _checkoutTheme!.completedColor as T;
        }
        break;
      case 'stepIndicatorIconSize':
      case 'stepNumberFontSize':
        // numeric sizes
        break;
      default:
        break;
    }

    return defaultValue;
  }

  // Minimal _config placeholder to support old lookup patterns (.getColor, .getFontWeight, etc.)
  _ConfigShim? get _config => _ConfigShim(_checkoutTheme);

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep.clamp(0, widget.steps.length - 1);
    
    _setupAnimations();
    _initializeValidations();
    
    if (widget.style == CheckoutStepStyle.horizontal) {
      _pageController = PageController(initialPage: _currentStep);
    }
  }

  void _setupAnimations() {
    _stepController = AnimationController(
  duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressController = AnimationController(
  duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
  duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
  curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
  curve: Curves.easeOutCubic,
    ));

    if (widget.enableAnimations) {
      _stepController.forward();
      _progressController.animateTo(_currentStep / (widget.steps.length - 1));
      _slideController.forward();
    } else {
      _stepController.value = 1.0;
      _progressController.value = _currentStep / (widget.steps.length - 1);
      _slideController.value = 1.0;
    }
  }

  void _initializeValidations() {
    _stepValidations = List.generate(widget.steps.length, (index) => false);
    _stepCompletions = List.generate(widget.steps.length, (index) => false);
    
    // Mark previous steps as completed if current step > 0
    for (int i = 0; i < _currentStep; i++) {
      _stepValidations[i] = true;
      _stepCompletions[i] = true;
    }
  }

  void _handleStepTap(int stepIndex) {
    if (!widget.enableNavigation) return;
    
    // Check if step jumping is allowed
    if (!widget.allowStepJumping && stepIndex > _currentStep + 1) {
      return;
    }
    
    // Check if previous steps are completed
    if (!widget.allowStepJumping) {
      for (int i = 0; i < stepIndex; i++) {
        if (!_stepCompletions[i]) {
          return;
        }
      }
    }
    
  if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    
    _goToStep(stepIndex);
    widget.onStepTapped?.call(stepIndex);
  }

  void _goToStep(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= widget.steps.length || stepIndex == _currentStep) {
      return;
    }
    
    setState(() {
      _currentStep = stepIndex;
    });
    
    if (widget.enableAnimations) {
      _progressController.animateTo(_currentStep / (widget.steps.length - 1));
      
      if (widget.style == CheckoutStepStyle.horizontal && _pageController != null) {
        _pageController!.animateToPage(
          stepIndex,
          duration: Duration(milliseconds: _getConfig('pageTransitionDuration', 300)),
          curve: _config?.getCurve('pageTransitionCurve', Curves.easeInOut) ?? Curves.easeInOut,
        );
      }
    }
  }

  bool _validateCurrentStep() {
    if (!widget.enableValidation || _currentStep >= widget.steps.length) {
      return true;
    }
    
    final step = widget.steps[_currentStep];
    final isValid = step.validator?.call() ?? true;
    
    setState(() {
      _stepValidations[_currentStep] = isValid;
    });
    
    widget.onStepValidated?.call(_currentStep, isValid);
    
    return isValid;
  }

  void _nextStep() {
    if (_currentStep >= widget.steps.length - 1) {
      _completeCheckout();
      return;
    }
    
    // Validate current step if required
    if (widget.validationMode == CheckoutValidationMode.onNext) {
      if (!_validateCurrentStep()) {
        return;
      }
    }
    
    // Mark current step as completed
    setState(() {
      _stepCompletions[_currentStep] = true;
    });
    
    widget.onStepCompleted?.call(_currentStep);
    
  if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    
    _goToStep(_currentStep + 1);
  }

  void _previousStep() {
    if (_currentStep <= 0) return;
    
  if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    
    _goToStep(_currentStep - 1);
  }

  void _completeCheckout() {
    // Validate all steps if required
    if (widget.enableValidation) {
      for (int i = 0; i < widget.steps.length; i++) {
        final step = widget.steps[i];
        final isValid = step.validator?.call() ?? true;
        
        if (!isValid) {
          _goToStep(i);
          return;
        }
      }
    }
    
    // Mark all steps as completed
    setState(() {
      for (int i = 0; i < widget.steps.length; i++) {
        _stepCompletions[i] = true;
      }
    });
    
  if (widget.enableHaptics) {
      HapticFeedback.heavyImpact();
    }
    
    widget.onCheckoutCompleted?.call();
  }

  @override
  void didUpdateWidget(CheckoutStepNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    
  // legacy runtime config removed
    
    if (widget.currentStep != oldWidget.currentStep) {
      _currentStep = widget.currentStep.clamp(0, widget.steps.length - 1);
      
      if (widget.enableAnimations) {
        _progressController.animateTo(_currentStep / (widget.steps.length - 1));
      }
    }
    
    if (widget.steps.length != oldWidget.steps.length) {
      _initializeValidations();
    }
  }

  @override
  void dispose() {
    _stepController.dispose();
    _progressController.dispose();
    _slideController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.steps, this);
    }

  final theme = Theme.of(context).extension<ShopKitTheme>()!;

    // Apply theme-specific styling if themeStyle is provided
    Widget content;
    if (widget.themeStyle != null) {
      content = _buildThemedCheckoutSteps(context, theme, widget.themeStyle!);
    } else {
      content = _buildCheckoutSteps(context, theme);
    }

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: content,
      );
    }

    return content;
  }

  Widget _buildCheckoutSteps(BuildContext context, ShopKitTheme theme) {
    switch (widget.style) {
      case CheckoutStepStyle.horizontal:
        return _buildHorizontalSteps(context, theme);
      case CheckoutStepStyle.compact:
        return _buildCompactSteps(context, theme);
      case CheckoutStepStyle.card:
        return _buildCardSteps(context, theme);
      case CheckoutStepStyle.vertical:
        return _buildVerticalSteps(context, theme);
    }
  }

  Widget _buildVerticalSteps(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min, // CRITICAL FIX: Prevents unbounded height
      children: [
        if (widget.showProgress) _buildProgressIndicator(context, theme),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.steps.length,
            itemBuilder: (context, index) {
              return _buildVerticalStepItem(context, theme, index);
            },
          ),
        ),
        
        if (widget.enableNavigation) _buildNavigationButtons(context, theme),
      ],
    );
  }

  Widget _buildHorizontalSteps(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min, // CRITICAL FIX: Prevents unbounded height
      children: [
        if (widget.showProgress) _buildHorizontalStepIndicator(context, theme),
        
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: widget.enableNavigation ? null : const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentStep = page;
              });
            },
            itemCount: widget.steps.length,
            itemBuilder: (context, index) {
              return _buildHorizontalStepContent(context, theme, index);
            },
          ),
        ),
        
        if (widget.enableNavigation) _buildNavigationButtons(context, theme),
      ],
    );
  }

  Widget _buildCompactSteps(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          if (widget.showProgress) _buildCompactProgressIndicator(context, theme),
          
          const SizedBox(height: 16.0),
          
          Expanded(
            child: _buildStepContent(context, theme, _currentStep),
          ),
          
          if (widget.enableNavigation) _buildCompactNavigationButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildCardSteps(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        color: theme.surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            if (widget.showProgress) _buildCardProgressIndicator(context, theme),
            
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(_getConfig('cardContentPadding', 16.0)),
                child: _buildStepContent(context, theme, _currentStep),
              ),
            ),
            
            if (widget.enableNavigation) _buildCardNavigationButtons(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalStepItem(BuildContext context, ShopKitTheme theme, int stepIndex) {
    final isActive = stepIndex == _currentStep;
    final isCompleted = _stepCompletions[stepIndex];
    final isValid = _stepValidations[stepIndex];

    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('verticalStepSpacing', 24.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          _buildStepIndicator(context, theme, stepIndex, isActive, isCompleted, isValid),
          
          SizedBox(width: _getConfig('verticalStepIndicatorSpacing', 16.0)),
          
          // Step Content
          Expanded(
            child: GestureDetector(
              onTap: () => _handleStepTap(stepIndex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isActive
                          ? (_pick(_checkoutTheme?.activeColor, theme.primaryColor)).withValues(alpha: 0.1)
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        border: isActive
                          ? Border.all(
                              color: _pick(_checkoutTheme?.activeColor, theme.primaryColor),
                              width: 1.0,
                            )
                          : null,
                ),
                child: isActive
                  ? _buildStepContent(context, theme, stepIndex)
                  : _buildStepSummary(context, theme, stepIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStepContent(BuildContext context, ShopKitTheme theme, int stepIndex) {
    return Container(
      padding: EdgeInsets.all(_getConfig('horizontalStepContentPadding', 16.0)),
      child: _buildStepContent(context, theme, stepIndex),
    );
  }

  Widget _buildStepIndicator(BuildContext context, ShopKitTheme theme, int stepIndex, bool isActive, bool isCompleted, bool isValid) {
    return GestureDetector(
      onTap: () => _handleStepTap(stepIndex),
      child: AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  width: 40.0,
  height: 40.0,
        decoration: BoxDecoration(
          color: isCompleted
            ? _config?.getColor('completedStepColor', theme.successColor) ?? theme.successColor
            : isActive
              ? _config?.getColor('activeStepColor', theme.primaryColor) ?? theme.primaryColor
              : _config?.getColor('inactiveStepColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
              ? _config?.getColor('activeStepBorderColor', theme.primaryColor) ?? theme.primaryColor
              : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: isActive
            ? [
                BoxShadow(
                  color: _pick(_checkoutTheme?.activeColor, theme.primaryColor).withValues(alpha: 0.3),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        ),
        child: Center(
          child: isCompleted
            ? Icon(
                Icons.check,
                color: _config?.getColor('completedStepIconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                size: _getConfig('stepIndicatorIconSize', 20.0),
              )
            : widget.showStepNumbers
              ? Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: isActive
                      ? _config?.getColor('activeStepNumberColor', theme.onPrimaryColor) ?? theme.onPrimaryColor
                      : _config?.getColor('inactiveStepNumberColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                    fontSize: _getConfig('stepNumberFontSize', 16.0),
                    fontWeight: _config?.getFontWeight('stepNumberFontWeight', FontWeight.bold) ?? FontWeight.bold,
                  ),
                )
              : Icon(
                  widget.steps[stepIndex].icon ?? Icons.circle,
                  color: isActive
                    ? _config?.getColor('activeStepIconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor
                    : _config?.getColor('inactiveStepIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  size: _getConfig('stepIndicatorIconSize', 20.0),
                ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, ShopKitTheme theme, int stepIndex) {
  if (widget.customStepBuilder != null) {
      return widget.customStepBuilder!(context, widget.steps[stepIndex], stepIndex, stepIndex == _currentStep);
    }

    final step = widget.steps[stepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.title,
          style: checkoutTheme?.activeTitleStyle ?? TextStyle(
            color: theme.onSurfaceColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        if (step.description.isNotEmpty) ...[
          SizedBox(height: _getConfig('stepTitleDescriptionSpacing', 8.0)),
          Text(
            step.description,
            style: TextStyle(
              color: theme.onSurfaceColor.withValues(alpha: 0.7),
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ],
        
        if (step.content != null) ...[
          SizedBox(height: _getConfig('stepDescriptionContentSpacing', 16.0)),
          Expanded(child: step.content!),
        ],
      ],
    );
  }

  Widget _buildStepSummary(BuildContext context, ShopKitTheme theme, int stepIndex) {
    final step = widget.steps[stepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.title,
          style: TextStyle(
            color: _config?.getColor('stepSummaryTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
            fontSize: _getConfig('stepSummaryTitleFontSize', 16.0),
            fontWeight: _config?.getFontWeight('stepSummaryTitleFontWeight', FontWeight.w600) ?? FontWeight.w600,
          ),
        ),
        
        if (step.description.isNotEmpty) ...[
          SizedBox(height: _getConfig('stepSummarySpacing', 4.0)),
          Text(
            step.description,
            style: TextStyle(
              color: _config?.getColor('stepSummaryDescriptionColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('stepSummaryDescriptionFontSize', 12.0),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, ShopKitTheme theme) {
    if (widget.customProgressBuilder != null) {
      return widget.customProgressBuilder!(context, _currentStep, widget.steps.length);
    }

    switch (widget.progressStyle) {
      case CheckoutProgressStyle.circular:
        return _buildCircularProgress(context, theme);
      case CheckoutProgressStyle.stepped:
        return _buildSteppedProgress(context, theme);
      case CheckoutProgressStyle.linear:
        return _buildLinearProgress(context, theme);
    }
  }

  Widget _buildLinearProgress(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('linearProgressPadding', 16.0)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getConfig('progressText', 'Step ${_currentStep + 1} of ${widget.steps.length}'),
                style: TextStyle(
                  color: _config?.getColor('progressTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  fontSize: _getConfig('progressTextFontSize', 14.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              Text(
                '${((_currentStep + 1) / widget.steps.length * 100).round()}%',
                style: TextStyle(
                  color: _config?.getColor('progressPercentageColor', theme.primaryColor) ?? theme.primaryColor,
                  fontSize: _getConfig('progressPercentageFontSize', 14.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: _getConfig('progressBarSpacing', 8.0)),
          
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: _config?.getColor('progressBackgroundColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _config?.getColor('progressValueColor', theme.primaryColor) ?? theme.primaryColor,
                ),
                minHeight: _getConfig('progressBarHeight', 6.0),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('circularProgressPadding', 16.0)),
      child: Center(
        child: SizedBox(
          width: _getConfig('circularProgressSize', 80.0),
          height: _getConfig('circularProgressSize', 80.0),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  CircularProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: _config?.getColor('circularProgressBackgroundColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _config?.getColor('circularProgressValueColor', theme.primaryColor) ?? theme.primaryColor,
                    ),
                    strokeWidth: _getConfig('circularProgressStrokeWidth', 6.0),
                  ),
                  
                  Center(
                    child: Text(
                      '${_currentStep + 1}/${widget.steps.length}',
                      style: TextStyle(
                        color: _config?.getColor('circularProgressTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                        fontSize: _getConfig('circularProgressTextFontSize', 16.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSteppedProgress(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('steppedProgressPadding', 16.0)),
      child: Row(
        children: List.generate(widget.steps.length, (index) {
          final isCompleted = _stepCompletions[index];
          final isActive = index == _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: _getConfig('steppedProgressHeight', 4.0),
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                        ? _config?.getColor('steppedProgressActiveColor', theme.primaryColor) ?? theme.primaryColor
                        : _config?.getColor('steppedProgressInactiveColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(_getConfig('steppedProgressBorderRadius', 2.0)),
                    ),
                  ),
                ),
                
                if (index < widget.steps.length - 1)
                  SizedBox(width: _getConfig('steppedProgressSpacing', 4.0)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHorizontalStepIndicator(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('horizontalIndicatorPadding', 16.0)),
      child: Row(
        children: List.generate(widget.steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = _stepCompletions[index];
          
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleStepTap(index),
                    child: Column(
                      children: [
                        _buildStepIndicator(context, theme, index, isActive, isCompleted, _stepValidations[index]),
                        
                        SizedBox(height: _getConfig('horizontalIndicatorSpacing', 8.0)),
                        
                        Text(
                          widget.steps[index].title,
                          style: TextStyle(
                            color: isActive
                              ? _config?.getColor('horizontalIndicatorActiveTextColor', theme.primaryColor) ?? theme.primaryColor
                              : _config?.getColor('horizontalIndicatorInactiveTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
                            fontSize: _getConfig('horizontalIndicatorTextFontSize', 12.0),
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (index < widget.steps.length - 1)
                  Container(
                    width: _getConfig('horizontalIndicatorConnectorWidth', 40.0),
                    height: _getConfig('horizontalIndicatorConnectorHeight', 2.0),
                    color: isCompleted
                      ? _config?.getColor('horizontalIndicatorConnectorActiveColor', theme.primaryColor) ?? theme.primaryColor
                      : _config?.getColor('horizontalIndicatorConnectorInactiveColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCompactProgressIndicator(BuildContext context, ShopKitTheme theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.steps[_currentStep].title,
            style: TextStyle(
              color: _config?.getColor('compactProgressTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('compactProgressTitleFontSize', 18.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getConfig('compactProgressBadgeHorizontalPadding', 8.0),
            vertical: _getConfig('compactProgressBadgeVerticalPadding', 4.0),
          ),
          decoration: BoxDecoration(
            color: _config?.getColor('compactProgressBadgeBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
            borderRadius: BorderRadius.circular(_getConfig('compactProgressBadgeBorderRadius', 12.0)),
          ),
          child: Text(
            '${_currentStep + 1}/${widget.steps.length}',
            style: TextStyle(
              color: _config?.getColor('compactProgressBadgeTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
              fontSize: _getConfig('compactProgressBadgeTextFontSize', 12.0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardProgressIndicator(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('cardProgressIndicatorPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('cardProgressIndicatorBackgroundColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_getConfig('cardProgressIndicatorBorderRadius', 12.0)),
        ),
      ),
      child: _buildLinearProgress(context, theme),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, ShopKitTheme theme) {
    if (widget.customNavigationBuilder != null) {
      return widget.customNavigationBuilder!(
        context,
        _currentStep,
        widget.steps.length,
        _currentStep > 0 ? _previousStep : null,
        _currentStep < widget.steps.length - 1 ? _nextStep : _completeCheckout,
      );
    }

    return Container(
      padding: EdgeInsets.all(_getConfig('navigationButtonsPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('navigationButtonsBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        boxShadow: _getConfig('enableNavigationButtonsShadow', true)
          ? [
              BoxShadow(
                color: theme.onSurfaceColor.withValues(alpha: _getConfig('navigationButtonsShadowOpacity', 0.1)),
                blurRadius: _getConfig('navigationButtonsShadowBlurRadius', 8.0),
                offset: const Offset(0, -2),
              ),
            ]
          : null,
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: _getConfig('navigationButtonVerticalPadding', 12.0)),
                    side: BorderSide(
                      color: _config?.getColor('previousButtonBorderColor', theme.primaryColor) ?? theme.primaryColor,
                    ),
                  ),
                  child: Text(
                    _getConfig('previousButtonText', 'Previous'),
                    style: TextStyle(
                      fontSize: _getConfig('navigationButtonFontSize', 16.0),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: _getConfig('navigationButtonSpacing', 16.0)),
            ],
            
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: ElevatedButton(
                onPressed: _currentStep < widget.steps.length - 1 ? _nextStep : _completeCheckout,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: _getConfig('navigationButtonVerticalPadding', 12.0)),
                  backgroundColor: _config?.getColor('nextButtonBackgroundColor', theme.primaryColor) ?? theme.primaryColor,
                  foregroundColor: _config?.getColor('nextButtonTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                ),
                child: Text(
                  _currentStep < widget.steps.length - 1
                    ? _getConfig('nextButtonText', 'Next')
                    : _getConfig('completeButtonText', 'Complete'),
                  style: TextStyle(
                    fontSize: _getConfig('navigationButtonFontSize', 16.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNavigationButtons(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('compactNavigationHorizontalPadding', 16.0),
        vertical: _getConfig('compactNavigationVerticalPadding', 8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            IconButton(
              onPressed: _previousStep,
              icon: Icon(
                Icons.chevron_left,
                color: _config?.getColor('compactNavigationIconColor', theme.primaryColor) ?? theme.primaryColor,
              ),
            )
          else
            const SizedBox(width: 48),
          
          Text(
            '${_currentStep + 1} / ${widget.steps.length}',
            style: TextStyle(
              color: _config?.getColor('compactNavigationCounterColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('compactNavigationCounterFontSize', 14.0),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          if (_currentStep < widget.steps.length - 1)
            IconButton(
              onPressed: _nextStep,
              icon: Icon(
                Icons.chevron_right,
                color: _config?.getColor('compactNavigationIconColor', theme.primaryColor) ?? theme.primaryColor,
              ),
            )
          else
            IconButton(
              onPressed: _completeCheckout,
              icon: Icon(
                Icons.check,
                color: _config?.getColor('compactNavigationCompleteIconColor', theme.successColor) ?? theme.successColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardNavigationButtons(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('cardNavigationPadding', 16.0)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: _config?.getColor('cardNavigationBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: _buildNavigationButtons(context, theme),
    );
  }

  /// Public API for external control
  int get currentStep => _currentStep;
  
  int get totalSteps => widget.steps.length;
  
  double get progress => _currentStep / (widget.steps.length - 1);
  
  bool get isFirstStep => _currentStep == 0;
  
  bool get isLastStep => _currentStep == widget.steps.length - 1;
  
  bool get canGoNext => _currentStep < widget.steps.length - 1;
  
  bool get canGoPrevious => _currentStep > 0;
  
  bool isStepCompleted(int stepIndex) {
    return stepIndex < _stepCompletions.length ? _stepCompletions[stepIndex] : false;
  }
  
  bool isStepValid(int stepIndex) {
    return stepIndex < _stepValidations.length ? _stepValidations[stepIndex] : false;
  }
  
  void goToStep(int stepIndex) {
    _goToStep(stepIndex);
  }
  
  void nextStep() {
    _nextStep();
  }
  
  void previousStep() {
    _previousStep();
  }
  
  void completeCheckout() {
    _completeCheckout();
  }
  
  bool validateStep(int stepIndex) {
    if (stepIndex < 0 || stepIndex >= widget.steps.length) {
      return false;
    }
    
    final step = widget.steps[stepIndex];
    final isValid = step.validator?.call() ?? true;
    
    setState(() {
      _stepValidations[stepIndex] = isValid;
    });
    
    return isValid;
  }
  
  void markStepCompleted(int stepIndex, bool completed) {
    if (stepIndex >= 0 && stepIndex < _stepCompletions.length) {
      setState(() {
        _stepCompletions[stepIndex] = completed;
      });
    }
  }

  /// Build themed checkout steps with ShopKitThemeConfig
  Widget _buildThemedCheckoutSteps(BuildContext context, ShopKitTheme theme, String themeStyleString) {
    final themeStyle = ShopKitThemeStyleExtension.fromString(themeStyleString);
    final themeConfig = ShopKitThemeConfig.forStyle(themeStyle, context);
    
    Widget content = _buildCheckoutSteps(context, theme);
    
    // Apply theme-specific styling
    return Container(
      decoration: BoxDecoration(
        color: themeConfig.backgroundColor ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(themeConfig.borderRadius),
        boxShadow: themeConfig.enableShadows ? [
          BoxShadow(
            color: (themeConfig.shadowColor ?? theme.onSurfaceColor).withValues(alpha: 0.1),
            blurRadius: themeConfig.elevation * 2,
            offset: Offset(0, themeConfig.elevation),
          ),
        ] : null,
      ),
      child: content,
    );
  }
}

/// Data class for checkout step
class CheckoutStepData {
  const CheckoutStepData({
    required this.title,
    this.description = '',
    this.content,
    this.icon,
    this.validator,
  });

  final String title;
  final String description;
  final Widget? content;
  final IconData? icon;
  final bool Function()? validator;
}

/// Style options for checkout steps
enum CheckoutStepStyle {
  vertical,
  horizontal,
  compact,
  card,
}

/// Progress indicator styles
enum CheckoutProgressStyle {
  linear,
  circular,
  stepped,
}

/// Validation modes
enum CheckoutValidationMode {
  onNext,
  onComplete,
  manual,
}
