import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/flexible_widget_config.dart';
import '../../theme/shopkit_theme.dart';
import '../../models/review_model.dart';

/// A comprehensive review widget with advanced features and unlimited customization
/// Features: Multiple layouts, rating displays, sorting, filtering, pagination, and extensive theming
class ReviewWidgetNew extends StatefulWidget {
  const ReviewWidgetNew({
    super.key,
    required this.reviews,
    this.config,
    this.customBuilder,
    this.customReviewBuilder,
    this.customHeaderBuilder,
    this.customFilterBuilder,
    this.customSummaryBuilder,
    this.onReviewTap,
    this.onLikeToggle,
    this.onReport,
    this.onSortChanged,
    this.onFilterChanged,
    this.enableLiking = true,
    this.enableReporting = true,
    this.enableSorting = true,
    this.enableFiltering = true,
    this.enablePagination = true,
    this.enableAnimations = true,
    this.enableHaptics = true,
    this.showSummary = true,
    this.showPhotos = true,
    this.style = ReviewWidgetStyle.standard,
    this.layout = ReviewLayout.list,
    this.itemsPerPage = 10,
    this.currentPage = 0,
  });

  /// List of reviews to display
  final List<ReviewModel> reviews;

  /// Configuration for unlimited customization
  final FlexibleWidgetConfig? config;

  /// Custom builder for complete control
  final Widget Function(BuildContext, List<ReviewModel>, ReviewWidgetNewState)? customBuilder;

  /// Custom review item builder
  final Widget Function(BuildContext, ReviewModel, int)? customReviewBuilder;

  /// Custom header builder
  final Widget Function(BuildContext, List<ReviewModel>)? customHeaderBuilder;

  /// Custom filter builder
  final Widget Function(BuildContext, ReviewFilter)? customFilterBuilder;

  /// Custom summary builder
  final Widget Function(BuildContext, ReviewSummary)? customSummaryBuilder;

  /// Callbacks
  final Function(ReviewModel)? onReviewTap;
  final Function(ReviewModel, bool)? onLikeToggle;
  final Function(ReviewModel)? onReport;
  final Function(ReviewSortOption)? onSortChanged;
  final Function(ReviewFilter)? onFilterChanged;

  /// Feature toggles
  final bool enableLiking;
  final bool enableReporting;
  final bool enableSorting;
  final bool enableFiltering;
  final bool enablePagination;
  final bool enableAnimations;
  final bool enableHaptics;
  final bool showSummary;
  final bool showPhotos;

  /// Style and layout options
  final ReviewWidgetStyle style;
  final ReviewLayout layout;

  /// Pagination
  final int itemsPerPage;
  final int currentPage;

  @override
  State<ReviewWidgetNew> createState() => ReviewWidgetNewState();
}

