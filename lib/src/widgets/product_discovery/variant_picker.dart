import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/theme.dart';
import '../../models/variant_model.dart';

/// A comprehensive variant picker widget with unlimited customization options
/// Features: Multiple layouts, animations, advanced theming, and extensive configuration
class VariantPicker extends StatefulWidget {
  const VariantPicker({
    super.key,
    required this.variants,
    this.selectedVariant,
    this.onVariantSelected,
  this.customBuilder,
  this.customVariantBuilder,
  this.customGroupBuilder,
    this.layout = VariantPickerLayout.grid,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.enableMultiSelect = false,
    this.groupByType = true,
    this.showLabels = true,
    this.showPrices = true,
    this.showAvailability = true,
  this.maxSelections,
  });

  /// List of variants to display
  final List<VariantModel> variants;

  /// Currently selected variant
  final VariantModel? selectedVariant;

  /// Callback when variant is selected
  final void Function(VariantModel)? onVariantSelected;

  // Legacy FlexibleWidgetConfig removed in new theming refactor.

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<VariantModel>, VariantPickerState)? customBuilder;

  /// Custom variant item builder
  final Widget Function(BuildContext, VariantModel, bool, int)? customVariantBuilder;

  /// Custom group builder (when groupByType is true)
  final Widget Function(BuildContext, String, List<VariantModel>)? customGroupBuilder;

  /// Layout style for variants
  final VariantPickerLayout layout;

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable haptic feedback
  final bool enableHaptics;

  /// Whether to allow multiple selections
  final bool enableMultiSelect;

  /// Whether to group variants by type
  final bool groupByType;

  /// Whether to show variant labels
  final bool showLabels;

  /// Whether to show variant prices
  final bool showPrices;

  /// Whether to show availability status
  final bool showAvailability;

  /// Maximum number of selections (for multi-select)
  final int? maxSelections;

  // themeStyle removed; use Theme.of(context).extension<ShopKitTheme>().variantPickerTheme

  @override
  State<VariantPicker> createState() => VariantPickerState();
}

