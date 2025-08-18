import 'package:flutter/material.dart';
import '../../models/filter_model.dart';
import '../../theme/theme.dart'; // Import the new, unified theme system

/// A customizable product filter widget for filtering and sorting products, styled via ShopKitTheme.
class ProductFilter extends StatefulWidget {
  const ProductFilter({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    this.onSortChanged,
    this.initialSortOption,
    this.showSortOptions = true,
    this.showFilterCount = true,
    this.isExpanded = false,
  });

  /// The list of available `FilterModel`s to display.
  final List<FilterModel> filters;

  /// A callback that fires whenever a filter's values are changed.
  final ValueChanged<List<FilterModel>> onFiltersChanged;

  /// A callback that fires when the sort option is changed.
  final ValueChanged<String>? onSortChanged;

  /// The initial sort option to display as selected.
  final String? initialSortOption;

  /// If true, the sort by options are displayed.
  final bool showSortOptions;

  /// If true, a badge with the count of active filters is shown in the header.
  final bool showFilterCount;

  /// If true, the filter section is expanded by default.
  final bool isExpanded;

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  late List<FilterModel> _activeFilters;
  String? _selectedSort;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _activeFilters = List.from(widget.filters);
    _selectedSort = widget.initialSortOption;
    _isExpanded = widget.isExpanded;
  }

  void _updateFilter(FilterModel filter, List<dynamic> selectedValues) {
    setState(() {
      final index = _activeFilters.indexWhere((f) => f.id == filter.id);
      if (index != -1) {
        _activeFilters[index] = filter.copyWith(selectedValues: selectedValues);
      }
    });
    widget.onFiltersChanged(_activeFilters);
  }

  void _toggleCheckboxOption(FilterModel filter, String option, bool selected) {
    final currentValues = List<String>.from(filter.selectedValues);
    if (selected) {
      if (!currentValues.contains(option)) {
        currentValues.add(option);
      }
    } else {
      currentValues.remove(option);
    }
    _updateFilter(filter, currentValues);
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters = _activeFilters
          .map((filter) => filter.copyWith(selectedValues: []))
          .toList();
      _selectedSort = null;
    });
    widget.onFiltersChanged(_activeFilters);
    widget.onSortChanged?.call('');
  }

  int _getActiveFilterCount() {
    return _activeFilters
        .where((filter) => filter.selectedValues.isNotEmpty)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shopKitTheme = theme.extension<ShopKitTheme>();
    final filterTheme = shopKitTheme?.productFilterTheme;
    final spacing = shopKitTheme?.spacing;

    return Container(
      decoration: BoxDecoration(
        color: filterTheme?.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: filterTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.md ?? 12.0),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: filterTheme?.borderRadius ?? BorderRadius.circular(shopKitTheme?.radii.md ?? 12.0),
            child: Padding(
              padding: EdgeInsets.all(spacing?.md ?? 16.0),
              child: Row(
                children: [
                  Icon(Icons.tune, color: shopKitTheme?.colors.primary ?? theme.colorScheme.primary),
                  SizedBox(width: spacing?.sm ?? 8.0),
                  Text(
                    'Filters',
                    style: filterTheme?.headerTextStyle ?? shopKitTheme?.typography.headline2 ?? theme.textTheme.titleMedium,
                  ),
                  if (widget.showFilterCount && _getActiveFilterCount() > 0) ...[
                    SizedBox(width: spacing?.sm ?? 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: shopKitTheme?.colors.primary ?? theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(shopKitTheme?.radii.full ?? 999),
                      ),
                      child: Text(
                        '${_getActiveFilterCount()}',
                        style: TextStyle(
                          color: shopKitTheme?.colors.onPrimary ?? theme.colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (_getActiveFilterCount() > 0)
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: Text('Clear All', style: TextStyle(color: shopKitTheme?.colors.error ?? theme.colorScheme.error)),
                    ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: shopKitTheme?.colors.onSurface ?? theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(color: theme.colorScheme.outline.withOpacity(0.2), height: 1),
            Padding(
              padding: EdgeInsets.all(spacing?.md ?? 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showSortOptions) ...[
                    _buildSortSection(theme, shopKitTheme),
                    SizedBox(height: spacing?.md ?? 16.0),
                  ],
                  ..._activeFilters.map((filter) => Padding(
                        padding: EdgeInsets.only(bottom: spacing?.md ?? 16.0),
                        child: _buildFilterSection(filter, theme, shopKitTheme),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSortSection(ThemeData theme, ShopKitTheme? shopKitTheme) {
    final filterTheme = shopKitTheme?.productFilterTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: filterTheme?.filterTitleStyle ?? shopKitTheme?.typography.body2 ?? theme.textTheme.titleSmall,
        ),
        SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
        Wrap(
          spacing: shopKitTheme?.spacing.sm ?? 8.0,
          runSpacing: shopKitTheme?.spacing.sm ?? 8.0,
          children: _sortOptions.map((option) {
            final isSelected = _selectedSort == option.value;
            return FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedSort = selected ? option.value : null);
                widget.onSortChanged?.call(_selectedSort ?? '');
              },
              selectedColor: filterTheme?.activeChipColor ?? shopKitTheme?.colors.primary,
              backgroundColor: filterTheme?.inactiveChipColor ?? theme.colorScheme.surfaceContainerHighest,
              labelStyle: isSelected ? filterTheme?.activeChipTextStyle : filterTheme?.inactiveChipTextStyle,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterSection(FilterModel filter, ThemeData theme, ShopKitTheme? shopKitTheme) {
    switch (filter.type) {
      case FilterType.range:
      case FilterType.price:
        return _buildRangeFilter(filter, theme, shopKitTheme);
      case FilterType.multiSelect:
        return _buildCheckboxFilter(filter, theme, shopKitTheme);
      case FilterType.singleSelect:
        return _buildDropdownFilter(filter, theme, shopKitTheme);
      case FilterType.boolean:
      case FilterType.rating:
        return _buildCheckboxFilter(filter, theme, shopKitTheme);
    }
  }

  Widget _buildRangeFilter(FilterModel filter, ThemeData theme, ShopKitTheme? shopKitTheme) {
    final filterTheme = shopKitTheme?.productFilterTheme;
    final currentRange = filter.selectedValues.isNotEmpty
        ? filter.selectedValues
        : [filter.minValue, filter.maxValue];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: filterTheme?.filterTitleStyle ?? shopKitTheme?.typography.body2 ?? theme.textTheme.titleSmall,
        ),
        RangeSlider(
          values: RangeValues(
            (currentRange[0] as num).toDouble(),
            (currentRange[1] as num).toDouble(),
          ),
          min: (filter.minValue as num).toDouble(),
          max: (filter.maxValue as num).toDouble(),
          divisions: 20,
          labels: RangeLabels(
            '\$${(currentRange[0] as num).toStringAsFixed(0)}',
            '\$${(currentRange[1] as num).toStringAsFixed(0)}',
          ),
          onChanged: (values) {
            _updateFilter(filter, [values.start, values.end]);
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxFilter(FilterModel filter, ThemeData theme, ShopKitTheme? shopKitTheme) {
    final filterTheme = shopKitTheme?.productFilterTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: filterTheme?.filterTitleStyle ?? shopKitTheme?.typography.body2 ?? theme.textTheme.titleSmall,
        ),
        SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
        Wrap(
          spacing: shopKitTheme?.spacing.sm ?? 8.0,
          runSpacing: shopKitTheme?.spacing.sm ?? 8.0,
          children: (filter.options as List<String>).map((option) {
            final isSelected = filter.selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                _toggleCheckboxOption(filter, option, selected);
              },
              selectedColor: filterTheme?.activeChipColor ?? shopKitTheme?.colors.primary,
              backgroundColor: filterTheme?.inactiveChipColor ?? theme.colorScheme.surfaceContainerHighest,
              labelStyle: isSelected ? filterTheme?.activeChipTextStyle : filterTheme?.inactiveChipTextStyle,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(FilterModel filter, ThemeData theme, ShopKitTheme? shopKitTheme) {
    final filterTheme = shopKitTheme?.productFilterTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: filterTheme?.filterTitleStyle ?? shopKitTheme?.typography.body2 ?? theme.textTheme.titleSmall,
        ),
        SizedBox(height: shopKitTheme?.spacing.sm ?? 8.0),
        DropdownButtonFormField<String>(
          value: filter.selectedValues.isNotEmpty ? filter.selectedValues.first : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(shopKitTheme?.radii.sm ?? 8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: (filter.options as List<String>).map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            _updateFilter(filter, value != null ? [value] : []);
          },
        ),
      ],
    );
  }
  
  static const List<SortOption> _sortOptions = [
    SortOption('relevance', 'Relevance'),
    SortOption('price_low', 'Price: Low to High'),
    SortOption('price_high', 'Price: High to Low'),
    SortOption('rating', 'Customer Rating'),
    SortOption('newest', 'Newest'),
    SortOption('popular', 'Most Popular'),
  ];
}

class SortOption {
  const SortOption(this.value, this.label);
  final String value;
  final String label;
}