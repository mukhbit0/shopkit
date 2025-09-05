import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../models/product_model.dart';

/// Modern search bar built with shadcn/ui components
class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    this.onSearch,
    this.onSuggestionTap,
    this.onClear,
    this.suggestions = const [],
    this.placeholder = 'Search products...',
    this.showSearchButton = true,
    this.showClearButton = true,
    this.enabled = true,
    this.autofocus = false,
    this.debounceMs = 300,
  });

  final Function(String query)? onSearch;
  final Function(ProductModel product)? onSuggestionTap;
  final VoidCallback? onClear;
  final List<ProductModel> suggestions;
  final String placeholder;
  final bool showSearchButton;
  final bool showClearButton;
  final bool enabled;
  final bool autofocus;
  final int debounceMs;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    _removeOverlay();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && widget.suggestions.isNotEmpty) {
      _showSuggestionsOverlay();
    } else {
      _hideSuggestionsOverlay();
    }
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    
    if (query.isNotEmpty) {
      widget.onSearch?.call(query);
      if (widget.suggestions.isNotEmpty && _focusNode.hasFocus) {
        _showSuggestionsOverlay();
      }
    } else {
      _hideSuggestionsOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildSuggestionsOverlay(),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestionsOverlay() {
    _removeOverlay();
  }  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleSuggestionTap(ProductModel product) {
    _controller.text = product.name;
    _hideSuggestionsOverlay();
    _focusNode.unfocus();
    widget.onSuggestionTap?.call(product);
  }

  void _handleClear() {
    _controller.clear();
    _hideSuggestionsOverlay();
    widget.onClear?.call();
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      _hideSuggestionsOverlay();
      _focusNode.unfocus();
      widget.onSearch?.call(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              controller: _controller,
              focusNode: _focusNode,
              placeholder: Text(widget.placeholder),
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onSubmitted: (_) => _handleSearch(),
            ),
          ),
          const SizedBox(width: 8),
          if (widget.showClearButton && _controller.text.isNotEmpty)
            ShadButton(
              onPressed: _handleClear,
              child: const Icon(Icons.clear, size: 18),
            ),
          if (widget.showSearchButton) ...[
            const SizedBox(width: 4),
            ShadButton(
              onPressed: _handleSearch,
              child: const Icon(Icons.search, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      width: _getSuggestionsWidth(),
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 52),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: widget.suggestions.isEmpty
                ? _buildEmptyState()
                : _buildSuggestionsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'No products found',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.suggestions.length,
      itemBuilder: (context, index) {
        final product = widget.suggestions[index];
        return _buildSuggestionItem(product);
      },
    );
  }

  Widget _buildSuggestionItem(ProductModel product) {
    return InkWell(
      onTap: () => _handleSuggestionTap(product),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Product image
            if (product.imageUrl != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.brand?.isNotEmpty == true) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.brand!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Price
            Text(
              product.formattedPrice,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getSuggestionsWidth() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300;
  }
}