class ReviewWidgetNewState extends State<ReviewWidgetNew>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  FlexibleWidgetConfig? _config;
  ReviewSortOption _currentSort = ReviewSortOption.newest;
  ReviewFilter _currentFilter = ReviewFilter();
  int _currentPage = 0;
  List<ReviewModel> _filteredReviews = [];
  ReviewSummary _summary = ReviewSummary.empty();

  // Configuration helpers
  T _getConfig<T>(String key, T defaultValue) {
    return _config?.get<T>(key, defaultValue) ?? defaultValue;
  }

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('review_widget', context: context);
    _currentPage = widget.currentPage;
    
    _setupAnimations();
    _applyFiltersAndSort();
    _calculateSummary();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: _getConfig('fadeAnimationDuration', 300)),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: _getConfig('slideAnimationDuration', 400)),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: _config?.getCurve('fadeAnimationCurve', Curves.easeInOut) ?? Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: _config?.getCurve('slideAnimationCurve', Curves.easeOutCubic) ?? Curves.easeOutCubic,
    ));

    if (widget.enableAnimations) {
      _fadeController.forward();
      _slideController.forward();
    } else {
      _fadeController.value = 1.0;
      _slideController.value = 1.0;
    }
  }

  void _applyFiltersAndSort() {
    List<ReviewModel> filtered = List.from(widget.reviews);

    // Apply filters
    if (_currentFilter.minRating != null) {
      filtered = filtered.where((review) => review.rating >= _currentFilter.minRating!).toList();
    }

    if (_currentFilter.maxRating != null) {
      filtered = filtered.where((review) => review.rating <= _currentFilter.maxRating!).toList();
    }

    if (_currentFilter.hasPhotos) {
      filtered = filtered.where((review) => review.hasImages).toList();
    }

    if (_currentFilter.verified) {
      filtered = filtered.where((review) => review.isVerifiedPurchase).toList();
    }

    // Apply sorting
    switch (_currentSort) {
      case ReviewSortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ReviewSortOption.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case ReviewSortOption.highestRated:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSortOption.lowestRated:
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case ReviewSortOption.mostHelpful:
        filtered.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
    }

    setState(() {
      _filteredReviews = filtered;
    });
  }

  void _calculateSummary() {
    if (widget.reviews.isEmpty) {
      _summary = ReviewSummary.empty();
      return;
    }

    final totalReviews = widget.reviews.length;
    final averageRating = widget.reviews.fold(0.0, (sum, review) => sum + review.rating) / totalReviews;
    
    final ratingDistribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = widget.reviews.where((review) => review.rating == i).length;
    }

    final reviewsWithPhotos = widget.reviews.where((review) => review.hasImages).length;
    final verifiedReviews = widget.reviews.where((review) => review.isVerifiedPurchase).length;

    _summary = ReviewSummary(
      totalReviews: totalReviews,
      averageRating: averageRating,
      ratingDistribution: ratingDistribution,
      reviewsWithPhotos: reviewsWithPhotos,
      verifiedReviews: verifiedReviews,
    );
  }

  void _handleSortChanged(ReviewSortOption sort) {
    setState(() {
      _currentSort = sort;
    });
    
    _applyFiltersAndSort();
    
    if (widget.enableHaptics && _getConfig('enableSortHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    widget.onSortChanged?.call(sort);
  }

  void _handleFilterChanged(ReviewFilter filter) {
    setState(() {
      _currentFilter = filter;
      _currentPage = 0; // Reset to first page when filter changes
    });
    
    _applyFiltersAndSort();
    
    if (widget.enableHaptics && _getConfig('enableFilterHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    widget.onFilterChanged?.call(filter);
  }

  void _handleReviewTap(ReviewModel review) {
    if (widget.enableHaptics && _getConfig('enableTapHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    widget.onReviewTap?.call(review);
  }

  void _handleLikeToggle(ReviewModel review, bool isLiked) {
    if (widget.enableHaptics && _getConfig('enableLikeHaptics', true)) {
      HapticFeedback.lightImpact();
    }
    
    widget.onLikeToggle?.call(review, isLiked);
  }

  void _handleReport(ReviewModel review) {
    if (widget.enableHaptics && _getConfig('enableReportHaptics', true)) {
      HapticFeedback.mediumImpact();
    }
    
    widget.onReport?.call(review);
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    
    if (widget.enableHaptics && _getConfig('enablePageChangeHaptics', true)) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  void didUpdateWidget(ReviewWidgetNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    _config = widget.config ?? FlexibleWidgetConfig.forWidget('review_widget', context: context);
    
    if (widget.reviews != oldWidget.reviews) {
      _applyFiltersAndSort();
      _calculateSummary();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.reviews, this);
    }

    final theme = ShopKitThemeProvider.of(context);

    Widget content = _buildReviewWidget(context, theme);

    if (widget.enableAnimations) {
      content = SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildReviewWidget(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('containerPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('backgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: _config?.getBorderRadius('borderRadius', BorderRadius.circular(12)) ?? BorderRadius.circular(12),
        border: _getConfig('showBorder', false)
          ? Border.all(
              color: _config?.getColor('borderColor', theme.onSurfaceColor.withValues(alpha: 0.2)) ?? theme.onSurfaceColor.withValues(alpha: 0.2),
              width: _getConfig('borderWidth', 1.0),
            )
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSummary) _buildSummarySection(context, theme),
          
          if (widget.enableSorting || widget.enableFiltering)
            _buildControlsSection(context, theme),
          
          _buildReviewsList(context, theme),
          
          if (widget.enablePagination && _getTotalPages() > 1)
            _buildPaginationSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, ShopKitTheme theme) {
    if (widget.customSummaryBuilder != null) {
      return widget.customSummaryBuilder!(context, _summary);
    }

    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('summaryBottomMargin', 20.0)),
      padding: EdgeInsets.all(_getConfig('summaryPadding', 16.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('summaryBackgroundColor', theme.primaryColor.withValues(alpha: 0.05)) ?? theme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(_getConfig('summaryBorderRadius', 8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _summary.averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      color: _config?.getColor('averageRatingColor', theme.primaryColor) ?? theme.primaryColor,
                      fontSize: _getConfig('averageRatingFontSize', 32.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < _summary.averageRating.floor()
                            ? Icons.star
                            : index < _summary.averageRating
                              ? Icons.star_half
                              : Icons.star_border,
                          color: _config?.getColor('starColor', Colors.amber) ?? Colors.amber,
                          size: _getConfig('summaryStarSize', 20.0),
                        );
                      }),
                    ],
                  ),
                  
                  Text(
                    '${_summary.totalReviews} reviews',
                    style: TextStyle(
                      color: _config?.getColor('reviewCountColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                      fontSize: _getConfig('reviewCountFontSize', 12.0),
                    ),
                  ),
                ],
              ),
              
              SizedBox(width: _getConfig('summaryContentSpacing', 24.0)),
              
              Expanded(
                child: _buildRatingDistribution(context, theme),
              ),
            ],
          ),
          
          if (_getConfig('showSummaryStats', true)) ...[
            SizedBox(height: _getConfig('summaryStatsSpacing', 16.0)),
            _buildSummaryStats(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(BuildContext context, ShopKitTheme theme) {
    return Column(
      children: [5, 4, 3, 2, 1].map((rating) {
        final count = _summary.ratingDistribution[rating] ?? 0;
        final percentage = _summary.totalReviews > 0 ? count / _summary.totalReviews : 0.0;
        
        return Container(
          margin: EdgeInsets.symmetric(vertical: _getConfig('distributionItemSpacing', 2.0)),
          child: Row(
            children: [
              Text(
                '$rating',
                style: TextStyle(
                  color: _config?.getColor('distributionLabelColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                  fontSize: _getConfig('distributionLabelFontSize', 12.0),
                ),
              ),
              
              SizedBox(width: _getConfig('distributionLabelSpacing', 8.0)),
              
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: _config?.getColor('distributionBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _config?.getColor('distributionValueColor', theme.primaryColor) ?? theme.primaryColor,
                  ),
                  minHeight: _getConfig('distributionBarHeight', 6.0),
                ),
              ),
              
              SizedBox(width: _getConfig('distributionCountSpacing', 8.0)),
              
              Text(
                count.toString(),
                style: TextStyle(
                  color: _config?.getColor('distributionCountColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                  fontSize: _getConfig('distributionCountFontSize', 12.0),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSummaryStats(BuildContext context, ShopKitTheme theme) {
    return Row(
      children: [
        _buildStatItem(
          context,
          theme,
          Icons.photo_camera,
          '${_summary.reviewsWithPhotos}',
          'with photos',
        ),
        
        SizedBox(width: _getConfig('statItemSpacing', 16.0)),
        
        _buildStatItem(
          context,
          theme,
          Icons.verified,
          '${_summary.verifiedReviews}',
          'verified',
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, ShopKitTheme theme, IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(
          icon,
          color: _config?.getColor('statIconColor', theme.primaryColor) ?? theme.primaryColor,
          size: _getConfig('statIconSize', 16.0),
        ),
        
        SizedBox(width: _getConfig('statIconSpacing', 4.0)),
        
        Text(
          '$value $label',
          style: TextStyle(
            color: _config?.getColor('statTextColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
            fontSize: _getConfig('statTextFontSize', 12.0),
          ),
        ),
      ],
    );
  }

  Widget _buildControlsSection(BuildContext context, ShopKitTheme theme) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('controlsBottomMargin', 16.0)),
      child: Row(
        children: [
          if (widget.enableSorting) ...[
            _buildSortDropdown(context, theme),
            SizedBox(width: _getConfig('controlsSpacing', 16.0)),
          ],
          
          if (widget.enableFiltering)
            _buildFilterButton(context, theme),
          
          Spacer(),
          
          Text(
            '${_filteredReviews.length} reviews',
            style: TextStyle(
              color: _config?.getColor('filteredCountColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
              fontSize: _getConfig('filteredCountFontSize', 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context, ShopKitTheme theme) {
    return DropdownButton<ReviewSortOption>(
      value: _currentSort,
      onChanged: (sort) {
        if (sort != null) {
          _handleSortChanged(sort);
        }
      },
      items: ReviewSortOption.values.map((sort) {
        return DropdownMenuItem(
          value: sort,
          child: Text(
            _getSortLabel(sort),
            style: TextStyle(
              fontSize: _getConfig('sortDropdownFontSize', 14.0),
            ),
          ),
        );
      }).toList(),
      underline: Container(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: _config?.getColor('sortDropdownIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, ShopKitTheme theme) {
    final hasActiveFilters = _currentFilter.hasActiveFilters;
    
    return TextButton.icon(
      onPressed: () => _showFilterDialog(context, theme),
      icon: Icon(
        Icons.filter_list,
        color: hasActiveFilters 
          ? _config?.getColor('activeFilterIconColor', theme.primaryColor) ?? theme.primaryColor
          : _config?.getColor('filterIconColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
        size: _getConfig('filterIconSize', 16.0),
      ),
      label: Text(
        _getConfig('filterButtonText', 'Filter'),
        style: TextStyle(
          color: hasActiveFilters 
            ? _config?.getColor('activeFilterTextColor', theme.primaryColor) ?? theme.primaryColor
            : _config?.getColor('filterTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
          fontSize: _getConfig('filterButtonFontSize', 14.0),
        ),
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, ShopKitTheme theme) {
    if (_filteredReviews.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, _filteredReviews.length);
    final pageReviews = _filteredReviews.sublist(startIndex, endIndex);

    switch (widget.layout) {
      case ReviewLayout.grid:
        return _buildReviewsGrid(context, theme, pageReviews);
      case ReviewLayout.compact:
        return _buildCompactReviewsList(context, theme, pageReviews);
      case ReviewLayout.list:
        return _buildReviewsListView(context, theme, pageReviews);
    }
  }

  Widget _buildReviewsListView(BuildContext context, ShopKitTheme theme, List<ReviewModel> reviews) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => Divider(
        height: _getConfig('reviewSeparatorHeight', 24.0),
        color: _config?.getColor('reviewSeparatorColor', theme.onSurfaceColor.withValues(alpha: 0.1)) ?? theme.onSurfaceColor.withValues(alpha: 0.1),
      ),
      itemBuilder: (context, index) {
        final review = reviews[index];
        
        if (widget.customReviewBuilder != null) {
          return widget.customReviewBuilder!(context, review, index);
        }
        
        return _buildStandardReviewItem(context, theme, review, index);
      },
    );
  }

  Widget _buildReviewsGrid(BuildContext context, ShopKitTheme theme, List<ReviewModel> reviews) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getConfig('gridCrossAxisCount', 2),
        childAspectRatio: _getConfig('gridChildAspectRatio', 0.8),
        mainAxisSpacing: _getConfig('gridMainAxisSpacing', 16.0),
        crossAxisSpacing: _getConfig('gridCrossAxisSpacing', 16.0),
      ),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildGridReviewItem(context, theme, review, index);
      },
    );
  }

  Widget _buildCompactReviewsList(BuildContext context, ShopKitTheme theme, List<ReviewModel> reviews) {
    return Column(
      children: reviews.asMap().entries.map((entry) {
        final index = entry.key;
        final review = entry.value;
        return _buildCompactReviewItem(context, theme, review, index);
      }).toList(),
    );
  }

  Widget _buildStandardReviewItem(BuildContext context, ShopKitTheme theme, ReviewModel review, int index) {
    return GestureDetector(
      onTap: () => _handleReviewTap(review),
      child: Container(
        padding: EdgeInsets.all(_getConfig('reviewItemPadding', 16.0)),
        decoration: BoxDecoration(
          color: _config?.getColor('reviewItemBackgroundColor', Colors.transparent) ?? Colors.transparent,
          borderRadius: BorderRadius.circular(_getConfig('reviewItemBorderRadius', 8.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewHeader(context, theme, review),
            
            SizedBox(height: _getConfig('reviewHeaderSpacing', 12.0)),
            
            _buildReviewContent(context, theme, review),
            
            if (review.hasImages && widget.showPhotos) ...[
              SizedBox(height: _getConfig('reviewPhotosSpacing', 12.0)),
              _buildReviewPhotos(context, theme, review),
            ],
            
            SizedBox(height: _getConfig('reviewActionsSpacing', 12.0)),
            
            _buildReviewActions(context, theme, review),
          ],
        ),
      ),
    );
  }

  Widget _buildGridReviewItem(BuildContext context, ShopKitTheme theme, ReviewModel review, int index) {
    return Container(
      padding: EdgeInsets.all(_getConfig('gridReviewItemPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('gridReviewItemBackgroundColor', theme.surfaceColor) ?? theme.surfaceColor,
        borderRadius: BorderRadius.circular(_getConfig('gridReviewItemBorderRadius', 8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewRating(context, theme, review),
          
          SizedBox(height: _getConfig('gridReviewSpacing', 8.0)),
          
          Expanded(
            child: Text(
              review.comment,
              style: TextStyle(
                color: _config?.getColor('gridReviewCommentColor', theme.onSurfaceColor.withValues(alpha: 0.8)) ?? theme.onSurfaceColor.withValues(alpha: 0.8),
                fontSize: _getConfig('gridReviewCommentFontSize', 12.0),
                height: 1.3,
              ),
              maxLines: _getConfig('gridReviewMaxLines', 4),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          Text(
            review.userName,
            style: TextStyle(
              color: _config?.getColor('gridReviewUserNameColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
              fontSize: _getConfig('gridReviewUserNameFontSize', 10.0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactReviewItem(BuildContext context, ShopKitTheme theme, ReviewModel review, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: _getConfig('compactReviewSpacing', 12.0)),
      padding: EdgeInsets.all(_getConfig('compactReviewPadding', 12.0)),
      decoration: BoxDecoration(
        color: _config?.getColor('compactReviewBackgroundColor', theme.surfaceColor.withValues(alpha: 0.5)) ?? theme.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(_getConfig('compactReviewBorderRadius', 6.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildReviewRating(context, theme, review),
              
              if (review.isVerifiedPurchase)
                Container(
                  margin: EdgeInsets.only(top: _getConfig('verifiedBadgeSpacing', 4.0)),
                  child: Icon(
                    Icons.verified,
                    color: _config?.getColor('verifiedBadgeColor', theme.successColor) ?? theme.successColor,
                    size: _getConfig('verifiedBadgeSize', 14.0),
                  ),
                ),
            ],
          ),
          
          SizedBox(width: _getConfig('compactReviewContentSpacing', 12.0)),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: TextStyle(
                    color: _config?.getColor('compactReviewUserNameColor', theme.onSurfaceColor.withValues(alpha: 0.8)) ?? theme.onSurfaceColor.withValues(alpha: 0.8),
                    fontSize: _getConfig('compactReviewUserNameFontSize', 12.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                SizedBox(height: _getConfig('compactReviewUserNameSpacing', 4.0)),
                
                Text(
                  review.comment,
                  style: TextStyle(
                    color: _config?.getColor('compactReviewCommentColor', theme.onSurfaceColor.withValues(alpha: 0.7)) ?? theme.onSurfaceColor.withValues(alpha: 0.7),
                    fontSize: _getConfig('compactReviewCommentFontSize', 12.0),
                    height: 1.3,
                  ),
                  maxLines: _getConfig('compactReviewMaxLines', 2),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewHeader(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.userName,
                    style: TextStyle(
                      color: _config?.getColor('reviewUserNameColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                      fontSize: _getConfig('reviewUserNameFontSize', 14.0),
                      fontWeight: _config?.getFontWeight('reviewUserNameFontWeight', FontWeight.w600) ?? FontWeight.w600,
                    ),
                  ),
                  
                  if (review.isVerifiedPurchase) ...[
                    SizedBox(width: _getConfig('verifiedBadgeSpacing', 6.0)),
                    Icon(
                      Icons.verified,
                      color: _config?.getColor('verifiedBadgeColor', theme.successColor) ?? theme.successColor,
                      size: _getConfig('verifiedBadgeSize', 16.0),
                    ),
                  ],
                ],
              ),
              
              SizedBox(height: _getConfig('reviewUserNameSpacing', 4.0)),
              
              Text(
                _formatDate(review.createdAt),
                style: TextStyle(
                  color: _config?.getColor('reviewDateColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
                  fontSize: _getConfig('reviewDateFontSize', 12.0),
                ),
              ),
            ],
          ),
        ),
        
        _buildReviewRating(context, theme, review),
      ],
    );
  }

  Widget _buildReviewRating(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < review.rating ? Icons.star : Icons.star_border,
            color: _config?.getColor('reviewStarColor', Colors.amber) ?? Colors.amber,
            size: _getConfig('reviewStarSize', 16.0),
          );
        }),
      ],
    );
  }

  Widget _buildReviewContent(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return Text(
      review.comment,
      style: TextStyle(
        color: _config?.getColor('reviewCommentColor', theme.onSurfaceColor.withValues(alpha: 0.8)) ?? theme.onSurfaceColor.withValues(alpha: 0.8),
        fontSize: _getConfig('reviewCommentFontSize', 14.0),
        height: _getConfig('reviewCommentLineHeight', 1.4),
      ),
    );
  }

  Widget _buildReviewPhotos(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return SizedBox(
      height: _getConfig('reviewPhotosHeight', 80.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: review.imageUrls?.length ?? 0,
        itemBuilder: (context, index) {
          final photo = review.imageUrls![index];
          
          return Container(
            width: _getConfig('reviewPhotoWidth', 80.0),
            margin: EdgeInsets.only(right: _getConfig('reviewPhotoSpacing', 8.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_getConfig('reviewPhotoBorderRadius', 6.0)),
              child: Image.network(
                photo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: theme.surfaceColor,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.onSurfaceColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewActions(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return Row(
      children: [
        if (widget.enableLiking)
          _buildLikeButton(context, theme, review),
        
        SizedBox(width: _getConfig('reviewActionSpacing', 16.0)),
        
        Text(
          'Helpful (${review.helpfulCount})',
          style: TextStyle(
            color: _config?.getColor('helpfulTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            fontSize: _getConfig('helpfulTextFontSize', 12.0),
          ),
        ),
        
        Spacer(),
        
        if (widget.enableReporting)
          _buildReportButton(context, theme, review),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    // This would typically track liked state in a parent widget or state management
    final isLiked = review.helpfulCount > 0; // Use helpful count as indicator
    
    return InkWell(
      onTap: () => _handleLikeToggle(review, !isLiked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: isLiked 
              ? _config?.getColor('likedButtonColor', theme.primaryColor) ?? theme.primaryColor
              : _config?.getColor('likeButtonColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
            size: _getConfig('likeButtonSize', 16.0),
          ),
          
          if (_getConfig('showLikeText', true)) ...[
            SizedBox(width: _getConfig('likeTextSpacing', 4.0)),
            Text(
              _getConfig('likeButtonText', 'Helpful'),
              style: TextStyle(
                color: isLiked 
                  ? _config?.getColor('likedTextColor', theme.primaryColor) ?? theme.primaryColor
                  : _config?.getColor('likeTextColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
                fontSize: _getConfig('likeTextFontSize', 12.0),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, ShopKitTheme theme, ReviewModel review) {
    return InkWell(
      onTap: () => _handleReport(review),
      child: Icon(
        Icons.flag_outlined,
        color: _config?.getColor('reportButtonColor', theme.onSurfaceColor.withValues(alpha: 0.4)) ?? theme.onSurfaceColor.withValues(alpha: 0.4),
        size: _getConfig('reportButtonSize', 16.0),
      ),
    );
  }

  Widget _buildPaginationSection(BuildContext context, ShopKitTheme theme) {
    final totalPages = _getTotalPages();
    
    return Container(
      margin: EdgeInsets.only(top: _getConfig('paginationTopMargin', 20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0 ? () => _handlePageChanged(_currentPage - 1) : null,
            icon: Icon(
              Icons.chevron_left,
              color: _currentPage > 0 
                ? _config?.getColor('paginationButtonColor', theme.primaryColor) ?? theme.primaryColor
                : _config?.getColor('paginationDisabledColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
            ),
          ),
          
          ...List.generate(totalPages.clamp(0, 5), (index) {
            final page = index;
            final isCurrentPage = page == _currentPage;
            
            return InkWell(
              onTap: () => _handlePageChanged(page),
              child: Container(
                padding: EdgeInsets.all(_getConfig('paginationNumberPadding', 8.0)),
                margin: EdgeInsets.symmetric(horizontal: _getConfig('paginationNumberSpacing', 4.0)),
                decoration: BoxDecoration(
                  color: isCurrentPage 
                    ? _config?.getColor('paginationActiveBackgroundColor', theme.primaryColor) ?? theme.primaryColor
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(_getConfig('paginationNumberBorderRadius', 4.0)),
                ),
                child: Text(
                  (page + 1).toString(),
                  style: TextStyle(
                    color: isCurrentPage 
                      ? _config?.getColor('paginationActiveTextColor', theme.onPrimaryColor) ?? theme.onPrimaryColor
                      : _config?.getColor('paginationTextColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                    fontSize: _getConfig('paginationTextFontSize', 14.0),
                    fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
          
          IconButton(
            onPressed: _currentPage < totalPages - 1 ? () => _handlePageChanged(_currentPage + 1) : null,
            icon: Icon(
              Icons.chevron_right,
              color: _currentPage < totalPages - 1
                ? _config?.getColor('paginationButtonColor', theme.primaryColor) ?? theme.primaryColor
                : _config?.getColor('paginationDisabledColor', theme.onSurfaceColor.withValues(alpha: 0.3)) ?? theme.onSurfaceColor.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ShopKitTheme theme) {
    return Container(
      padding: EdgeInsets.all(_getConfig('emptyStatePadding', 40.0)),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: _getConfig('emptyStateIconSize', 64.0),
              color: _config?.getColor('emptyStateIconColor', theme.onSurfaceColor.withValues(alpha: 0.4)) ?? theme.onSurfaceColor.withValues(alpha: 0.4),
            ),
            
            SizedBox(height: _getConfig('emptyStateSpacing', 16.0)),
            
            Text(
              _getConfig('emptyStateTitle', 'No reviews found'),
              style: TextStyle(
                color: _config?.getColor('emptyStateTitleColor', theme.onSurfaceColor) ?? theme.onSurfaceColor,
                fontSize: _getConfig('emptyStateTitleFontSize', 18.0),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: _getConfig('emptyStateDescSpacing', 8.0)),
            
            Text(
              _getConfig('emptyStateDescription', 'Try adjusting your filters or check back later'),
              style: TextStyle(
                color: _config?.getColor('emptyStateDescColor', theme.onSurfaceColor.withValues(alpha: 0.6)) ?? theme.onSurfaceColor.withValues(alpha: 0.6),
                fontSize: _getConfig('emptyStateDescFontSize', 14.0),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ShopKitTheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getConfig('filterDialogTitle', 'Filter Reviews')),
        content: _buildFilterContent(context, theme),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleFilterChanged(ReviewFilter()); // Clear filters
            },
            child: Text(_getConfig('clearFiltersText', 'Clear')),
          ),
          
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_getConfig('cancelText', 'Cancel')),
          ),
          
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Apply current filter
            },
            child: Text(_getConfig('applyFiltersText', 'Apply')),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(BuildContext context, ShopKitTheme theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: Text(_getConfig('filterWithPhotosText', 'With photos')),
          value: _currentFilter.hasPhotos,
          onChanged: (value) {
            setState(() {
              _currentFilter = _currentFilter.copyWith(hasPhotos: value ?? false);
            });
          },
        ),
        
        CheckboxListTile(
          title: Text(_getConfig('filterVerifiedText', 'Verified purchases')),
          value: _currentFilter.verified,
          onChanged: (value) {
            setState(() {
              _currentFilter = _currentFilter.copyWith(verified: value ?? false);
            });
          },
        ),
      ],
    );
  }

  // Helper methods
  int _getTotalPages() {
    return (_filteredReviews.length / widget.itemsPerPage).ceil();
  }

  String _getSortLabel(ReviewSortOption sort) {
    switch (sort) {
      case ReviewSortOption.newest:
        return _getConfig('sortNewestText', 'Newest');
      case ReviewSortOption.oldest:
        return _getConfig('sortOldestText', 'Oldest');
      case ReviewSortOption.highestRated:
        return _getConfig('sortHighestRatedText', 'Highest Rated');
      case ReviewSortOption.lowestRated:
        return _getConfig('sortLowestRatedText', 'Lowest Rated');
      case ReviewSortOption.mostHelpful:
        return _getConfig('sortMostHelpfulText', 'Most Helpful');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Public API for external control
  List<ReviewModel> get filteredReviews => _filteredReviews;
  
  ReviewSummary get summary => _summary;
  
  ReviewSortOption get currentSort => _currentSort;
  
  ReviewFilter get currentFilter => _currentFilter;
  
  int get currentPage => _currentPage;
  
  void setSortOption(ReviewSortOption sort) {
    _handleSortChanged(sort);
  }
  
  void setFilter(ReviewFilter filter) {
    _handleFilterChanged(filter);
  }
  
  void goToPage(int page) {
    if (page >= 0 && page < _getTotalPages()) {
      _handlePageChanged(page);
    }
  }
  
  void refreshData() {
    _applyFiltersAndSort();
    _calculateSummary();
  }
}

/// Style options for review widget
enum ReviewWidgetStyle {
  standard,
  compact,
  card,
  minimal,
}

/// Layout options for reviews
enum ReviewLayout {
  list,
  grid,
  compact,
}

/// Sort options for reviews
enum ReviewSortOption {
  newest,
  oldest,
  highestRated,
  lowestRated,
  mostHelpful,
}

/// Filter options for reviews
class ReviewFilter {
  const ReviewFilter({
    this.minRating,
    this.maxRating,
    this.hasPhotos = false,
    this.verified = false,
  });

  final int? minRating;
  final int? maxRating;
  final bool hasPhotos;
  final bool verified;

  bool get hasActiveFilters => 
    minRating != null || maxRating != null || hasPhotos || verified;

  ReviewFilter copyWith({
    int? minRating,
    int? maxRating,
    bool? hasPhotos,
    bool? verified,
  }) {
    return ReviewFilter(
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      hasPhotos: hasPhotos ?? this.hasPhotos,
      verified: verified ?? this.verified,
    );
  }
}

/// Summary data for reviews
class ReviewSummary {
  const ReviewSummary({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.reviewsWithPhotos,
    required this.verifiedReviews,
  });

  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final int reviewsWithPhotos;
  final int verifiedReviews;

  ReviewSummary.empty()
    : totalReviews = 0,
      averageRating = 0.0,
      ratingDistribution = {},
      reviewsWithPhotos = 0,
      verifiedReviews = 0;
}
