import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';

/// A comprehensive product search bar with advanced features and unlimited customization
/// Features: Voice search, filters, suggestions, history, analytics, and extensive theming
class ProductSearchBarAdvanced extends StatefulWidget {
  const ProductSearchBarAdvanced({
    super.key,
    this.onSearch,
    this.onFilterTap,
    this.onSuggestionTap,
    this.onClearHistory,
    this.config,
    this.customBuilder,
    this.customSuggestionBuilder,
    this.customFilterBuilder,
    this.controller,
    this.focusNode,
    this.initialQuery,
    this.suggestions = const [],
    this.searchHistory = const [],
    this.enableVoiceSearch = true,
    this.enableFilters = true,
    this.enableSuggestions = true,
    this.enableHistory = true,
    this.enableAutoComplete = true,
    this.enableAnalytics = false,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.maxSuggestions = 5,
    this.maxHistory = 10,
  });

  /// Callback when search is performed
  final void Function(String query)? onSearch;

  /// Callback when filter button is tapped
  final VoidCallback? onFilterTap;

  /// Callback when suggestion is tapped
  final void Function(String suggestion)? onSuggestionTap;

  /// Callback when clear history is tapped
  final VoidCallback? onClearHistory;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, ProductSearchBarAdvancedState)? customBuilder;

  /// Custom suggestion item builder
  final Widget Function(BuildContext, String, int)? customSuggestionBuilder;

  /// Custom filter button builder
  final Widget Function(BuildContext, VoidCallback?)? customFilterBuilder;

  /// Text controller for the search field
  final TextEditingController? controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Initial search query
  final String? initialQuery;

  /// List of search suggestions
  final List<String> suggestions;

  /// List of search history
  final List<String> searchHistory;

  /// Whether to enable voice search
  final bool enableVoiceSearch;

  /// Whether to enable filters
  final bool enableFilters;

  /// Whether to enable suggestions
  final bool enableSuggestions;

  /// Whether to enable search history
  final bool enableHistory;

  /// Whether to enable auto-complete
  final bool enableAutoComplete;

  /// Whether to enable search analytics
  final bool enableAnalytics;

  /// Debounce delay for search
  final Duration debounceDelay;

  /// Maximum number of suggestions to show
  final int maxSuggestions;

  /// Maximum number of history items to keep
  final int maxHistory;

  @override
  State<ProductSearchBarAdvanced> createState() => ProductSearchBarAdvancedState();
}

