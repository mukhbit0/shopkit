import 'package:flutter/material.dart';
import '../../models/filter_model.dart';

/// A customizable product filter widget for filtering and sorting products
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
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.spacing = 16.0,
  });

  /// List of available filters
  final List<FilterModel> filters;

  /// Callback when filters are changed
  final ValueChanged<List<FilterModel>> onFiltersChanged;

  /// Callback when sort option is changed
  final ValueChanged<String>? onSortChanged;

  /// Initial sort option
  final String? initialSortOption;

  /// Whether to show sort options
  final bool showSortOptions;

  /// Whether to show active filter count
  final bool showFilterCount;

  /// Whether the filter panel is initially expanded
  final bool isExpanded;

  /// Background color of the filter panel
  final Color? backgroundColor;

  /// Border radius of the filter panel
  final BorderRadius? borderRadius;

  /// Internal padding
  final EdgeInsets? padding;

  /// Spacing between filter items
  final double spacing;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filters',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.showFilterCount &&
                      _getActiveFilterCount() > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_getActiveFilterCount()}',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
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
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),

          // Expandable filter content
          if (_isExpanded) ...[
            Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
            Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort options
                  if (widget.showSortOptions) ...[
                    _buildSortSection(theme),
                    SizedBox(height: widget.spacing),
                  ],

                  // Filters
                  ..._activeFilters.map((filter) => Padding(
                        padding: EdgeInsets.only(bottom: widget.spacing),
                        child: _buildFilterSection(filter, theme),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSortSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sortOptions.map((option) {
            final isSelected = _selectedSort == option.value;
            return FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSort = selected ? option.value : null;
                });
                widget.onSortChanged?.call(_selectedSort ?? '');
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterSection(FilterModel filter, ThemeData theme) {
    switch (filter.type) {
      case FilterType.range:
        return _buildRangeFilter(filter, theme);
      case FilterType.multiSelect:
        return _buildCheckboxFilter(filter, theme);
      case FilterType.singleSelect:
        return _buildDropdownFilter(filter, theme);
      case FilterType.boolean:
      case FilterType.rating:
      case FilterType.price:
        return _buildCheckboxFilter(filter, theme);
    }
  }

  Widget _buildRangeFilter(FilterModel filter, ThemeData theme) {
    final currentRange = filter.selectedValues.isNotEmpty
        ? filter.selectedValues
        : [filter.minValue, filter.maxValue];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(
            (currentRange[0] as num).toDouble(),
            (currentRange[1] as num).toDouble(),
          ),
          min: (filter.minValue as num).toDouble(),
          max: (filter.maxValue as num).toDouble(),
          divisions: 20,
          labels: RangeLabels(
            '\$${currentRange[0]}',
            '\$${currentRange[1]}',
          ),
          onChanged: (values) {
            _updateFilter(filter, [values.start, values.end]);
          },
        ),
      ],
    );
  }

  Widget _buildCheckboxFilter(FilterModel filter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (filter.options as List<String>).map((option) {
            final isSelected = filter.selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                _toggleCheckboxOption(filter, option, selected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(FilterModel filter, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filter.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: filter.selectedValues.isNotEmpty
              ? filter.selectedValues.first
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: (filter.options as List<String>).map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            _updateFilter(filter, value != null ? [value] : []);
          },
        ),
      ],
    );
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

  int _getActiveFilterCount() {
    return _activeFilters
        .where((filter) => filter.selectedValues.isNotEmpty)
        .length;
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