class VariantPickerState extends State<VariantPicker>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _selectionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final Set<VariantModel> _selectedVariants = {};
  final Map<String, List<VariantModel>> _groupedVariants = {};
  // Placeholder for removed legacy FlexibleWidgetConfig (kept null so legacy accessors no-op).
  final dynamic _config = null;

  // Legacy config accessor stub – always returns provided default.
  T _getConfig<T>(String key, T defaultValue) => defaultValue;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupInitialSelection();
    _groupVariants();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
  duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _selectionController = AnimationController(
  duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
  curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
  begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
  curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
  begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
  curve: Curves.elasticOut,
    ));

    if (widget.enableAnimations) {
      _animationController.forward();
    }
  }

  void _setupInitialSelection() {
    if (widget.selectedVariant != null) {
      _selectedVariants.add(widget.selectedVariant!);
    }
  }

  void _groupVariants() {
    if (widget.groupByType) {
      _groupedVariants.clear();
      for (final variant in widget.variants) {
        final type = variant.type;
        _groupedVariants[type] ??= [];
        _groupedVariants[type]!.add(variant);
      }
    }
  }

  void _handleVariantSelection(VariantModel variant) {
    if (widget.enableHaptics && _getConfig('enableHapticFeedback', true)) {
      HapticFeedback.lightImpact();
    }

    setState(() {
      if (widget.enableMultiSelect) {
        if (_selectedVariants.contains(variant)) {
          _selectedVariants.remove(variant);
        } else {
          if (widget.maxSelections == null || 
              _selectedVariants.length < widget.maxSelections!) {
            _selectedVariants.add(variant);
          } else {
            // Remove oldest selection if at max
            final oldestVariant = _selectedVariants.first;
            _selectedVariants.remove(oldestVariant);
            _selectedVariants.add(variant);
          }
        }
      } else {
        _selectedVariants.clear();
        _selectedVariants.add(variant);
      }
    });

    if (widget.enableAnimations) {
      _selectionController.forward().then((_) {
        _selectionController.reverse();
      });
    }

    // Call callback with the primary selected variant
    if (_selectedVariants.isNotEmpty) {
      widget.onVariantSelected?.call(_selectedVariants.first);
    }
  }

  @override
  void didUpdateWidget(VariantPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update config
    // Update selection if selectedVariant changed
    if (widget.selectedVariant != oldWidget.selectedVariant) {
      _selectedVariants.clear();
      if (widget.selectedVariant != null) {
        _selectedVariants.add(widget.selectedVariant!);
      }
    }
    
    // Regroup variants if needed
    if (widget.variants != oldWidget.variants || widget.groupByType != oldWidget.groupByType) {
      _groupVariants();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.variants, this);
    }

  final theme = Theme.of(context).extension<ShopKitTheme>()!;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildVariantPicker(context, theme),
      ),
    );
  }

  Widget _buildVariantPicker(BuildContext context, ShopKitTheme theme) {
    if (widget.variants.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(theme.radii.md.toDouble()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, theme),
          const SizedBox(height: 16),
          
          if (widget.groupByType && _groupedVariants.isNotEmpty)
            _buildGroupedVariants(context, theme)
          else
            _buildVariantsList(context, theme),
          
          if (_selectedVariants.isNotEmpty) _buildSelectedInfo(context, theme),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ShopKitTheme theme) {
    return Text(
  'Select Variant',
      style: TextStyle(
        color: _config?.getColor('titleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        fontSize: _getConfig('titleFontSize', 18.0),
        fontWeight: _config?.getFontWeight('titleFontWeight', FontWeight.w600) ?? FontWeight.w600,
        fontFamily: _getConfig('fontFamily', null),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShopKitTheme theme) {
    return Container(
  padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: _config?.getColor('emptyStateIconColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Variants Available',
            style: TextStyle(
              color: _config?.getColor('emptyStateTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('emptyStateTitleFontSize', 16.0),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_getConfig('showEmptyStateSubtitle', true)) ...[
            const SizedBox(height: 8),
            Text(
              'This product has no variants to choose from.',
              style: TextStyle(
                color: _config?.getColor('emptyStateSubtitleColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                fontSize: _getConfig('emptyStateSubtitleFontSize', 14.0),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupedVariants(BuildContext context, ShopKitTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _groupedVariants.entries.map((entry) {
        final groupType = entry.key;
        final groupVariants = entry.value;
        
        return widget.customGroupBuilder?.call(context, groupType, groupVariants) ??
          _buildVariantGroup(context, theme, groupType, groupVariants);
      }).toList(),
    );
  }

  Widget _buildVariantGroup(BuildContext context, ShopKitTheme theme, String groupType, List<VariantModel> groupVariants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_getConfig('showGroupTitles', true)) ...[
          Text(
            groupType,
            style: TextStyle(
              color: _config?.getColor('groupTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('groupTitleFontSize', 16.0),
              fontWeight: _config?.getFontWeight('groupTitleFontWeight', FontWeight.w500) ?? FontWeight.w500,
              fontFamily: _getConfig('fontFamily', null),
            ),
          ),
          SizedBox(height: _getConfig('groupTitleSpacing', 12.0)),
        ],
        
        _buildVariantsLayout(context, theme, groupVariants),
        
        SizedBox(height: _getConfig('groupSpacing', 24.0)),
      ],
    );
  }

  Widget _buildVariantsList(BuildContext context, ShopKitTheme theme) {
    return _buildVariantsLayout(context, theme, widget.variants);
  }

  Widget _buildVariantsLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    switch (widget.layout) {
      case VariantPickerLayout.list:
        return _buildListLayout(context, theme, variants);
      case VariantPickerLayout.grid:
        return _buildGridLayout(context, theme, variants);
      case VariantPickerLayout.chips:
        return _buildChipsLayout(context, theme, variants);
      case VariantPickerLayout.dropdown:
        return _buildDropdownLayout(context, theme, variants);
      case VariantPickerLayout.carousel:
        return _buildCarouselLayout(context, theme, variants);
      case VariantPickerLayout.buttons:
        return _buildButtonsLayout(context, theme, variants);
    }
  }

  Widget _buildListLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    return Column(
      children: variants.asMap().entries.map((entry) {
        final index = entry.key;
        final variant = entry.value;
        final isSelected = _selectedVariants.contains(variant);
        
        return _buildListItem(context, theme, variant, isSelected, index);
      }).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, ShopKitTheme theme, VariantModel variant, bool isSelected, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('listItemSpacing', 8.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleVariantSelection(variant),
          borderRadius: _config?.getBorderRadius('listItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: Duration(milliseconds: _getConfig('listItemAnimationDuration', 200)),
            padding: _config?.getEdgeInsets('listItemPadding', const EdgeInsets.all(12)) ?? const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                ? (_config?.getColor('selectedListItemColor', theme.primaryColor.withValues(alpha: 0.1)) ?? theme.primaryColor.withValues(alpha: 0.1))
                : (_config?.getColor('unselectedListItemColor', Colors.transparent) ?? Colors.transparent),
              borderRadius: _config?.getBorderRadius('listItemBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                  ? (_config?.getColor('selectedListItemBorderColor', theme.primaryColor) ?? theme.primaryColor)
                  : (_config?.getColor('unselectedListItemBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2)),
                width: _getConfig('listItemBorderWidth', 1.0),
              ),
            ),
            child: Row(
              children: [
                if (_getConfig('showListItemIcon', true))
                  Container(
                    width: _getConfig('listItemIconSize', 24.0),
                    height: _getConfig('listItemIconSize', 24.0),
                    decoration: BoxDecoration(
                      color: _getVariantColor(variant),
                      borderRadius: BorderRadius.circular(_getConfig('listItemIconRadius', 4.0)),
                      border: Border.all(
                        color: theme.onSurfaceColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                
                if (_getConfig('showListItemIcon', true))
                  SizedBox(width: _getConfig('listItemIconSpacing', 12.0)),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showLabels)
                        Text(
                          variant.name,
                          style: TextStyle(
                            color: _config?.getColor('listItemTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                            fontSize: _getConfig('listItemFontSize', 16.0),
                            fontWeight: isSelected
                              ? (_config?.getFontWeight('selectedListItemFontWeight', FontWeight.w600) ?? FontWeight.w600)
                              : (_config?.getFontWeight('unselectedListItemFontWeight', FontWeight.w400) ?? FontWeight.w400),
                          ),
                        ),
                      
                      if (widget.showPrices && variant.additionalPrice != null) ...[
                        SizedBox(height: _getConfig('listItemPriceSpacing', 4.0)),
                        Text(
                          variant.getFormattedAdditionalPrice('USD'),
                          style: TextStyle(
                            color: _config?.getColor('listItemPriceColor', theme.primaryColor) ?? theme.primaryColor,
                            fontSize: _getConfig('listItemPriceFontSize', 14.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      
                      if (widget.showAvailability) ...[
                        SizedBox(height: _getConfig('listItemAvailabilitySpacing', 4.0)),
                        _buildAvailabilityIndicator(context, theme, variant),
                      ],
                    ],
                  ),
                ),
                
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: _config?.getColor('selectedIconColor', theme.primaryColor) ?? theme.primaryColor,
                    size: _getConfig('selectedIconSize', 20.0),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    final crossAxisCount = _getConfig('gridCrossAxisCount', 3);
    final aspectRatio = _getConfig('gridAspectRatio', 1.0);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: _getConfig('gridCrossAxisSpacing', 12.0),
        mainAxisSpacing: _getConfig('gridMainAxisSpacing', 12.0),
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        final variant = variants[index];
        final isSelected = _selectedVariants.contains(variant);
        
        return widget.customVariantBuilder?.call(context, variant, isSelected, index) ??
          _buildGridItem(context, theme, variant, isSelected, index);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, ShopKitTheme theme, VariantModel variant, bool isSelected, int index) {
    return ScaleTransition(
      scale: isSelected ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleVariantSelection(variant),
          borderRadius: _config?.getBorderRadius('gridItemBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: Duration(milliseconds: _getConfig('gridItemAnimationDuration', 200)),
            decoration: BoxDecoration(
              color: _getVariantColor(variant),
              borderRadius: _config?.getBorderRadius('gridItemBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                  ? (_config?.getColor('selectedGridItemBorderColor', theme.primaryColor) ?? theme.primaryColor)
                  : (_config?.getColor('unselectedGridItemBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2)),
                width: isSelected ? _getConfig('selectedGridItemBorderWidth', 2.0) : _getConfig('unselectedGridItemBorderWidth', 1.0),
              ),
              boxShadow: isSelected && _getConfig('enableSelectedShadow', true)
                ? [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: _getConfig('selectedShadowOpacity', 0.3)),
                      blurRadius: _getConfig('selectedShadowBlur', 8.0),
                      offset: Offset(0, _getConfig('selectedShadowOffsetY', 2.0)),
                    ),
                  ]
                : null,
            ),
            child: Stack(
              children: [
                if (widget.showLabels || widget.showPrices)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(_getConfig('gridItemLabelPadding', 8.0)),
                      decoration: BoxDecoration(
                        color: _config?.getColor('gridItemLabelBackgroundColor', Colors.black.withValues(alpha: 0.7)) ?? Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(_getConfig('gridItemBorderRadius', 12.0)),
                          bottomRight: Radius.circular(_getConfig('gridItemBorderRadius', 12.0)),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.showLabels)
                            Text(
                              variant.name,
                              style: TextStyle(
                                color: _config?.getColor('gridItemLabelColor', Colors.white) ?? Colors.white,
                                fontSize: _getConfig('gridItemLabelFontSize', 12.0),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          
                          if (widget.showPrices && variant.additionalPrice != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              variant.getFormattedAdditionalPrice('USD'),
                              style: TextStyle(
                                color: _config?.getColor('gridItemPriceColor', Colors.white) ?? Colors.white,
                                fontSize: _getConfig('gridItemPriceFontSize', 10.0),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                
                if (isSelected)
                  Positioned(
                    top: _getConfig('selectedIndicatorTop', 8.0),
                    right: _getConfig('selectedIndicatorRight', 8.0),
                    child: Container(
                      padding: EdgeInsets.all(_getConfig('selectedIndicatorPadding', 4.0)),
                      decoration: BoxDecoration(
                        color: _config?.getColor('selectedIndicatorColor', theme.primaryColor) ?? theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: _config?.getColor('selectedIndicatorIconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
                        size: _getConfig('selectedIndicatorIconSize', 16.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChipsLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    return Wrap(
      spacing: _getConfig('chipSpacing', 8.0),
      runSpacing: _getConfig('chipRunSpacing', 8.0),
      children: variants.asMap().entries.map((entry) {
        final index = entry.key;
        final variant = entry.value;
        final isSelected = _selectedVariants.contains(variant);
        
        return _buildChipItem(context, theme, variant, isSelected, index);
      }).toList(),
    );
  }

  Widget _buildChipItem(BuildContext context, ShopKitTheme theme, VariantModel variant, bool isSelected, int index) {
    return FilterChip(
      label: Text(variant.name),
      selected: isSelected,
      onSelected: (selected) => _handleVariantSelection(variant),
      selectedColor: _config?.getColor('chipSelectedColor', theme.primaryColor) ?? theme.primaryColor,
      backgroundColor: _config?.getColor('chipBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
      checkmarkColor: _config?.getColor('chipCheckmarkColor', theme.onPrimaryColor) ?? theme.onPrimaryColor,
      labelStyle: TextStyle(
        color: isSelected
          ? (_config?.getColor('chipSelectedTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
          : (_config?.getColor('chipTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
        fontSize: _getConfig('chipFontSize', 14.0),
        fontWeight: isSelected
          ? (_config?.getFontWeight('chipSelectedFontWeight', FontWeight.w500) ?? FontWeight.w500)
          : (_config?.getFontWeight('chipFontWeight', FontWeight.w400) ?? FontWeight.w400),
      ),
      padding: _config?.getEdgeInsets('chipPadding', const EdgeInsets.symmetric(horizontal: 12, vertical: 8)) ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: _config?.getBorderRadius('chipBorderRadius', BorderRadius.circular(20)) ?? BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildDropdownLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    final selectedVariant = _selectedVariants.isNotEmpty ? _selectedVariants.first : null;
    
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<VariantModel>(
        value: selectedVariant,
        decoration: InputDecoration(
          hintText: _getConfig('dropdownHint', 'Select a variant'),
          border: OutlineInputBorder(
            borderRadius: _config?.getBorderRadius('dropdownBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          ),
          contentPadding: _config?.getEdgeInsets('dropdownPadding', const EdgeInsets.symmetric(horizontal: 12, vertical: 16)) ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        items: variants.map((variant) {
          return DropdownMenuItem<VariantModel>(
            value: variant,
            child: Row(
              children: [
                if (_getConfig('showDropdownColors', true))
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getVariantColor(variant),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme.onSurfaceColor.withValues(alpha: 0.2)),
                    ),
                  ),
                
                if (_getConfig('showDropdownColors', true))
                  const SizedBox(width: 12),
                
                Expanded(
                  child: Text(
                    variant.name,
                    style: TextStyle(
                      fontSize: _getConfig('dropdownFontSize', 16.0),
                      color: _config?.getColor('dropdownTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                    ),
                  ),
                ),
                
                if (widget.showPrices && variant.additionalPrice != null)
                  Text(
                    variant.getFormattedAdditionalPrice('USD'),
                    style: TextStyle(
                      fontSize: _getConfig('dropdownPriceFontSize', 14.0),
                      color: _config?.getColor('dropdownPriceColor', theme.primaryColor) ?? theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
        onChanged: (variant) {
          if (variant != null) {
            _handleVariantSelection(variant);
          }
        },
      ),
    );
  }

  Widget _buildCarouselLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    return SizedBox(
      height: _getConfig('carouselHeight', 120.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: _getConfig('carouselPadding', 0.0)),
        itemCount: variants.length,
        separatorBuilder: (context, index) => SizedBox(width: _getConfig('carouselItemSpacing', 12.0)),
        itemBuilder: (context, index) {
          final variant = variants[index];
          final isSelected = _selectedVariants.contains(variant);
          
          return _buildCarouselItem(context, theme, variant, isSelected, index);
        },
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, ShopKitTheme theme, VariantModel variant, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _handleVariantSelection(variant),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _getConfig('carouselItemAnimationDuration', 200)),
        width: _getConfig('carouselItemWidth', 80.0),
        decoration: BoxDecoration(
          color: _getVariantColor(variant),
          borderRadius: _config?.getBorderRadius('carouselItemBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
              ? (_config?.getColor('selectedCarouselItemBorderColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('unselectedCarouselItemBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2)),
            width: isSelected ? _getConfig('selectedCarouselItemBorderWidth', 2.0) : _getConfig('unselectedCarouselItemBorderWidth', 1.0),
          ),
          boxShadow: isSelected && _getConfig('enableCarouselSelectedShadow', true)
            ? [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: _getConfig('carouselSelectedShadowOpacity', 0.3)),
                  blurRadius: _getConfig('carouselSelectedShadowBlur', 8.0),
                  offset: Offset(0, _getConfig('carouselSelectedShadowOffsetY', 2.0)),
                ),
              ]
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showLabels)
              Text(
                variant.name,
                style: TextStyle(
                  color: _config?.getColor('carouselItemTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  fontSize: _getConfig('carouselItemFontSize', 12.0),
                  fontWeight: isSelected
                    ? (_config?.getFontWeight('selectedCarouselItemFontWeight', FontWeight.w600) ?? FontWeight.w600)
                    : (_config?.getFontWeight('unselectedCarouselItemFontWeight', FontWeight.w400) ?? FontWeight.w400),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            
            if (widget.showPrices && variant.additionalPrice != null) ...[
              const SizedBox(height: 4),
              Text(
                variant.getFormattedAdditionalPrice('USD'),
                style: TextStyle(
                  color: _config?.getColor('carouselItemPriceColor', theme.primaryColor) ?? theme.primaryColor,
                  fontSize: _getConfig('carouselItemPriceFontSize', 10.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsLayout(BuildContext context, ShopKitTheme theme, List<VariantModel> variants) {
    return Column(
      children: variants.asMap().entries.map((entry) {
        final index = entry.key;
        final variant = entry.value;
        final isSelected = _selectedVariants.contains(variant);
        
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: _getConfig('buttonSpacing', 8.0)),
          child: _buildButtonItem(context, theme, variant, isSelected, index),
        );
      }).toList(),
    );
  }

  Widget _buildButtonItem(BuildContext context, ShopKitTheme theme, VariantModel variant, bool isSelected, int index) {
    return ElevatedButton(
      onPressed: () => _handleVariantSelection(variant),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
          ? (_config?.getColor('selectedButtonColor', theme.primaryColor) ?? theme.primaryColor)
          : (_config?.getColor('unselectedButtonColor', theme.surfaceColor) ?? theme.surfaceColor),
        foregroundColor: isSelected
          ? (_config?.getColor('selectedButtonTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
          : (_config?.getColor('unselectedButtonTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor),
        shape: RoundedRectangleBorder(
          borderRadius: _config?.getBorderRadius('buttonBorderRadius', BorderRadius.circular(8)) ?? BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
              ? (_config?.getColor('selectedButtonBorderColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('unselectedButtonBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2)),
            width: _getConfig('buttonBorderWidth', 1.0),
          ),
        ),
        padding: _config?.getEdgeInsets('buttonPadding', const EdgeInsets.symmetric(vertical: 16, horizontal: 20)) ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        elevation: isSelected ? _getConfig('selectedButtonElevation', 2.0) : _getConfig('unselectedButtonElevation', 0.0),
      ),
      child: Row(
        children: [
          if (_getConfig('showButtonColors', true))
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getVariantColor(variant),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.onSurfaceColor.withValues(alpha: 0.2)),
              ),
            ),
          
          if (_getConfig('showButtonColors', true))
            const SizedBox(width: 12),
          
          Expanded(
            child: Text(
              variant.name,
              style: TextStyle(
                fontSize: _getConfig('buttonFontSize', 16.0),
                fontWeight: isSelected
                  ? (_config?.getFontWeight('selectedButtonFontWeight', FontWeight.w600) ?? FontWeight.w600)
                  : (_config?.getFontWeight('unselectedButtonFontWeight', FontWeight.w400) ?? FontWeight.w400),
              ),
            ),
          ),
          
          if (widget.showPrices && variant.additionalPrice != null)
            Text(
              variant.getFormattedAdditionalPrice('USD'),
              style: TextStyle(
                fontSize: _getConfig('buttonPriceFontSize', 14.0),
                fontWeight: FontWeight.w500,
              ),
            ),
          
          if (isSelected)
            Icon(
              Icons.check,
              size: _getConfig('buttonCheckIconSize', 20.0),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityIndicator(BuildContext context, ShopKitTheme theme, VariantModel variant) {
    final isAvailable = variant.isInStock;
    
    return Row(
      children: [
        Container(
          width: _getConfig('availabilityIndicatorSize', 8.0),
          height: _getConfig('availabilityIndicatorSize', 8.0),
          decoration: BoxDecoration(
            color: isAvailable
              ? (_config?.getColor('availableIndicatorColor', theme.successColor) ?? theme.successColor)
              : (_config?.getColor('unavailableIndicatorColor', theme.errorColor) ?? theme.errorColor),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: _getConfig('availabilityIndicatorSpacing', 6.0)),
        Text(
          isAvailable
            ? _getConfig('availableText', 'Available')
            : _getConfig('unavailableText', 'Out of Stock'),
          style: TextStyle(
            color: isAvailable
              ? (_config?.getColor('availableTextColor', theme.successColor) ?? theme.successColor)
              : (_config?.getColor('unavailableTextColor', theme.errorColor) ?? theme.errorColor),
            fontSize: _getConfig('availabilityFontSize', 12.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedInfo(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.enableMultiSelect ? 'Selected Variants (${_selectedVariants.length})' : 'Selected Variant',
            style: TextStyle(
              color: _config?.getColor('selectedInfoTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
              fontSize: _getConfig('selectedInfoTitleFontSize', 14.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _selectedVariants.map((variant) {
              return Chip(
                label: Text(
                  variant.name,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                backgroundColor: theme.colors.primary,
                labelStyle: TextStyle(color: theme.colors.onPrimary),
                deleteIcon: widget.enableMultiSelect ? Icon(Icons.close, size: 16, color: theme.colors.onPrimary) : null,
                onDeleted: widget.enableMultiSelect
                  ? () => _handleVariantSelection(variant)
                  : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getVariantColor(VariantModel variant) {
    // Try to parse color from variant swatchColor
    if (variant.swatchColor != null) {
      return _parseColor(variant.swatchColor!) ?? _getConfig('defaultVariantColor', Colors.grey.shade300);
    }
    
    // Try to extract color from name if it's a color variant
    if (variant.isColorVariant) {
      final color = _parseColorFromName(variant.value);
      if (color != null) return color;
    }
    
    // Default color
    return _getConfig('defaultVariantColor', Colors.grey.shade300);
  }

  Color? _parseColor(String colorString) {
    try {
      // Handle hex colors
      if (colorString.startsWith('#')) {
        final hex = colorString.substring(1);
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      }
      
      // Handle color names
      return _getColorByName(colorString);
    } catch (e) {
      return null;
    }
  }

  Color? _parseColorFromName(String name) {
    final lowerName = name.toLowerCase();
    
    // Common color names
    final colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'black': Colors.black,
      'white': Colors.white,
      'grey': Colors.grey,
      'gray': Colors.grey,
    };
    
    for (final entry in colorMap.entries) {
      if (lowerName.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return null;
  }

  Color? _getColorByName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return null;
    }
  }

  /// Public API for external control
  List<VariantModel> get selectedVariants => _selectedVariants.toList();
  
  VariantModel? get primarySelectedVariant => _selectedVariants.isNotEmpty ? _selectedVariants.first : null;
  
  void selectVariant(VariantModel variant) {
    if (widget.variants.contains(variant)) {
      _handleVariantSelection(variant);
    }
  }
  
  void clearSelection() {
    setState(() {
      _selectedVariants.clear();
    });
  }
  
  void selectVariants(List<VariantModel> variants) {
    if (widget.enableMultiSelect) {
      setState(() {
        _selectedVariants.clear();
        for (final variant in variants) {
          if (widget.variants.contains(variant)) {
            if (widget.maxSelections == null || 
                _selectedVariants.length < widget.maxSelections!) {
              _selectedVariants.add(variant);
            }
          }
        }
      });
    }
  }
}

/// Layout options for variant picker
enum VariantPickerLayout {
  list,
  grid,
  chips,
  dropdown,
  carousel,
  buttons,
}