class ProductSearchBarAdvancedState extends State<ProductSearchBarAdvanced>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late AnimationController _suggestionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _suggestionFadeAnimation;

  FlexibleWidgetConfig? _config;
  String _currentQuery = '';
  List<String> _filteredSuggestions = [];
  List<String> _filteredHistory = [];
  bool _showSuggestions = false;
  bool _isListening = false;
  Timer? _debounceTimer;
  Timer? _focusHideTimer;

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('search_bar', context: context);
    _setupControllers();
    _setupAnimations();
    _setupInitialState();
  }

  void _setupControllers() {
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onQueryChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: _getConfig('containerAnimationDuration', 400)),
      vsync: this,
    );

    _suggestionController = AnimationController(
      duration: Duration(milliseconds: _getConfig('suggestionAnimationDuration', 200)),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _config?.getCurve('fadeAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, _getConfig('slideAnimationOffset', -0.1)),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
    ));

    _suggestionFadeAnimation = CurvedAnimation(
      parent: _suggestionController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  void _setupInitialState() {
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
    }
  }

  void _onQueryChanged() {
    final query = _controller.text;
    if (query != _currentQuery) {
      setState(() {
        _currentQuery = query;
        _filterSuggestions(query);
        _filterHistory(query);
        _showSuggestions = query.isNotEmpty && (
          _filteredSuggestions.isNotEmpty || 
          _filteredHistory.isNotEmpty
        );
      });

      if (_showSuggestions) {
        _suggestionController.forward();
      } else {
        _suggestionController.reverse();
      }

      // Debounced search with cancellable timer
      _debounceTimer?.cancel();
      if (widget.debounceDelay == Duration.zero) {
        if (_controller.text == query && query.isNotEmpty) {
          _performSearch(query);
        }
      } else {
        _debounceTimer = Timer(widget.debounceDelay, () {
          if (_controller.text == query && query.isNotEmpty) {
            _performSearch(query);
          }
        });
      }
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _currentQuery.isNotEmpty) {
      setState(() {
        _filterSuggestions(_currentQuery);
        _filterHistory(_currentQuery);
        _showSuggestions = _filteredSuggestions.isNotEmpty || _filteredHistory.isNotEmpty;
      });
      
      if (_showSuggestions) {
        _suggestionController.forward();
      }
    } else if (!_focusNode.hasFocus) {
      // Delay hiding suggestions to allow for tap events
      _focusHideTimer?.cancel();
      _focusHideTimer = Timer(const Duration(milliseconds: 150), () {
        if (!_focusNode.hasFocus) {
          if (mounted) {
            setState(() => _showSuggestions = false);
          }
          _suggestionController.reverse();
        }
      });
    }
  }

  void _filterSuggestions(String query) {
    if (!widget.enableSuggestions || query.isEmpty) {
      _filteredSuggestions.clear();
      return;
    }

    _filteredSuggestions = widget.suggestions
      .where((suggestion) => 
        suggestion.toLowerCase().contains(query.toLowerCase()) &&
        suggestion.toLowerCase() != query.toLowerCase()
      )
      .take(widget.maxSuggestions)
      .toList();
  }

  void _filterHistory(String query) {
    if (!widget.enableHistory || query.isEmpty) {
      _filteredHistory.clear();
      return;
    }

    _filteredHistory = widget.searchHistory
      .where((history) => 
        history.toLowerCase().contains(query.toLowerCase()) &&
        history.toLowerCase() != query.toLowerCase()
      )
      .take(widget.maxHistory)
      .toList();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    if (_getConfig('enableHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    widget.onSearch?.call(query.trim());
    
    // Hide suggestions after search
    setState(() => _showSuggestions = false);
    _suggestionController.reverse();
    
    // Remove focus if configured
    if (_getConfig('removeFocusAfterSearch', true)) {
      _focusNode.unfocus();
    }

    // Analytics tracking
    if (widget.enableAnalytics) {
      _trackSearchAnalytics(query.trim());
    }
  }

  void _trackSearchAnalytics(String query) {
    // Implement analytics tracking here
  // Analytics logging removed or delegate to injected logger if needed
  }

  void _handleSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _currentQuery = suggestion;
    _performSearch(suggestion);
    widget.onSuggestionTap?.call(suggestion);
  }

  void _handleVoiceSearch() async {
    if (_getConfig('enableHaptics', true)) {
      HapticFeedback.mediumImpact();
    }

    setState(() => _isListening = true);

    // Simulate voice search (implement actual voice recognition here)
  await Future.delayed(const Duration(seconds: 2)); // simulate voice input

    setState(() => _isListening = false);

    // For demo purposes, we'll just show a mock result
    if (_getConfig('enableVoiceSearchDemo', true)) {
      const mockResult = 'wireless headphones';
      _controller.text = mockResult;
      _currentQuery = mockResult;
      _performSearch(mockResult);
    }
  }

  void _clearSearch() {
    if (_getConfig('enableHaptics', true)) {
      HapticFeedback.lightImpact();
    }

    _controller.clear();
    setState(() {
      _currentQuery = '';
      _showSuggestions = false;
      _filteredSuggestions.clear();
      _filteredHistory.clear();
    });
    _suggestionController.reverse();
  }

  @override
  void didUpdateWidget(ProductSearchBarAdvanced oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update config
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('search_bar', context: context);
    
    // Update controller if needed
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onQueryChanged);
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onQueryChanged);
    }
    
    // Update focus node if needed
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
  _debounceTimer?.cancel();
  _focusHideTimer?.cancel();
    _controller.removeListener(_onQueryChanged);
    _focusNode.removeListener(_onFocusChanged);
    
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    
    _animationController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildSearchBar(context, theme),
            if (_showSuggestions)
              _buildSuggestionsList(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ShopKitTheme theme) {
    final searchBarStyle = _getConfig('searchBarStyle', 'elevated');
    
    return Container(
      height: _getConfig('searchBarHeight', 56.0),
      decoration: _buildSearchBarDecoration(theme, searchBarStyle),
      child: Row(
        children: [
          _buildLeadingIcon(context, theme),
          
          Expanded(
            child: _buildSearchField(context, theme),
          ),
          
          if (_currentQuery.isNotEmpty)
            _buildClearButton(context, theme),
          
          if (widget.enableVoiceSearch)
            _buildVoiceButton(context, theme),
          
          if (widget.enableFilters)
            _buildFilterButton(context, theme),
        ],
      ),
    );
  }

  BoxDecoration _buildSearchBarDecoration(ShopKitTheme theme, String style) {
    switch (style) {
      case 'outlined':
        return BoxDecoration(
          color: _config?.getColor('searchBarBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
          borderRadius: _config?.getBorderRadius('searchBarBorderRadius', BorderRadius.circular(28)) ?? BorderRadius.circular(28),
          border: Border.all(
            color: _config?.getColor('searchBarBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
            width: _getConfig('searchBarBorderWidth', 1.0),
          ),
        );
      
      case 'filled':
        return BoxDecoration(
          color: _config?.getColor('searchBarBackgroundColor', theme.onSurfaceColor.withValues(alpha: 0.1)) ?? theme.onSurfaceColor.withValues(alpha: 0.1),
          borderRadius: _config?.getBorderRadius('searchBarBorderRadius', BorderRadius.circular(28)) ?? BorderRadius.circular(28),
        );
      
      case 'underlined':
        return BoxDecoration(
          color: _config?.getColor('searchBarBackgroundColor', Colors.transparent) ?? Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: _config?.getColor('searchBarBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
              width: _getConfig('searchBarBorderWidth', 1.0),
            ),
          ),
        );
      
      case 'elevated':
      default:
        return BoxDecoration(
          color: _config?.getColor('searchBarBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
          borderRadius: _config?.getBorderRadius('searchBarBorderRadius', BorderRadius.circular(28)) ?? BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: theme.onSurfaceColor.withValues(alpha: _getConfig('searchBarShadowOpacity', 0.1)),
              blurRadius: _getConfig('searchBarShadowBlur', 8.0),
              offset: Offset(0, _getConfig('searchBarShadowOffsetY', 2.0)),
            ),
          ],
        );
    }
  }

  Widget _buildLeadingIcon(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.only(left: _getConfig('leadingIconPadding', 16.0)),
      child: Icon(
        Icons.search,
        color: _config?.getColor('searchIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
        size: _getConfig('searchIconSize', 24.0),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _getConfig('searchFieldPadding', 16.0)),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(
          color: _config?.getColor('searchTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
          fontSize: _getConfig('searchTextFontSize', 16.0),
          fontWeight: _config?.getFontWeight('searchTextFontWeight', FontWeight.w400) ?? FontWeight.w400,
          fontFamily: _getConfig('fontFamily', null),
        ),
        decoration: InputDecoration(
          hintText: _getConfig('hintText', 'Search products...'),
          hintStyle: TextStyle(
            color: _config?.getColor('hintTextColor', theme.onSurfaceColor.withValues(alpha: 0.5)) ?? theme.onSurfaceColor.withValues(alpha: 0.5),
            fontSize: _getConfig('hintTextFontSize', 16.0),
            fontWeight: _config?.getFontWeight('hintTextFontWeight', FontWeight.w400) ?? FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: _performSearch,
        autocorrect: _getConfig('enableAutocorrect', true),
        enableSuggestions: widget.enableAutoComplete,
      ),
    );
  }

  Widget _buildClearButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _getConfig('clearButtonPadding', 8.0)),
          child: GestureDetector(
            onTap: _clearSearch,
        child: Container(
          padding: EdgeInsets.all(_getConfig('clearButtonInnerPadding', 4.0)),
          decoration: BoxDecoration(
            color: _config?.getColor('clearButtonBackgroundColor', theme.onSurfaceColor.withValues(alpha: 0.1)) ?? theme.onSurfaceColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            color: _config?.getColor('clearButtonIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            size: _getConfig('clearButtonIconSize', 18.0),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _getConfig('voiceButtonPadding', 8.0)),
          child: GestureDetector(
            onTap: _handleVoiceSearch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(_getConfig('voiceButtonInnerPadding', 8.0)),
          decoration: BoxDecoration(
            color: _isListening
              ? (_config?.getColor('voiceButtonActiveColor', theme.primaryColor) ?? theme.primaryColor)
              : (_config?.getColor('voiceButtonInactiveColor', Colors.transparent) ?? Colors.transparent),
            borderRadius: BorderRadius.circular(_getConfig('voiceButtonBorderRadius', 20.0)),
          ),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening
              ? (_config?.getColor('voiceButtonActiveIconColor', theme.onPrimaryColor) ?? theme.onPrimaryColor)
              : (_config?.getColor('voiceButtonInactiveIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6)),
            size: _getConfig('voiceButtonIconSize', 20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, ShopKitTheme theme) {
    if (widget.customFilterBuilder != null) {
      return widget.customFilterBuilder!(context, widget.onFilterTap);
    }

    return Container(
      padding: EdgeInsets.only(right: _getConfig('filterButtonPadding', 16.0)),
          child: GestureDetector(
            onTap: widget.onFilterTap,
        child: Container(
          padding: EdgeInsets.all(_getConfig('filterButtonInnerPadding', 8.0)),
          decoration: BoxDecoration(
            color: _config?.getColor('filterButtonBackgroundColor', Colors.transparent) ?? Colors.transparent,
            borderRadius: BorderRadius.circular(_getConfig('filterButtonBorderRadius', 20.0)),
            border: Border.all(
              color: _config?.getColor('filterButtonBorderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
              width: _getConfig('filterButtonBorderWidth', 1.0),
            ),
          ),
          child: Icon(
            Icons.tune,
            color: _config?.getColor('filterButtonIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            size: _getConfig('filterButtonIconSize', 20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context, ShopKitTheme theme) {
    return FadeTransition(
      opacity: _suggestionFadeAnimation,
      child: Container(
        margin: EdgeInsets.only(top: _getConfig('suggestionsTopMargin', 8.0)),
        constraints: BoxConstraints(
          maxHeight: _getConfig('suggestionsMaxHeight', 300.0),
        ),
        decoration: BoxDecoration(
          color: _config?.getColor('suggestionsBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
          borderRadius: _config?.getBorderRadius('suggestionsBorderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.onSurfaceColor.withValues(alpha: _getConfig('suggestionsShadowOpacity', 0.1)),
              blurRadius: _getConfig('suggestionsShadowBlur', 8.0),
              offset: Offset(0, _getConfig('suggestionsShadowOffsetY', 2.0)),
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: _getConfig('suggestionsPadding', 8.0)),
          children: [
            ..._buildHistoryItems(context, theme),
            ..._buildSuggestionItems(context, theme),
            if (widget.enableHistory && widget.searchHistory.isNotEmpty)
              _buildClearHistoryButton(context, theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHistoryItems(BuildContext context, ShopKitTheme theme) {
    if (!widget.enableHistory || _filteredHistory.isEmpty) return [];

    return [
      if (_getConfig('showHistoryHeader', true))
        _buildSectionHeader(context, theme, 'Recent Searches', Icons.history),
      
      ..._filteredHistory.asMap().entries.map((entry) {
        final history = entry.value;
        return _buildSuggestionItem(
          context,
          theme,
          history,
          Icons.history,
          () => _handleSuggestionTap(history),
          isHistory: true,
        );
      }),
    ];
  }

  List<Widget> _buildSuggestionItems(BuildContext context, ShopKitTheme theme) {
    if (!widget.enableSuggestions || _filteredSuggestions.isEmpty) return [];

    return [
      if (_getConfig('showSuggestionsHeader', true))
        _buildSectionHeader(context, theme, 'Suggestions', Icons.lightbulb_outline),
      
      ..._filteredSuggestions.asMap().entries.map((entry) {
        final index = entry.key;
        final suggestion = entry.value;
        return widget.customSuggestionBuilder?.call(context, suggestion, index) ??
            _buildSuggestionItem(
              context,
              theme,
              suggestion,
              Icons.search,
              () => _handleSuggestionTap(suggestion),
            );
      }),
    ];
  }

  Widget _buildSectionHeader(BuildContext context, ShopKitTheme theme, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getConfig('sectionHeaderPadding', 16.0),
        vertical: _getConfig('sectionHeaderVerticalPadding', 8.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: _getConfig('sectionHeaderIconSize', 16.0),
            color: _config?.getColor('sectionHeaderIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
          ),
          SizedBox(width: _getConfig('sectionHeaderIconSpacing', 8.0)),
          Text(
            title,
            style: TextStyle(
              color: _config?.getColor('sectionHeaderTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
              fontSize: _getConfig('sectionHeaderFontSize', 12.0),
              fontWeight: _config?.getFontWeight('sectionHeaderFontWeight', FontWeight.w500) ?? FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context, 
    ShopKitTheme theme, 
    String text, 
    IconData icon, 
    VoidCallback onTap, {
    bool isHistory = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _getConfig('suggestionItemPadding', 16.0),
            vertical: _getConfig('suggestionItemVerticalPadding', 12.0),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: _getConfig('suggestionItemIconSize', 20.0),
                color: isHistory
                  ? (_config?.getColor('historyItemIconColor', theme.onSurfaceColor.withValues(alpha: 0.4)) ?? theme.onSurfaceColor.withValues(alpha: 0.4))
                  : (_config?.getColor('suggestionItemIconColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6)),
              ),
              SizedBox(width: _getConfig('suggestionItemIconSpacing', 16.0)),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: _config?.getColor('suggestionItemTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                    fontSize: _getConfig('suggestionItemFontSize', 16.0),
                    fontWeight: _config?.getFontWeight('suggestionItemFontWeight', FontWeight.w400) ?? FontWeight.w400,
                  ),
                ),
              ),
              if (_getConfig('showSuggestionArrows', true))
                Icon(
                  Icons.north_west,
                  size: _getConfig('suggestionArrowSize', 16.0),
                  color: _config?.getColor('suggestionArrowColor', theme.onSurfaceColor.withValues(alpha: 0.4)) ?? theme.onSurfaceColor.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearHistoryButton(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(top: _getConfig('clearHistoryButtonTopMargin', 8.0)),
      padding: EdgeInsets.symmetric(horizontal: _getConfig('clearHistoryButtonPadding', 16.0)),
      child: TextButton(
        onPressed: widget.onClearHistory,
        style: TextButton.styleFrom(
          foregroundColor: _config?.getColor('clearHistoryButtonTextColor', theme.primaryColor) ?? theme.primaryColor,
          padding: EdgeInsets.symmetric(vertical: _getConfig('clearHistoryButtonVerticalPadding', 8.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.clear_all,
              size: _getConfig('clearHistoryButtonIconSize', 16.0),
            ),
            SizedBox(width: _getConfig('clearHistoryButtonIconSpacing', 8.0)),
            Text(
              _getConfig('clearHistoryButtonText', 'Clear Search History'),
              style: TextStyle(
                fontSize: _getConfig('clearHistoryButtonFontSize', 14.0),
                fontWeight: _config?.getFontWeight('clearHistoryButtonFontWeight', FontWeight.w500) ?? FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Public API for external control
  String get currentQuery => _currentQuery;
  
  bool get hasFocus => _focusNode.hasFocus;
  
  bool get isListening => _isListening;
  
  void focus() => _focusNode.requestFocus();
  
  void unfocus() => _focusNode.unfocus();
  
  void setQuery(String query) {
    _controller.text = query;
    _currentQuery = query;
  }
  
  void clearQuery() => _clearSearch();
  
  void performSearch([String? query]) {
    final searchQuery = query ?? _currentQuery;
    _performSearch(searchQuery);
  }
}
